From: akpm@linux-foundation.org
Subject: + mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
 added to -mm tree
Date: Fri, 02 May 2014 14:12:11 -0700
Message-ID: <53640a2b.iA8KywpUA7gyjgaA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaEBVMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 17:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, torvalds@linux-foundation.org, steven@uplinklabs.net, riel@redhat.com, peterz@infradead.org, mingo@kernel.org, mgorman@suse.de, hpa@zytor.com, david.vrabel@citrix.com, gorcunov@openvz.org

Subject: + mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch added to -mm tree
To: gorcunov@openvz.org,david.vrabel@citrix.com,hpa@zytor.com,mgorman@suse.de,mingo@kernel.org,peterz@infradead.org,riel@redhat.com,steven@uplinklabs.net,torvalds@linux-foundation.org,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 14:12:11 -0700


The patch titled
     Subject: mm: x86 pgtable: require X86_64 for soft-dirty tracker
has been added to the -mm tree.  Its filename is
     mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: x86 pgtable: require X86_64 for soft-dirty tracker

Tracking dirty status on 2 level pages requires very ugly macros and
taking into account how old the machines who can operate without PAE mode
only are, lets drop soft dirty tracker from them for code simplicity (note
I can't drop all the macros from 2 level pages by now since
_PAGE_BIT_PROTNONE and _PAGE_BIT_FILE are still used even without
tracker).

Linus proposed to completely rip off softdirty support on x86-32 (even
with PAE) and since for CRIU we're not planning to support native x86-32
mode, lets do that.

(Softdirty tracker is relatively new feature which is mostly used by CRIU
so I don't expect if such API change would cause problems for userspace).

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

 arch/x86/Kconfig                      |    2 
 arch/x86/include/asm/pgtable-2level.h |   49 ------------------------
 2 files changed, 1 insertion(+), 50 deletions(-)

diff -puN arch/x86/Kconfig~mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker
+++ a/arch/x86/Kconfig
@@ -105,7 +105,7 @@ config X86
 	select HAVE_ARCH_SECCOMP_FILTER
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CMOS_UPDATE
-	select HAVE_ARCH_SOFT_DIRTY
+	select HAVE_ARCH_SOFT_DIRTY if X86_64
 	select CLOCKSOURCE_WATCHDOG
 	select GENERIC_CLOCKEVENTS
 	select ARCH_CLOCKSOURCE_DATA
diff -puN arch/x86/include/asm/pgtable-2level.h~mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -62,53 +62,6 @@ static inline unsigned long pte_bitop(un
 	return ((value >> rightshift) & mask) << leftshift;
 }
 
-#ifdef CONFIG_MEM_SOFT_DIRTY
-
-/*
- * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE, _PAGE_BIT_SOFT_DIRTY and
- * _PAGE_BIT_PROTNONE are taken, split up the 28 bits of offset
- * into this range.
- */
-#define PTE_FILE_MAX_BITS	28
-#define PTE_FILE_SHIFT1		(_PAGE_BIT_PRESENT + 1)
-#define PTE_FILE_SHIFT2		(_PAGE_BIT_FILE + 1)
-#define PTE_FILE_SHIFT3		(_PAGE_BIT_PROTNONE + 1)
-#define PTE_FILE_SHIFT4		(_PAGE_BIT_SOFT_DIRTY + 1)
-#define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
-#define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
-#define PTE_FILE_BITS3		(PTE_FILE_SHIFT4 - PTE_FILE_SHIFT3 - 1)
-
-#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
-#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
-#define PTE_FILE_MASK3		((1U << PTE_FILE_BITS3) - 1)
-
-#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
-#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
-#define PTE_FILE_LSHIFT4	(PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)
-
-static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
-{
-	return (pgoff_t)
-		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
-		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
-		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3, PTE_FILE_MASK3,  PTE_FILE_LSHIFT3) +
-		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT4,           -1UL,  PTE_FILE_LSHIFT4));
-}
-
-static __always_inline pte_t pgoff_to_pte(pgoff_t off)
-{
-	return (pte_t){
-		.pte_low =
-			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
-			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
-			pte_bitop(off, PTE_FILE_LSHIFT3, PTE_FILE_MASK3,  PTE_FILE_SHIFT3) +
-			pte_bitop(off, PTE_FILE_LSHIFT4,           -1UL,  PTE_FILE_SHIFT4) +
-			_PAGE_FILE,
-	};
-}
-
-#else /* CONFIG_MEM_SOFT_DIRTY */
-
 /*
  * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE and _PAGE_BIT_PROTNONE are taken,
  * split up the 29 bits of offset into this range.
@@ -145,8 +98,6 @@ static __always_inline pte_t pgoff_to_pt
 	};
 }
 
-#endif /* CONFIG_MEM_SOFT_DIRTY */
