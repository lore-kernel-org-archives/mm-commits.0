From: akpm@linux-foundation.org
Subject: [merged] lib-radix-tree-radix_tree_delete_item.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:19 -0700
Message-ID: <533f0887.+aCqieTSGn9TOnV1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbaDDTbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan@kernel.org, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] lib-radix-tree-radix_tree_delete_item.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan@kernel.org,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:19 -0700


The patch titled
     Subject: lib: radix-tree: add radix_tree_delete_item()
has been removed from the -mm tree.  Its filename was
     lib-radix-tree-radix_tree_delete_item.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: lib: radix-tree: add radix_tree_delete_item()

Provide a function that does not just delete an entry at a given index,
but also allows passing in an expected item.  Delete only if that item is
still located at the specified index.

This is handy when lockless tree traversals want to delete entries as well
because they don't have to do an second, locked lookup to verify the slot
has not changed under them before deleting the entry.

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

 include/linux/radix-tree.h |    1 +
 lib/radix-tree.c           |   31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff -puN include/linux/radix-tree.h~lib-radix-tree-radix_tree_delete_item include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~lib-radix-tree-radix_tree_delete_item
+++ a/include/linux/radix-tree.h
@@ -219,6 +219,7 @@ static inline void radix_tree_replace_sl
 int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
 void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_delete(struct radix_tree_root *, unsigned long);
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
diff -puN lib/radix-tree.c~lib-radix-tree-radix_tree_delete_item lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-tree-radix_tree_delete_item
+++ a/lib/radix-tree.c
@@ -1337,15 +1337,18 @@ static inline void radix_tree_shrink(str
 }
 
 /**
- *	radix_tree_delete    -    delete an item from a radix tree
+ *	radix_tree_delete_item    -    delete an item from a radix tree
  *	@root:		radix tree root
  *	@index:		index key
+ *	@item:		expected item
  *
- *	Remove the item at @index from the radix tree rooted at @root.
+ *	Remove @item at @index from the radix tree rooted at @root.
  *
- *	Returns the address of the deleted item, or NULL if it was not present.
+ *	Returns the address of the deleted item, or NULL if it was not present
+ *	or the entry at the given @index was not @item.
  */
-void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
+void *radix_tree_delete_item(struct radix_tree_root *root,
+			     unsigned long index, void *item)
 {
 	struct radix_tree_node *node = NULL;
 	struct radix_tree_node *slot = NULL;
@@ -1380,6 +1383,11 @@ void *radix_tree_delete(struct radix_tre
 	if (slot == NULL)
 		goto out;
 
+	if (item && slot != item) {
+		slot = NULL;
+		goto out;
+	}
+
 	/*
 	 * Clear all tags associated with the item to be deleted.
 	 * This way of doing it would be inefficient, but seldom is any set.
@@ -1424,6 +1432,21 @@ void *radix_tree_delete(struct radix_tre
 out:
 	return slot;
 }
+EXPORT_SYMBOL(radix_tree_delete_item);
+
+/**
+ *	radix_tree_delete    -    delete an item from a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Remove the item at @index from the radix tree rooted at @root.
+ *
+ *	Returns the address of the deleted item, or NULL if it was not present.
+ */
+void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
+{
+	return radix_tree_delete_item(root, index, NULL);
+}
 EXPORT_SYMBOL(radix_tree_delete);
 
 /**
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

