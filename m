From: akpm@linux-foundation.org
Subject: - allow-huge-page-allocations-to-use-gfp_high_movable.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:40 -0700
Message-ID: <200707172300.l6HN0eLO011313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935744AbXGQXBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Allow huge page allocations to use GFP_HIGH_MOVABLE
has been removed from the -mm tree.  Its filename was
     allow-huge-page-allocations-to-use-gfp_high_movable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow huge page allocations to use GFP_HIGH_MOVABLE
From: Mel Gorman <mel@csn.ul.ie>

Huge pages are not movable so are not allocated from ZONE_MOVABLE.  However,
as ZONE_MOVABLE will always have pages that can be migrated or reclaimed, it
can be used to satisfy hugepage allocations even when the system has been
running a long time.  This allows an administrator to resize the hugepage pool
at runtime depending on the size of ZONE_MOVABLE.

This patch adds a new sysctl called hugepages_treat_as_movable.  When a
non-zero value is written to it, future allocations for the huge page pool
will use ZONE_MOVABLE.  Despite huge pages being non-movable, we do not
introduce additional external fragmentation of note as huge pages are always
the largest contiguous block we care about.

[akpm@linux-foundation.org: various fixes]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h   |    2 ++
 include/linux/mempolicy.h |    6 +++---
 kernel/sysctl.c           |    8 ++++++++
 mm/hugetlb.c              |   23 ++++++++++++++++++++---
 mm/mempolicy.c            |    5 +++--
 5 files changed, 36 insertions(+), 8 deletions(-)

diff -puN include/linux/hugetlb.h~allow-huge-page-allocations-to-use-gfp_high_movable include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~allow-huge-page-allocations-to-use-gfp_high_movable
+++ a/include/linux/hugetlb.h
@@ -15,6 +15,7 @@ static inline int is_vm_hugetlb_page(str
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
+int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int);
 void unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
@@ -29,6 +30,7 @@ int hugetlb_reserve_pages(struct inode *
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 
 extern unsigned long max_huge_pages;
+extern unsigned long hugepages_treat_as_movable;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 
diff -puN include/linux/mempolicy.h~allow-huge-page-allocations-to-use-gfp_high_movable include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~allow-huge-page-allocations-to-use-gfp_high_movable
+++ a/include/linux/mempolicy.h
@@ -159,7 +159,7 @@ extern void mpol_fix_fork_child_flag(str
 
 extern struct mempolicy default_policy;
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
-		unsigned long addr);
+		unsigned long addr, gfp_t gfp_flags);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -256,9 +256,9 @@ static inline void mpol_fix_fork_child_f
 #define set_cpuset_being_rebound(x) do {} while (0)
 
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
-		unsigned long addr)
+		unsigned long addr, gfp_t gfp_flags)
 {
-	return NODE_DATA(0)->node_zonelists + gfp_zone(GFP_HIGHUSER);
+	return NODE_DATA(0)->node_zonelists + gfp_zone(gfp_flags);
 }
 
 static inline int do_migrate_pages(struct mm_struct *mm,
diff -puN kernel/sysctl.c~allow-huge-page-allocations-to-use-gfp_high_movable kernel/sysctl.c
--- a/kernel/sysctl.c~allow-huge-page-allocations-to-use-gfp_high_movable
+++ a/kernel/sysctl.c
@@ -826,6 +826,14 @@ static ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	 },
+	 {
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hugepages_treat_as_movable",
+		.data		= &hugepages_treat_as_movable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &hugetlb_treat_movable_handler,
+	},
 #endif
 	{
 		.ctl_name	= VM_LOWMEM_RESERVE_RATIO,
diff -puN mm/hugetlb.c~allow-huge-page-allocations-to-use-gfp_high_movable mm/hugetlb.c
--- a/mm/hugetlb.c~allow-huge-page-allocations-to-use-gfp_high_movable
+++ a/mm/hugetlb.c
@@ -27,6 +27,9 @@ unsigned long max_huge_pages;
 static struct list_head hugepage_freelists[MAX_NUMNODES];
 static unsigned int nr_huge_pages_node[MAX_NUMNODES];
 static unsigned int free_huge_pages_node[MAX_NUMNODES];
+static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
+unsigned long hugepages_treat_as_movable;
+
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
  */
@@ -68,12 +71,13 @@ static struct page *dequeue_huge_page(st
 {
 	int nid;
 	struct page *page = NULL;
-	struct zonelist *zonelist = huge_zonelist(vma, address);
+	struct zonelist *zonelist = huge_zonelist(vma, address,
+						htlb_alloc_mask);
 	struct zone **z;
 
 	for (z = zonelist->zones; *z; z++) {
 		nid = zone_to_nid(*z);
-		if (cpuset_zone_allowed_softwall(*z, GFP_HIGHUSER) &&
+		if (cpuset_zone_allowed_softwall(*z, htlb_alloc_mask) &&
 		    !list_empty(&hugepage_freelists[nid]))
 			break;
 	}
@@ -113,7 +117,7 @@ static int alloc_fresh_huge_page(void)
 	prev_nid = nid;
 	spin_unlock(&nid_lock);
 
-	page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
+	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
 					HUGETLB_PAGE_ORDER);
 	if (page) {
 		set_compound_page_dtor(page, free_huge_page);
@@ -263,6 +267,19 @@ int hugetlb_sysctl_handler(struct ctl_ta
 	max_huge_pages = set_max_huge_pages(max_huge_pages);
 	return 0;
 }
+
+int hugetlb_treat_movable_handler(struct ctl_table *table, int write,
+			struct file *file, void __user *buffer,
+			size_t *length, loff_t *ppos)
+{
+	proc_dointvec(table, write, file, buffer, length, ppos);
+	if (hugepages_treat_as_movable)
+		htlb_alloc_mask = GFP_HIGHUSER_MOVABLE;
+	else
+		htlb_alloc_mask = GFP_HIGHUSER;
+	return 0;
+}
+
 #endif /* CONFIG_SYSCTL */
 
 int hugetlb_report_meminfo(char *buf)
diff -puN mm/mempolicy.c~allow-huge-page-allocations-to-use-gfp_high_movable mm/mempolicy.c
--- a/mm/mempolicy.c~allow-huge-page-allocations-to-use-gfp_high_movable
+++ a/mm/mempolicy.c
@@ -1203,7 +1203,8 @@ static inline unsigned interleave_nid(st
 
 #ifdef CONFIG_HUGETLBFS
 /* Return a zonelist suitable for a huge page allocation. */
-struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr)
+struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
+							gfp_t gfp_flags)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 
@@ -1211,7 +1212,7 @@ struct zonelist *huge_zonelist(struct vm
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
-		return NODE_DATA(nid)->node_zonelists + gfp_zone(GFP_HIGHUSER);
+		return NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_flags);
 	}
 	return zonelist_policy(GFP_HIGHUSER, pol);
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
