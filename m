From: akpm@linux-foundation.org
Subject: + gpio-led-properly-initialize-return-value.patch added to -mm tree
Date: Thu, 21 Oct 2010 13:22:05 -0700
Message-ID: <201010212022.o9LKM5xx001377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482Ab0JUUWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 16:22:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org, rpurdie@rpsys.net


The patch titled
     gpio led: properly initialize return value
has been added to the -mm tree.  Its filename is
     gpio-led-properly-initialize-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio led: properly initialize return value
From: Davidlohr Bueso <dave@gnu.org>

In the event that none of the configs are set (CONFIG_LEDS_GPIO_PLATFORM,
CONFIG_LEDS_GPIO_OF, CONFIG_LEDS_GPIO_PLATFORM), we will return a bogus
value when initializing the module.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-gpio.c~gpio-led-properly-initialize-return-value drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~gpio-led-properly-initialize-return-value
+++ a/drivers/leds/leds-gpio.c
@@ -316,7 +316,7 @@ static struct of_platform_driver of_gpio
 
 static int __init gpio_led_init(void)
 {
-	int ret;
+	int ret = 0;
 
 #ifdef CONFIG_LEDS_GPIO_PLATFORM	
 	ret = platform_driver_register(&gpio_led_driver);
_

Patches currently in -mm which might be from dave@gnu.org are

linux-next.patch
gpio-led-properly-initialize-return-value.patch
procfs-fix-proc-softirqs-formatting.patch

