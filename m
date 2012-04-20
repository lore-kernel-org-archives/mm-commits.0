From: akpm@linux-foundation.org
Subject: + arch-x86-platform-geode-net5501c-change-active_low-to-0-for-led-driver.patch added to -mm tree
Date: Fri, 20 Apr 2012 15:16:12 -0700
Message-ID: <20120420221612.B5FCFA00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:58707 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2DTWQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 18:16:14 -0400
Received: by vcbfk26 with SMTP id fk26so1160786vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 15:16:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gurligebis@gentoo.org, hpa@zytor.com, mingo@redhat.com, philipp@redfish-solutions.com, tglx@linutronix.de


The patch titled
     Subject: arch/x86/platform/geode/net5501.c: change active_low to 0 for LED driver
has been added to the -mm tree.  Its filename is
     arch-x86-platform-geode-net5501c-change-active_low-to-0-for-led-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: arch/x86/platform/geode/net5501.c: change active_low to 0 for LED driver

Patches currently in -mm which might be from gurligebis@gentoo.org are

arch-x86-platform-geode-net5501c-change-active_low-to-0-for-led-driver.patch

