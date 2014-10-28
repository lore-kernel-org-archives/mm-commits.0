From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-fix-wrong-time-from-read_alarm.patch added to -mm
 tree
Date: Tue, 28 Oct 2014 14:26:11 -0700
Message-ID: <545009f3.G1HfFamx+ZSHgO7I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaJ1V0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: fix wrong time from read_alarm
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-fix-wrong-time-from-read_alarm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pcf8563-fix-wrong-time-from-read_alarm.patch

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

rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

