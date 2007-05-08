From: akpm@linux-foundation.org
Subject: - driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data.patch removed from -mm tree
Date: Mon, 07 May 2007 22:10:07 -0700
Message-ID: <200705080510.l485A7Ec014104@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967868AbXEHFKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 01:10:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mreimer@vpop.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     ds1wm: simplify platform_data
has been removed from the -mm tree.  Its filename was
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data.patch

This patch was dropped because it was folded into driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch

------------------------------------------------------
Subject: ds1wm: simplify platform_data
From: Matt Reimer <mreimer@vpop.net>

Simplify ds1wm's platform_data by using IORESOURCE_IRQ_* flags rather than the
platform_data field active_high.

Signed-off-by: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |   11 +++++++----
 include/linux/ds1wm.h      |    1 -
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/w1/masters/ds1wm.c~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data
+++ a/drivers/w1/masters/ds1wm.c
@@ -90,6 +90,7 @@ struct ds1wm_data {
 	struct platform_device *pdev;
 	struct ds1wm_platform_data *pdata;
 	int		irq;
+	int		active_high;
 	struct clk	*clk;
 	int		slave_present;
 	void		*reset_complete;
@@ -141,7 +142,7 @@ static int ds1wm_reset(struct ds1wm_data
 	ds1wm_data->reset_complete = &reset_done;
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, DS1WM_INTEN_EPD |
-		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
+		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
 
 	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_1W_RESET);
 
@@ -163,7 +164,7 @@ static int ds1wm_reset(struct ds1wm_data
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
-		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
+		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
 
 	if (!ds1wm_data->slave_present) {
                 dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
@@ -356,9 +357,11 @@ static int ds1wm_probe(struct platform_d
 		goto err1;
 	}
 	ds1wm_data->irq = res->start;
+	ds1wm_data->active_high = (res->flags & IORESOURCE_IRQ_HIGHEDGE) ?
+		1 : 0;
 
-	set_irq_type(ds1wm_data->irq, res->flags & IORESOURCE_IRQ_LOWEDGE ?
-			IRQ_TYPE_EDGE_FALLING : IRQ_TYPE_EDGE_RISING);
+	set_irq_type(ds1wm_data->irq, ds1wm_data->active_high ?
+			IRQ_TYPE_EDGE_RISING : IRQ_TYPE_EDGE_FALLING);
 
 	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
 			  "ds1wm", ds1wm_data);
diff -puN include/linux/ds1wm.h~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data include/linux/ds1wm.h
--- a/include/linux/ds1wm.h~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data
+++ a/include/linux/ds1wm.h
@@ -6,7 +6,6 @@ struct ds1wm_platform_data {
 			     * e.g. on h5xxx and h2200 this is 2
 			     * (registers aligned to 4-byte boundaries),
 			     * while on hx4700 this is 1 */
-	int active_high;    /* interrupt polarity, passed to DS1WM as IAS bit */
 	void (*enable)(struct platform_device *pdev);
 	void (*disable)(struct platform_device *pdev);
 };
_

Patches currently in -mm which might be from mreimer@vpop.net are

w1-allow-bus-master-to-have-reset-and-byte-ops.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch
