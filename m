From: akpm@linux-foundation.org
Subject: - rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:54 -0700
Message-ID: <200805132133.m4DLXsY0000863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759777AbYEMVea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, a.zummo@towertech.it, david-b@pacbell.net, dmitri.vorobiev@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc_time_to_tm: use unsigned arithmetic
has been removed from the -mm tree.  Its filename was
     rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: remove old-fashioned `register' keyword]
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
+	unsigned int days, month, year;
 
 	days = time / 86400;
 	time -= days * 86400;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-make-the-rtc-sync-mode-11-minute-again.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

