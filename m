From: akpm@linux-foundation.org
Subject: - sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-update.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:45:01 -0700
Message-ID: <200704302145.l3ULj1Hr015639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423716AbXD3Vpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladislav.yasevich@hp.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage update
has been removed from the -mm tree.  Its filename was
     sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage update
From: Vlad Yasevich <vladislav.yasevich@hp.com>

Here is an updated patch.  bytes_copied got turned into an int everywhere
since that is what the new API expects, so it should be enough for the old
api as well.  This also makes the code more consistent.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN net/sctp/socket.c~sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-update net/sctp/socket.c
--- a/net/sctp/socket.c~sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-update
+++ a/net/sctp/socket.c
@@ -4078,7 +4078,7 @@ done:
  */
 static int sctp_copy_laddrs_old(struct sock *sk, __u16 port,
 					int max_addrs, void *to,
-					size_t *bytes_copied)
+					int *bytes_copied)
 {
 	struct list_head *pos, *next;
 	struct sctp_sockaddr_entry *addr;
@@ -4107,7 +4107,7 @@ static int sctp_copy_laddrs_old(struct s
 }
 
 static int sctp_copy_laddrs(struct sock *sk, __u16 port, void *to,
-			    size_t space_left, size_t *bytes_copied)
+			    size_t space_left, int *bytes_copied)
 {
 	struct list_head *pos, *next;
 	struct sctp_sockaddr_entry *addr;
@@ -4156,7 +4156,7 @@ static int sctp_getsockopt_local_addrs_o
 	rwlock_t *addr_lock;
 	int err = 0;
 	void *addrs;
-	size_t bytes_copied = 0;
+	int bytes_copied = 0;
 
 	if (len != sizeof(struct sctp_getaddrs_old))
 		return -EINVAL;
@@ -4185,7 +4185,7 @@ static int sctp_getsockopt_local_addrs_o
 	to = getaddrs.addrs;
 
 	/* Allocate space for a local instance of packed array to hold all
-	 * the data.  We store addresses here first and then copy them
+	 * the data.  We store addresses here first and then put write them
 	 * to the user in one shot.
 	 */
 	addrs = kmalloc(sizeof(union sctp_addr) * getaddrs.addr_num,
@@ -4256,7 +4256,7 @@ static int sctp_getsockopt_local_addrs(s
 	rwlock_t *addr_lock;
 	int err = 0;
 	size_t space_left;
-	size_t bytes_copied = 0;
+	int bytes_copied = 0;
 	void *addrs;
 
 	if (len <= sizeof(struct sctp_getaddrs))
_

Patches currently in -mm which might be from vladislav.yasevich@hp.com are

origin.patch
use-menuconfig-objects-sctp.patch
