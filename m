From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-add-inbound-memory-mapping-callbacks.patch added to -mm tree
Date: Tue, 18 Sep 2012 14:41:05 -0700
Message-ID: <20120918214106.5934A1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48259 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2IRVlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 17:41:07 -0400
Received: by ggnu1 with SMTP id u1so48916ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 14:41:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio/tsi721: add inbound memory mapping callbacks
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-add-inbound-memory-mapping-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: add inbound memory mapping callbacks

Add Tsi721 routines to support RapidIO subsystem's inbound memory mapping
interface (RapidIO to system's local memory).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   88 ++++++++++++++++++++++++++++-
 drivers/rapidio/devices/tsi721.h |   15 +++-
 2 files changed, 99 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-inbound-memory-mapping-callbacks drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-inbound-memory-mapping-callbacks
+++ a/drivers/rapidio/devices/tsi721.c
@@ -862,6 +862,90 @@ static void tsi721_init_pc2sr_mapping(st
 }
 
 /**
+ * tsi721_rio_map_inb_mem -- Mapping inbound memory region.
+ * @mport: RapidIO master port
+ * @lstart: Local memory space start address.
+ * @rstart: RapidIO space start address.
+ * @size: The mapping region size.
+ * @flags: Flags for mapping. 0 for using default flags.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the inbound mapping
+ * from rstart to lstart.
+ */
+static int tsi721_rio_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
+		u64 rstart, u32 size, u32 flags)
+{
+	struct tsi721_device *priv = mport->priv;
+	int i;
+	u32 regval;
+
+	if (!is_power_of_2(size) || size < 0x1000 ||
+	    ((u64)lstart & (size - 1)) || (rstart & (size - 1)))
+		return -EINVAL;
+
+	/* Search for free inbound translation window */
+	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
+		regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
+		if (!(regval & TSI721_IBWIN_LB_WEN))
+			break;
+	}
+
+	if (i >= TSI721_IBWIN_NUM) {
+		dev_err(&priv->pdev->dev,
+			"Unable to find free inbound window\n");
+		return -EBUSY;
+	}
+
+	iowrite32(TSI721_IBWIN_SIZE(size) << 8,
+			priv->regs + TSI721_IBWIN_SZ(i));
+
+	iowrite32(((u64)lstart >> 32), priv->regs + TSI721_IBWIN_TUA(i));
+	iowrite32(((u64)lstart & TSI721_IBWIN_TLA_ADD),
+		  priv->regs + TSI721_IBWIN_TLA(i));
+
+	iowrite32(rstart >> 32, priv->regs + TSI721_IBWIN_UB(i));
+	iowrite32((rstart & TSI721_IBWIN_LB_BA) | TSI721_IBWIN_LB_WEN,
+		priv->regs + TSI721_IBWIN_LB(i));
+	dev_dbg(&priv->pdev->dev,
+		"Configured IBWIN%d mapping (RIO_0x%llx -> PCIe_0x%llx)\n",
+		i, rstart, (unsigned long long)lstart);
+
+	return 0;
+}
+
+/**
+ * fsl_rio_unmap_inb_mem -- Unmapping inbound memory region.
+ * @mport: RapidIO master port
+ * @lstart: Local memory space start address.
+ */
+static void tsi721_rio_unmap_inb_mem(struct rio_mport *mport,
+				dma_addr_t lstart)
+{
+	struct tsi721_device *priv = mport->priv;
+	int i;
+	u64 addr;
+	u32 regval;
+
+	/* Search for matching active inbound translation window */
+	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
+		regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
+		if (regval & TSI721_IBWIN_LB_WEN) {
+			regval = ioread32(priv->regs + TSI721_IBWIN_TUA(i));
+			addr = (u64)regval << 32;
+			regval = ioread32(priv->regs + TSI721_IBWIN_TLA(i));
+			addr |= regval & TSI721_IBWIN_TLA_ADD;
+
+			if (addr == (u64)lstart) {
+				iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
+				break;
+			}
+		}
+	}
+}
+
+/**
  * tsi721_init_sr2pc_mapping - initializes inbound (SRIO->PCIe)
  * translation regions.
  * @priv: pointer to tsi721 private data
@@ -874,7 +958,7 @@ static void tsi721_init_sr2pc_mapping(st
 
 	/* Disable all SR2PC inbound windows */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++)
-		iowrite32(0, priv->regs + TSI721_IBWINLB(i));
+		iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
 }
 
 /**
@@ -2144,6 +2228,8 @@ static int __devinit tsi721_setup_mport(
 	ops->add_outb_message = tsi721_add_outb_message;
 	ops->add_inb_buffer = tsi721_add_inb_buffer;
 	ops->get_inb_message = tsi721_get_inb_message;
+	ops->map_inb = tsi721_rio_map_inb_mem;
+	ops->unmap_inb = tsi721_rio_unmap_inb_mem;
 
 	mport = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	if (!mport) {
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-inbound-memory-mapping-callbacks drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-inbound-memory-mapping-callbacks
+++ a/drivers/rapidio/devices/tsi721.h
@@ -156,9 +156,18 @@
 
 #define TSI721_IBWIN_NUM	8
 
-#define TSI721_IBWINLB(x)	(0x29000 + (x) * 0x20)
-#define TSI721_IBWINLB_BA	0xfffff000
-#define TSI721_IBWINLB_WEN	0x00000001
+#define TSI721_IBWIN_LB(x)	(0x29000 + (x) * 0x20)
+#define TSI721_IBWIN_LB_BA	0xfffff000
+#define TSI721_IBWIN_LB_WEN	0x00000001
+
+#define TSI721_IBWIN_UB(x)	(0x29004 + (x) * 0x20)
+#define TSI721_IBWIN_SZ(x)	(0x29008 + (x) * 0x20)
+#define TSI721_IBWIN_SZ_SIZE	0x00001f00
+#define TSI721_IBWIN_SIZE(size)	(__fls(size) - 12)
+
+#define TSI721_IBWIN_TLA(x)	(0x2900c + (x) * 0x20)
+#define TSI721_IBWIN_TLA_ADD	0xfffff000
+#define TSI721_IBWIN_TUA(x)	(0x29010 + (x) * 0x20)
 
 #define TSI721_SR2PC_GEN_INTE	0x29800
 #define TSI721_SR2PC_PWE	0x29804
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

linux-next.patch
rapidio-tsi721-modify-mport-name-assignment.patch
rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch
drivers-rapidio-devices-tsi721c-fix-error-return-code.patch
rapidio-add-inbound-memory-mapping-interface.patch
rapidio-tsi721-add-inbound-memory-mapping-callbacks.patch

