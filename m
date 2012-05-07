From: akpm@linux-foundation.org
Subject: [merged] arch-x86-platform-geode-net5501c-change-active_low-to-0-for-led-driver.patch removed from -mm tree
Date: Mon, 07 May 2012 14:19:00 -0700
Message-ID: <20120507211900.B6CF5A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:58070 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab2EGVTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2012 17:19:02 -0400
Received: by yhgm50 with SMTP id m50so634030yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 07 May 2012 14:19:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gurligebis@gentoo.org, hpa@zytor.com, mingo@redhat.com, philipp@redfish-solutions.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/platform/geode/net5501.c: change active_low to 0 for LED driver
has been removed from the -mm tree.  Its filename was
     arch-x86-platform-geode-net5501c-change-active_low-to-0-for-led-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: arch/x86/platform/geode/net5501.c: change active_low to 0 for LED driver

It seems that there was an error with the active_low = 1 for the
LED, since it should be set to 0 (meaning that active is high,
since 0 is false, hence the confusion.

The wiki article about it confuses it, since it contradicts itself,
regarding what turns on the LED.

I have tested 3.4-rc2 on my net5501 with this patch, and it makes the LED
behave correctly, where "none" turns it off, and "default-on" turns it on,
when echoed onto the trigger "file" in /sys/class/leds.

Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Philip Prindeville <philipp@redfish-solutions.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/geode/net5501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/platform/geode/net5501.c~arch-x86-platform-geode-net5501c-change-active_low-to-0-for-led-driver arch/x86/platform/geode/net5501.c
--- a/arch/x86/platform/geode/net5501.c~arch-x86-platform-geode-net5501c-change-active_low-to-0-for-led-driver
+++ a/arch/x86/platform/geode/net5501.c
@@ -63,7 +63,7 @@ static struct gpio_led net5501_leds[] = 
 		.name = "net5501:1",
 		.gpio = 6,
 		.default_trigger = "default-on",
-		.active_low = 1,
+		.active_low = 0,
 	},
 };
 
_

Patches currently in -mm which might be from gurligebis@gentoo.org are


