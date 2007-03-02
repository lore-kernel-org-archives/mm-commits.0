From: akpm@linux-foundation.org
Subject: + init-dma-masks-in-pnp_dev.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:39:28 -0800
Message-ID: <200703020239.l222dSA9030227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXCBCkn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:40:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, abelay@novell.com, dbrownell@users.sourceforge.net, perex@suse.cz


The patch titled
     init dma masks in pnp_dev
has been added to the -mm tree.  Its filename is
     init-dma-masks-in-pnp_dev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc_cmos-oops-fix.patch
parport-is-an-orphan.patch
add-config_generic_gpio.patch
gpio_keys-driver-shouldnt-be-arm-specific.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
