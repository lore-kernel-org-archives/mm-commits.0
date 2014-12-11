From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-fix-wrong-time-from-read_alarm.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:11 -0800
Message-ID: <5489eb5f.LBYg9p0v46t7+2Im%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaLKTHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: fix wrong time from read_alarm
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-fix-wrong-time-from-read_alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kardell <jan.kardell@telliq.com>
Subject: rtc: pcf8563: fix wrong time from read_alarm

Incorrect mask was used for hour and monthday fields.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-wrong-time-from-read_alarm drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-wrong-time-from-read_alarm
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -336,8 +336,8 @@ static int pcf8563_rtc_read_alarm(struct
 		__func__, buf[0], buf[1], buf[2], buf[3]);
 
 	tm->time.tm_min = bcd2bin(buf[0] & 0x7F);
-	tm->time.tm_hour = bcd2bin(buf[1] & 0x7F);
-	tm->time.tm_mday = bcd2bin(buf[2] & 0x1F);
+	tm->time.tm_hour = bcd2bin(buf[1] & 0x3F);
+	tm->time.tm_mday = bcd2bin(buf[2] & 0x3F);
 	tm->time.tm_wday = bcd2bin(buf[3] & 0x7);
 	tm->time.tm_mon = -1;
 	tm->time.tm_year = -1;
_

Patches currently in -mm which might be from jan.kardell@telliq.com are

origin.patch

