From: akpm@linux-foundation.org
Subject: [to-be-updated]
 x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch removed from -mm tree
Date: Thu, 17 Apr 2014 11:58:09 -0700
Message-ID: <53502441.f5+BVL+vzD31/H8u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQS6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 14:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, steven@uplinklabs.net, srikar@linux.vnet.ibm.com, riel@redhat.com, peterz@infradead.org, mingo@kernel.org, hpa@zytor.com, gorcunov@gmail.com, fengguang.wu@intel.com, david.vrabel@citrix.com, dave.hansen@intel.com, aarcange@redhat.com, mgorman@suse.de

Subject: [to-be-updated] x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch removed from -mm tree
To: mgorman@suse.de,aarcange@redhat.com,dave.hansen@intel.com,david.vrabel@citrix.com,fengguang.wu@intel.com,gorcunov@gmail.com,hpa@zytor.com,mingo@kernel.org,peterz@infradead.org,riel@redhat.com,srikar@linux.vnet.ibm.com,steven@uplinklabs.net,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 11:58:09 -0700


The patch titled
     Subject: x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix
has been removed from the -mm tree.  Its filename was
     x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix

PowerPC has NUMA_BALANCING and non-NUMA_BALANCING versions of pte_present
and I missed that when testing cross-compiling.  This should be collapsed
with the patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch

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

 arch/powerpc/include/asm/pgtable.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/powerpc/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -126,6 +126,12 @@ static inline int pte_present(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_PRESENT;
 }
+
+static inline int pte_present_nonuma(pte_t pte)
+{
+	return pte_present(pte);
+}
+
 #endif /* CONFIG_NUMA_BALANCING */
 
 /* Conversion functions: convert a page and protection to a page entry,
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-use-paravirt-friendly-ops-for-numa-hinting-ptes.patch
thp-close-race-between-split-and-zap-huge-pages.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

