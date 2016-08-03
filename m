From: akpm@linux-foundation.org
Subject: [merged] rapidio-change-inbound-window-size-type-to-u64.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:14:36 -0700
Message-ID: <57a2348c.Cel79l9ogosyq6Uk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbcHCSOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, benh@kernel.crashing.org, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: change inbound window size type to u64
has been removed from the -mm tree.  Its filename was
     rapidio-change-inbound-window-size-type-to-u64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: change inbound window size type to u64

Current definition of map_inb() mport operations callback uses u32 type to
specify required inbound window (IBW) size.  This is limiting factor
because existing hardware - tsi721 and fsl_rio, both support IBW size up
to 16GB.

Changing type of size parameter to u64 to allow IBW size configurations
larger than 4GB.

[alexandre.bounine@idt.com: remove compiler warning about size of constant]
  Link: http://lkml.kernel.org/r/20160802184856.2566-1-alexandre.bounine@idt.com
Link: http://lkml.kernel.org/r/1469125134-16523-11-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c    |    4 ++--
 drivers/rapidio/devices/tsi721.c |   14 +++++++++-----
 include/linux/rio.h              |    2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-change-inbound-window-size-type-to-u64 arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-change-inbound-window-size-type-to-u64
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -289,7 +289,7 @@ static void fsl_rio_inbound_mem_init(str
 }
 
 int fsl_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
-	u64 rstart, u32 size, u32 flags)
+	u64 rstart, u64 size, u32 flags)
 {
 	struct rio_priv *priv = mport->priv;
 	u32 base_size;
@@ -298,7 +298,7 @@ int fsl_map_inb_mem(struct rio_mport *mp
 	u32 riwar;
 	int i;
 
-	if ((size & (size - 1)) != 0)
+	if ((size & (size - 1)) != 0 || size > 0x400000000ULL)
 		return -EINVAL;
 
 	base_size_log = ilog2(size);
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-change-inbound-window-size-type-to-u64 drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-change-inbound-window-size-type-to-u64
+++ a/drivers/rapidio/devices/tsi721.c
@@ -1090,7 +1090,7 @@ static void tsi721_init_pc2sr_mapping(st
  * from rstart to lstart.
  */
 static int tsi721_rio_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
-		u64 rstart, u32 size, u32 flags)
+		u64 rstart, u64 size, u32 flags)
 {
 	struct tsi721_device *priv = mport->priv;
 	int i, avail = -1;
@@ -1103,6 +1103,10 @@ static int tsi721_rio_map_inb_mem(struct
 	struct tsi721_ib_win_mapping *map = NULL;
 	int ret = -EBUSY;
 
+	/* Max IBW size supported by HW is 16GB */
+	if (size > 0x400000000UL)
+		return -EINVAL;
+
 	if (direct) {
 		/* Calculate minimal acceptable window size and base address */
 
@@ -1110,15 +1114,15 @@ static int tsi721_rio_map_inb_mem(struct
 		ibw_start = lstart & ~(ibw_size - 1);
 
 		tsi_debug(IBW, &priv->pdev->dev,
-			"Direct (RIO_0x%llx -> PCIe_%pad), size=0x%x, ibw_start = 0x%llx",
+			"Direct (RIO_0x%llx -> PCIe_%pad), size=0x%llx, ibw_start = 0x%llx",
 			rstart, &lstart, size, ibw_start);
 
 		while ((lstart + size) > (ibw_start + ibw_size)) {
 			ibw_size *= 2;
 			ibw_start = lstart & ~(ibw_size - 1);
-			if (ibw_size > 0x80000000) { /* Limit max size to 2GB */
+			/* Check for crossing IBW max size 16GB */
+			if (ibw_size > 0x400000000UL)
 				return -EBUSY;
-			}
 		}
 
 		loc_start = ibw_start;
@@ -1129,7 +1133,7 @@ static int tsi721_rio_map_inb_mem(struct
 
 	} else {
 		tsi_debug(IBW, &priv->pdev->dev,
-			"Translated (RIO_0x%llx -> PCIe_%pad), size=0x%x",
+			"Translated (RIO_0x%llx -> PCIe_%pad), size=0x%llx",
 			rstart, &lstart, size);
 
 		if (!is_power_of_2(size) || size < 0x1000 ||
diff -puN include/linux/rio.h~rapidio-change-inbound-window-size-type-to-u64 include/linux/rio.h
--- a/include/linux/rio.h~rapidio-change-inbound-window-size-type-to-u64
+++ a/include/linux/rio.h
@@ -425,7 +425,7 @@ struct rio_ops {
 	int (*add_inb_buffer)(struct rio_mport *mport, int mbox, void *buf);
 	void *(*get_inb_message)(struct rio_mport *mport, int mbox);
 	int (*map_inb)(struct rio_mport *mport, dma_addr_t lstart,
-			u64 rstart, u32 size, u32 flags);
+			u64 rstart, u64 size, u32 flags);
 	void (*unmap_inb)(struct rio_mport *mport, dma_addr_t lstart);
 	int (*query_mport)(struct rio_mport *mport,
 			   struct rio_mport_attr *attr);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


