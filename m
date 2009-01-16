From: akpm@linux-foundation.org
Subject: + regulator-minor-cleanup-of-virtual-consumer.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:10:46 -0800
Message-ID: <200901160010.n0G0AkxG004980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbZAPALH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:11:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk


The patch titled
     regulator: minor cleanup of virtual consumer
has been added to the -mm tree.  Its filename is
     regulator-minor-cleanup-of-virtual-consumer.patch

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
Subject: regulator: minor cleanup of virtual consumer
From: David Brownell <dbrownell@users.sourceforge.net>

Minor cleanup to the regulator set_mode sysfs support: switch to
sysfs_streq() in set_mode(), which is also a code shrink.  Use the same
strings that get_mode() uses, shrinking data too.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/virtual.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/regulator/virtual.c~regulator-minor-cleanup-of-virtual-consumer drivers/regulator/virtual.c
--- a/drivers/regulator/virtual.c~regulator-minor-cleanup-of-virtual-consumer
+++ a/drivers/regulator/virtual.c
@@ -226,13 +226,13 @@ static ssize_t set_mode(struct device *d
 	unsigned int mode;
 	int ret;
 
-	if (strncmp(buf, "fast", strlen("fast")) == 0)
+	if (sysfs_streq(buf, "fast\n") == 0)
 		mode = REGULATOR_MODE_FAST;
-	else if (strncmp(buf, "normal", strlen("normal")) == 0)
+	else if (sysfs_streq(buf, "normal\n") == 0)
 		mode = REGULATOR_MODE_NORMAL;
-	else if (strncmp(buf, "idle", strlen("idle")) == 0)
+	else if (sysfs_streq(buf, "idle\n") == 0)
 		mode = REGULATOR_MODE_IDLE;
-	else if (strncmp(buf, "standby", strlen("standby")) == 0)
+	else if (sysfs_streq(buf, "standby\n") == 0)
 		mode = REGULATOR_MODE_STANDBY;
 	else {
 		dev_err(dev, "Configuring invalid mode\n");
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
rtc-tw4030-add-alarm-update-interfaces-v2.patch
rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-shutdown.patch
drivers-usb-core-hubc-fix-config_usb_otg=y-build.patch
linux-next.patch
mmc-fixes-and-enhancements-for-the-mmc-spi-driver.patch
regulator-minor-cleanup-of-virtual-consumer.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller-update.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch

