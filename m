From: akpm@linux-foundation.org
Subject: [merged] pci-dma-add-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:31 -0400
Message-ID: <201003150703.o2F734lh016902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935962Ab0COHEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, hpa@zytor.c


The patch titled
     pci-dma: add include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-add-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: add include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch adds include/linux/pci-dma.h that defines the pci_unmap state
API:

DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
DECLARE_PCI_UNMAP_LEN(LEN_NAME)
pci_unmap_addr(PTR, ADDR_NAME)
pci_unmap_addr_set(PTR, ADDR_NAME, VAL)
pci_unmap_len(PTR, LEN_NAME)
pci_unmap_len_set(PTR, LEN_NAME, VAL)

This enables us to remove lots of the duplication in architecture
implementations since there are only two ways to define the API.

If architectures define CONFIG_NEED_DMA_MAP_STATE, they get the real
definition of pci_unmap state API.  If not, they get the noop definition.

In the long term, it's better to replace the API with the generic device
model API such as DECLARE_DMA_UNMAP_ADDR.  We can map the API to the
generic one (like dma-mapping-compat.h does).  This patch also makes the
migration process easier.  We can remove this file after the migration.

It might be simpler to add the API to include/linux/pci.h but looks it's
already too large.  We'll remove pci-dma.h after finishing moving to the
generic device model.  So I put the API to a separate file.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci-dma.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN /dev/null include/linux/pci-dma.h
--- /dev/null
+++ a/include/linux/pci-dma.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_PCI_DMA_H
+#define _LINUX_PCI_DMA_H
+
+#ifdef CONFIG_NEED_DMA_MAP_STATE
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
+#define pci_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
+#define pci_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
+#else
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
+#define pci_unmap_addr(PTR, ADDR_NAME)           (0)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
+#define pci_unmap_len(PTR, LEN_NAME)             (0)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+#endif
+
+#endif
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

