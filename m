From: akpm@linux-foundation.org
Subject: - sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:59 -0700
Message-ID: <200704302144.l3ULixVG015636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946842AbXD3V6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladislav.yasevich@hp.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     SCTP: fix sctp_getsockopt_local_addrs_old() to use local storage
has been removed from the -mm tree.  Its filename was
     sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCTP: fix sctp_getsockopt_local_addrs_old() to use local storage
From: Vlad Yasevich <vladislav.yasevich@hp.com>

sctp_getsockopt_local_addrs_old() in net/sctp/socket.c calls copy_to_user()
while the spinlock addr_lock is held.  This should not be done as
copy_to_user() might sleep.  The call to sctp_copy_laddrs_to_user() while
holding the lock is also problematic as it calls copy_to_user()

[akpm@linux-foundation.org: various fixes]
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |   96 +++++++++++++++++++++++++++-----------------
 1 files changed, 60 insertions(+), 36 deletions(-)

diff -puN net/sctp/socket.c~sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage net/sctp/socket.c
--- a/net/sctp/socket.c~sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage
+++ a/net/sctp/socket.c
@@ -3987,7 +3987,7 @@ static int sctp_getsockopt_peer_addrs(st
 		memcpy(&temp, &from->ipaddr, sizeof(temp));
 		sctp_get_pf_specific(sk->sk_family)->addr_v4map(sp, &temp);
 		addrlen = sctp_get_af_specific(sk->sk_family)->sockaddr_len;
-		if(space_left < addrlen)
+		if (space_left < addrlen)
 			return -ENOMEM;
 		if (copy_to_user(to, &temp, addrlen))
 			return -EFAULT;
@@ -4076,8 +4076,9 @@ done:
 /* Helper function that copies local addresses to user and returns the number
  * of addresses copied.
  */
-static int sctp_copy_laddrs_to_user_old(struct sock *sk, __u16 port, int max_addrs,
-					void __user *to)
+static int sctp_copy_laddrs_old(struct sock *sk, __u16 port,
+					int max_addrs, void *to,
+					size_t *bytes_copied)
 {
 	struct list_head *pos, *next;
 	struct sctp_sockaddr_entry *addr;
@@ -4094,10 +4095,10 @@ static int sctp_copy_laddrs_to_user_old(
 		sctp_get_pf_specific(sk->sk_family)->addr_v4map(sctp_sk(sk),
 								&temp);
 		addrlen = sctp_get_af_specific(temp.sa.sa_family)->sockaddr_len;
-		if (copy_to_user(to, &temp, addrlen))
-			return -EFAULT;
+		memcpy(to, &temp, addrlen);
 
 		to += addrlen;
+		*bytes_copied += addrlen;
 		cnt ++;
 		if (cnt >= max_addrs) break;
 	}
@@ -4105,8 +4106,8 @@ static int sctp_copy_laddrs_to_user_old(
 	return cnt;
 }
 
-static int sctp_copy_laddrs_to_user(struct sock *sk, __u16 port,
-				    void __user **to, size_t space_left)
+static int sctp_copy_laddrs(struct sock *sk, __u16 port, void *to,
+			    size_t space_left, size_t *bytes_copied)
 {
 	struct list_head *pos, *next;
 	struct sctp_sockaddr_entry *addr;
@@ -4123,14 +4124,14 @@ static int sctp_copy_laddrs_to_user(stru
 		sctp_get_pf_specific(sk->sk_family)->addr_v4map(sctp_sk(sk),
 								&temp);
 		addrlen = sctp_get_af_specific(temp.sa.sa_family)->sockaddr_len;
-		if(space_left<addrlen)
+		if (space_left < addrlen)
 			return -ENOMEM;
-		if (copy_to_user(*to, &temp, addrlen))
-			return -EFAULT;
+		memcpy(to, &temp, addrlen);
 
-		*to += addrlen;
+		to += addrlen;
 		cnt ++;
 		space_left -= addrlen;
+		bytes_copied += addrlen;
 	}
 
 	return cnt;
@@ -4154,6 +4155,8 @@ static int sctp_getsockopt_local_addrs_o
 	int addrlen;
 	rwlock_t *addr_lock;
 	int err = 0;
+	void *addrs;
+	size_t bytes_copied = 0;
 
 	if (len != sizeof(struct sctp_getaddrs_old))
 		return -EINVAL;
@@ -4181,6 +4184,15 @@ static int sctp_getsockopt_local_addrs_o
 
 	to = getaddrs.addrs;
 
+	/* Allocate space for a local instance of packed array to hold all
+	 * the data.  We store addresses here first and then copy them
+	 * to the user in one shot.
+	 */
+	addrs = kmalloc(sizeof(union sctp_addr) * getaddrs.addr_num,
+			GFP_KERNEL);
+	if (!addrs)
+		return -ENOMEM;
+
 	sctp_read_lock(addr_lock);
 
 	/* If the endpoint is bound to 0.0.0.0 or ::0, get the valid
@@ -4190,13 +4202,9 @@ static int sctp_getsockopt_local_addrs_o
 		addr = list_entry(bp->address_list.next,
 				  struct sctp_sockaddr_entry, list);
 		if (sctp_is_any(&addr->a)) {
-			cnt = sctp_copy_laddrs_to_user_old(sk, bp->port,
-							   getaddrs.addr_num,
-							   to);
-			if (cnt < 0) {
-				err = cnt;
-				goto unlock;
-			}
+			cnt = sctp_copy_laddrs_old(sk, bp->port,
+						   getaddrs.addr_num,
+						   addrs, &bytes_copied);
 			goto copy_getaddrs;
 		}
 	}
@@ -4206,22 +4214,29 @@ static int sctp_getsockopt_local_addrs_o
 		memcpy(&temp, &addr->a, sizeof(temp));
 		sctp_get_pf_specific(sk->sk_family)->addr_v4map(sp, &temp);
 		addrlen = sctp_get_af_specific(temp.sa.sa_family)->sockaddr_len;
-		if (copy_to_user(to, &temp, addrlen)) {
-			err = -EFAULT;
-			goto unlock;
-		}
+		memcpy(addrs, &temp, addrlen);
 		to += addrlen;
+		bytes_copied += addrlen;
 		cnt ++;
 		if (cnt >= getaddrs.addr_num) break;
 	}
 
 copy_getaddrs:
+	sctp_read_unlock(addr_lock);
+
+	/* copy the entire address list into the user provided space */
+	if (copy_to_user(to, addrs, bytes_copied)) {
+		err = -EFAULT;
+		goto error;
+	}
+
+	/* copy the leading structure back to user */
 	getaddrs.addr_num = cnt;
 	if (copy_to_user(optval, &getaddrs, sizeof(struct sctp_getaddrs_old)))
 		err = -EFAULT;
 
-unlock:
-	sctp_read_unlock(addr_lock);
+error:
+	kfree(addrs);
 	return err;
 }
 
@@ -4241,7 +4256,8 @@ static int sctp_getsockopt_local_addrs(s
 	rwlock_t *addr_lock;
 	int err = 0;
 	size_t space_left;
-	int bytes_copied;
+	size_t bytes_copied = 0;
+	void *addrs;
 
 	if (len <= sizeof(struct sctp_getaddrs))
 		return -EINVAL;
@@ -4269,6 +4285,9 @@ static int sctp_getsockopt_local_addrs(s
 	to = optval + offsetof(struct sctp_getaddrs,addrs);
 	space_left = len - sizeof(struct sctp_getaddrs) -
 			 offsetof(struct sctp_getaddrs,addrs);
+	addrs = kmalloc(space_left, GFP_KERNEL);
+	if (!addrs)
+		return -ENOMEM;
 
 	sctp_read_lock(addr_lock);
 
@@ -4279,11 +4298,11 @@ static int sctp_getsockopt_local_addrs(s
 		addr = list_entry(bp->address_list.next,
 				  struct sctp_sockaddr_entry, list);
 		if (sctp_is_any(&addr->a)) {
-			cnt = sctp_copy_laddrs_to_user(sk, bp->port,
-						       &to, space_left);
+			cnt = sctp_copy_laddrs(sk, bp->port, addrs,
+						space_left, &bytes_copied);
 			if (cnt < 0) {
 				err = cnt;
-				goto unlock;
+				goto error;
 			}
 			goto copy_getaddrs;
 		}
@@ -4294,26 +4313,31 @@ static int sctp_getsockopt_local_addrs(s
 		memcpy(&temp, &addr->a, sizeof(temp));
 		sctp_get_pf_specific(sk->sk_family)->addr_v4map(sp, &temp);
 		addrlen = sctp_get_af_specific(temp.sa.sa_family)->sockaddr_len;
-		if(space_left < addrlen)
-			return -ENOMEM; /*fixme: right error?*/
-		if (copy_to_user(to, &temp, addrlen)) {
-			err = -EFAULT;
-			goto unlock;
+		if (space_left < addrlen) {
+			err =  -ENOMEM; /*fixme: right error?*/
+			goto error;
 		}
+		memcpy(addrs, &temp, addrlen);
 		to += addrlen;
+		bytes_copied += addrlen;
 		cnt ++;
 		space_left -= addrlen;
 	}
 
 copy_getaddrs:
+	sctp_read_unlock(addr_lock);
+
+	if (copy_to_user(to, addrs, bytes_copied)) {
+		err = -EFAULT;
+		goto error;
+	}
 	if (put_user(cnt, &((struct sctp_getaddrs __user *)optval)->addr_num))
 		return -EFAULT;
-	bytes_copied = ((char __user *)to) - optval;
 	if (put_user(bytes_copied, optlen))
 		return -EFAULT;
 
-unlock:
-	sctp_read_unlock(addr_lock);
+error:
+	kfree(addrs);
 	return err;
 }
 
_

Patches currently in -mm which might be from vladislav.yasevich@hp.com are

origin.patch
use-menuconfig-objects-sctp.patch
