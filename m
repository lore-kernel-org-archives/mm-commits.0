From: akpm@linux-foundation.org
Subject: - init-dma-masks-in-pnp_dev.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:41 -0700
Message-ID: <200705090245.l492jfnG008766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031125AbXEICp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, abelay@novell.com, dbrownell@users.sourceforge.net, perex@suse.cz, mm-commits@vger.kernel.org


The patch titled
     init dma masks in pnp_dev
has been removed from the -mm tree.  Its filename was
     init-dma-masks-in-pnp_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: init dma masks in pnp_dev
From: David Brownell <david-b@pacbell.net>

PNP now initializes device dma masks, which prevents oopses when generic
dma calls are made using pnp device nodes.

This assumes PNP only uses ISA DMA, with 24 bit addresses; and that it's
safe to init those masks for all devices (rather than finding out which
devices have been assigned DMA channels, and handling only those).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adam Belay <abelay@novell.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/core.c  |    3 +++
 include/linux/pnp.h |    1 +
 2 files changed, 4 insertions(+)

diff -puN drivers/pnp/core.c~init-dma-masks-in-pnp_dev drivers/pnp/core.c
--- a/drivers/pnp/core.c~init-dma-masks-in-pnp_dev
+++ a/drivers/pnp/core.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <linux/dma-mapping.h>
 
 #include "base.h"
 
@@ -114,6 +115,8 @@ int __pnp_add_device(struct pnp_dev *dev
 	int ret;
 	pnp_fixup_device(dev);
 	dev->dev.bus = &pnp_bus_type;
+	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dma_mask = dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
 	dev->dev.release = &pnp_release_device;
 	dev->status = PNP_READY;
 	spin_lock(&pnp_lock);
diff -puN include/linux/pnp.h~init-dma-masks-in-pnp_dev include/linux/pnp.h
--- a/include/linux/pnp.h~init-dma-masks-in-pnp_dev
+++ a/include/linux/pnp.h
@@ -177,6 +177,7 @@ static inline void pnp_set_card_drvdata 
 
 struct pnp_dev {
 	struct device dev;		/* Driver Model device interface */
+	u64 dma_mask;
 	unsigned char number;		/* used as an index, must be unique */
 	int status;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
