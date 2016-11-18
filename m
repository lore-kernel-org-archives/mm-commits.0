From: akpm@linux-foundation.org
Subject: +
 ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch added to -mm tree
Date: Fri, 18 Nov 2016 14:59:58 -0800
Message-ID: <582f87ee.+crVK8cLZYRNZcLQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753071AbcKRW77 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 17:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix
has been added to the -mm tree.  Its filename is
     ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix

fix coding style, comments

Cc: Guozhonghua <guozhonghua@h3c.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
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
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mle-releases-issue-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

