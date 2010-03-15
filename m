From: akpm@linux-foundation.org
Subject: [merged] dma-mappingh-add-the-dma_unmap-state-api.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:21 -0400
Message-ID: <201003150703.o2F73sDd016973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935930Ab0COHEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, arnd@arndb.de, davem@davemloft.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     dma-mapping.h: add the dma_unmap state API
has been removed from the -mm tree.  Its filename was
     dma-mappingh-add-the-dma_unmap-state-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping.h: add the dma_unmap state API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Adds the following macros:

DECLARE_DMA_UNMAP_ADDR(ADDR_NAME)
DECLARE_DMA_UNMAP_LEN(LEN_NAME)
dma_unmap_addr(PTR, ADDR_NAME)
dma_unmap_addr_set(PTR, ADDR_NAME, VAL)
dma_unmap_len(PTR, LEN_NAME)
dma_unmap_len_set(PTR, LEN_NAME, VAL)

The API corresponds to the pci_unmap state API.  We'll move to this new
generic API from the PCI specific API in the long term.  As
include/asm-generic/pci-dma-compat.h does, the pci_unmap API simply calls
the new generic API for some time.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt   |   58 ++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h |   16 +++++++++
 include/linux/pci-dma.h     |   21 +++---------
 3 files changed, 80 insertions(+), 15 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mappingh-add-the-dma_unmap-state-api Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mappingh-add-the-dma_unmap-state-api
+++ a/Documentation/DMA-API.txt
@@ -472,6 +472,64 @@ void whizco_dma_map_sg_attrs(struct devi
 	....
 
 
+Part Ie - Optimizing Unmap State Space Consumption
+--------------------------------
+
+On some platforms, dma_unmap_{single,page}() is simply a nop.
+Therefore, keeping track of the mapping address and length is a waste
+of space. Instead of filling your drivers up with ifdefs and the like
+to "work around" this (which would defeat the whole purpose of a
+portable API) the following facilities are provided.
+
+Actually, instead of describing the macros one by one, we'll
+transform some example code.
+
+1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
+   Example, before:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		dma_addr_t mapping;
+		__u32 len;
+	};
+
+   after:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		DEFINE_DMA_UNMAP_ADDR(mapping);
+		DEFINE_DMA_UNMAP_LEN(len);
+	};
+
+2) Use dma_unmap_{addr,len}_set to set these values.
+   Example, before:
+
+	ringp->mapping = FOO;
+	ringp->len = BAR;
+
+   after:
+
+	dma_unmap_addr_set(ringp, mapping, FOO);
+	dma_unmap_len_set(ringp, len, BAR);
+
+3) Use dma_unmap_{addr,len} to access these values.
+   Example, before:
+
+	dma_unmap_single(dev, ringp->mapping, ringp->len,
+			 DMA_FROM_DEVICE);
+
+   after:
+
+	dma_unmap_single(dev,
+			 dma_unmap_addr(ringp, mapping),
+			 dma_unmap_len(ringp, len),
+			 DMA_FROM_DEVICE);
+
+It really should be self-explanatory.  We treat the ADDR and LEN
+separately, because it is possible for an implementation to only
+need the address in order to perform the unmap operation.
+
+
 Part II - Advanced dma_ usage
 -----------------------------
 
diff -puN include/linux/dma-mapping.h~dma-mappingh-add-the-dma_unmap-state-api include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mappingh-add-the-dma_unmap-state-api
+++ a/include/linux/dma-mapping.h
@@ -232,4 +232,20 @@ struct dma_attrs;
 
 #endif /* CONFIG_HAVE_DMA_ATTRS */
 
+#ifdef CONFIG_NEED_DMA_MAP_STATE
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME
+#define dma_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
+#define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
+#else
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
+#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
+#define dma_unmap_len(PTR, LEN_NAME)             (0)
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+#endif
+
 #endif
diff -puN include/linux/pci-dma.h~dma-mappingh-add-the-dma_unmap-state-api include/linux/pci-dma.h
--- a/include/linux/pci-dma.h~dma-mappingh-add-the-dma_unmap-state-api
+++ a/include/linux/pci-dma.h
@@ -1,20 +1,11 @@
 #ifndef _LINUX_PCI_DMA_H
 #define _LINUX_PCI_DMA_H
 
-#ifdef CONFIG_NEED_DMA_MAP_STATE
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
-#else
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)           (0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)             (0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
-#endif
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME) DEFINE_DMA_UNMAP_ADDR(ADDR_NAME);
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)   DEFINE_DMA_UNMAP_LEN(LEN_NAME);
+#define pci_unmap_addr             dma_unmap_addr
+#define pci_unmap_addr_set         dma_unmap_addr_set
+#define pci_unmap_len              dma_unmap_len
+#define pci_unmap_len_set          dma_unmap_len_set
 
 #endif
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

