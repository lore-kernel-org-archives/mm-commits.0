From: akpm@linux-foundation.org
Subject: [merged] tmpfs-fix-off-by-one-in-max_blocks-checks.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:50 -0700
Message-ID: <201104181759.p3IHx1Zo016111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231Ab1DRSD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: fix off-by-one in max_blocks checks
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-off-by-one-in-max_blocks-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: fix off-by-one in max_blocks checks
From: Hugh Dickins <hughd@google.com>

If you fill up a tmpfs, df was showing
tmpfs                   460800         -         -   -  /tmp
because of an off-by-one in the max_blocks checks.  Fix it so df shows
tmpfs                   460800    460800         0 100% /tmp

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-off-by-one-in-max_blocks-checks mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-off-by-one-in-max_blocks-checks
+++ a/mm/shmem.c
@@ -421,7 +421,8 @@ static swp_entry_t *shmem_swp_alloc(stru
 		 * a waste to allocate index if we cannot allocate data.
 		 */
 		if (sbinfo->max_blocks) {
-			if (percpu_counter_compare(&sbinfo->used_blocks, (sbinfo->max_blocks - 1)) > 0)
+			if (percpu_counter_compare(&sbinfo->used_blocks,
+						sbinfo->max_blocks - 1) >= 0)
 				return ERR_PTR(-ENOSPC);
 			percpu_counter_inc(&sbinfo->used_blocks);
 			spin_lock(&inode->i_lock);
@@ -1397,7 +1398,8 @@ repeat:
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
-			if ((percpu_counter_compare(&sbinfo->used_blocks, sbinfo->max_blocks) > 0) ||
+			if (percpu_counter_compare(&sbinfo->used_blocks,
+						sbinfo->max_blocks) >= 0 ||
 			    shmem_acct_block(info->flags)) {
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mmap-add-alignment-for-some-variables.patch
mmap-avoid-unnecessary-anon_vma-lock.patch
mmap-avoid-merging-cloned-vmas.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
prio_tree-debugging-patch.patch

