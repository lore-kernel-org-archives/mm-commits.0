From: akpm@linux-foundation.org
Subject: + rtc-cmos-fix-boot-log-message.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:15:01 -0800
Message-ID: <200811052015.mA5KF1mc032295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbYKEUPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:15:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, david-b@pacbell.net


The patch titled
     rtc-cmos: fix boot log message
has been added to the -mm tree.  Its filename is
     rtc-cmos-fix-boot-log-message.patch

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
Subject: rtc-cmos: fix boot log message
From: Frans Pop <elendil@planet.nl>

-rtc0: alarms up to one month, y3k, 114 bytes nvram, , hpet irqs irqs
+rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-fix-boot-log-message drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-fix-boot-log-message
+++ a/drivers/rtc/rtc-cmos.c
@@ -794,7 +794,7 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s, %zd bytes nvram, %s irqs\n",
+	pr_info("%s: alarms up to one %s%s, %zd bytes nvram%s\n",
 			cmos_rtc.rtc->dev.bus_id,
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
_

Patches currently in -mm which might be from elendil@planet.nl are

rtc-cmos-fix-boot-log-message.patch
linux-next.patch

