From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status.patch
 added to -mm tree
Date: Fri, 07 Aug 2015 15:57:03 -0700
Message-ID: <55c537bf.5RqW63uMjv264YJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946320AbbHGW5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: add VmHugetlbRSS: field in /proc/pid/status
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-vmhugetlbrs=
s-field-in-proc-pid-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-vmhugetlbrs=
s-field-in-proc-pid-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: add VmHugetlbRSS: field in /proc/pid/status

Currently there's no easy way to get per-process usage of hugetlb pages=
,
which is inconvenient because applications which use hugetlb typically
want to control their processes on the basis of how much memory (includ=
ing
hugetlb) they use.  So this patch simply provides easy access to the in=
fo
via /proc/pid/status.

This patch shouldn't change the OOM behavior (so hugetlb usage is ignor=
ed
as is now,) which I guess is fine until we have some strong reason to d=
o
it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: J=F6rn Engel <joern@logfs.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c       |    5 ++++-
 include/linux/hugetlb.h  |   18 ++++++++++++++++++
 include/linux/mm.h       |    3 +++
 include/linux/mm_types.h |    3 +++
 mm/hugetlb.c             |    9 +++++++++
 mm/memory.c              |    4 ++--
 mm/rmap.c                |    4 +++-
 7 files changed, 42 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-=
pid-status fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-=
status
+++ a/fs/proc/task_mmu.c
@@ -22,7 +22,7 @@
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	unsigned long data, text, lib, swap, ptes, pmds;
-	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
+	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss, hugetlb_r=
ss;
=20
 	/*
 	 * Note: to minimize their overhead, mm maintains hiwater_vm and
@@ -37,6 +37,7 @@ void task_mem(struct seq_file *m, struct
 	hiwater_rss =3D total_rss =3D get_mm_rss(mm);
 	if (hiwater_rss < mm->hiwater_rss)
 		hiwater_rss =3D mm->hiwater_rss;
+	hugetlb_rss =3D get_hugetlb_rss(mm);
=20
 	data =3D mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text =3D (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >>=
 10;
@@ -51,6 +52,7 @@ void task_mem(struct seq_file *m, struct
 		"VmPin:\t%8lu kB\n"
 		"VmHWM:\t%8lu kB\n"
 		"VmRSS:\t%8lu kB\n"
+		"VmHugetlbRSS:\t%8lu kB\n"
 		"VmData:\t%8lu kB\n"
 		"VmStk:\t%8lu kB\n"
 		"VmExe:\t%8lu kB\n"
@@ -64,6 +66,7 @@ void task_mem(struct seq_file *m, struct
 		mm->pinned_vm << (PAGE_SHIFT-10),
 		hiwater_rss << (PAGE_SHIFT-10),
 		total_rss << (PAGE_SHIFT-10),
+		hugetlb_rss << (PAGE_SHIFT-10),
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
 		ptes >> 10,
diff -puN include/linux/hugetlb.h~mm-hugetlb-add-vmhugetlbrss-field-in-=
proc-pid-status include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-add-vmhugetlbrss-field-in-proc=
-pid-status
+++ a/include/linux/hugetlb.h
@@ -483,6 +483,21 @@ static inline spinlock_t *huge_pte_lockp
 #define hugepages_supported() (HPAGE_SHIFT !=3D 0)
 #endif
=20
+/*
+ * This simple wrappers are to hide MM_HUGETLBPAGES from outside huget=
lbfs
+ * subsystem. The counter MM_HUGETLBPAGES is maintained in page unit b=
asis,
+ * so it changes by 512 for example if a 2MB hugepage is mapped or unm=
apped.
+ */
+static inline int get_hugetlb_rss(struct mm_struct *mm)
+{
+	return get_mm_counter(mm, MM_HUGETLBPAGES);
+}
+
+static inline void mod_hugetlb_rss(struct mm_struct *mm, long value)
+{
+	add_mm_counter(mm, MM_HUGETLBPAGES, value);
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
@@ -519,6 +534,9 @@ static inline spinlock_t *huge_pte_lockp
 {
 	return &mm->page_table_lock;
 }
+
+#define get_hugetlb_rss(mm)	0
+#define mod_hugetlb_rss(mm, value)	do {} while (0)
 #endif	/* CONFIG_HUGETLB_PAGE */
=20
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff -puN include/linux/mm.h~mm-hugetlb-add-vmhugetlbrss-field-in-proc-=
pid-status include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-=
status
+++ a/include/linux/mm.h
@@ -1342,6 +1342,9 @@ static inline void sync_mm_rss(struct mm
 }
 #endif
=20
+extern inline void init_rss_vec(int *rss);
+extern inline void add_mm_rss_vec(struct mm_struct *mm, int *rss);
+
 int vma_wants_writenotify(struct vm_area_struct *vma);
=20
 extern pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long add=
r,
diff -puN include/linux/mm_types.h~mm-hugetlb-add-vmhugetlbrss-field-in=
-proc-pid-status include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hugetlb-add-vmhugetlbrss-field-in-pro=
c-pid-status
+++ a/include/linux/mm_types.h
@@ -359,6 +359,9 @@ enum {
 	MM_FILEPAGES,
 	MM_ANONPAGES,
 	MM_SWAPENTS,
+#ifdef CONFIG_HUGETLB_PAGE
+	MM_HUGETLBPAGES,
+#endif
 	NR_MM_COUNTERS
 };
=20
diff -puN mm/hugetlb.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-st=
atus mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status
+++ a/mm/hugetlb.c
@@ -2971,9 +2971,11 @@ int copy_hugetlb_page_range(struct mm_st
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 	int ret =3D 0;
+	int rss[NR_MM_COUNTERS];
=20
 	cow =3D (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) =3D=3D VM_MAYWRIT=
E;
=20
+	init_rss_vec(rss);
 	mmun_start =3D vma->vm_start;
 	mmun_end =3D vma->vm_end;
 	if (cow)
@@ -3025,6 +3027,7 @@ int copy_hugetlb_page_range(struct mm_st
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
+			rss[MM_HUGETLBPAGES] +=3D pages_per_huge_page(h);
 		}
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
@@ -3033,6 +3036,7 @@ int copy_hugetlb_page_range(struct mm_st
 	if (cow)
 		mmu_notifier_invalidate_range_end(src, mmun_start, mmun_end);
=20
+	add_mm_rss_vec(dst, rss);
 	return ret;
 }
=20
@@ -3051,6 +3055,7 @@ void __unmap_hugepage_range(struct mmu_g
 	unsigned long sz =3D huge_page_size(h);
 	const unsigned long mmun_start =3D start;	/* For mmu_notifiers */
 	const unsigned long mmun_end   =3D end;	/* For mmu_notifiers */
+	int rss[NR_MM_COUNTERS];
=20
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
@@ -3060,6 +3065,7 @@ void __unmap_hugepage_range(struct mmu_g
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	address =3D start;
 again:
+	init_rss_vec(rss);
 	for (; address < end; address +=3D sz) {
 		ptep =3D huge_pte_offset(mm, address);
 		if (!ptep)
@@ -3105,6 +3111,7 @@ again:
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
=20
+		rss[MM_HUGETLBPAGES] -=3D pages_per_huge_page(h);
 		page_remove_rmap(page);
 		force_flush =3D !__tlb_remove_page(tlb, page);
 		if (force_flush) {
@@ -3120,6 +3127,7 @@ again:
 unlock:
 		spin_unlock(ptl);
 	}
+	add_mm_rss_vec(mm, rss);
 	/*
 	 * mmu_gather ran out of room to batch pages, we break out of
 	 * the PTE lock to avoid doing the potential expensive TLB invalidate
@@ -3501,6 +3509,7 @@ retry:
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
=20
+	mod_hugetlb_rss(mm, pages_per_huge_page(h));
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
 		ret =3D hugetlb_cow(mm, vma, address, ptep, new_pte, page, ptl);
diff -puN mm/memory.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-sta=
tus mm/memory.c
--- a/mm/memory.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status
+++ a/mm/memory.c
@@ -621,12 +621,12 @@ int __pte_alloc_kernel(pmd_t *pmd, unsig
 	return 0;
 }
=20
-static inline void init_rss_vec(int *rss)
+inline void init_rss_vec(int *rss)
 {
 	memset(rss, 0, sizeof(int) * NR_MM_COUNTERS);
 }
=20
-static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
+inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
 {
 	int i;
=20
diff -puN mm/rmap.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-statu=
s mm/rmap.c
--- a/mm/rmap.c~mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status
+++ a/mm/rmap.c
@@ -1348,7 +1348,9 @@ static int try_to_unmap_one(struct page
 	update_hiwater_rss(mm);
=20
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (!PageHuge(page)) {
+		if (PageHuge(page)) {
+			mod_hugetlb_rss(mm, -(1 << compound_order(page)));
+		} else {
 			if (PageAnon(page))
 				dec_mm_counter(mm, MM_ANONPAGES);
 			else
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com =
are

origin.patch
mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch
hugetlb-make-the-function-vma_shareable-bool.patch
pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-update-documentation.patch
pagemap-update-documentation-fix.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
hugetlbfs-add-hugetlbfs_fallocate-fix.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_r=
ange.patch
mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.=
patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
reverted-selftests-add-hugetlbfstest.patch
selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch
documentation-update-libhugetlbfs-location-and-use-for-testing.patch
smaps-fill-missing-fields-for-vmavm_hugetlb.patch
mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status.patch
mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status-fix.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.pat=
ch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.pat=
ch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
