From: akpm@linux-foundation.org
Subject: + rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch added to -mm tree
Date: Wed, 07 May 2008 14:53:53 -0700
Message-ID: <200805072153.m47Lrr49018378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105AbYEGVzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, a.zummo@towertech.it, david-b@pacbell.net, dmitri.vorobiev@gmail.com, stable@kernel.org


The patch titled
     rtc: rtc_time_to_tm: use unsigned arithmetic
has been added to the -mm tree.  Its filename is
     rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc_time_to_tm: use unsigned arithmetic
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The input argument to rtc_time_to_tm() is unsigned as well as are members of
the output structure.  However signed arithmetic is used within for
calculations leading to incorrect results for input values outside the signed
positive range.  If this happens the time of day returned is out of range.

Found the problem when fiddling with the RTC and the driver where year was set
to an unexpectedly large value like 2070, e.g.:

rtc0: setting system clock to 2070-01-01 1193046:71582832:26 UTC (3155760954)

while it should be:

rtc0: setting system clock to 2070-01-01 00:15:54 UTC (3155760954)

Changing types to unsigned fixes the problem.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-lib.c~rtc-rtc_time_to_tm-use-unsigned-arithmetic drivers/rtc/rtc-lib.c
--- a/drivers/rtc/rtc-lib.c~rtc-rtc_time_to_tm-use-unsigned-arithmetic
+++ a/drivers/rtc/rtc-lib.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(rtc_year_days);
  */
 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-	register int days, month, year;
+	register unsigned int days, month, year;
 
 	days = time / 86400;
 	time -= days * 86400;
_

Patches currently in -mm which might be from macro@linux-mips.org are

rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch

