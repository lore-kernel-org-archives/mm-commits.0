From: akpm@linux-foundation.org
Subject: + rtc-cmos-fix-printk-output.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:27:36 -0700
Message-ID: <200904171827.n3HIRaEd025583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbZDQSaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, david-b@pacbell.net


The patch titled
     rtc-cmos: fix printk output
has been added to the -mm tree.  Its filename is
     rtc-cmos-fix-printk-output.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-cmos-fix-printk-output.patch

