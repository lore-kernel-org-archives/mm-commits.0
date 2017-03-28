From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 28 Mar 2017 12:10:05 -0700
Message-ID: <58dab50d.uWQCkNB21PQtf+cu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbdC1TKM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 15:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c     |    4 ----
 net/rxrpc/sendmsg.c |    6 ------
 2 files changed, 10 deletions(-)

diff -puN drivers/md/md.c~linux-next-git-rejects drivers/md/md.c
--- a/drivers/md/md.c~linux-next-git-rejects
+++ a/drivers/md/md.c
@@ -6522,13 +6522,9 @@ static int update_size(struct mddev *mdd
 	}
 	rv = mddev->pers->resize(mddev, num_sectors);
 	if (!rv) {
-<<<<<<< HEAD
-		if (mddev->queue) {
-=======
 		if (mddev_is_clustered(mddev))
 			md_cluster_ops->update_size(mddev, old_dev_sectors);
 		else if (mddev->queue) {
->>>>>>> linux-next/akpm-base
 			set_capacity(mddev->gendisk, mddev->array_sectors);
 			revalidate_disk(mddev->gendisk);
 		}
diff -puN net/rxrpc/sendmsg.c~linux-next-git-rejects net/rxrpc/sendmsg.c
--- a/net/rxrpc/sendmsg.c~linux-next-git-rejects
+++ a/net/rxrpc/sendmsg.c
@@ -618,14 +618,8 @@ int rxrpc_kernel_send_data(struct socket
 		ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len);
 		break;
 	case RXRPC_CALL_COMPLETE:
-<<<<<<< HEAD
-		read_lock_bh(&call->state_lock);
-		ret = -call->error;
-		read_unlock_bh(&call->state_lock);
-=======
 		/* It's too late for this call */
 		ret = -ESHUTDOWN;
->>>>>>> linux-next/akpm-base
 		break;
 	default:
 		 /* Request phase complete for this client call */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
x86-atomic-move-__atomic_add_unless-out-of-line-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

