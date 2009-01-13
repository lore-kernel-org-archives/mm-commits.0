From: akpm@linux-foundation.org
Subject: + rtc-pxa-fix-build-failure.patch added to -mm tree
Date: Mon, 12 Jan 2009 23:11:39 -0800
Message-ID: <200901130711.n0D7BdS9022899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZAMHMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 02:12:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ospite@studenti.unina.it, a.zummo@towertech.it, ao2@openezx.org, david-b@pacbell.net


The patch titled
     rtc-pxa: fix build failure
has been added to the -mm tree.  Its filename is
     rtc-pxa-fix-build-failure.patch

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
Subject: rtc-pxa: fix build failure
From: Antonio Ospite <ospite@studenti.unina.it>

Fix these build errors:

  CC      drivers/rtc/rtc-pxa.o
drivers/rtc/rtc-pxa.c: In function `pxa_rtc_init':
drivers/rtc/rtc-pxa.c:472: error: implicit declaration of function `cpu_is_pxa27x'
drivers/rtc/rtc-pxa.c:472: error: implicit declaration of function `cpu_is_pxa3xx'

Signed-off-by: Antonio Ospite <ao2@openezx.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-pxa.c~rtc-pxa-fix-build-failure drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-pxa-fix-build-failure
+++ a/drivers/rtc/rtc-pxa.c
@@ -27,6 +27,8 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 
+#include <mach/hardware.h>
+
 #define TIMER_FREQ		CLOCK_TICK_RATE
 #define RTC_DEF_DIVIDER		(32768 - 1)
 #define RTC_DEF_TRIM		0
_

Patches currently in -mm which might be from ospite@studenti.unina.it are

rtc-pxa-fix-build-failure.patch

