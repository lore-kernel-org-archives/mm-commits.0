From: akpm@linux-foundation.org
Subject: [merged] mm-filemap-move-radix-tree-hole-searching-here.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:23 -0700
Message-ID: <533f088b.xRyYdI1wfy929C6U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbaDDTbY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan@kernel.org, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-filemap-move-radix-tree-hole-searching-here.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan@kernel.org,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:23 -0700


The patch titled
     Subject: mm: filemap: move radix tree hole searching here
has been removed from the -mm tree.  Its filename was
     mm-filemap-move-radix-tree-hole-searching-here.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: filemap: move radix tree hole searching here

The radix tree hole searching code is only used for page cache, for
example the readahead code trying to get a a picture of the area
surrounding a fault.

It sufficed to rely on the radix tree definition of holes, which is "empty
tree slot".  But this is about to change, though, as shadow page
descriptors will be stored in the page cache after the actual pages get
evicted from memory.

Move the functions over to mm/filemap.c and make them native page cache
operations, where they can later be adapted to handle the new definition
of "page cache hole".

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
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

 fs/nfs/blocklayout/blocklayout.c |    2 
 include/linux/pagemap.h          |    5 +
 include/linux/radix-tree.h       |    4 -
 lib/radix-tree.c                 |   75 ----------------------------
 mm/filemap.c                     |   76 +++++++++++++++++++++++++++++
 mm/readahead.c                   |    4 -
 6 files changed, 84 insertions(+), 82 deletions(-)

diff -puN fs/nfs/blocklayout/blocklayout.c~mm-filemap-move-radix-tree-hole-searching-here fs/nfs/blocklayout/blocklayout.c
--- a/fs/nfs/blocklayout/blocklayout.c~mm-filemap-move-radix-tree-hole-searching-here
+++ a/fs/nfs/blocklayout/blocklayout.c
@@ -1213,7 +1213,7 @@ static u64 pnfs_num_cont_bytes(struct in
 	end = DIV_ROUND_UP(i_size_read(inode), PAGE_CACHE_SIZE);
 	if (end != NFS_I(inode)->npages) {
 		rcu_read_lock();
-		end = radix_tree_next_hole(&mapping->page_tree, idx + 1, ULONG_MAX);
+		end = page_cache_next_hole(mapping, idx + 1, ULONG_MAX);
 		rcu_read_unlock();
 	}
 
diff -puN include/linux/pagemap.h~mm-filemap-move-radix-tree-hole-searching-here include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-filemap-move-radix-tree-hole-searching-here
+++ a/include/linux/pagemap.h
@@ -243,6 +243,11 @@ static inline struct page *page_cache_al
 
 typedef int filler_t(void *, struct page *);
 
+pgoff_t page_cache_next_hole(struct address_space *mapping,
+			     pgoff_t index, unsigned long max_scan);
+pgoff_t page_cache_prev_hole(struct address_space *mapping,
+			     pgoff_t index, unsigned long max_scan);
+
 extern struct page * find_get_page(struct address_space *mapping,
 				pgoff_t index);
 extern struct page * find_lock_page(struct address_space *mapping,
diff -puN include/linux/radix-tree.h~mm-filemap-move-radix-tree-hole-searching-here include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~mm-filemap-move-radix-tree-hole-searching-here
+++ a/include/linux/radix-tree.h
@@ -227,10 +227,6 @@ radix_tree_gang_lookup(struct radix_tree
 unsigned int radix_tree_gang_lookup_slot(struct radix_tree_root *root,
 			void ***results, unsigned long *indices,
 			unsigned long first_index, unsigned int max_items);
-unsigned long radix_tree_next_hole(struct radix_tree_root *root,
-				unsigned long index, unsigned long max_scan);
-unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
-				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 int radix_tree_maybe_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
diff -puN lib/radix-tree.c~mm-filemap-move-radix-tree-hole-searching-here lib/radix-tree.c
--- a/lib/radix-tree.c~mm-filemap-move-radix-tree-hole-searching-here
+++ a/lib/radix-tree.c
@@ -946,81 +946,6 @@ next:
 }
 EXPORT_SYMBOL(radix_tree_range_tag_if_tagged);
 
-
-/**
- *	radix_tree_next_hole    -    find the next hole (not-present entry)
- *	@root:		tree root
- *	@index:		index key
- *	@max_scan:	maximum range to search
- *
- *	Search the set [index, min(index+max_scan-1, MAX_INDEX)] for the lowest
- *	indexed hole.
- *
- *	Returns: the index of the hole if found, otherwise returns an index
- *	outside of the set specified (in which case 'return - index >= max_scan'
- *	will be true). In rare cases of index wrap-around, 0 will be returned.
- *
- *	radix_tree_next_hole may be called under rcu_read_lock. However, like
- *	radix_tree_gang_lookup, this will not atomically search a snapshot of
- *	the tree at a single point in time. For example, if a hole is created
- *	at index 5, then subsequently a hole is created at index 10,
- *	radix_tree_next_hole covering both indexes may return 10 if called
- *	under rcu_read_lock.
- */
-unsigned long radix_tree_next_hole(struct radix_tree_root *root,
-				unsigned long index, unsigned long max_scan)
-{
-	unsigned long i;
-
-	for (i = 0; i < max_scan; i++) {
-		if (!radix_tree_lookup(root, index))
-			break;
-		index++;
-		if (index == 0)
-			break;
-	}
-
-	return index;
-}
-EXPORT_SYMBOL(radix_tree_next_hole);
-
-/**
- *	radix_tree_prev_hole    -    find the prev hole (not-present entry)
- *	@root:		tree root
- *	@index:		index key
- *	@max_scan:	maximum range to search
- *
- *	Search backwards in the range [max(index-max_scan+1, 0), index]
- *	for the first hole.
- *
- *	Returns: the index of the hole if found, otherwise returns an index
- *	outside of the set specified (in which case 'index - return >= max_scan'
- *	will be true). In rare cases of wrap-around, ULONG_MAX will be returned.
- *
- *	radix_tree_next_hole may be called under rcu_read_lock. However, like
- *	radix_tree_gang_lookup, this will not atomically search a snapshot of
- *	the tree at a single point in time. For example, if a hole is created
- *	at index 10, then subsequently a hole is created at index 5,
- *	radix_tree_prev_hole covering both indexes may return 5 if called under
- *	rcu_read_lock.
- */
-unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
-				   unsigned long index, unsigned long max_scan)
-{
-	unsigned long i;
-
-	for (i = 0; i < max_scan; i++) {
-		if (!radix_tree_lookup(root, index))
-			break;
-		index--;
-		if (index == ULONG_MAX)
-			break;
-	}
-
-	return index;
-}
-EXPORT_SYMBOL(radix_tree_prev_hole);
-
 /**
  *	radix_tree_gang_lookup - perform multiple lookup on a radix tree
  *	@root:		radix tree root
diff -puN mm/filemap.c~mm-filemap-move-radix-tree-hole-searching-here mm/filemap.c
--- a/mm/filemap.c~mm-filemap-move-radix-tree-hole-searching-here
+++ a/mm/filemap.c
@@ -686,6 +686,82 @@ int __lock_page_or_retry(struct page *pa
 }
 
 /**
+ * page_cache_next_hole - find the next hole (not-present entry)
+ * @mapping: mapping
+ * @index: index
+ * @max_scan: maximum range to search
+ *
+ * Search the set [index, min(index+max_scan-1, MAX_INDEX)] for the
+ * lowest indexed hole.
+ *
+ * Returns: the index of the hole if found, otherwise returns an index
+ * outside of the set specified (in which case 'return - index >=
+ * max_scan' will be true). In rare cases of index wrap-around, 0 will
+ * be returned.
+ *
+ * page_cache_next_hole may be called under rcu_read_lock. However,
+ * like radix_tree_gang_lookup, this will not atomically search a
+ * snapshot of the tree at a single point in time. For example, if a
+ * hole is created at index 5, then subsequently a hole is created at
+ * index 10, page_cache_next_hole covering both indexes may return 10
+ * if called under rcu_read_lock.
+ */
+pgoff_t page_cache_next_hole(struct address_space *mapping,
+			     pgoff_t index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(&mapping->page_tree, index))
+			break;
+		index++;
+		if (index == 0)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(page_cache_next_hole);
+
+/**
+ * page_cache_prev_hole - find the prev hole (not-present entry)
+ * @mapping: mapping
+ * @index: index
+ * @max_scan: maximum range to search
+ *
+ * Search backwards in the range [max(index-max_scan+1, 0), index] for
+ * the first hole.
+ *
+ * Returns: the index of the hole if found, otherwise returns an index
+ * outside of the set specified (in which case 'index - return >=
+ * max_scan' will be true). In rare cases of wrap-around, ULONG_MAX
+ * will be returned.
+ *
+ * page_cache_prev_hole may be called under rcu_read_lock. However,
+ * like radix_tree_gang_lookup, this will not atomically search a
+ * snapshot of the tree at a single point in time. For example, if a
+ * hole is created at index 10, then subsequently a hole is created at
+ * index 5, page_cache_prev_hole covering both indexes may return 5 if
+ * called under rcu_read_lock.
+ */
+pgoff_t page_cache_prev_hole(struct address_space *mapping,
+			     pgoff_t index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(&mapping->page_tree, index))
+			break;
+		index--;
+		if (index == ULONG_MAX)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(page_cache_prev_hole);
+
+/**
  * find_get_page - find and get a page reference
  * @mapping: the address_space to search
  * @offset: the page index
diff -puN mm/readahead.c~mm-filemap-move-radix-tree-hole-searching-here mm/readahead.c
--- a/mm/readahead.c~mm-filemap-move-radix-tree-hole-searching-here
+++ a/mm/readahead.c
@@ -347,7 +347,7 @@ static pgoff_t count_history_pages(struc
 	pgoff_t head;
 
 	rcu_read_lock();
-	head = radix_tree_prev_hole(&mapping->page_tree, offset - 1, max);
+	head = page_cache_prev_hole(mapping, offset - 1, max);
 	rcu_read_unlock();
 
 	return offset - 1 - head;
@@ -427,7 +427,7 @@ ondemand_readahead(struct address_space
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = radix_tree_next_hole(&mapping->page_tree, offset+1,max);
+		start = page_cache_next_hole(mapping, offset + 1, max);
 		rcu_read_unlock();
 
 		if (!start || start - offset > max)
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

