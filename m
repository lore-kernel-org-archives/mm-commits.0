From: akpm@linux-foundation.org
Subject: [merged] rtc-vr41xx-fix-do_div-warning.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:13 -0800
Message-ID: <200911131927.nADJRDev030088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757216AbZKMT1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuasa@linux-mips.org, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lethal@linux-sh.org, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     rtc-vr41xx: fix do_div() warning
has been removed from the -mm tree.  Its filename was
     rtc-vr41xx-fix-do_div-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-vr41xx: fix do_div() warning
From: Yoichi Yuasa <yuasa@linux-mips.org>

drivers/rtc/rtc-vr41xx.c: In function 'vr41xx_rtc_irq_set_freq':
drivers/rtc/rtc-vr41xx.c:217: warning: comparison of distinct pointer types lacks a cast
drivers/rtc/rtc-vr41xx.c:217: warning: right shift count >= width of type
drivers/rtc/rtc-vr41xx.c:217: warning: passing argument 1 of '__div64_32' from incompatible pointer type
include/asm-generic/div64.h:35: note: expected 'uint64_t *' but argument is of type 'long unsigned int *'

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-fix-do_div-warning drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-fix-do_div-warning
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -209,19 +209,18 @@ static int vr41xx_rtc_set_alarm(struct d
 
 static int vr41xx_rtc_irq_set_freq(struct device *dev, int freq)
 {
-	unsigned long count;
+	u64 count;
 
 	if (!is_power_of_2(freq))
 		return -EINVAL;
 	count = RTC_FREQUENCY;
 	do_div(count, freq);
 
-	periodic_count = count;
