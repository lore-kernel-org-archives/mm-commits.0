From: akpm@linux-foundation.org
Subject: - splice-use-mapping_gfp_mask.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:47 -0700
Message-ID: <200804041900.m34J0lhM004296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbYDDTBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, jens.axboe@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     splice: use mapping_gfp_mask()
has been removed from the -mm tree.  Its filename was
     splice-use-mapping_gfp_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splice: use mapping_gfp_mask()
From: Hugh Dickins <hugh@veritas.com>

The loop block driver is careful to mask __GFP_IO|__GFP_FS out of its
mapping_gfp_mask, to avoid hangs under memory pressure.  But nowadays it uses
splice, usually going through __generic_file_splice_read.  That must use
mapping_gfp_mask instead of GFP_KERNEL to avoid those hangs.

Ought to go into 2.6.25.  For 2.6.23 and 2.6.24 stable?  Well, I've not
actually seen this hang on any of these, though presumably it's lurking there.
 Where I did see it, and test the fix, was 2.6.25-rc5-mm1: whose SLUB had a
disturbing predilection (since corrected) for order-4 allocations, even when
allocating radix tree nodes.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/splice.c~splice-use-mapping_gfp_mask fs/splice.c
--- a/fs/splice.c~splice-use-mapping_gfp_mask
+++ a/fs/splice.c
@@ -320,7 +320,7 @@ __generic_file_splice_read(struct file *
 				break;
 
 			error = add_to_page_cache_lru(page, mapping, index,
-					      GFP_KERNEL);
+						mapping_gfp_mask(mapping));
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mm-try-both-endianess-when-checking-for-endianess.patch
mempolicy-support-optional-mode-flags-fix.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

