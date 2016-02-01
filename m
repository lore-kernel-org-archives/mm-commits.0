From: akpm@linux-foundation.org
Subject: + m32r-fix-build-failure-due-to-smp-and-mmu.patch added to -mm
 tree
Date: Mon, 01 Feb 2016 15:52:36 -0800
Message-ID: <56afefc4.GtUbRvXzfU6CT5r8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbcBAXwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 18:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build failure due to SMP and MMU
has been added to the -mm tree.  Its filename is
     m32r-fix-build-failure-due-to-smp-and-mmu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-fix-build-failure-due-to-smp-and-mmu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-fix-build-failure-due-to-smp-and-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: fix build failure due to SMP and MMU

One of the randconfig build failed with the error:

arch/m32r/kernel/smp.c: In function 'smp_flush_tlb_mm':
arch/m32r/kernel/smp.c:283:20: error: subscripted value is neither array nor pointer nor vector
  mmc = &mm->context[cpu_id];
                    ^
arch/m32r/kernel/smp.c: In function 'smp_flush_tlb_page':
arch/m32r/kernel/smp.c:353:20: error: subscripted value is neither array nor pointer nor vector
  mmc = &mm->context[cpu_id];
                    ^
arch/m32r/kernel/smp.c: In function 'smp_invalidate_interrupt':
arch/m32r/kernel/smp.c:479:41: error: subscripted value is neither array nor pointer nor vector
  unsigned long *mmc = &flush_mm->context[cpu_id];

It turned out that CONFIG_SMP was defined but CONFIG_MMU was not defined. 
But arch/m32r/include/asm/mmu.h only defines mm_context_t as an array when
both CONFIG_SMP and CONFIG_MMU are defined.  And arch/m32r/kernel/smp.c is
always using context as an array.  So without MMU SMP can not work.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/Kconfig~m32r-fix-build-failure-due-to-smp-and-mmu arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-fix-build-failure-due-to-smp-and-mmu
+++ a/arch/m32r/Kconfig
@@ -276,6 +276,7 @@ source "kernel/Kconfig.preempt"
 
 config SMP
 	bool "Symmetric multi-processing support"
+	depends on MMU
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, say N. If you have a system with more
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

proc-fix-missing-reference-of-mm.patch
m32r-fix-build-failure-due-to-smp-and-mmu.patch
m32r-mm-fix-build-warning.patch

