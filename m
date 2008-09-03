From: akpm@linux-foundation.org
Subject: - rtc_time_to_tm-fix-signed-unsigned-arithmetic.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:52 -0700
Message-ID: <200809031611.m83GBqux023803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYICQMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.altenberg@linutronix.de, a.zummo@towertech.it, david-b@pacbell.net, dmitri.vorobiev@gmail.com, macro@linux-mips.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc_time_to_tm: fix signed/unsigned arithmetic
has been removed from the -mm tree.  Its filename was
     rtc_time_to_tm-fix-signed-unsigned-arithmetic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc_time_to_tm: fix signed/unsigned arithmetic
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

origin.patch

