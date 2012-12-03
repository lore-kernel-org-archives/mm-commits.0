From: akpm@linux-foundation.org
Subject: + thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch added to -mm tree
Date: Mon, 03 Dec 2012 15:36:08 -0800
Message-ID: <20121203233608.CB88582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40184 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2LCXgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 18:36:10 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so301581vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 15:36:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: thp: change_huge_pmd(): make sure we don't try to make a page writable
has been added to the -mm tree.  Its filename is
     thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: change_huge_pmd(): make sure we don't try to make a page writable

mprotect core never tries to make page writable using change_huge_pmd(). 
Let's add an assert that the assumption is true.  It's important to be
sure we will not make huge zero page writable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable
+++ a/mm/huge_memory.c
@@ -1434,6 +1434,7 @@ int change_huge_pmd(struct vm_area_struc
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
 		entry = pmd_modify(entry, newprot);
+		BUG_ON(pmd_write(entry));
 		set_pmd_at(mm, addr, pmd, entry);
 		spin_unlock(&vma->vm_mm->page_table_lock);
 		ret = 1;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
thp-fix-update_mmu_cache_pmd-calls.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build-fix.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
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
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch

