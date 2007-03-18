From: akpm@linux-foundation.org
Subject: - reduce-pnp-syslog-spam.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:08:26 -0800
Message-ID: <200703180908.l2I98QcG019942@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60344 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXCRJIi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, ambx1@neo.rr.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     reduce pnp syslog spam
has been removed from the -mm tree.  Its filename was
     reduce-pnp-syslog-spam.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reduce pnp syslog spam
From: David Brownell <david-b@pacbell.net>

Make some normal code paths in PNP stop issuing syslog spam.  Since PNP
issues calls regardless of device capablities, it's no surprise when some
of those devices don't support those calls!

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/manager.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pnp/manager.c~reduce-pnp-syslog-spam drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~reduce-pnp-syslog-spam
+++ a/drivers/pnp/manager.c
@@ -451,7 +451,7 @@ int pnp_auto_config_dev(struct pnp_dev *
 		return -EINVAL;
 
 	if(!pnp_can_configure(dev)) {
-		pnp_info("Device %s does not support resource configuration.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support resource configuration.", dev->dev.bus_id);
 		return -ENODEV;
 	}
 
@@ -482,7 +482,7 @@ int pnp_auto_config_dev(struct pnp_dev *
 int pnp_start_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_write(dev)) {
-		pnp_info("Device %s does not support activation.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support activation.", dev->dev.bus_id);
 		return -EINVAL;
 	}
 
@@ -506,7 +506,7 @@ int pnp_start_dev(struct pnp_dev *dev)
 int pnp_stop_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_disable(dev)) {
-		pnp_info("Device %s does not support disabling.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support disabling.", dev->dev.bus_id);
 		return -EINVAL;
 	}
 	if (dev->protocol->disable(dev)<0) {
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
gpio_direction_output-needs-an-initial-value-fix.patch
git-avr32.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-i2c-driver-update-2.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
