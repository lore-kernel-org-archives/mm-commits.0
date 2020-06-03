From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 125/131] powerpc/mm: drop platform defined
 pmd_mknotpresent()
Date: Wed, 03 Jun 2020 16:03:41 -0700
Message-ID: <20200603230341._b4SNc_Z5%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgFCXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, hpa@zytor.com, linux-mm@kvack.org, linux@armlinux.org.uk, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: powerpc/mm: drop platform defined pmd_mknotpresent()

Patch series "mm/thp: Rename pmd_mknotpresent() as pmd_mknotvalid()", v2.

This series renames pmd_mknotpresent() as pmd_mknotvalid().  Before that
it drops an existing pmd_mknotpresent() definition from powerpc platform
which was never required as it defines it's pmdp_invalidate() through
subscribing __HAVE_ARCH_PMDP_INVALIDATE.  This does not create any
functional change.

This rename was suggested by Catalin during a previous discussion while we
were trying to change the THP helpers on arm64 platform for migration.

https://patchwork.kernel.org/patch/11019637/


This patch (of 2):

Platform needs to define pmd_mknotpresent() for generic pmdp_invalidate()
only when __HAVE_ARCH_PMDP_INVALIDATE is not subscribed.  Otherwise
platform specific pmd_mknotpresent() is not required.  Hence just drop it.

Link: http://lkml.kernel.org/r/1587520326-10099-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1584680057-13753-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1584680057-13753-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-drop-platform-defined-pmd_mknotpresent
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1168,10 +1168,6 @@ static inline int pmd_large(pmd_t pmd)
 	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
 }
 
-static inline pmd_t pmd_mknotpresent(pmd_t pmd)
-{
-	return __pmd(pmd_val(pmd) & ~_PAGE_PRESENT);
-}
 /*
  * For radix we should always find H_PAGE_HASHPTE zero. Hence
  * the below will work for radix too
_
