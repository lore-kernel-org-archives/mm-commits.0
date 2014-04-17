From: akpm@linux-foundation.org
Subject: +
 x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch added to -mm tree
Date: Thu, 17 Apr 2014 11:59:05 -0700
Message-ID: <53502479.LRCT+DNEnTW+MVtR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQS7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 14:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, steven@uplinklabs.net, srikar@linux.vnet.ibm.com, riel@redhat.com, peterz@infradead.org, mingo@kernel.org, hpa@zytor.com, gorcunov@gmail.com, fengguang.wu@intel.com, david.vrabel@citrix.com, dave.hansen@intel.com, aarcange@redhat.com, mgorman@suse.de

Subject: + x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch added to -mm tree
To: mgorman@suse.de,aarcange@redhat.com,dave.hansen@intel.com,david.vrabel@citrix.com,fengguang.wu@intel.com,gorcunov@gmail.com,hpa@zytor.com,mingo@kernel.org,peterz@infradead.org,riel@redhat.com,srikar@linux.vnet.ibm.com,steven@uplinklabs.net,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 11:59:05 -0700


The patch titled
     Subject: x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix 2
has been added to the -mm tree.  Its filename is
     x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix 2

powerpc has NUMA_BALANCING and non-NUMA_BALANCING versions of pte_present
and I missed that when testing cross-compiling.  This patch replaces
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Anvin <hpa@zytor.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Noonan <steven@uplinklabs.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |    1 +
 arch/x86/include/asm/pgtable.h     |    1 +
 include/asm-generic/pgtable.h      |    4 ++++
 3 files changed, 6 insertions(+)

diff -puN arch/powerpc/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2 arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -44,6 +44,7 @@ static inline int pte_present(pte_t pte)
 	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t pte)
 {
 	return pte_val(pte) & (_PAGE_PRESENT);
diff -puN arch/x86/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2 arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2
+++ a/arch/x86/include/asm/pgtable.h
@@ -453,6 +453,7 @@ static inline int pte_present(pte_t a)
 			       _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t a)
 {
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
diff -puN include/asm-generic/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2
+++ a/include/asm-generic/pgtable.h
@@ -233,6 +233,10 @@ static inline int pmd_same(pmd_t pmd_a,
 # define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
 
+#ifndef pte_present_nonuma
+#define pte_present_nonuma(pte) pte_present(pte)
+#endif
+
 #ifndef flush_tlb_fix_spurious_fault
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-use-paravirt-friendly-ops-for-numa-hinting-ptes.patch
thp-close-race-between-split-and-zap-huge-pages.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

