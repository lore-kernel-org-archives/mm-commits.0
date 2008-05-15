From: akpm@linux-foundation.org
Subject: + leds-fix-unsigned-value-overflow-in-for-loop.patch added to -mm tree
Date: Thu, 15 May 2008 14:15:05 -0700
Message-ID: <200805152115.m4FLF7cb010921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbYEOVPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:15:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com


The patch titled
     leds: fix unsigned value overflow in for loop
has been added to the -mm tree.  Its filename is
     leds-fix-unsigned-value-overflow-in-for-loop.patch

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
Subject: leds: fix unsigned value overflow in for loop
From: Li Zefan <lizf@cn.fujitsu.com>

Fix the following unsigned variable overflow:
	unsigned i;
	for (i = n; i >= 0; i--)
	...

It won't break anything to use type 'int'.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-atmel-pwm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-atmel-pwm.c~leds-fix-unsigned-value-overflow-in-for-loop drivers/leds/leds-atmel-pwm.c
--- a/drivers/leds/leds-atmel-pwm.c~leds-fix-unsigned-value-overflow-in-for-loop
+++ a/drivers/leds/leds-atmel-pwm.c
@@ -37,7 +37,7 @@ static int __init pwmled_probe(struct pl
 {
 	const struct gpio_led_platform_data	*pdata;
 	struct pwmled				*leds;
-	unsigned				i;
+	int					i;
 	int					status;
 
 	pdata = pdev->dev.platform_data;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

leds-fix-unsigned-value-overflow-in-for-loop.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch

