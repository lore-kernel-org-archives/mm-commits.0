From: akpm@linux-foundation.org
Subject: - ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:51 -0700
Message-ID: <200807242328.m6ONSpjp011310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180AbYGXX3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tyhicks@linux.vnet.ibm.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: discard ecryptfsd registration messages in miscdev
has been removed from the -mm tree.  Its filename was
     ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: discard ecryptfsd registration messages in miscdev
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

The userspace eCryptfs daemon sends HELO and QUIT messages to the kernel
for per-user daemon (un)registration.  These messages are required when
netlink is used as the transport, but (un)registration is handled by
opening and closing the device file when miscdev is the transport.  These
messages should be discarded in the miscdev transport so that a daemon
isn't registered twice.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/miscdev.c |   59 ----------------------------------------
 1 file changed, 59 deletions(-)

diff -puN fs/ecryptfs/miscdev.c~ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev fs/ecryptfs/miscdev.c
--- a/fs/ecryptfs/miscdev.c~ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev
+++ a/fs/ecryptfs/miscdev.c
@@ -358,46 +358,6 @@ out_unlock_daemon:
 }
 
 /**
- * ecryptfs_miscdev_helo
- * @euid: effective user id of miscdevess sending helo packet
- * @user_ns: The namespace in which @euid applies
- * @pid: miscdevess id of miscdevess sending helo packet
- *
- * Returns zero on success; non-zero otherwise
- */
-static int ecryptfs_miscdev_helo(uid_t euid, struct user_namespace *user_ns,
-				 struct pid *pid)
-{
-	int rc;
-
-	rc = ecryptfs_process_helo(ECRYPTFS_TRANSPORT_MISCDEV, euid, user_ns,
-				   pid);
-	if (rc)
-		printk(KERN_WARNING "Error processing HELO; rc = [%d]\n", rc);
-	return rc;
-}
-
-/**
- * ecryptfs_miscdev_quit
- * @euid: effective user id of miscdevess sending quit packet
- * @user_ns: The namespace in which @euid applies
- * @pid: miscdevess id of miscdevess sending quit packet
- *
- * Returns zero on success; non-zero otherwise
- */
-static int ecryptfs_miscdev_quit(uid_t euid, struct user_namespace *user_ns,
-				 struct pid *pid)
-{
-	int rc;
-
-	rc = ecryptfs_process_quit(euid, user_ns, pid);
-	if (rc)
-		printk(KERN_WARNING
-		       "Error processing QUIT message; rc = [%d]\n", rc);
-	return rc;
-}
-
-/**
  * ecryptfs_miscdev_response - miscdevess response to message previously sent to daemon
  * @data: Bytes comprising struct ecryptfs_message
  * @data_size: sizeof(struct ecryptfs_message) + data len
@@ -512,26 +472,7 @@ ecryptfs_miscdev_write(struct file *file
 			       __func__, rc);
 		break;
 	case ECRYPTFS_MSG_HELO:
-		rc = ecryptfs_miscdev_helo(current->euid,
-					   current->nsproxy->user_ns,
-					   task_pid(current));
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to process "
-			       "helo from pid [0x%p]; rc = [%d]\n", __func__,
-			       task_pid(current), rc);
-			goto out_free;
-		}
-		break;
 	case ECRYPTFS_MSG_QUIT:
-		rc = ecryptfs_miscdev_quit(current->euid,
-					   current->nsproxy->user_ns,
-					   task_pid(current));
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to process "
-			       "quit from pid [0x%p]; rc = [%d]\n", __func__,
-			       task_pid(current), rc);
-			goto out_free;
-		}
 		break;
 	default:
 		ecryptfs_printk(KERN_WARNING, "Dropping miscdev "
_

Patches currently in -mm which might be from tyhicks@linux.vnet.ibm.com are

origin.patch

