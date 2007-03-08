From: akpm@linux-foundation.org
Subject: + reduce-pnp-syslog-spam.patch added to -mm tree
Date: Thu, 08 Mar 2007 01:05:07 -0800
Message-ID: <200703080905.l28957LK023763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030369AbXCHJFT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 04:05:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, ambx1@neo.rr.com, dbrownell@users.sourceforge.net


The patch titled
     reduce pnp syslog spam
has been added to the -mm tree.  Its filename is
     reduce-pnp-syslog-spam.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

reduce-pnp-syslog-spam.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-i2c-driver-update-2.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
