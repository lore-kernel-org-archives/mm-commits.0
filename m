From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-rs5c348c-fix-hour-decoding-in-12-hour-mode.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:20:29 -0700
Message-ID: <20120820212029.A920E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:55477 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2HTVUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:20:31 -0400
Received: by obbwc20 with SMTP id wc20so4080123obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:20:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, newten82@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-rs5c348c-fix-hour-decoding-in-12-hour-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode

Correct the offset by subtracting 20 from tm_hour before taking the modulo
12.

Reported-by: James Nute <newten82@gmail.com>
Tested-by: James Nute <newten82@gmail.com>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c348.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-rs5c348.c~drivers-rtc-rtc-rs5c348c-fix-hour-decoding-in-12-hour-mode drivers/rtc/rtc-rs5c348.c
--- a/drivers/rtc/rtc-rs5c348.c~drivers-rtc-rtc-rs5c348c-fix-hour-decoding-in-12-hour-mode
+++ a/drivers/rtc/rtc-rs5c348.c
@@ -122,9 +122,12 @@ rs5c348_rtc_read_time(struct device *dev
 	tm->tm_min = bcd2bin(rxbuf[RS5C348_REG_MINS] & RS5C348_MINS_MASK);
 	tm->tm_hour = bcd2bin(rxbuf[RS5C348_REG_HOURS] & RS5C348_HOURS_MASK);
 	if (!pdata->rtc_24h) {
-		tm->tm_hour %= 12;
-		if (rxbuf[RS5C348_REG_HOURS] & RS5C348_BIT_PM)
+		if (rxbuf[RS5C348_REG_HOURS] & RS5C348_BIT_PM) {
+			tm->tm_hour -= 20;
+			tm->tm_hour %= 12;
 			tm->tm_hour += 12;
+		} else
+			tm->tm_hour %= 12;
 	}
 	tm->tm_wday = bcd2bin(rxbuf[RS5C348_REG_WDAY] & RS5C348_WDAY_MASK);
 	tm->tm_mday = bcd2bin(rxbuf[RS5C348_REG_DAY] & RS5C348_DAY_MASK);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

drivers-rtc-rtc-rs5c348c-fix-hour-decoding-in-12-hour-mode.patch

