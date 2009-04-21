From: akpm@linux-foundation.org
Subject: [merged] ia64-fix-build-due-to-include-tangle.patch removed from -mm tree
Date: Tue, 21 Apr 2009 11:08:21 -0700
Message-ID: <200904211808.n3LI8LY3010058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbZDUSKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 14:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamahata@valinux.co.jp, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix build due to include tangle
has been removed from the -mm tree.  Its filename was
     ia64-fix-build-due-to-include-tangle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix build due to include tangle
From: Isaku Yamahata <yamahata@valinux.co.jp>

Fix the following compilation error caused by recursive inclusion of
kernel.h which defines BUILD_BUG_ON().

In this case, the case it catches will be caught by the case
CONFIG_PARAVIRT=n, so removing it would not hurt compile time check very
much.  So fix the breakage by removing it.

  CC      arch/ia64/kernel/asm-offsets.s
In file included from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from include/linux/sched.h:52,
                 from arch/ia64/kernel/asm-offsets.c:9:
arch/ia64/include/asm/bitops.h: In function 'set_bit':
arch/ia64/include/asm/bitops.h:47: error: implicit declaration of function 'BUILD_BUG_ON'

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/paravirt_privop.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/ia64/include/asm/paravirt_privop.h~ia64-fix-build-due-to-include-tangle arch/ia64/include/asm/paravirt_privop.h
--- a/arch/ia64/include/asm/paravirt_privop.h~ia64-fix-build-due-to-include-tangle
+++ a/arch/ia64/include/asm/paravirt_privop.h
@@ -445,7 +445,6 @@ paravirt_set_rr0_to_rr4(unsigned long va
 		register unsigned long ia64_intri_res asm ("r8");	\
 		register unsigned long __reg asm ("r8") = (reg);	\
 									\
-		BUILD_BUG_ON(!__builtin_constant_p(reg));		\
 		asm volatile (paravirt_alt_bundle(__PARAVIRT_BR,	\
 						  PARAVIRT_TYPE(GETREG) \
 						  + (reg))		\
@@ -464,7 +463,6 @@ paravirt_set_rr0_to_rr4(unsigned long va
 		register unsigned long ia64_clobber1 asm ("r8");	\
 		register unsigned long ia64_clobber2 asm ("r9");	\
 									\
-		BUILD_BUG_ON(!__builtin_constant_p(reg));		\
 		asm volatile (paravirt_alt_bundle(__PARAVIRT_BR,	\
 						  PARAVIRT_TYPE(SETREG) \
 						  + (reg))		\
_

Patches currently in -mm which might be from yamahata@valinux.co.jp are

linux-next.patch

