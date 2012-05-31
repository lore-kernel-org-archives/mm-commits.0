From: akpm@linux-foundation.org
Subject: [merged] lcd-add-callbacks-for-early-fb-event-blank-support.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:27 -0700
Message-ID: <20120531191827.7A6ECA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab2EaTS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:29 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: inki.dae@samsung.com, FlorianSchandinat@gmx.de, kyungmin.park@samsung.com, lars@metafoo.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lcd: add callbacks for early fb event blank support
has been removed from the -mm tree.  Its filename was
     lcd-add-callbacks-for-early-fb-event-blank-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Inki Dae <inki.dae@samsung.com>
Subject: lcd: add callbacks for early fb event blank support

This patchset adds early fb blank feature that a callback of lcd panel
driver is called prior to specific fb driver's one.  In the case of
MIPI-DSI based video mode LCD Panel, for lcd power off, the power off
commands should be transferred to lcd panel with display and mipi-dsi
controller enabled because the commands is set to lcd panel at vsync porch
period.  and in opposite case, the callback of fb driver should be called
prior to lcd panel driver's one because of same issue.  Also if fb_blank
mode is changed to FB_BLANK_POWERDOWN then display controller would be
off(clock disable) but lcd panel would be still on.  at this time, you
could see some issue like sparkling on lcd panel because video clock to be
delivered to ldi module of lcd panel was disabled.  this issue could
occurs for all lcd panels.

The callback order is as the following:

at fb_blank function of fbmem.c
-> fb_notifier_call_chain(FB_EARLY_EVENT_BLANK)
       -> lcd panel driver's early_set_power()
-> info->fbops->fb_blank()
       -> spcefic fb driver's fb_blank()
-> fb_notifier_call_chain(FB_EVENT_BLANK)
       -> lcd panel driver's set_power()
   -> fb_notifier_call_chain(FB_R_EARLY_EVENT_BLANK) if
info->fops->fb_blank() was failed.

fb_notifier_call_chain(FB_R_EARLY_EVENT_BLANK) would be called to revert
the effects of previous FB_EARLY_EVENT_BLANK call.  and note that if
early_set_power() of lcd_ops is NULL then early fb blank callback would be
ignored.


This patch:

Add early_set_power and r_early_set_power callbacks.  early_set_power
callback is called prior to fb_blank() of fbmem.c and r_early_set_power
callback is called if fb_blank() was failed to revert the effects of the
early_set_power call of lcd panel driver.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lcd.c |   10 ++++++++++
 include/linux/lcd.h           |   10 ++++++++++
 2 files changed, 20 insertions(+)

diff -puN drivers/video/backlight/lcd.c~lcd-add-callbacks-for-early-fb-event-blank-support drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~lcd-add-callbacks-for-early-fb-event-blank-support
+++ a/drivers/video/backlight/lcd.c
@@ -32,6 +32,8 @@ static int fb_notifier_callback(struct n
 	case FB_EVENT_BLANK:
 	case FB_EVENT_MODE_CHANGE:
 	case FB_EVENT_MODE_CHANGE_ALL:
+	case FB_EARLY_EVENT_BLANK:
+	case FB_R_EARLY_EVENT_BLANK:
 		break;
 	default:
 		return 0;
@@ -46,6 +48,14 @@ static int fb_notifier_callback(struct n
 		if (event == FB_EVENT_BLANK) {
 			if (ld->ops->set_power)
 				ld->ops->set_power(ld, *(int *)evdata->data);
+		} else if (event == FB_EARLY_EVENT_BLANK) {
+			if (ld->ops->early_set_power)
+				ld->ops->early_set_power(ld,
+						*(int *)evdata->data);
+		} else if (event == FB_R_EARLY_EVENT_BLANK) {
+			if (ld->ops->r_early_set_power)
+				ld->ops->r_early_set_power(ld,
+						*(int *)evdata->data);
 		} else {
 			if (ld->ops->set_mode)
 				ld->ops->set_mode(ld, evdata->data);
diff -puN include/linux/lcd.h~lcd-add-callbacks-for-early-fb-event-blank-support include/linux/lcd.h
--- a/include/linux/lcd.h~lcd-add-callbacks-for-early-fb-event-blank-support
+++ a/include/linux/lcd.h
@@ -40,6 +40,16 @@ struct lcd_ops {
 	/* Get the LCD panel power status (0: full on, 1..3: controller
 	   power on, flat panel power off, 4: full off), see FB_BLANK_XXX */
 	int (*get_power)(struct lcd_device *);
+	/*
+	 * Enable or disable power to the LCD(0: on; 4: off, see FB_BLANK_XXX)
+	 * and this callback would be called proir to fb driver's callback.
+	 *
+	 * P.S. note that if early_set_power is not NULL then early fb notifier
+	 *	would be registered.
+	 */
+	int (*early_set_power)(struct lcd_device *, int power);
+	/* revert the effects of the early blank event. */
+	int (*r_early_set_power)(struct lcd_device *, int power);
 	/* Enable or disable power to the LCD (0: on; 4: off, see FB_BLANK_XXX) */
 	int (*set_power)(struct lcd_device *, int power);
 	/* Get the current contrast setting (0-max_contrast) */
_

Patches currently in -mm which might be from inki.dae@samsung.com are

origin.patch
linux-next.patch

