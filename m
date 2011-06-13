From: akpm@linux-foundation.org
Subject: + drivers-misc-apds990xc-apds990x_chip_on-should-depend-on-config_pm-config_pm_runtime.patch added to -mm tree
Date: Mon, 13 Jun 2011 13:53:52 -0700
Message-ID: <201106132053.p5DKrrrr021269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab1FMUyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 16:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, jic23@cam.ac.uk, samu.p.onkalo@nokia.com


The patch titled
     drivers/misc/apds990x.c: apds990x_chip_on() should depend on CONFIG_PM || CONFIG_PM_RUNTIME
has been added to the -mm tree.  Its filename is
     drivers-misc-apds990xc-apds990x_chip_on-should-depend-on-config_pm-config_pm_runtime.patch

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
Subject: drivers/misc/apds990x.c: apds990x_chip_on() should depend on CONFIG_PM || CONFIG_PM_RUNTIME
From: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/misc/apds990x.c: At top level:
drivers/misc/apds990x.c:613: warning: `apds990x_chip_on' defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/apds990x.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/apds990x.c~drivers-misc-apds990xc-apds990x_chip_on-should-depend-on-config_pm-config_pm_runtime drivers/misc/apds990x.c
--- a/drivers/misc/apds990x.c~drivers-misc-apds990xc-apds990x_chip_on-should-depend-on-config_pm-config_pm_runtime
+++ a/drivers/misc/apds990x.c
@@ -609,6 +609,7 @@ static int apds990x_detect(struct apds99
 	return ret;
 }
 
+#if defined(CONFIG_PM) || defined(CONFIG_PM_RUNTIME)
 static int apds990x_chip_on(struct apds990x_chip *chip)
 {
 	int err	 = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
@@ -624,6 +625,7 @@ static int apds990x_chip_on(struct apds9
 	apds990x_mode_on(chip);
 	return 0;
 }
+#endif
 
 static int apds990x_chip_off(struct apds990x_chip *chip)
 {
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
w1-w1_master_ds1wm-should-depend-on-generic_hardirqs.patch
mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
drivers-misc-apds990xc-apds990x_chip_on-should-depend-on-config_pm-config_pm_runtime.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
staging-iio-make-iio-depend-on-generic_hardirqs.patch

