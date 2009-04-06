From: akpm@linux-foundation.org
Subject: [merged] xtensa-remove-redefinition-of-xchal_mmu_asid_bits.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:46 -0700
Message-ID: <200904061939.n36JdkkG014047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbZDFTnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: remove redefinition of XCHAL_MMU_ASID_BITS
has been removed from the -mm tree.  Its filename was
     xtensa-remove-redefinition-of-xchal_mmu_asid_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: remove redefinition of XCHAL_MMU_ASID_BITS
From: Johannes Weiner <jw@emlix.com>

This constant is defined in all core headers.  Remove the redundant
definition which might error out if other includes lead to inclusion
of <variant/core.h>.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/mmu_context.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/xtensa/include/asm/mmu_context.h~xtensa-remove-redefinition-of-xchal_mmu_asid_bits arch/xtensa/include/asm/mmu_context.h
--- a/arch/xtensa/include/asm/mmu_context.h~xtensa-remove-redefinition-of-xchal_mmu_asid_bits
+++ a/arch/xtensa/include/asm/mmu_context.h
@@ -20,13 +20,13 @@
 #include <linux/stringify.h>
 #include <linux/sched.h>
 
+#include <variant/core.h>
+
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
 
-#define XCHAL_MMU_ASID_BITS	8
