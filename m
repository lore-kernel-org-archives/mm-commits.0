From: akpm@linux-foundation.org
Subject: + rtc-efi-check-for-invalid-data-coming-back-from-uefi.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 16:01:21 -0700
Message-ID: <53a4bd41.QTvDXVe04D5BhVdz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaFTXBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 19:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rw@suse.de, jg1.han@samsung.com, jbeulich@suse.com, a.zummo@towertech.it, JBeulich@suse.com


The patch titled
     Subject: drivers/rtc/rtc-efi.c: check for invalid data coming back from UEFI
has been added to the -mm tree.  Its filename is
     rtc-efi-check-for-invalid-data-coming-back-from-uefi.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-efi-check-for-invalid-data-coming-back-from-uefi.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-efi-check-for-invalid-data-coming-back-from-uefi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: drivers/rtc/rtc-efi.c: check for invalid data coming back from UEFI

In particular seeing zero in eft->month is problematic, as it results in
-1 (converted to unsigned int, i.e.  yielding 0xffffffff) getting passed
to rtc_year_days(), where the value gets used as an array index (normally
resulting in a crash).  This was observed with the driver enabled on x86
on some Fujitsu system (with possibly not up to date firmware, but
anyway).

Perhaps efi_read_alarm() should not fail if neither enabled nor pending
are set, but the returned time is invalid?

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reported-by: Raymund Will <rw@suse.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-efi.c~rtc-efi-check-for-invalid-data-coming-back-from-uefi drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~rtc-efi-check-for-invalid-data-coming-back-from-uefi
+++ a/drivers/rtc/rtc-efi.c
@@ -17,6 +17,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/stringify.h>
 #include <linux/time.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
@@ -48,8 +49,8 @@ compute_wday(efi_time_t *eft)
 	int y;
 	int ndays = 0;
 
-	if (eft->year < 1998) {
-		pr_err("EFI year < 1998, invalid date\n");
+	if (eft->year < EFI_RTC_EPOCH) {
+		pr_err("EFI year < " __stringify(EFI_RTC_EPOCH) ", invalid date\n");
 		return -1;
 	}
 
@@ -78,19 +79,36 @@ convert_to_efi_time(struct rtc_time *wti
 	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
 }
 
-static void
+static bool
 convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 {
 	memset(wtime, 0, sizeof(*wtime));
+
+	if (eft->second >= 60)
+		return false;
 	wtime->tm_sec  = eft->second;
+
+	if (eft->minute >= 60)
+		return false;
 	wtime->tm_min  = eft->minute;
+
+	if (eft->hour >= 24)
+		return false;
 	wtime->tm_hour = eft->hour;
+
+	if (!eft->day || eft->day > 31)
+		return false;
 	wtime->tm_mday = eft->day;
+
+	if (!eft->month || eft->month > 12)
+		return false;
 	wtime->tm_mon  = eft->month - 1;
 	wtime->tm_year = eft->year - 1900;
 
 	/* day of the week [0-6], Sunday=0 */
 	wtime->tm_wday = compute_wday(eft);
+	if (wtime->tm_wday < 0)
+		return false;
 
 	/* day in the year [1-365]*/
 	wtime->tm_yday = compute_yday(eft);
@@ -106,6 +124,8 @@ convert_from_efi_time(efi_time_t *eft, s
 	default:
 		wtime->tm_isdst = -1;
 	}
+
+	return true;
 }
 
 static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
@@ -122,7 +142,8 @@ static int efi_read_alarm(struct device
 	if (status != EFI_SUCCESS)
 		return -EINVAL;
 
-	convert_from_efi_time(&eft, &wkalrm->time);
+	if (!convert_from_efi_time(&eft, &wkalrm->time))
+		return -EIO;
 
 	return rtc_valid_tm(&wkalrm->time);
 }
@@ -163,7 +184,8 @@ static int efi_read_time(struct device *
 		return -EINVAL;
 	}
 
-	convert_from_efi_time(&eft, tm);
+	if (!convert_from_efi_time(&eft, tm))
+		return -EIO;
 
 	return rtc_valid_tm(tm);
 }
_

Patches currently in -mm which might be from JBeulich@suse.com are

rtc-efi-check-for-invalid-data-coming-back-from-uefi.patch

