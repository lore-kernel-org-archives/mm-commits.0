From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch removed from -mm tree
Date: Mon, 16 Dec 2013 12:39:26 -0800
Message-ID: <52af64fe.1QxL9j0NSA9tfbTq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3LPUj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, nicolas.ferre@atmel.com, linus@narrativeteam.com

Subject: [merged] drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch removed from -mm tree
To: linus@narrativeteam.com,nicolas.ferre@atmel.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:26 -0800


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-at91rm9200c-correct-alarm-over-day-month-wrap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Linus Pizunski <linus@narrativeteam.com>
Subject: drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Update month and day of month to the alarm month/day instead of current
day/month when setting the RTC alarm mask.

Signed-off-by: Linus Pizunski <linus@narrativeteam.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <stable@vger.kernel.org>
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


