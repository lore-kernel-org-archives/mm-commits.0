From: akpm@linux-foundation.org
Subject: +
 rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch added to
 -mm tree
Date: Tue, 28 Oct 2014 14:26:12 -0700
Message-ID: <545009f4.JCrEFtylh0JAF6V2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaJ1V0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:26:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: handle consequeces of lacking second alarm reg
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

