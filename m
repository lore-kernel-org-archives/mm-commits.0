From: akpm@linux-foundation.org
Subject: [merged] pci-dma-parisc-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:53 -0400
Message-ID: <201003150703.o2F73Q5j016943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935930Ab0COHDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, deller@gmx.de, jbarnes@virtuousgeek.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     pci-dma: parisc: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-parisc-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: parisc: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig           |    3 +++
 arch/parisc/include/asm/pci.h |   14 +-------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff -puN arch/parisc/Kconfig~pci-dma-parisc-use-include-linux-pci-dmah arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~pci-dma-parisc-use-include-linux-pci-dmah
+++ a/arch/parisc/Kconfig
@@ -95,6 +95,9 @@ config PM
 config STACKTRACE_SUPPORT
 	def_bool y
 
+config NEED_DMA_MAP_STATE
+	def_bool y
+
 config ISA_DMA_API
 	bool
 
diff -puN arch/parisc/include/asm/pci.h~pci-dma-parisc-use-include-linux-pci-dmah arch/parisc/include/asm/pci.h
--- a/arch/parisc/include/asm/pci.h~pci-dma-parisc-use-include-linux-pci-dmah
+++ a/arch/parisc/include/asm/pci.h
@@ -183,19 +183,7 @@ struct pci_bios_ops {
 	void (*fixup_bus)(struct pci_bus *bus);
 };
 
-/* pci_unmap_{single,page} is not a nop, thus... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
-	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
-	__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)			\
-	((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)		\
-	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)			\
-	((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
-	(((PTR)->LEN_NAME) = (VAL))
+#include <linux/pci-dma.h>
 
 /*
 ** Stuff declared in arch/parisc/kernel/pci.c
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

