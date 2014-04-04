From: akpm@linux-foundation.org
Subject: [merged]
 mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:21 -0700
Message-ID: <533f0889.DD4Du3geGumgUj4L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaDDTbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan@kernel.org, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan@kernel.org,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:21 -0700


The patch titled
     Subject: mm: shmem: save one radix tree lookup when truncating swapped pages
has been removed from the -mm tree.  Its filename was
     mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: shmem: save one radix tree lookup when truncating swapped pages

Page cache radix tree slots are usually stabilized by the page lock, but
shmem's swap cookies have no such thing.  Because the overall truncation
loop is lockless, the swap entry is currently confirmed by a tree lookup
and then deleted by another tree lookup under the same tree lock region.

Use radix_tree_delete_item() instead, which does the verification and
deletion with only one lookup.  This also allows removing the delete-only
special case from shmem_radix_tree_replace().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Metin Doslu <metin@citusdata.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ozgun Erdogan <ozgun@citusdata.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/shmem.c~mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages mm/shmem.c
--- a/mm/shmem.c~mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages
+++ a/mm/shmem.c
@@ -242,19 +242,17 @@ static int shmem_radix_tree_replace(stru
 			pgoff_t index, void *expected, void *replacement)
 {
 	void **pslot;
-	void *item = NULL;
+	void *item;
 
 	VM_BUG_ON(!expected);
+	VM_BUG_ON(!replacement);
 	pslot = radix_tree_lookup_slot(&mapping->page_tree, index);
-	if (pslot)
-		item = radix_tree_deref_slot_protected(pslot,
-							&mapping->tree_lock);
+	if (!pslot)
+		return -ENOENT;
+	item = radix_tree_deref_slot_protected(pslot, &mapping->tree_lock);
 	if (item != expected)
 		return -ENOENT;
-	if (replacement)
-		radix_tree_replace_slot(pslot, replacement);
-	else
-		radix_tree_delete(&mapping->page_tree, index);
+	radix_tree_replace_slot(pslot, replacement);
 	return 0;
 }
 
@@ -386,14 +384,15 @@ export:
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
 {
-	int error;
+	void *old;
 
 	spin_lock_irq(&mapping->tree_lock);
-	error = shmem_radix_tree_replace(mapping, index, radswap, NULL);
+	old = radix_tree_delete_item(&mapping->page_tree, index, radswap);
 	spin_unlock_irq(&mapping->tree_lock);
-	if (!error)
-		free_swap_and_cache(radix_to_swp_entry(radswap));
-	return error;
+	if (old != radswap)
+		return -ENOENT;
+	free_swap_and_cache(radix_to_swp_entry(radswap));
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm-fix.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

