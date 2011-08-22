From: akpm@linux-foundation.org
Subject: + leds-add-missing-include-of-linux-moduleh.patch added to -mm tree
Date: Mon, 22 Aug 2011 15:10:55 -0700
Message-ID: <201108222210.p7MMAtmI009400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab1HVWLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 18:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, damm@opensource.se, kristoffer.ericson@gmail.com, noodles@earth.li, rpurdie@rpsys.net


The patch titled
     leds: add missing include of linux/module.h
has been added to the -mm tree.  Its filename is
     leds-add-missing-include-of-linux-moduleh.patch

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
Subject: leds: add missing include of linux/module.h
From: Axel Lin <axel.lin@gmail.com>

Add missing include of linux/module.h for drivers that use interfaces from
linux/module.h.  This patch fixes build errors.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Jonathan McDowell <noodles@earth.li>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-ams-delta.c |    1 +
 drivers/leds/leds-hp6xx.c     |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/leds/leds-ams-delta.c~leds-add-missing-include-of-linux-moduleh drivers/leds/leds-ams-delta.c
--- a/drivers/leds/leds-ams-delta.c~leds-add-missing-include-of-linux-moduleh
+++ a/drivers/leds/leds-ams-delta.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
diff -puN drivers/leds/leds-hp6xx.c~leds-add-missing-include-of-linux-moduleh drivers/leds/leds-hp6xx.c
--- a/drivers/leds/leds-hp6xx.c~leds-add-missing-include-of-linux-moduleh
+++ a/drivers/leds/leds-hp6xx.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch
leds-add-missing-include-of-linux-moduleh.patch
linux-next.patch

