From: akpm@linux-foundation.org
Subject: + alpha-compile-fixes.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:45:53 -0800
Message-ID: <200901270845.n0R8jr7G023121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbZA0IqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:46:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: compile fixes
has been added to the -mm tree.  Its filename is
     alpha-compile-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: compile fixes
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

- jensen build: fix conflicting declarations for pci_alloc_consistent()
  and undefined virt_to_phys();

- SMP: arch/alpha/kernel/smp.c:124: warning: passing argument 2
       of '__cpu_test_and_set' discards qualifiers from pointer target type
  Interestingly, this only happens with gcc-4.2; gcc <= 4.1 and gcc-4.3
  are OK. Fixed with extra assignment.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h |    2 ++
 arch/alpha/kernel/pci-noop.c         |    3 ++-
 arch/alpha/kernel/smp.c              |    3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~alpha-compile-fixes arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~alpha-compile-fixes
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -29,6 +29,8 @@
 
 #else	/* no PCI - no IOMMU. */
 
+#include <asm/io.h>	/* for virt_to_phys() */
+
 struct scatterlist;
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			 dma_addr_t *dma_handle, gfp_t gfp);
diff -puN arch/alpha/kernel/pci-noop.c~alpha-compile-fixes arch/alpha/kernel/pci-noop.c
--- a/arch/alpha/kernel/pci-noop.c~alpha-compile-fixes
+++ a/arch/alpha/kernel/pci-noop.c
@@ -109,7 +109,8 @@ sys_pciconfig_write(unsigned long bus, u
 /* Stubs for the routines in pci_iommu.c: */
 
 void *
-pci_alloc_consistent(struct pci_dev *pdev, size_t size, dma_addr_t *dma_addrp)
+__pci_alloc_consistent(struct pci_dev *pdev, size_t size,
+		       dma_addr_t *dma_addrp, gfp_t gfp)
 {
 	return NULL;
 }
diff -puN arch/alpha/kernel/smp.c~alpha-compile-fixes arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~alpha-compile-fixes
+++ a/arch/alpha/kernel/smp.c
@@ -120,8 +120,9 @@ void __cpuinit
 smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
+	cpumask_t mask = cpu_online_map;
 
-	if (cpu_test_and_set(cpuid, cpu_online_map)) {
+	if (cpu_test_and_set(cpuid, mask)) {
 		printk("??, cpu 0x%x already present??\n", cpuid);
 		BUG();
 	}
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-use-syscall-wrappers.patch
alpha-compile-fixes.patch
make-sure-nobodys-leaking-resources.patch

