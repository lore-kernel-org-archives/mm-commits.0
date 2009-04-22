From: akpm@linux-foundation.org
Subject: [merged] rtc-cmos-fix-printk-output.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:37 -0700
Message-ID: <200904221830.n3MIUb8V006276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbZDVSdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khc@pm.waw.pl, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos: fix printk output
has been removed from the -mm tree.  Its filename was
     rtc-cmos-fix-printk-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos: fix printk output
From: Krzysztof Halasa <khc@pm.waw.pl>

With no IRQ available/defined, RTC-CMOS driver prints something like:
	rtc0: alarms up to one no, y3k, 114 bytes nvram
                              ^^^^
I guess the following is a bit easier to understand:
	rtc0: no alarms, y3k, 114 bytes nvram

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-fix-printk-output drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-fix-printk-output
+++ a/drivers/rtc/rtc-cmos.c
@@ -797,17 +797,15 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s, %zd bytes nvram%s\n",
-			dev_name(&cmos_rtc.rtc->dev),
-			is_valid_irq(rtc_irq)
-				?  (cmos_rtc.mon_alrm
-					? "year"
-					: (cmos_rtc.day_alrm
-						? "month" : "day"))
-				: "no",
-			cmos_rtc.century ? ", y3k" : "",
-			nvram.size,
-			is_hpet_enabled() ? ", hpet irqs" : "");
+	pr_info("%s: %s%s, %zd bytes nvram%s\n",
+		dev_name(&cmos_rtc.rtc->dev),
+		!is_valid_irq(rtc_irq) ? "no alarms" :
+			cmos_rtc.mon_alrm ? "alarms up to one year" :
+			cmos_rtc.day_alrm ? "alarms up to one month" :
+			"alarms up to one day",
+		cmos_rtc.century ? ", y3k" : "",
+		nvram.size,
+		is_hpet_enabled() ? ", hpet irqs" : "");
 
 	return 0;
 
_

Patches currently in -mm which might be from khc@pm.waw.pl are


