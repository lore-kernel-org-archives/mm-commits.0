From: akpm@linux-foundation.org
Subject: + leds-fix-the-menuconfig-being-wrongly-displayed.patch added to -mm tree
Date: Thu, 09 Jun 2011 16:47:41 -0700
Message-ID: <201106092347.p59Nlfax008899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757411Ab1FIXr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 19:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@canonical.com, Valdis.Kletnieks@vt.edu, eric.y.miao@gmail.com, randy.dunlap@oracle.com, rpurdie@rpsys.net


The patch titled
     leds: fix the incorrect display in menuconfig
has been added to the -mm tree.  Its filename is
     leds-fix-the-menuconfig-being-wrongly-displayed.patch

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
Subject: leds: fix the incorrect display in menuconfig
From: Eric Miao <eric.miao@canonical.com>

Seems when a config option does not have a dependency of the menuconfig,
it messes the display of the rest configs, even if it's a hidden one.

Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/leds/Kconfig~leds-fix-the-menuconfig-being-wrongly-displayed drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-fix-the-menuconfig-being-wrongly-displayed
+++ a/drivers/leds/Kconfig
@@ -14,15 +14,14 @@ menuconfig NEW_LEDS
 	  This is not related to standard keyboard LEDs which are controlled
 	  via the input system.
 
+if NEW_LEDS
+
 config LEDS_CLASS
 	bool "LED Class Support"
-	depends on NEW_LEDS
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
-if NEW_LEDS
