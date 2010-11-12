From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:45:00 -0800
Message-ID: <201011121945.oACJj0Ka028067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab0KLTp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:45:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5521.c: perform SW reset before detection
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch

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
Subject: drivers/leds/leds-lp5521.c: perform SW reset before detection
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Chip detection may fail if the chip is in some odd state for example after
system restart.  Chip doesn't have HW reset line.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-perform-sw-reset-before-detection drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-perform-sw-reset-before-detection
+++ a/drivers/leds/leds-lp5521.c
@@ -245,13 +245,6 @@ static int lp5521_configure(struct i2c_c
 
 	lp5521_init_engine(chip, attr_group);
 
-	lp5521_write(client, LP5521_REG_RESET, 0xff);
-
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
-
 	/* Set all PWMs to direct control mode */
 	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
 
@@ -716,6 +709,11 @@ static int lp5521_probe(struct i2c_clien
 		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
+	lp5521_write(client, LP5521_REG_RESET, 0xff);
+	usleep_range(10000, 20000); /*
+				     * Exact value is not available. 10 - 20ms
+				     * appears to be enough for reset.
+				     */
 	ret = lp5521_detect(client);
 
 	if (ret) {
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch
drivers-leds-leds-lp5521c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch
drivers-leds-leds-lp5523c-perform-sw-reset-before-detection.patch

