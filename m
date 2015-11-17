From: akpm@linux-foundation.org
Subject: +
 dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:38:01 -0800
Message-ID: <564b9e39.RGQLCpVFqF57sWoW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbKQViD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, a-jacquiot@ti.com, cmetcalf@ezchip.com, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, hskinnemoen@gmail.com, james.hogan@imgtec.com, jesper.nilsson@axis.com, lftan@altera.com, msalter@redhat.com, realmz6@gmail.com, starvik@axis.com, vgupta@synopsys.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: make the generic coherent dma mmap implementation optional
has been added to the -mm tree.  Its filename is
     dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: dma-mapping: make the generic coherent dma mmap implementation optional

This series converts all remaining architectures to use dma_map_ops and
the generic implementation of the DMA API.  This not only simplifies the
code a lot, but also prepares for possible future changes like more
generic non-iommu dma_ops implementations or generic per-device
dma_map_ops.


This patch (of 16):

We have a couple architectures that do not want to support this code, so
add another Kconfig symbol that disables the code similar to what we do
for the nommu case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig               |    3 +++
 drivers/base/dma-mapping.c |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/Kconfig~dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional arch/Kconfig
--- a/arch/Kconfig~dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional
+++ a/arch/Kconfig
@@ -564,4 +564,7 @@ config OLD_SIGACTION
 config COMPAT_OLD_SIGACTION
 	bool
 
+config ARCH_NO_COHERENT_DMA_MMAP
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN drivers/base/dma-mapping.c~dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c~dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional
+++ a/drivers/base/dma-mapping.c
@@ -247,7 +247,7 @@ int dma_common_mmap(struct device *dev,
 		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
 {
 	int ret = -ENXIO;
-#ifdef CONFIG_MMU
+#if defined(CONFIG_MMU) && !defined(CONFIG_ARCH_NO_COHERENT_DMA_MMAP)
 	unsigned long user_count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	unsigned long pfn = page_to_pfn(virt_to_page(cpu_addr));
@@ -264,7 +264,7 @@ int dma_common_mmap(struct device *dev,
 				      user_count << PAGE_SHIFT,
 				      vma->vm_page_prot);
 	}
-#endif	/* CONFIG_MMU */
+#endif	/* CONFIG_MMU && !CONFIG_ARCH_NO_COHERENT_DMA_MMAP */
 
 	return ret;
 }
_

Patches currently in -mm which might be from hch@lst.de are

dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

