From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-optimize-irq-bit-access.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:38:49 -0800
Message-ID: <20120128003849.9285EA01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:41899 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2A1Aiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:38:50 -0500
Received: by ghrr20 with SMTP id r20so84455ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:38:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vbyravarasu@nvidia.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-twl.c: optimize IRQ bit access
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-optimize-irq-bit-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: drivers/rtc/rtc-twl.c: optimize IRQ bit access

As the TWL RTC driver has a cached copy of enabled RTC interrupt bits in
variable rtc_irq_bits, that can be checked before really setting or
masking any of the interrupt bits.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-optimize-irq-bit-access drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-optimize-irq-bit-access
+++ a/drivers/rtc/rtc-twl.c
@@ -176,6 +176,10 @@ static int set_rtc_irq_bit(unsigned char
 	unsigned char val;
 	int ret;
 
+	/* if the bit is set, return from here */
+	if (rtc_irq_bits & bit)
+		return 0;
+
 	val = rtc_irq_bits | bit;
 	val &= ~BIT_RTC_INTERRUPTS_REG_EVERY_M;
 	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
@@ -193,6 +197,10 @@ static int mask_rtc_irq_bit(unsigned cha
 	unsigned char val;
 	int ret;
 
+	/* if the bit is clear, return from here */
+	if (!(rtc_irq_bits & bit))
+		return 0;
+
 	val = rtc_irq_bits & ~bit;
 	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
 	if (ret == 0)
_
Subject: Subject: drivers/rtc/rtc-twl.c: optimize IRQ bit access

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

drivers-rtc-rtc-twlc-optimize-irq-bit-access.patch

