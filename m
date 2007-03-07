From: akpm@linux-foundation.org
Subject: - reduce-rtc-syslog-spam.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:03:40 -0800
Message-ID: <200703072303.l27N3fT8012132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36641 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965712AbXCGXDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     reduce rtc syslog spam
has been removed from the -mm tree.  Its filename was
     reduce-rtc-syslog-spam.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: reduce rtc syslog spam
From: David Brownell <david-b@pacbell.net>

Make the RTC core less noisy.  On fault paths this message is confusing;
and on success, a message from the driver itself should be much more
informative (displaying chip type, options, etc).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/class.c~reduce-rtc-syslog-spam drivers/rtc/class.c
--- a/drivers/rtc/class.c~reduce-rtc-syslog-spam
+++ a/drivers/rtc/class.c
@@ -85,7 +85,7 @@ struct rtc_device *rtc_device_register(c
 	if (err)
 		goto exit_kfree;
 
-	dev_info(dev, "rtc core: registered %s as %s\n",
+	dev_dbg(dev, "rtc core: registered %s as %s\n",
 			rtc->name, rtc->class_dev.class_id);
 
 	return rtc;
_

Patches currently in -mm which might be from david-b@pacbell.net are

reduce-rtc-syslog-spam.patch
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
