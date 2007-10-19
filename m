From: akpm@linux-foundation.org
Subject: - unify-dma_bit_mask-definitions-v31.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:38 -0700
Message-ID: <200710190341.l9J3fccJ012835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763520AbXJSD4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, James.Bottomley@steeleye.com, jeff@garzik.org, jeremy@goop.org, muli@il.ibm.com, satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     unify DMA_..BIT_MASK definitions: v3.1
has been removed from the -mm tree.  Its filename was
     unify-dma_bit_mask-definitions-v31.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unify DMA_..BIT_MASK definitions: v3.1
From: Borislav Petkov <bbpetkov@yahoo.de>

Remove redundant DMA_..BIT_MASK definitions across two drivers.  The
computation of the majority of the bitmasks is done by the compiler.  The
initial split of the patch touching each a different file got removed due
to possible git bisect breakage.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Reviewed-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netxen/netxen_nic_main.c |    3 ---
 include/linux/dma-mapping.h          |   24 ++++++++++++++----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/net/netxen/netxen_nic_main.c~unify-dma_bit_mask-definitions-v31 drivers/net/netxen/netxen_nic_main.c
--- a/drivers/net/netxen/netxen_nic_main.c~unify-dma_bit_mask-definitions-v31
+++ a/drivers/net/netxen/netxen_nic_main.c
@@ -53,9 +53,6 @@ static char netxen_nic_driver_string[] =
 #define NETXEN_ADAPTER_UP_MAGIC 777
 #define NETXEN_NIC_PEG_TUNE 0
 
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_35BIT_MASK	0x00000007ffffffffULL
-
 /* Local functions to NetXen NIC driver */
 static int __devinit netxen_nic_probe(struct pci_dev *pdev,
 				      const struct pci_device_id *ent);
diff -puN include/linux/dma-mapping.h~unify-dma_bit_mask-definitions-v31 include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~unify-dma_bit_mask-definitions-v31
+++ a/include/linux/dma-mapping.h
@@ -13,16 +13,20 @@ enum dma_data_direction {
 	DMA_NONE = 3,
 };
 
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#define DMA_48BIT_MASK	0x0000ffffffffffffULL
-#define DMA_40BIT_MASK	0x000000ffffffffffULL
-#define DMA_39BIT_MASK	0x0000007fffffffffULL
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_31BIT_MASK	0x000000007fffffffULL
-#define DMA_30BIT_MASK	0x000000003fffffffULL
-#define DMA_29BIT_MASK	0x000000001fffffffULL
-#define DMA_28BIT_MASK	0x000000000fffffffULL
-#define DMA_24BIT_MASK	0x0000000000ffffffULL
+#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
+
+#define DMA_64BIT_MASK	(~0ULL)
+#define DMA_48BIT_MASK	DMA_BIT_MASK(48)
+#define DMA_47BIT_MASK	DMA_BIT_MASK(47)
+#define DMA_40BIT_MASK	DMA_BIT_MASK(40)
+#define DMA_39BIT_MASK	DMA_BIT_MASK(39)
+#define DMA_35BIT_MASK	DMA_BIT_MASK(35)
+#define DMA_32BIT_MASK	DMA_BIT_MASK(32)
+#define DMA_31BIT_MASK	DMA_BIT_MASK(31)
+#define DMA_30BIT_MASK	DMA_BIT_MASK(30)
+#define DMA_29BIT_MASK	DMA_BIT_MASK(29)
+#define DMA_28BIT_MASK	DMA_BIT_MASK(28)
+#define DMA_24BIT_MASK	DMA_BIT_MASK(24)
 
 #define DMA_MASK_NONE	0x0ULL
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
