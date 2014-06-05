From: akpm@linux-foundation.org
Subject: [merged] mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:21 -0700
Message-ID: <5390ca39.amOuJn/1aImu+BA3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaFETvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, torvalds@linux-foundation.org, steven@uplinklabs.net, riel@redhat.com, peterz@infradead.org, mingo@kernel.org, mgorman@suse.de, hpa@zytor.com, david.vrabel@citrix.com, gorcunov@openvz.org

Subject: [merged] mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch removed from -mm tree
To: gorcunov@openvz.org,david.vrabel@citrix.com,hpa@zytor.com,mgorman@suse.de,mingo@kernel.org,peterz@infradead.org,riel@redhat.com,steven@uplinklabs.net,torvalds@linux-foundation.org,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:21 -0700


The patch titled
     Subject: mm: x86 pgtable: drop unneeded preprocessor ifdef
has been removed from the -mm tree.  Its filename was
     mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: x86 pgtable: drop unneeded preprocessor ifdef

_PAGE_BIT_FILE (bit 6) is always less than _PAGE_BIT_PROTNONE (bit 8), so
drop redundant #ifdef.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Noonan <steven@uplinklabs.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |   10 ----------
 arch/x86/include/asm/pgtable_64.h     |    8 --------
 2 files changed, 18 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~mm-x86-pgtable-drop-unneeded-preprocessor-ifdef arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~mm-x86-pgtable-drop-unneeded-preprocessor-ifdef
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -115,13 +115,8 @@ static __always_inline pte_t pgoff_to_pt
  */
 #define PTE_FILE_MAX_BITS	29
 #define PTE_FILE_SHIFT1		(_PAGE_BIT_PRESENT + 1)
-#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define PTE_FILE_SHIFT2		(_PAGE_BIT_FILE + 1)
 #define PTE_FILE_SHIFT3		(_PAGE_BIT_PROTNONE + 1)
-#else
-#define PTE_FILE_SHIFT2		(_PAGE_BIT_PROTNONE + 1)
-#define PTE_FILE_SHIFT3		(_PAGE_BIT_FILE + 1)
-#endif
 #define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 
@@ -153,13 +148,8 @@ static __always_inline pte_t pgoff_to_pt
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
 /* Encode and de-code a swap entry */
-#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
-#else
-#define SWP_TYPE_BITS (_PAGE_BIT_PROTNONE - _PAGE_BIT_PRESENT - 1)
-#define SWP_OFFSET_SHIFT (_PAGE_BIT_FILE + 1)
-#endif
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
 
diff -puN arch/x86/include/asm/pgtable_64.h~mm-x86-pgtable-drop-unneeded-preprocessor-ifdef arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~mm-x86-pgtable-drop-unneeded-preprocessor-ifdef
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -143,7 +143,6 @@ static inline int pgd_large(pgd_t pgd) {
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
 /* Encode and de-code a swap entry */
-#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
 #ifdef CONFIG_NUMA_BALANCING
 /* Automatic NUMA balancing needs to be distinguishable from swap entries */
@@ -151,13 +150,6 @@ static inline int pgd_large(pgd_t pgd) {
 #else
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
 #endif
-#else
-#ifdef CONFIG_NUMA_BALANCING
-#error Incompatible format for automatic NUMA balancing
-#endif
-#define SWP_TYPE_BITS (_PAGE_BIT_PROTNONE - _PAGE_BIT_PRESENT - 1)
-#define SWP_OFFSET_SHIFT (_PAGE_BIT_FILE + 1)
-#endif
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch

