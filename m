From: akpm@linux-foundation.org
Subject: + drivers-hwmon-f75375sc-shift-control-mode-to-the-correct-bit-position.patch added to -mm tree
Date: Fri, 03 Sep 2010 15:01:41 -0700
Message-ID: <201009032201.o83M1fFX014871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab0ICWCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 18:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guillem@hadrons.org, khali@linux-fr.org, w.sang@pengutronix.de


The patch titled
     drivers/hwmon/f75375s.c: shift control mode to the correct bit position
has been added to the -mm tree.  Its filename is
     drivers-hwmon-f75375sc-shift-control-mode-to-the-correct-bit-position.patch

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
Subject: drivers/hwmon/f75375s.c: shift control mode to the correct bit position
From: Guillem Jover <guillem@hadrons.org>

The spec notes that fan0 and fan1 control mode bits are located in bits
7-6 and 5-4 respectively, but the FAN_CTRL_MODE macro was making the bits
shift by 5 instead of by 4.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/f75375s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/f75375s.c~drivers-hwmon-f75375sc-shift-control-mode-to-the-correct-bit-position drivers/hwmon/f75375s.c
--- a/drivers/hwmon/f75375s.c~drivers-hwmon-f75375sc-shift-control-mode-to-the-correct-bit-position
+++ a/drivers/hwmon/f75375s.c
@@ -79,7 +79,7 @@ enum chips { f75373, f75375 };
 #define F75375_REG_PWM2_DROP_DUTY	0x6C
 
 #define FAN_CTRL_LINEAR(nr)		(4 + nr)
-#define FAN_CTRL_MODE(nr)		(5 + ((nr) * 2))
+#define FAN_CTRL_MODE(nr)		(4 + ((nr) * 2))
 
 /*
  * Data structures and manipulation thereof
_

Patches currently in -mm which might be from guillem@hadrons.org are

drivers-hwmon-f75375sc-shift-control-mode-to-the-correct-bit-position.patch
drivers-hwmon-f75375sc-do-not-overwrite-values-read-from-registers.patch

