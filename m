From: akpm@linux-foundation.org
Subject: + alpha-remove-dma64_addr_t-usage.patch added to -mm tree
Date: Tue, 12 Oct 2010 14:42:36 -0700
Message-ID: <201010122142.o9CLgakW020688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab0JLVnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Oct 2010 17:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: remove dma64_addr_t usage
has been added to the -mm tree.  Its filename is
     alpha-remove-dma64_addr_t-usage.patch

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
Subject: alpha: remove dma64_addr_t usage
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_addr_t is always 64 bit on alpha. So let's use dma_addr_t instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-remove-dma64_addr_t-usage arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-remove-dma64_addr_t-usage
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -223,7 +223,7 @@ iommu_arena_free(struct pci_iommu_arena 
  */
 static int pci_dac_dma_supported(struct pci_dev *dev, u64 mask)
 {
-	dma64_addr_t dac_offset = alpha_mv.pci_dac_offset;
+	dma_addr_t dac_offset = alpha_mv.pci_dac_offset;
 	int ok = 1;
 
 	/* If this is not set, the machine doesn't support DAC at all.  */
@@ -756,7 +756,7 @@ static void alpha_pci_unmap_sg(struct de
 	spin_lock_irqsave(&arena->lock, flags);
 
 	for (end = sg + nents; sg < end; ++sg) {
-		dma64_addr_t addr;
+		dma_addr_t addr;
 		size_t size;
 		long npages, ofs;
 		dma_addr_t tend;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
tile-enable-arch_dma_addr_t_64bit.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
alpha-enable-arch_dma_addr_t_64bit.patch
uml-define-config_no_dma.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
sparc-remove-dma64_addr_t-usage.patch
mips-remove-dma64_addr_t-usage.patch
alpha-remove-dma64_addr_t-usage.patch
remove-dma64_addr_t.patch

