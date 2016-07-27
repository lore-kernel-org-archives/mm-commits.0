From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch removed from -mm tree
Date: Wed, 27 Jul 2016 11:59:57 -0700
Message-ID: <579904ad.MpJY4hIJgIGzgbeQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0S76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: check for irq disabled() only if DEBUG_VM is enabled
has been removed from the -mm tree.  Its filename was
     powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm: check for irq disabled() only if DEBUG_VM is enabled

We don't need to check this always.  The idea here is to capture the wrong
usage of find_linux_pte_or_hugepte and we can do that by occasionally
running with DEBUG_VM enabled.

Link: http://lkml.kernel.org/r/1464692688-6612-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable.h~powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -71,10 +71,8 @@ pte_t *__find_linux_pte_or_hugepte(pgd_t
 static inline pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea,
 					       bool *is_thp, unsigned *shift)
 {
-	if (!arch_irqs_disabled()) {
-		pr_info("%s called with irq enabled\n", __func__);
-		dump_stack();
-	}
+	VM_WARN(!arch_irqs_disabled(),
+		"%s called with irq enabled\n", __func__);
 	return __find_linux_pte_or_hugepte(pgdir, ea, is_thp, shift);
 }
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


