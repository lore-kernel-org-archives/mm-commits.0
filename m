From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch added
 to -mm tree
Date: Mon, 18 Nov 2013 14:37:55 -0800
Message-ID: <528a96c3.pNP4macGhZoTA0xI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3KRWh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 17:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nicolas.ferre@atmel.com, linus@narrativeteam.com

Subject: + drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch added to -mm tree
To: linus@narrativeteam.com,nicolas.ferre@atmel.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 14:37:55 -0800


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Linus Pizunski <linus@narrativeteam.com>
Subject: drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Update month and day of month to the alarm month/day instead of current
day/month when setting the RTC alarm mask.

Signed-off-by: Linus Pizunski <linus@narrativeteam.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -220,6 +220,8 @@ static int at91_rtc_setalarm(struct devi
 
 	at91_alarm_year = tm.tm_year;
 
+	tm.tm_mon = alrm->time.tm_mon;
+	tm.tm_mday = alrm->time.tm_mday;
 	tm.tm_hour = alrm->time.tm_hour;
 	tm.tm_min = alrm->time.tm_min;
 	tm.tm_sec = alrm->time.tm_sec;
_

Patches currently in -mm which might be from linus@narrativeteam.com are

drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch

