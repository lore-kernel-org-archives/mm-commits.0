From: akpm@linux-foundation.org
Subject: + rtc_time_to_tm-fix-signed-unsigned-arithmetic.patch added to -mm tree
Date: Thu, 14 Aug 2008 14:50:19 -0700
Message-ID: <200808142150.m7ELoJrj031312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbYHNVve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 17:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.altenberg@linutronix.de, a.zummo@towertech.it, david-b@pacbell.net, dmitri.vorobiev@gmail.com, macro@linux-mips.org, stable@kernel.org


The patch titled
     rtc_time_to_tm: fix signed / unsigned arithmetic
has been added to the -mm tree.  Its filename is
     rtc_time_to_tm-fix-signed-unsigned-arithmetic.patch

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
Subject: rtc_time_to_tm: fix signed / unsigned arithmetic
From: Jan Altenberg <jan.altenberg@linutronix.de>

commit 945185a69daa457c4c5e46e47f4afad7dcea734f ("rtc: rtc_time_to_tm: use
unsigned arithmetic") changed the some types in rtc_time_to_tm() to
unsigned:

 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-       register int days, month, year;
+       unsigned int days, month, year;

This doesn't work for all cases, because days is checked for < 0 later
on:

if (days < 0) {
	year -= 1;
	days += 365 + LEAP_YEAR(year);
}

I think the correct fix would be to keep days signed and do an appropriate
cast later on.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lib.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-lib.c~rtc_time_to_tm-fix-signed-unsigned-arithmetic drivers/rtc/rtc-lib.c
--- a/drivers/rtc/rtc-lib.c~rtc_time_to_tm-fix-signed-unsigned-arithmetic
+++ a/drivers/rtc/rtc-lib.c
@@ -51,10 +51,11 @@ EXPORT_SYMBOL(rtc_year_days);
  */
 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-	unsigned int days, month, year;
+	unsigned int month, year;
+	int days;
 
 	days = time / 86400;
-	time -= days * 86400;
+	time -= (unsigned int) days * 86400;
 
 	/* day of the week, 1970-01-01 was a Thursday */
 	tm->tm_wday = (days + 4) % 7;
_

Patches currently in -mm which might be from jan.altenberg@linutronix.de are

rtc_time_to_tm-fix-signed-unsigned-arithmetic.patch

