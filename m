From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-rs5c348c-fix-hour-decoding-in-12-hour-mode.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:45 -0700
Message-ID: <20120824184146.1A6565C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40164 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2HXSlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:47 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so106165bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, newten82@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-rs5c348c-fix-hour-decoding-in-12-hour-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

