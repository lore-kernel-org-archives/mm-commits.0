From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:28:52 -0700
Message-ID: <53960af4.qNJaRYut4SBNK6Qz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaFIT2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlee@suse.com, a.zummo@towertech.it, joeyli.kernel@gmail.com

Subject: [merged] drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch removed from -mm tree
To: joeyli.kernel@gmail.com,a.zummo@towertech.it,jlee@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:28:52 -0700


The patch titled
     Subject: drivers/rtc/rtc-efi.c: avoid subtracting day twice when computing year days
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: drivers/rtc/rtc-efi.c: avoid subtracting day twice when computing year days

Compared source code of rtc-lib.c::rtc_year_days() with
efirtc.c::rtc_year_days(), found the code in rtc-efi decreases value of
day twice when it computing year days.  rtc-lib.c::rtc_year_days() has
already decrease days and return the year days from 0 to 365.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-efi.c~drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days
+++ a/drivers/rtc/rtc-efi.c
@@ -35,7 +35,7 @@ static inline int
 compute_yday(efi_time_t *eft)
 {
 	/* efi_time_t.month is in the [1-12] so, we need -1 */
-	return rtc_year_days(eft->day - 1, eft->month - 1, eft->year);
+	return rtc_year_days(eft->day, eft->month - 1, eft->year);
 }
 /*
  * returns day of the week [0-6] 0=Sunday
_

Patches currently in -mm which might be from joeyli.kernel@gmail.com are

origin.patch

