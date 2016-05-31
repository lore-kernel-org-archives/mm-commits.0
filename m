From: akpm@linux-foundation.org
Subject: +
 powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch added
 to -mm tree
Date: Tue, 31 May 2016 12:13:04 -0700
Message-ID: <574de240.uG8/5OM2Lu9RY6K+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbcEaTNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: check for irq disabled() only if DEBUG_VM is enabled
has been added to the -mm tree.  Its filename is
     powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-debug-add-vm_warn-which-maps-to-warn.patch
powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch

