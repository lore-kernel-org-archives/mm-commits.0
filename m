From: akpm@linux-foundation.org
Subject: [folded-merged] thp-huge-zero-page-basic-preparation-v6.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:34:07 -0800
Message-ID: <20121212213407.B287A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:43492 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2LLVeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:34:09 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so128845ghb.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:34:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-huge-zero-page-basic-preparation-v6
has been removed from the -mm tree.  Its filename was
     thp-huge-zero-page-basic-preparation-v6.patch

This patch was dropped because it was folded into thp-huge-zero-page-basic-preparation.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-huge-zero-page-basic-preparation-v6

Huge zero page (hzp) is a non-movable huge page (2M on x86-64) filled
with zeros.

For now let's allocate the page on hugepage_init(). We'll switch to lazy
allocation later.

We are not going to map the huge zero page until we can handle it
properly on all code paths.

is_huge_zero_{pfn,pmd}() functions will be used by following patches to
check whether the pfn/pmd is huge zero page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-huge-zero-page-basic-preparation-v6 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-huge-zero-page-basic-preparation-v6
+++ a/mm/huge_memory.c
@@ -161,7 +161,7 @@ static int start_khugepaged(void)
 	return err;
 }
 
-static int init_huge_zero_page(void)
+static int __init init_huge_zero_page(void)
 {
 	struct page *hpage;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-implement-refcounting-for-huge-zero-page-fix.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch

