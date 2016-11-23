From: akpm@linux-foundation.org
Subject: [folded-merged] mle-releases-issue-fix.patch removed from -mm
 tree
Date: Tue, 22 Nov 2016 16:38:07 -0800
Message-ID: <5834e4ef.cHVA+Ig4zXXzJRgF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39866 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755909AbcKWAsx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:48:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mle-releases-issue-fix
has been removed from the -mm tree.  Its filename was
     mle-releases-issue-fix.patch

This patch was dropped because it was folded into mle-releases-issue.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mle-releases-issue-fix

cleanups

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
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
mle-releases-issue.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

