From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-optimize-irq-bit-access.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:27 -0700
Message-ID: <20120326193127.7E35EA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:48787 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2CZTb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:28 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so832340yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl.c: optimize IRQ bit access
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-optimize-irq-bit-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

origin.patch
linux-next.patch

