From: akpm@linux-foundation.org
Subject: [folded-merged] thp-copy_huge_pmd-copy-huge-zero-page-v6.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:34:39 -0800
Message-ID: <20121212213440.696A8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59151 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab2LLVel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:34:41 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so128505ggn.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:34:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-copy_huge_pmd-copy-huge-zero-page-v6
has been removed from the -mm tree.  Its filename was
     thp-copy_huge_pmd-copy-huge-zero-page-v6.patch

This patch was dropped because it was folded into thp-copy_huge_pmd-copy-huge-zero-page.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-copy_huge_pmd-copy-huge-zero-page-v6

It's easy to copy huge zero page. Just set destination pmd to huge zero
page.

It's safe to copy huge zero page since we have none yet :-p

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/huge_memory.c~thp-copy_huge_pmd-copy-huge-zero-page-v6 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-copy_huge_pmd-copy-huge-zero-page-v6
+++ a/mm/huge_memory.c
@@ -958,6 +958,11 @@ int copy_huge_pmd(struct mm_struct *dst_
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
+	/*
+	 * mm->pagetable lock is enough to be sure that huge zero pmd is not
+	 * under splitting since we don't split the page itself, only pmd to
+	 * a page table.
+	 */
 	if (is_huge_zero_pmd(pmd)) {
 		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd);
 		ret = 0;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
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

