From: akpm@linux-foundation.org
Subject: - leds-wrap-use-default-on-trigger-for-power-led.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:57 -0700
Message-ID: <200810182320.m9INKvsH029865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbYJRXVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-wrap: use default-on trigger for power led
has been removed from the -mm tree.  Its filename was
     leds-wrap-use-default-on-trigger-for-power-led.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-wrap: use default-on trigger for power led
From: Sven Wegener <sven.wegener@stealer.net>

The power led is normally lit after boot, let's use the default-on trigger
as the default trigger for it.  This gets the initial brightness value
right and being on is the default behaviour we expect for a power led.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-wrap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-wrap.c~leds-wrap-use-default-on-trigger-for-power-led drivers/leds/leds-wrap.c
--- a/drivers/leds/leds-wrap.c~leds-wrap-use-default-on-trigger-for-power-led
+++ a/drivers/leds/leds-wrap.c
@@ -53,8 +53,9 @@ static void wrap_extra_led_set(struct le
 }
 
 static struct led_classdev wrap_power_led = {
-	.name		= "wrap::power",
-	.brightness_set	= wrap_power_led_set,
+	.name			= "wrap::power",
+	.brightness_set		= wrap_power_led_set,
+	.default_trigger	= "default-on",
 };
 
 static struct led_classdev wrap_error_led = {
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

origin.patch

