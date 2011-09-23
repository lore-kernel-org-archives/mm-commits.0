From: akpm@google.com
Subject: [failures] leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch removed from -mm tree
Date: Fri, 23 Sep 2011 16:26:48 -0700
Message-ID: <201109232326.p8NNQm79021366@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:24117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1IWX04 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 19:26:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@canonical.com, linus.walleij@linaro.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-class: change back LEDS_CLASS to tristate instead of bool
has been removed from the -mm tree.  Its filename was
     leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bryan Wu <bryan.wu@canonical.com>
Subject: leds-class: change back LEDS_CLASS to tristate instead of bool

LEDS_CLASS is required by leds and trigger drivers, but we can build it as
module.  So change this option back as tristate and treak the help message
as well.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@google.com>
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
linux-next.patch

