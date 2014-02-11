From: akpm@linux-foundation.org
Subject: + ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch added to -mm tree
Date: Mon, 10 Feb 2014 16:16:09 -0800
Message-ID: <52f96bc9.5WTcxPP36pcZX3ba%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaBKAQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com

Subject: + ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch added to -mm tree
To: joe@perches.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:16:09 -0800


The patch titled
     Subject: ncpfs: Add pr_fmt and convert printks to pr_<level>
has been added to the -mm tree.  Its filename is
     ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ncpfs: Add pr_fmt and convert printks to pr_<level>

Convert to a more current logging style.

Add pr_fmt to prefix with "ncpfs: ".
Remove the embedded function names and use "%s: ", __func__

Some previously unprefixed messages now have "ncpfs: "

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/file.c          |    4 +++-
 fs/ncpfs/getopt.c        |   12 +++++++-----
 fs/ncpfs/inode.c         |   10 ++++++----
 fs/ncpfs/ncplib_kernel.c |    4 ++--
 fs/ncpfs/sock.c          |   31 ++++++++++++++++---------------
 5 files changed, 34 insertions(+), 27 deletions(-)

diff -puN fs/ncpfs/file.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level
+++ a/fs/ncpfs/file.c
@@ -6,6 +6,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/uaccess.h>
 
 #include <linux/time.h>
@@ -34,7 +36,7 @@ int ncp_make_open(struct inode *inode, i
 
 	error = -EINVAL;
 	if (!inode) {
-		printk(KERN_ERR "ncp_make_open: got NULL inode\n");
+		pr_err("%s: got NULL inode\n", __func__);
 		goto out;
 	}
 
diff -puN fs/ncpfs/getopt.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level fs/ncpfs/getopt.c
--- a/fs/ncpfs/getopt.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level
+++ a/fs/ncpfs/getopt.c
@@ -2,6 +2,8 @@
  * getopt.c
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/string.h>
 
@@ -46,8 +48,8 @@ int ncp_getopt(const char *caller, char
 				if (opts->has_arg & OPT_NOPARAM) {
 					return opts->val;
 				}
-				printk(KERN_INFO "%s: the %s option requires an argument\n",
-				       caller, token);
+				pr_info("%s: the %s option requires an argument\n",
+					caller, token);
 				return -EINVAL;
 			}
 			if (opts->has_arg & OPT_INT) {
@@ -57,18 +59,18 @@ int ncp_getopt(const char *caller, char
 				if (!*v) {
 					return opts->val;
 				}
-				printk(KERN_INFO "%s: invalid numeric value in %s=%s\n",
+				pr_info("%s: invalid numeric value in %s=%s\n",
 					caller, token, val);
 				return -EDOM;
 			}
 			if (opts->has_arg & OPT_STRING) {
 				return opts->val;
 			}
-			printk(KERN_INFO "%s: unexpected argument %s to the %s option\n",
+			pr_info("%s: unexpected argument %s to the %s option\n",
 				caller, val, token);
 			return -EINVAL;
 		}
 	}
-	printk(KERN_INFO "%s: Unrecognized mount option %s\n", caller, token);
+	pr_info("%s: Unrecognized mount option %s\n", caller, token);
 	return -EOPNOTSUPP;
 }
diff -puN fs/ncpfs/inode.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level
+++ a/fs/ncpfs/inode.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 
 #include <asm/uaccess.h>
@@ -257,7 +259,7 @@ ncp_iget(struct super_block *sb, struct
 	struct inode *inode;
 
 	if (info == NULL) {
-		printk(KERN_ERR "ncp_iget: info is NULL\n");
+		pr_err("%s: info is NULL\n", __func__);
 		return NULL;
 	}
 
@@ -289,7 +291,7 @@ ncp_iget(struct super_block *sb, struct
 		}
 		insert_inode_hash(inode);
 	} else
-		printk(KERN_ERR "ncp_iget: iget failed!\n");
+		pr_err("%s: iget failed!\n", __func__);
 	return inode;
 }
 
@@ -305,7 +307,7 @@ ncp_evict_inode(struct inode *inode)
 
 	if (ncp_make_closed(inode) != 0) {
 		/* We can't do anything but complain. */
-		printk(KERN_ERR "ncp_evict_inode: could not close\n");
+		pr_err("%s: could not close\n", __func__);
 	}
 }
 
@@ -620,7 +622,7 @@ static int ncp_fill_super(struct super_b
 	   now because of PATH_MAX changes.. */
 	if (server->m.time_out < 1) {
 		server->m.time_out = 10;
-		printk(KERN_INFO "You need to recompile your ncpfs utils..\n");
+		pr_info("You need to recompile your ncpfs utils..\n");
 	}
 	server->m.time_out = server->m.time_out * HZ / 100;
 	server->m.file_mode = (server->m.file_mode & S_IRWXUGO) | S_IFREG;
diff -puN fs/ncpfs/ncplib_kernel.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level fs/ncpfs/ncplib_kernel.c
--- a/fs/ncpfs/ncplib_kernel.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level
+++ a/fs/ncpfs/ncplib_kernel.c
@@ -9,7 +9,7 @@
  *
  */
 
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "ncp_fs.h"
 
@@ -425,7 +425,7 @@ int ncp_obtain_info(struct ncp_server *s
 	int result;
 
 	if (target == NULL) {
-		printk(KERN_ERR "ncp_obtain_info: invalid call\n");
+		pr_err("%s: invalid call\n", __func__);
 		return -EINVAL;
 	}
 	ncp_init_request(server);
diff -puN fs/ncpfs/sock.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level fs/ncpfs/sock.c
--- a/fs/ncpfs/sock.c~ncpfs-add-pr_fmt-and-convert-printks-to-pr_level
+++ a/fs/ncpfs/sock.c
@@ -8,6 +8,7 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/time.h>
 #include <linux/errno.h>
@@ -231,7 +232,7 @@ static void __ncptcp_try_send(struct ncp
 		return;
 
 	if (result < 0) {
-		printk(KERN_ERR "ncpfs: tcp: Send failed: %d\n", result);
+		pr_err("tcp: Send failed: %d\n", result);
 		__ncp_abort_request(server, rq, result);
 		return;
 	}
@@ -332,7 +333,7 @@ static int ncp_add_request(struct ncp_se
 	mutex_lock(&server->rcv.creq_mutex);
 	if (!ncp_conn_valid(server)) {
 		mutex_unlock(&server->rcv.creq_mutex);
-		printk(KERN_ERR "ncpfs: tcp: Server died\n");
+		pr_err("tcp: Server died\n");
 		return -EIO;
 	}
 	ncp_req_get(req);
@@ -448,7 +449,7 @@ void ncpdgram_rcv_proc(struct work_struc
 							result -= 8;
 							hdrl = sock->sk->sk_family == AF_INET ? 8 : 6;
 							if (sign_verify_reply(server, server->rxbuf + hdrl, result - hdrl, cpu_to_le32(result), server->rxbuf + result)) {
-								printk(KERN_INFO "ncpfs: Signature violation\n");
+								pr_info("Signature violation\n");
 								result = -EIO;
 							}
 						}
@@ -524,7 +525,7 @@ static int do_tcp_rcv(struct ncp_server
 		return result;
 	}
 	if (result > len) {
-		printk(KERN_ERR "ncpfs: tcp: bug in recvmsg (%u > %Zu)\n", result, len);
+		pr_err("tcp: bug in recvmsg (%u > %Zu)\n", result, len);
 		return -EIO;			
 	}
 	return result;
@@ -552,7 +553,7 @@ static int __ncptcp_rcv_proc(struct ncp_
 					__ncptcp_abort(server);
 				}
 				if (result < 0) {
-					printk(KERN_ERR "ncpfs: tcp: error in recvmsg: %d\n", result);
+					pr_err("tcp: error in recvmsg: %d\n", result);
 				} else {
 					DPRINTK(KERN_ERR "ncpfs: tcp: EOF\n");
 				}
@@ -566,20 +567,20 @@ static int __ncptcp_rcv_proc(struct ncp_
 		switch (server->rcv.state) {
 			case 0:
 				if (server->rcv.buf.magic != htonl(NCP_TCP_RCVD_MAGIC)) {
-					printk(KERN_ERR "ncpfs: tcp: Unexpected reply type %08X\n", ntohl(server->rcv.buf.magic));
+					pr_err("tcp: Unexpected reply type %08X\n", ntohl(server->rcv.buf.magic));
 					__ncptcp_abort(server);
 					return -EIO;
 				}
 				datalen = ntohl(server->rcv.buf.len) & 0x0FFFFFFF;
 				if (datalen < 10) {
-					printk(KERN_ERR "ncpfs: tcp: Unexpected reply len %d\n", datalen);
+					pr_err("tcp: Unexpected reply len %d\n", datalen);
 					__ncptcp_abort(server);
 					return -EIO;
 				}
 #ifdef CONFIG_NCPFS_PACKET_SIGNING				
 				if (server->sign_active) {
 					if (datalen < 18) {
-						printk(KERN_ERR "ncpfs: tcp: Unexpected reply len %d\n", datalen);
+						pr_err("tcp: Unexpected reply len %d\n", datalen);
 						__ncptcp_abort(server);
 						return -EIO;
 					}
@@ -618,7 +619,7 @@ skipdata:;
 					goto skipdata2;
 				}
 				if (datalen > req->datalen + 8) {
-					printk(KERN_ERR "ncpfs: tcp: Unexpected reply len %d (expected at most %Zd)\n", datalen, req->datalen + 8);
+					pr_err("tcp: Unexpected reply len %d (expected at most %Zd)\n", datalen, req->datalen + 8);
 					server->rcv.state = 3;
 					goto skipdata;
 				}
@@ -638,12 +639,12 @@ skipdata:;
 				req = server->rcv.creq;
 				if (req->tx_type != NCP_ALLOC_SLOT_REQUEST) {
 					if (((struct ncp_reply_header*)server->rxbuf)->sequence != server->sequence) {
-						printk(KERN_ERR "ncpfs: tcp: Bad sequence number\n");
+						pr_err("tcp: Bad sequence number\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
 					if ((((struct ncp_reply_header*)server->rxbuf)->conn_low | (((struct ncp_reply_header*)server->rxbuf)->conn_high << 8)) != server->connection) {
-						printk(KERN_ERR "ncpfs: tcp: Connection number mismatch\n");
+						pr_err("tcp: Connection number mismatch\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
@@ -651,7 +652,7 @@ skipdata:;
 #ifdef CONFIG_NCPFS_PACKET_SIGNING				
 				if (server->sign_active && req->tx_type != NCP_DEALLOC_SLOT_REQUEST) {
 					if (sign_verify_reply(server, server->rxbuf + 6, req->datalen - 6, cpu_to_be32(req->datalen + 16), &server->rcv.buf.type)) {
-						printk(KERN_ERR "ncpfs: tcp: Signature violation\n");
+						pr_err("tcp: Signature violation\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
@@ -742,7 +743,7 @@ static int ncp_do_request(struct ncp_ser
 	int result;
 
 	if (server->lock == 0) {
-		printk(KERN_ERR "ncpfs: Server not locked!\n");
+		pr_err("Server not locked!\n");
 		return -EIO;
 	}
 	if (!ncp_conn_valid(server)) {
@@ -865,14 +866,14 @@ void ncp_lock_server(struct ncp_server *
 {
 	mutex_lock(&server->mutex);
 	if (server->lock)
-		printk(KERN_WARNING "ncp_lock_server: was locked!\n");
+		pr_warn("%s: was locked!\n", __func__);
 	server->lock = 1;
 }
 
 void ncp_unlock_server(struct ncp_server *server)
 {
 	if (!server->lock) {
-		printk(KERN_WARNING "ncp_unlock_server: was not locked!\n");
+		pr_warn("%s: was not locked!\n", __func__);
 		return;
 	}
 	server->lock = 0;
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-fix-detection-of-git-repository.patch
checkpatch-fix-detection-of-git-repository.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

