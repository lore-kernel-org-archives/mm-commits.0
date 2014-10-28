From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch added to -mm tree
Date: Tue, 28 Oct 2014 14:26:10 -0700
Message-ID: <545009f2.gIaI+JBRknxnZHvw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaJ1V0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: fix write of invalid bits to ST2 reg
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch

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
Subject: rtc: pcf8563: fix write of invalid bits to ST2 reg

The NXP datasheet says:
"Bits labeled as N should always be written with logic 0."

At least one of those bits is sometime read as a 1, therfore violating
this rule.  To fix this we mask away those bits.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -28,6 +28,7 @@
 #define PCF8563_REG_ST2		0x01
 #define PCF8563_BIT_AIE		(1 << 1)
 #define PCF8563_BIT_AF		(1 << 3)
+#define PCF8563_BITS_ST2_N	(7 << 5)
 
 #define PCF8563_REG_SC		0x02 /* datetime */
 #define PCF8563_REG_MN		0x03
@@ -130,7 +131,7 @@ static int pcf8563_set_alarm_mode(struct
 	else
 		buf &= ~PCF8563_BIT_AIE;
 
-	buf &= ~PCF8563_BIT_AF;
+	buf &= ~(PCF8563_BIT_AF | PCF8563_BITS_ST2_N);
 
 	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, &buf);
 	if (err < 0) {
_

Patches currently in -mm which might be from jan.kardell@telliq.com are

rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

