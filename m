From: akpm@linux-foundation.org
Subject: [folded] dma-mappingh-add-the-dma_unmap-state-api-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 15:02:32 -0800
Message-ID: <201003102302.o2AN2W8E009119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757385Ab0CJXDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 18:03:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, arnd@arndb.de, davem@davemloft.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     dma-mappingh-add-the-dma_unmap-state-api-fix
has been removed from the -mm tree.  Its filename was
     dma-mappingh-add-the-dma_unmap-state-api-fix.patch

This patch was dropped because it was folded into dma-mappingh-add-the-dma_unmap-state-api.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mappingh-add-the-dma_unmap-state-api-fix
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- adding the semicolons at the end of DECLARE_DMA_UNMAP_{ADDR|LEN}
  confuses people.

- they are "definitions", not "declarations".

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt   |    8 +++-----
 include/linux/dma-mapping.h |    8 ++++----
 include/linux/pci-dma.h     |   12 ++++++------
 3 files changed, 13 insertions(+), 15 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mappingh-add-the-dma_unmap-state-api-fix Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mappingh-add-the-dma_unmap-state-api-fix
+++ a/Documentation/DMA-API.txt
@@ -484,7 +484,7 @@ portable API) the following facilities a
 Actually, instead of describing the macros one by one, we'll
 transform some example code.
 
-1) Use DECLARE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
+1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
    Example, before:
 
 	struct ring_state {
@@ -497,12 +497,10 @@ transform some example code.
 
 	struct ring_state {
 		struct sk_buff *skb;
-		DECLARE_DMA_UNMAP_ADDR(mapping)
-		DECLARE_DMA_UNMAP_LEN(len)
+		DEFINE_DMA_UNMAP_ADDR(mapping);
+		DEFINE_DMA_UNMAP_LEN(len);
 	};
 
-NOTE: DO NOT put a semicolon at the end of the DECLARE_*() macro.
-
 2) Use dma_unmap_{addr,len}_set to set these values.
    Example, before:
 
diff -puN include/linux/dma-mapping.h~dma-mappingh-add-the-dma_unmap-state-api-fix include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mappingh-add-the-dma_unmap-state-api-fix
+++ a/include/linux/dma-mapping.h
@@ -233,15 +233,15 @@ struct dma_attrs;
 #endif /* CONFIG_HAVE_DMA_ATTRS */
 
 #ifdef CONFIG_NEED_DMA_MAP_STATE
-#define DECLARE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
-#define DECLARE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME
 #define dma_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
 #define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
 #define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
 #define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
 #else
-#define DECLARE_DMA_MAP_ADDR(ADDR_NAME)
-#define DECLARE_DMA_UNMAP_LEN(LEN_NAME)
+#define DEFINE_DMA_MAP_ADDR(ADDR_NAME)
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
 #define dma_unmap_addr(PTR, ADDR_NAME)           (0)
 #define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
 #define dma_unmap_len(PTR, LEN_NAME)             (0)
diff -puN include/linux/pci-dma.h~dma-mappingh-add-the-dma_unmap-state-api-fix include/linux/pci-dma.h
--- a/include/linux/pci-dma.h~dma-mappingh-add-the-dma_unmap-state-api-fix
+++ a/include/linux/pci-dma.h
@@ -1,11 +1,11 @@
 #ifndef _LINUX_PCI_DMA_H
 #define _LINUX_PCI_DMA_H
 
-#define DECLARE_PCI_UNMAP_ADDR    DECLARE_DMA_UNMAP_ADDR
-#define DECLARE_PCI_UNMAP_LEN     DECLARE_DMA_UNMAP_LEN
-#define pci_unmap_addr            dma_unmap_addr
-#define pci_unmap_addr_set        dma_unmap_addr_set
-#define pci_unmap_len             dma_unmap_len
-#define pci_unmap_len_set         dma_unmap_len_set
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME) DEFINE_DMA_UNMAP_ADDR(ADDR_NAME);
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)   DEFINE_DMA_UNMAP_LEN(LEN_NAME);
+#define pci_unmap_addr             dma_unmap_addr
+#define pci_unmap_addr_set         dma_unmap_addr_set
+#define pci_unmap_len              dma_unmap_len
+#define pci_unmap_len_set          dma_unmap_len_set
 
 #endif
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
dma-mappingh-add-the-dma_unmap-state-api-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
documentation-remove-the-pci-dma-api-description-in-dma-apitxt.patch
documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
documentation-fix-block-biodoctxt-dma-mapping-description.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

