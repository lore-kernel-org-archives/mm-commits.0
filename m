From: akpm@linux-foundation.org
Subject: [merged]
 rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:07:14 -0800
Message-ID: <5489eb62.loECUwGY9+rROkaR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbaLKTHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: handle consequeces of lacking second alarm reg
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kardell <jan.kardell@telliq.com>
Subject: rtc: pcf8563: handle consequeces of lacking second alarm reg

To guarantee that a set alarm occurs in the future, the set alarm time is
rounded up to the nearest minute.  Also we cannot handle UIE as it
requires second precision.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -361,6 +361,14 @@ static int pcf8563_rtc_set_alarm(struct
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char buf[4];
 	int err;
+	unsigned long alarm_time;
+
+	/* The alarm has no seconds, round up to nearest minute */
+	if (tm->time.tm_sec) {
+		rtc_tm_to_time(&tm->time, &alarm_time);
+		alarm_time += 60-tm->time.tm_sec;
+		rtc_time_to_tm(alarm_time, &tm->time);
+	}
 
 	dev_dbg(dev, "%s, min=%d hour=%d wday=%d mday=%d "
 		"enabled=%d pending=%d\n", __func__,
@@ -435,6 +443,9 @@ static int pcf8563_probe(struct i2c_clie
 
 	}
 
+	/* the pcf8563 alarm only supports a minute accuracy */
+	pcf8563->rtc->uie_unsupported = 1;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from jan.kardell@telliq.com are

origin.patch

