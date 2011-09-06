From: akpm@linux-foundation.org
Subject: + leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:49:52 -0700
Message-ID: <201109062249.p86Mnq0Q008882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883Ab1IFWuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@canonical.com, linus.walleij@linaro.org, rpurdie@rpsys.net


The patch titled
     leds-class: change back LEDS_CLASS to tristate instead of bool
has been added to the -mm tree.  Its filename is
     leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch

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
Subject: leds-class: change back LEDS_CLASS to tristate instead of bool
From: Bryan Wu <bryan.wu@canonical.com>

LEDS_CLASS is required by leds and trigger drivers, but we can build it as
module.  So change this option back as tristate and treak the help message
as well.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/leds/Kconfig~leds-class-change-back-leds_class-to-tristate-instead-of-bool drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-class-change-back-leds_class-to-tristate-instead-of-bool
+++ a/drivers/leds/Kconfig
@@ -17,10 +17,13 @@ menuconfig NEW_LEDS
 if NEW_LEDS
 
 config LEDS_CLASS
-	bool "LED Class Support"
+	tristate "LED Class Support"
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
-	  need this to do anything useful with LEDs.  If unsure, say N.
+	  need this to do anything useful with LEDs.  If unsure, say M.
+
+	  Note: don't disable it as N, because plenty of led and trigger drivers
+	  are using this option.
 
 comment "LED drivers"
 
_

Patches currently in -mm which might be from bryan.wu@canonical.com are

origin.patch
leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch
documentation-leds-class-fix-a-typo.patch

