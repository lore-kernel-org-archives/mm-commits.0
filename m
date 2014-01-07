From: akpm@linux-foundation.org
Subject: +
 backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch
 added to -mm tree
Date: Tue, 07 Jan 2014 14:11:37 -0800
Message-ID: <52cc7b99.QawpIVMf6nM6fEXH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaAGWLi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 17:11:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 14:11:37 -0800


The patch titled
     Subject: backlight: kb3886_bl: fix incorrect placement of __initdata marker
has been added to the -mm tree.  Its filename is
     backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: kb3886_bl: fix incorrect placement of __initdata marker

The __initdata marker can be virtually anywhere on the line, EXCEPT right
after "struct".  The preferred location is before the "=" sign if there is
one, or before the trailing ";" otherwise.  It also fixes the following
chechpatch warning.

  WARNING: __initdata should be placed after kb3886bl_device_table[]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/kb3886_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -78,7 +78,7 @@ static struct kb3886bl_machinfo *bl_mach
 static unsigned long kb3886bl_flags;
 #define KB3886BL_SUSPENDED     0x01
 
-static struct dmi_system_id __initdata kb3886bl_device_table[] = {
+static struct dmi_system_id kb3886bl_device_table[] __initdata = {
 	{
 		.ident = "Sahara Touch-iT",
 		.matches = {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
backlight-jornada720-use-devm_backlight_device_register.patch
backlight-hp680_bl-use-devm_backlight_device_register.patch
backlight-omap1-use-devm_backlight_device_register.patch
backlight-ot200_bl-use-devm_backlight_device_register.patch
backlight-tosa-use-devm_backlight_device_register.patch
backlight-jornada720-use-devm_lcd_device_register.patch
backlight-l4f00242t03-use-devm_lcd_device_register.patch
backlight-tosa-use-devm_lcd_device_register.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
backlight-kb3886_bl-fix-incorrect-placement-of-__initdata-marker.patch
backlight-lp855x-remove-unnecessary-parentheses.patch
backlight-lp8788-remove-unnecessary-parentheses.patch
drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch
rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

