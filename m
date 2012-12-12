From: akpm@linux-foundation.org
Subject: [folded-merged] thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:37:14 -0800
Message-ID: <20121212213714.7698D820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:65182 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2LLVhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:37:16 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so129611ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:37:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-setup-huge-zero-page-on-non-write-page-fault-fix
has been removed from the -mm tree.  Its filename was
     thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch

This patch was dropped because it was folded into thp-setup-huge-zero-page-on-non-write-page-fault.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-setup-huge-zero-page-on-non-write-page-fault-fix

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-setup-huge-zero-page-on-non-write-page-fault-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-setup-huge-zero-page-on-non-write-page-fault-fix
+++ a/mm/huge_memory.c
@@ -738,7 +738,7 @@ int do_huge_pmd_anonymous_page(struct mm
 			pgtable_t pgtable;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
-				goto out;
+				return VM_FAULT_OOM;
 			spin_lock(&mm->page_table_lock);
 			set_huge_zero_page(pgtable, mm, vma, haddr, pmd);
 			spin_unlock(&mm->page_table_lock);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-implement-refcounting-for-huge-zero-page-fix.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch

