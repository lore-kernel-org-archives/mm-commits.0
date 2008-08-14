From: akpm@linux-foundation.org
Subject: + leds-wrap-use-default-on-trigger-for-power-led.patch added to -mm tree
Date: Thu, 14 Aug 2008 02:32:30 -0700
Message-ID: <200808140932.m7E9WUU2001695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYHNJct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 05:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, rpurdie@rpsys.net


The patch titled
     leds-wrap: use default-on trigger for power led
has been added to the -mm tree.  Its filename is
     leds-wrap-use-default-on-trigger-for-power-led.patch

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

leds-avoid-needless-strlen-for-attributes.patch
leds-wrap-use-default-on-trigger-for-power-led.patch
leds-fsg-change-order-of-initialization-and-deinitialization.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch

