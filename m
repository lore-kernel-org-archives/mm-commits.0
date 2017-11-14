From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?ocfs2-old-mle-put-and-release-after-the-function-dlm=5Fad?=
 =?US-ASCII?Q?d=5Fmigration=5Fmle-called-fix.patch?= removed from -mm tree
Date: Mon, 13 Nov 2017 22:26:55 -0800
Message-ID: <20171114062655.wquCNMoyX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753403AbdKNG05 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 01:26:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch

This patch was dropped because it was folded into ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix

fix coding style, comments

Cc: Guozhonghua <guozhonghua@h3c.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2613,7 +2613,7 @@ static int dlm_migrate_lockres(struct dl
 	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
 				    namelen, target, dlm->node_num);
 	if (ret == -EEXIST) {
-		if(oldmle)
+		if (oldmle)
 			__dlm_put_mle(oldmle);
 
 		spin_unlock(&dlm->master_lock);
@@ -2622,10 +2622,11 @@ static int dlm_migrate_lockres(struct dl
 		goto fail;
 	}
 
-	/* If an old one mle found, it should be put. if its type is BLOCK,
-	 * it should be put again. Because it had been unhasded from the map
+	/*
+	 * If an old mle is found, it should be put.  If its type is BLOCK,
+	 * it should be put again.  Because it has been unhasded from the map
 	 * in the function dlm_add_migration_mle.
-	 * otherwise the memory will be leaked. It will not found it again from
+	 * Otherwise the memory will be leaked.  It will not be found again from
 	 * the hash map.
 	 */
 	if (oldmle) {
@@ -2633,9 +2634,11 @@ static int dlm_migrate_lockres(struct dl
 		__dlm_mle_detach_hb_events(dlm, oldmle);
 		__dlm_put_mle(oldmle);
 
-		/* if the type of the mle is BLOCK, should put it once for release.
-		 * otherwise memory leak may be caused because oldmle had been unhashed
-		 * from the hash map, it will not be found anymore.
+		/*
+		 * If the type of the mle is BLOCK, it should be put once for
+		 * release.  Otherwise a memory leak may be caused because
+		 * oldmle has been unhashed from the hash map and it will not
+		 * be found any more.
 		 */
 		if (oldmle->type == DLM_MLE_BLOCK)
 			__dlm_put_mle(oldmle);
@@ -3201,10 +3204,11 @@ int dlm_migrate_request_handler(struct o
 	if (ret < 0)
 		kmem_cache_free(dlm_mle_cache, mle);
 
-	/* If an old one mle found, it should be put. if its type is BLOCK,
-	 * it should be put again. Because it had been unhasded from the map
-	 * in the function dlm_add_migration_mle.
-	 * otherwise the memory will be leaked. It will not found it again from
+	/*
+	 * If an old mle is found, it should be put.  If its type is BLOCK,
+	 * it should be put again because it has been unhashed from the map
+	 * in the dlm_add_migration_mle().
+	 * Otherwise the memory will be leaked.  It will not be found again from
 	 * the hash map.
 	 */
 	if (oldmle) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
net-sched-sch_redc-work-around-gcc-444-anon-union-initializer-issue.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

