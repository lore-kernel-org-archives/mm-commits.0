From: akpm@linux-foundation.org
Subject: + rtc-isl1208-fixes-double-removal-of-a-sysfs-entry.patch added to -mm tree
Date: Thu, 07 Aug 2008 13:08:25 -0700
Message-ID: <200808072008.m77K8P0R003009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755671AbYHGUJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 16:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net, hartleys@visionengravers.com, hvr@gnu.org


The patch titled
     rtc-isl1208: fix double removal of a sysfs entry
has been added to the -mm tree.  Its filename is
     rtc-isl1208-fixes-double-removal-of-a-sysfs-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-isl1208: fix double removal of a sysfs entry
From: Alessandro Zummo <a.zummo@towertech.it>

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Hartley Sweeten <hartleys@visionengravers.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-isl1208.c~rtc-isl1208-fixes-double-removal-of-a-sysfs-entry drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~rtc-isl1208-fixes-double-removal-of-a-sysfs-entry
+++ a/drivers/rtc/rtc-isl1208.c
@@ -482,7 +482,7 @@ isl1208_sysfs_register(struct device *de
 static int
 isl1208_sysfs_unregister(struct device *dev)
 {
-	device_remove_file(dev, &dev_attr_atrim);
+	device_remove_file(dev, &dev_attr_dtrim);
 	device_remove_file(dev, &dev_attr_atrim);
 	device_remove_file(dev, &dev_attr_usr);
 
_

Patches currently in -mm which might be from a.zummo@towertech.it are

rtc-isl1208-fixes-double-removal-of-a-sysfs-entry.patch
ntp-let-update_persistent_clock-sleep.patch
rtc-pcf8563-remove-client-validation.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-ds1374-wakup-support.patch
rtc-ds1374-wakeup-support-update.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

