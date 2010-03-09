From: akpm@linux-foundation.org
Subject: [merged] sdio-introduce-api-for-special-power-management-features.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:09 -0800
Message-ID: <201003091908.o29J89T7031424__6089.49537058852$1268161755$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab0CITJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:09:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     sdio: introduce API for special power management features
has been removed from the -mm tree.  Its filename was
     sdio-introduce-api-for-special-power-management-features.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: introduce API for special power management features
From: Nicolas Pitre <nico@fluxnic.net>

This patch series provides the core changes needed to allow SDIO cards to
remain powered and active while the host system is suspended, and let them
wake up the host system when needed.  This is used to implement
wake-on-lan with SDIO wireless cards at the moment.  Patches to add that
support to the libertas driver will be posted separately.



This patch:

Some SDIO cards have the ability to keep on running autonomously when the
host system is suspended, and wake it up when needed.  This however
requires that the host controller preserve power to the card, and
configure itself appropriately for wake-up.

There is however 4 layers of abstractions involved: the host controller
driver, the MMC core code, the SDIO card management code, and the actual
SDIO function driver.  To make things simple and manageable, host drivers
must advertise their PM capabilities with a feature bitmask, then function
drivers can query and set those features from their suspend method.  Then
each layer in the suspend call chain is expected to act upon those bits
accordingly.

[akpm@linux-foundation.org: fix typo in comment]
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c       |   12 +++++--
 drivers/mmc/core/sdio_io.c    |   49 ++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h      |    5 +++
 include/linux/mmc/pm.h        |   30 +++++++++++++++++++
 include/linux/mmc/sdio_func.h |    5 +++
 5 files changed, 98 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/core/core.c~sdio-introduce-api-for-special-power-management-features drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~sdio-introduce-api-for-special-power-management-features
+++ a/drivers/mmc/core/core.c
@@ -1151,6 +1151,9 @@ void mmc_stop_host(struct mmc_host *host
 	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
+	/* clear pm flags now and let card drivers set them as needed */
+	host->pm_flags = 0;
+
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
 		if (host->bus_ops->remove)
@@ -1273,12 +1276,13 @@ int mmc_suspend_host(struct mmc_host *ho
 			mmc_claim_host(host);
 			mmc_detach_bus(host);
 			mmc_release_host(host);
+			host->pm_flags = 0;
 			err = 0;
 		}
 	}
 	mmc_bus_put(host);
 
-	if (!err)
+	if (!err && !(host->pm_flags & MMC_PM_KEEP_POWER))
 		mmc_power_off(host);
 
 	return err;
@@ -1296,8 +1300,10 @@ int mmc_resume_host(struct mmc_host *hos
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
-		mmc_power_up(host);
-		mmc_select_voltage(host, host->ocr);
+		if (!(host->pm_flags & MMC_PM_KEEP_POWER)) {
+			mmc_power_up(host);
+			mmc_select_voltage(host, host->ocr);
+		}
 		BUG_ON(!host->bus_ops->resume);
 		err = host->bus_ops->resume(host);
 		if (err) {
diff -puN drivers/mmc/core/sdio_io.c~sdio-introduce-api-for-special-power-management-features drivers/mmc/core/sdio_io.c
--- a/drivers/mmc/core/sdio_io.c~sdio-introduce-api-for-special-power-management-features
+++ a/drivers/mmc/core/sdio_io.c
@@ -640,3 +640,52 @@ void sdio_f0_writeb(struct sdio_func *fu
 		*err_ret = ret;
 }
 EXPORT_SYMBOL_GPL(sdio_f0_writeb);
+
+/**
+ *	sdio_get_host_pm_caps - get host power management capabilities
+ *	@func: SDIO function attached to host
+ *
+ *	Returns a capability bitmask corresponding to power management
+ *	features supported by the host controller that the card function
+ *	might rely upon during a system suspend.  The host doesn't need
+ *	to be claimed, nor the function active, for this information to be
+ *	obtained.
+ */
+mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func)
+{
+	BUG_ON(!func);
+	BUG_ON(!func->card);
+
+	return func->card->host->pm_caps;
+}
+EXPORT_SYMBOL_GPL(sdio_get_host_pm_caps);
+
+/**
+ *	sdio_set_host_pm_flags - set wanted host power management capabilities
+ *	@func: SDIO function attached to host
+ *
+ *	Set a capability bitmask corresponding to wanted host controller
+ *	power management features for the upcoming suspend state.
+ *	This must be called, if needed, each time the suspend method of
+ *	the function driver is called, and must contain only bits that
+ *	were returned by sdio_get_host_pm_caps().
+ *	The host doesn't need to be claimed, nor the function active,
+ *	for this information to be set.
+ */
+int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags)
+{
+	struct mmc_host *host;
+
+	BUG_ON(!func);
+	BUG_ON(!func->card);
+
+	host = func->card->host;
+
+	if (flags & ~host->pm_caps)
+		return -EINVAL;
+
+	/* function suspend methods are serialized, hence no lock needed */
+	host->pm_flags |= flags;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sdio_set_host_pm_flags);
diff -puN include/linux/mmc/host.h~sdio-introduce-api-for-special-power-management-features include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~sdio-introduce-api-for-special-power-management-features
+++ a/include/linux/mmc/host.h
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 
 #include <linux/mmc/core.h>
+#include <linux/mmc/pm.h>
 
 struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
@@ -152,6 +153,8 @@ struct mmc_host {
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
 
+	mmc_pm_flag_t		pm_caps;	/* supported pm features */
+
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
 	unsigned short		max_hw_segs;	/* see blk_queue_max_hw_segments */
@@ -197,6 +200,8 @@ struct mmc_host {
 	struct task_struct	*sdio_irq_thread;
 	atomic_t		sdio_irq_thread_abort;
 
+	mmc_pm_flag_t		pm_flags;	/* requested pm features */
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger	*led;		/* activity led */
 #endif
diff -puN /dev/null include/linux/mmc/pm.h
--- /dev/null
+++ a/include/linux/mmc/pm.h
@@ -0,0 +1,30 @@
+/*
+ * linux/include/linux/mmc/pm.h
+ *
+ * Author:	Nicolas Pitre
+ * Copyright:	(C) 2009 Marvell Technology Group Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef LINUX_MMC_PM_H
+#define LINUX_MMC_PM_H
+
+/*
+ * These flags are used to describe power management features that
+ * some cards (typically SDIO cards) might wish to benefit from when
+ * the host system is being suspended.  There are several layers of
+ * abstractions involved, from the host controller driver, to the MMC core
+ * code, to the SDIO core code, to finally get to the actual SDIO function
+ * driver.  This file is therefore used for common definitions shared across
+ * all those layers.
+ */
+
+typedef unsigned int mmc_pm_flag_t;
+
+#define MMC_PM_KEEP_POWER	(1 << 0)	/* preserve card power during suspend */
+#define MMC_PM_WAKE_SDIO_IRQ	(1 << 1)	/* wake up host system on SDIO IRQ assertion */
+
+#endif
diff -puN include/linux/mmc/sdio_func.h~sdio-introduce-api-for-special-power-management-features include/linux/mmc/sdio_func.h
--- a/include/linux/mmc/sdio_func.h~sdio-introduce-api-for-special-power-management-features
+++ a/include/linux/mmc/sdio_func.h
@@ -15,6 +15,8 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 
+#include <linux/mmc/pm.h>
+
 struct mmc_card;
 struct sdio_func;
 
@@ -153,5 +155,8 @@ extern unsigned char sdio_f0_readb(struc
 extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
 	unsigned int addr, int *err_ret);
 
+extern mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func);
+extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
+
 #endif
 
_

Patches currently in -mm which might be from nico@fluxnic.net are

linux-next.patch

