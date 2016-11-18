From: akpm@linux-foundation.org
Subject: + mle-releases-issue-fix.patch added to -mm tree
Date: Fri, 18 Nov 2016 14:51:26 -0800
Message-ID: <582f85ee.c7TadnMTdwh6e38p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752302AbcKRWv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 17:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ge.changwei@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mle-releases-issue-fix
has been added to the -mm tree.  Its filename is
     mle-releases-issue-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mle-releases-issue-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mle-releases-issue-fix.patch

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
Subject: mle-releases-issue-fix

cleanups

Cc: Gechangwei <ge.changwei@h3c.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: gechangwei <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~mle-releases-issue-fix fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~mle-releases-issue-fix
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1935,7 +1935,7 @@ ok:
 
 		spin_lock(&mle->spinlock);
 		if (mle->type == DLM_MLE_BLOCK || mle->type == DLM_MLE_MIGRATION)
-			extra_ref = test_bit(assert->node_idx, mle->maybe_map) ? 1 : 0;
+			extra_ref = test_bit(assert->node_idx, mle->maybe_map);
 		else {
 			/* MASTER mle: if any bits set in the response map
 			 * then the calling node needs to re-assert to clear
@@ -3338,7 +3338,7 @@ static void dlm_clean_block_mle(struct d
 		mlog(0, "mle found, but dead node %u would not have been "
 		     "master\n", dead_node);
 		spin_unlock(&mle->spinlock);
-	} else if(mle->master != O2NM_MAX_NODES){
+	} else if (mle->master != O2NM_MAX_NODES) {
 		mlog(ML_NOTICE, "mle found, master assert received, master has "
 			"already set to %d.\n ", mle->master);
 		spin_unlock(&mle->spinlock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mle-releases-issue-fix.patch
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

