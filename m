From: akpm@linux-foundation.org
Subject: + drivers-hwmon-f75375sc-do-not-overwrite-values-read-from-registers.patch added to -mm tree
Date: Fri, 03 Sep 2010 15:01:43 -0700
Message-ID: <201009032201.o83M1hia014874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932116Ab0ICWC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 18:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guillem@hadrons.org, khali@linux-fr.org, w.sang@pengutronix.de


The patch titled
     drivers/hwmon/f75375s.c: do not overwrite values read from registers
has been added to the -mm tree.  Its filename is
     drivers-hwmon-f75375sc-do-not-overwrite-values-read-from-registers.patch

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
Subject: drivers/hwmon/f75375s.c: do not overwrite values read from registers
From: Guillem Jover <guillem@hadrons.org>

All bits in the values read from registers to be used for the next write
were getting overwritten, avoid doing so to not mess with the current
configuration.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/f75375s.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/f75375s.c~drivers-hwmon-f75375sc-do-not-overwrite-values-read-from-registers drivers/hwmon/f75375s.c
--- a/drivers/hwmon/f75375s.c~drivers-hwmon-f75375sc-do-not-overwrite-values-read-from-registers
+++ a/drivers/hwmon/f75375s.c
@@ -298,7 +298,7 @@ static int set_pwm_enable_direct(struct 
 		return -EINVAL;
 
 	fanmode = f75375_read8(client, F75375_REG_FAN_TIMER);
-	fanmode = ~(3 << FAN_CTRL_MODE(nr));
+	fanmode &= ~(3 << FAN_CTRL_MODE(nr));
 
 	switch (val) {
 	case 0: /* Full speed */
@@ -350,7 +350,7 @@ static ssize_t set_pwm_mode(struct devic
 
 	mutex_lock(&data->update_lock);
 	conf = f75375_read8(client, F75375_REG_CONFIG1);
-	conf = ~(1 << FAN_CTRL_LINEAR(nr));
+	conf &= ~(1 << FAN_CTRL_LINEAR(nr));
 
 	if (val == 0)
 		conf |= (1 << FAN_CTRL_LINEAR(nr)) ;
_

Patches currently in -mm which might be from guillem@hadrons.org are

drivers-hwmon-f75375sc-shift-control-mode-to-the-correct-bit-position.patch
drivers-hwmon-f75375sc-do-not-overwrite-values-read-from-registers.patch

