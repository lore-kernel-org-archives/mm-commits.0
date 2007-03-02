From: akpm@linux-foundation.org
Subject: + allow-huge-page-allocations-to-use-gfp_high_movable.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:51 -0800
Message-ID: <200703022141.l22Lfpo5019792@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42083 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030469AbXCBVl4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Allow huge page allocations to use GFP_HIGH_MOVABLE
has been added to the -mm tree.  Its filename is
     allow-huge-page-allocations-to-use-gfp_high_movable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h   |    3 +++
 include/linux/mempolicy.h |    6 +++---
 include/linux/sysctl.h    |    1 +
 kernel/sysctl.c           |    8 ++++++++
 mm/hugetlb.c              |   23 ++++++++++++++++++++---
 mm/mempolicy.c            |    5 +++--
 6 files changed, 38 insertions(+), 8 deletions(-)

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
@@ -29,6 +30,8 @@ int hugetlb_reserve_pages(struct inode *
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 
 extern unsigned long max_huge_pages;
+extern unsigned long hugepages_treat_as_movable;
+extern gfp_t htlb_alloc_mask;
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
diff -puN include/linux/sysctl.h~allow-huge-page-allocations-to-use-gfp_high_movable include/linux/sysctl.h
--- a/include/linux/sysctl.h~allow-huge-page-allocations-to-use-gfp_high_movable
+++ a/include/linux/sysctl.h
@@ -207,6 +207,7 @@ enum
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+	VM_HUGETLB_TREAT_MOVABLE=36, /* Allocate hugepages from ZONE_MOVABLE */
 
 	/* s390 vm cmm sysctls */
 	VM_CMM_PAGES=1111,
diff -puN kernel/sysctl.c~allow-huge-page-allocations-to-use-gfp_high_movable kernel/sysctl.c
--- a/kernel/sysctl.c~allow-huge-page-allocations-to-use-gfp_high_movable
+++ a/kernel/sysctl.c
@@ -722,6 +722,14 @@ static ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	 },
+	 {
+		.ctl_name	= VM_HUGETLB_TREAT_MOVABLE,
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
+gfp_t htlb_alloc_mask = GFP_HIGHUSER;
+unsigned long hugepages_treat_as_movable;
+
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
  */
@@ -68,12 +71,13 @@ static struct page *dequeue_huge_page(st
 {
 	int nid = numa_node_id();
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
@@ -103,7 +107,7 @@ static int alloc_fresh_huge_page(void)
 {
 	static int nid = 0;
 	struct page *page;
-	page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
+	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
 					HUGETLB_PAGE_ORDER);
 	nid = next_node(nid, node_online_map);
 	if (nid == MAX_NUMNODES)
@@ -243,6 +247,19 @@ int hugetlb_sysctl_handler(struct ctl_ta
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
+		htlb_alloc_mask = GFP_HIGH_MOVABLE;
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
@@ -1202,7 +1202,8 @@ static inline unsigned interleave_nid(st
 
 #ifdef CONFIG_HUGETLBFS
 /* Return a zonelist suitable for a huge page allocation. */
-struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr)
+struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
+							gfp_t gfp_flags)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 
@@ -1210,7 +1211,7 @@ struct zonelist *huge_zonelist(struct vm
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
-		return NODE_DATA(nid)->node_zonelists + gfp_zone(GFP_HIGHUSER);
+		return NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_flags);
 	}
 	return zonelist_policy(GFP_HIGHUSER, pol);
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
