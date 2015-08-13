From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix.patch added
 to -mm tree
Date: Thu, 13 Aug 2015 13:50:38 -0700
Message-ID: <55cd031e.wGI1+riyN7gwarTs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbbHMUuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Aug 2015 16:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status=
-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix.patc=
h

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-status-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-status-fix.patch

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
Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: J=F6rn Engel <joern@logfs.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 +-
 mm/hugetlb.c                       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-status-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpag=
es-field-to-proc-pid-status-fix
+++ a/Documentation/filesystems/proc.txt
@@ -174,7 +174,7 @@ read the file /proc/PID/status:
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
-  HugetlbPages:          0 kB (0x2048kB)
+  HugetlbPages:          0 kB (0*2048kB)
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
diff -puN mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-p=
id-status-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-s=
tatus-fix
+++ a/mm/hugetlb.c
@@ -2807,7 +2807,7 @@ void hugetlb_report_usage(struct seq_fil
 		if (i > 0)
 			seq_puts(m, " ");
=20
-		seq_printf(m, "%ldx%dkB",
+		seq_printf(m, "%ld*%dkB",
 			atomic_long_read(&mm->hugetlb_usage.count[i]),
 			huge_page_size(&hstates[i]) >> 10);
 	}
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
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix.patch
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
