From: akpm@linux-foundation.org
Subject: - mm-dont-waste-swap-on-locked-pages.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:01 -0800
Message-ID: <200802052231.m15MVgln012184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761634AbYBEWmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, solo@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: don't waste swap on locked pages
has been removed from the -mm tree.  Its filename was
     mm-dont-waste-swap-on-locked-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't waste swap on locked pages
From: Hugh Dickins <hugh@veritas.com>

try_to_unmap always fails on a page found in a VM_LOCKED vma (unless
migrating), and recycles it back to the active list.  But if it's an
anonymous page, we've already allocated swap to it: just wasting swap.
Spot locked pages in page_referenced_one and treat them as referenced.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ethan Solomita <solo@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-dont-waste-swap-on-locked-pages mm/rmap.c
--- a/mm/rmap.c~mm-dont-waste-swap-on-locked-pages
+++ a/mm/rmap.c
@@ -283,7 +283,10 @@ static int page_referenced_one(struct pa
 	if (!pte)
 		goto out;
 
-	if (ptep_clear_flush_young(vma, address, pte))
+	if (vma->vm_flags & VM_LOCKED) {
+		referenced++;
+		*mapcount = 1;	/* break early from loop */
+	} else if (ptep_clear_flush_young(vma, address, pte))
 		referenced++;
 
 	/* Pretend the page is referenced if the task has the
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
