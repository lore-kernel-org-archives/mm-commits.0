From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch added to -mm tree
Date: Mon, 21 Apr 2014 13:11:07 -0700
Message-ID: <53557b5b.glllVdfdwIItkNkt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDUULI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlee@suse.com, a.zummo@towertech.it, joeyli.kernel@gmail.com

Subject: + drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch added to -mm tree
To: joeyli.kernel@gmail.com,a.zummo@towertech.it,jlee@suse.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:11:07 -0700


The patch titled
     Subject: drivers/rtc/rtc-efi.c: avoid subtracting day twice when computing year days
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-rtc-rtc-efic-avoid-subtracting-day-twice-when-computing-year-days.patch

