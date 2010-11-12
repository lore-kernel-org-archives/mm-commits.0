From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5523c-perform-sw-reset-before-detection.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:45:02 -0800
Message-ID: <201011121945.oACJj2BC028071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859Ab0KLTpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5523.c: perform SW reset before detection
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5523c-perform-sw-reset-before-detection.patch

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
Subject: drivers/leds/leds-lp5523.c: perform SW reset before detection
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Chip detection may fail if the chip is in some odd state for example after
system restart.  Chip doesn't have HW reset line.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-perform-sw-reset-before-detection drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-perform-sw-reset-before-detection
+++ a/drivers/leds/leds-lp5523.c
@@ -203,13 +203,6 @@ static int lp5523_configure(struct i2c_c
 		{ 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
 	};
 
-	lp5523_write(client, LP5523_REG_RESET, 0xff);
-
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
-
 	ret |= lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
 	/* Chip startup time is 500 us, 1 - 2 ms gives some margin */
 	usleep_range(1000, 2000);
@@ -941,6 +934,11 @@ static int lp5523_probe(struct i2c_clien
 		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
+	lp5523_write(client, LP5523_REG_RESET, 0xff);
+	usleep_range(10000, 20000); /*
+				     * Exact value is not available. 10 - 20ms
+				     * appears to be enough for reset.
+				     */
 	ret = lp5523_detect(client);
 	if (ret)
 		goto fail2;
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

