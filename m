From: akpm@linux-foundation.org
Subject: + wm97xx-fix-module-build-error-with-battery-driver.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:30:19 -0700
Message-ID: <200810162030.m9GKUJhX015018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509AbYJPUbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:31:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au, broonie@opensource.wolfsonmicro.com, cbouatmailru@gmail.com, marek.vasut@gmail.com, rmk+kernel@arm.linux.org.uk


The patch titled
     wm97xx: fix module build error with battery driver
has been added to the -mm tree.  Its filename is
     wm97xx-fix-module-build-error-with-battery-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wm97xx: fix module build error with battery driver
From: Herbert Xu <herbert@gondor.apana.org.au>

I had

CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_BATTERY_WM97XX=y

and the build failed with

drivers/built-in.o: In function `wm97xx_bat_get_property':
wm97xx_battery.c:(.text+0x76144): undefined reference to `wm97xx_read_aux_adc'
wm97xx_battery.c:(.text+0x761ff): undefined reference to `wm97xx_read_aux_adc'
make: *** [.tmp_vmlinux1] Error 1

which is quite understandable.

Since the battery driver appears to be a fully functional module
this patch changes the Makefile to let it be built as such.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/power/Makefile~wm97xx-fix-module-build-error-with-battery-driver drivers/power/Makefile
--- a/drivers/power/Makefile~wm97xx-fix-module-build-error-with-battery-driver
+++ a/drivers/power/Makefile
@@ -21,4 +21,8 @@ obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_b
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
-obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
\ No newline at end of file
+
+ifeq ($(CONFIG_BATTERY_WM97XX),y)
+obj-$(CONFIG_TOUCHSCREEN_WM97XX) += wm97xx_battery.o
+endif
+
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
wm97xx-fix-module-build-error-with-battery-driver.patch

