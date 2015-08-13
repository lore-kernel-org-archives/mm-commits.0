From: akpm@linux-foundation.org
Subject: + mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
 added to -mm tree
Date: Wed, 12 Aug 2015 17:01:03 -0700
Message-ID: <55cbde3f.Arq+UGrFczbl3Spa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbHMABE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 20:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: proc: add HugetlbPages field to /proc/PID/sm=
aps
has been added to the -mm tree.  Its filename is
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-smaps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-smaps.patch

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
Subject: mm: hugetlb: proc: add HugetlbPages field to /proc/PID/smaps

Currently /proc/PID/smaps provides no usage info for vma(VM_HUGETLB), w=
hich
is inconvenient when we want to know per-task or per-vma base hugetlb u=
sage.
To solve this, this patch adds a new line for hugetlb usage like below:

  Size:              20480 kB
  Rss:                   0 kB
  Pss:                   0 kB
  Shared_Clean:          0 kB
  Shared_Dirty:          0 kB
  Private_Clean:         0 kB
  Private_Dirty:         0 kB
  Referenced:            0 kB
  Anonymous:             0 kB
  AnonHugePages:         0 kB
  HugetlbPages:      18432 kB
  Swap:                  0 kB
  KernelPageSize:     2048 kB
  MMUPageSize:        2048 kB
  Locked:                0 kB
  VmFlags: rd wr mr mw me de ht

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: J=F6rn Engel <joern@logfs.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   32 ++++++++++++++++++---------
 fs/proc/task_mmu.c                 |   29 ++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-smaps Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpag=
es-field-to-proc-pid-smaps
+++ a/Documentation/filesystems/proc.txt
@@ -423,6 +423,8 @@ Private_Clean:         0 kB
 Private_Dirty:         0 kB
 Referenced:          892 kB
 Anonymous:             0 kB
+AnonHugePages:         0 kB
+HugetlbPages:          0 kB
 Swap:                  0 kB
 SwapPss:               0 kB
 KernelPageSize:        4 kB
@@ -440,20 +442,30 @@ The "proportional set size" (PSS) of a p
 in memory, where each page is divided by the number of processes shari=
ng it.
 So if a process has 1000 pages all to itself, and 1000 shared with one=
 other
 process, its PSS will be 1500.
+
 Note that even a page which is part of a MAP_SHARED mapping, but has o=
nly
-a single pte mapped, i.e.  is currently used by only one process, is a=
ccounted
-as private and not as shared.
+a single pte mapped, i.e.  is currently used by only one process, is
+accounted as private and not as shared.
+
 "Referenced" indicates the amount of memory currently marked as refere=
nced or
 accessed.
-"Anonymous" shows the amount of memory that does not belong to any fil=
e.  Even
-a mapping associated with a file may contain anonymous pages: when MAP=
_PRIVATE
-and a page is modified, the file page is replaced by a private anonymo=
us copy.
+
+"Anonymous" shows the amount of memory that does not belong to any fil=
e.
+Even a mapping associated with a file may contain anonymous pages: whe=
n
+MAP_PRIVATE and a page is modified, the file page is replaced by a pri=
vate
+anonymous copy.
+
+"AnonHugePages" shows the ammount of memory backed by transparent huge=
page.
+
+"HugetlbPages" shows the ammount of memory backed by hugetlbfs page.
+
 "Swap" shows how much would-be-anonymous memory is also used, but out =
on
-swap.
-"SwapPss" shows proportional swap share of this mapping.
-"VmFlags" field deserves a separate description. This member represent=
s the kernel
-flags associated with the particular virtual memory area in two letter=
 encoded
-manner. The codes are the following:
+swap.  SwapPss" shows proportional swap share of this mapping.
+
+"VmFlags" field deserves a separate description.  This member represen=
ts
+the kernel flags associated with the particular virtual memory area in=
 two
+letter encoded manner.  The codes are the following:
+
     rd  - readable
     wr  - writeable
     ex  - executable
diff -puN fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-=
proc-pid-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc=
-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -445,6 +445,7 @@ struct mem_size_stats {
 	unsigned long anonymous;
 	unsigned long anonymous_thp;
 	unsigned long swap;
+	unsigned long hugetlb;
 	u64 pss;
 	u64 swap_pss;
 };
@@ -625,12 +626,38 @@ static void show_smap_vma_flags(struct s
 	seq_putc(m, '\n');
 }
=20
+#ifdef CONFIG_HUGETLB_PAGE
+static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
+				 unsigned long addr, unsigned long end,
+				 struct mm_walk *walk)
+{
+	struct mem_size_stats *mss =3D walk->private;
+	struct vm_area_struct *vma =3D walk->vma;
+	struct page *page =3D NULL;
+
+	if (pte_present(*pte)) {
+		page =3D vm_normal_page(vma, addr, *pte);
+	} else if (is_swap_pte(*pte)) {
+		swp_entry_t swpent =3D pte_to_swp_entry(*pte);
+
+		if (is_migration_entry(swpent))
+			page =3D migration_entry_to_page(swpent);
+	}
+	if (page)
+		mss->hugetlb +=3D huge_page_size(hstate_vma(vma));
+	return 0;
+}
+#endif /* HUGETLB_PAGE */
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct vm_area_struct *vma =3D v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk =3D {
 		.pmd_entry =3D smaps_pte_range,
+#ifdef CONFIG_HUGETLB_PAGE
+		.hugetlb_entry =3D smaps_hugetlb_range,
+#endif
 		.mm =3D vma->vm_mm,
 		.private =3D &mss,
 	};
@@ -652,6 +679,7 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
+		   "HugetlbPages:   %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "SwapPss:        %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
@@ -667,6 +695,7 @@ static int show_smap(struct seq_file *m,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
 		   mss.anonymous_thp >> 10,
+		   mss.hugetlb >> 10,
 		   mss.swap >> 10,
 		   (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
 		   vma_kernel_pagesize(vma) >> 10,
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
