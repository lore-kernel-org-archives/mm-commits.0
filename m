From: akpm@linux-foundation.org
Subject: + thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp.patch added to -mm tree
Date: Fri, 30 Nov 2012 14:10:10 -0800
Message-ID: <20121130221010.A098382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40876 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2K3WKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 17:10:11 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so21857vcd.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 14:10:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, jslaby@suse.cz


The patch titled
     Subject: thp: fix anononymous page accounting in fallback path for COW of HZP
has been added to the -mm tree.  Its filename is
     thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp.patch

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
Subject: thp: fix anononymous page accounting in fallback path for COW of HZP

Don't forget to account newly allocated page in fallback path for
copy-on-write of huge zero page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp
+++ a/mm/huge_memory.c
@@ -1074,6 +1074,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 	spin_unlock(&mm->page_table_lock);
+	inc_mm_counter(mm, MM_ANONPAGES);
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
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
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
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

