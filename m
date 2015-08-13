From: akpm@linux-foundation.org
Subject: + mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch added to -mm tree
Date: Wed, 12 Aug 2015 17:01:05 -0700
Message-ID: <55cbde41.o9DnhNmSX2KJimzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbHMABG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 20:01:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: proc: add HugetlbPages field to /proc/PID/st=
atus
has been added to the -mm tree.  Its filename is
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-status.patch

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
Subject: mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status

Currently there's no easy way to get per-process usage of hugetlb pages=
,
which is inconvenient because userspace applications which use hugetlb
typically want to control their processes on the basis of how much memo=
ry
(including hugetlb) they use.  So this patch simply provides easy acces=
s
to the info via /proc/PID/status.

With this patch, for example, /proc/PID/status shows a line like this:

  HugetlbPages:      20480 kB (10x2048kB)

If your system supports and enables multiple hugepage sizes, the line l=
ooks
like this:

  HugetlbPages:    1069056 kB (1x1048576kB 10x2048kB)

so you can easily know how many hugepages in which pagesize are used by=
 a
process.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: J=F6rn Engel <joern@logfs.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +++
 fs/proc/task_mmu.c                 |    1 +
 include/linux/hugetlb.h            |   20 ++++++++++++++++++++
 include/linux/mm_types.h           |   10 ++++++++++
 mm/hugetlb.c                       |   27 +++++++++++++++++++++++++++
 mm/rmap.c                          |    4 +++-
 6 files changed, 64 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-status Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpag=
es-field-to-proc-pid-status
+++ a/Documentation/filesystems/proc.txt
@@ -174,6 +174,7 @@ read the file /proc/PID/status:
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
+  HugetlbPages:          0 kB (0x2048kB)
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -237,6 +238,8 @@ Table 1-2: Contents of the status files
  VmPTE                       size of page table entries
  VmPMD                       size of second level page tables
  VmSwap                      size of swap usage (the number of referre=
d swapents)
+ HugetlbPages                size of hugetlb memory portions (with add=
itional info
+                             about number of mapped hugepages for each=
 page size)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for =
queue
  SigPnd                      bitmap of pending signals for the thread
diff -puN fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-=
proc-pid-status fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc=
-pid-status
+++ a/fs/proc/task_mmu.c
@@ -69,6 +69,7 @@ void task_mem(struct seq_file *m, struct
 		ptes >> 10,
 		pmds >> 10,
 		swap << (PAGE_SHIFT-10));
+	hugetlb_report_usage(m, mm);
 }
=20
 unsigned long task_vsize(struct mm_struct *mm)
diff -puN include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-fiel=
d-to-proc-pid-status include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-field-to=
-proc-pid-status
+++ a/include/linux/hugetlb.h
@@ -483,6 +483,18 @@ static inline spinlock_t *huge_pte_lockp
 #define hugepages_supported() (HPAGE_SHIFT !=3D 0)
 #endif
=20
+void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
+
+static inline void inc_hugetlb_count(struct mm_struct *mm, struct hsta=
te *h)
+{
+	atomic_long_inc(&mm->hugetlb_usage.count[hstate_index(h)]);
+}
+
+static inline void dec_hugetlb_count(struct mm_struct *mm, struct hsta=
te *h)
+{
+	atomic_long_dec(&mm->hugetlb_usage.count[hstate_index(h)]);
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
@@ -519,6 +531,14 @@ static inline spinlock_t *huge_pte_lockp
 {
 	return &mm->page_table_lock;
 }
+
+static inline void hugetlb_report_usage(struct seq_file *f, struct mm_=
struct *m)
+{
+}
+
+static inline void dec_hugetlb_count(struct mm_struct *mm, struct hsta=
te *h)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
=20
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff -puN include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-fie=
ld-to-proc-pid-status include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-t=
o-proc-pid-status
+++ a/include/linux/mm_types.h
@@ -375,6 +375,12 @@ struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
 };
=20
+#ifdef CONFIG_HUGETLB_PAGE
+struct hugetlb_usage {
+	atomic_long_t count[HUGE_MAX_HSTATE];
+};
+#endif
+
 struct kioctx_table;
 struct mm_struct {
 	struct vm_area_struct *mmap;		/* list of VMAs */
@@ -495,6 +501,10 @@ struct mm_struct {
 	/* address of the bounds directory */
 	void __user *bd_addr;
 #endif
+
+#ifdef CONFIG_HUGETLB_PAGE
+	struct hugetlb_usage hugetlb_usage;
+#endif
 };
=20
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff -puN mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-p=
id-status mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-s=
tatus
+++ a/mm/hugetlb.c
@@ -2790,6 +2790,30 @@ void hugetlb_show_meminfo(void)
 				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
 }
=20
+void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
+{
+	int i;
+	unsigned long total_usage =3D 0;
+
+	for (i =3D 0; i < HUGE_MAX_HSTATE; i++) {
+		total_usage +=3D atomic_long_read(&mm->hugetlb_usage.count[i]) *
+			(huge_page_size(&hstates[i]) >> 10);
+	}
+
+	seq_printf(m, "HugetlbPages:\t%8lu kB (", total_usage);
+	for (i =3D 0; i < HUGE_MAX_HSTATE; i++) {
+		if (huge_page_order(&hstates[i]) =3D=3D 0)
+			break;
+		if (i > 0)
+			seq_puts(m, " ");
+
+		seq_printf(m, "%ldx%dkB",
+			atomic_long_read(&mm->hugetlb_usage.count[i]),
+			huge_page_size(&hstates[i]) >> 10);
+	}
+	seq_puts(m, ")\n");
+}
+
 /* Return the number pages of memory we physically have, in PAGE_SIZE =
units. */
 unsigned long hugetlb_total_pages(void)
 {
@@ -3025,6 +3049,7 @@ int copy_hugetlb_page_range(struct mm_st
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
+			inc_hugetlb_count(dst, h);
 		}
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
@@ -3105,6 +3130,7 @@ again:
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
=20
+		dec_hugetlb_count(mm, h);
 		page_remove_rmap(page);
 		force_flush =3D !__tlb_remove_page(tlb, page);
 		if (force_flush) {
@@ -3501,6 +3527,7 @@ retry:
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
=20
+	inc_hugetlb_count(mm, h);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
 		ret =3D hugetlb_cow(mm, vma, address, ptep, new_pte, page, ptl);
diff -puN mm/rmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-=
status mm/rmap.c
--- a/mm/rmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-stat=
us
+++ a/mm/rmap.c
@@ -1348,7 +1348,9 @@ static int try_to_unmap_one(struct page
 	update_hiwater_rss(mm);
=20
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (!PageHuge(page)) {
+		if (PageHuge(page)) {
+			dec_hugetlb_count(mm, page_hstate(page));
+		} else {
 			if (PageAnon(page))
 				dec_mm_counter(mm, MM_ANONPAGES);
 			else
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com =
are

mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page-fix.patch
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
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.pa=
tch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
reverted-selftests-add-hugetlbfstest.patch
selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch
documentation-update-libhugetlbfs-location-and-use-for-testing.patch
mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
mm-hwpoison-fix-pagehwpoison-test-set-race.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-erro=
r-handling.patch
mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hw=
poison_page.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hw=
poison_page-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
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
