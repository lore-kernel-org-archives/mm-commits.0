From: akpm@linux-foundation.org
Subject: + tmpfs-fix-off-by-one-in-max_blocks-checks.patch added to -mm tree
Date: Fri, 08 Apr 2011 12:34:08 -0700
Message-ID: <201104081934.p38JY8DA025278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757764Ab1DHTeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2011 15:34:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, tim.c.chen@linux.intel.com


The patch titled
     tmpfs: fix off-by-one in max_blocks checks
has been added to the -mm tree.  Its filename is
     tmpfs-fix-off-by-one-in-max_blocks-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
tmpfs-fix-off-by-one-in-max_blocks-checks.patch
mmap-add-alignment-for-some-variables.patch
mmap-avoid-unnecessary-anon_vma-lock.patch
mmap-avoid-merging-cloned-vmas.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
prio_tree-debugging-patch.patch

