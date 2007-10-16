From: akpm@linux-foundation.org
Subject: - rtc-allow-validated-rtc_pie_on-for-non-root.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:38 -0700
Message-ID: <200710162041.l9GKfcRh015808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934094AbXJPVb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan@kadzban.is-a-geek.net, alessandro.zummo@towertech.it, bryan@kdzbn.homelinux.net, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: allow validated RTC_PIE_ON for non-root
has been removed from the -mm tree.  Its filename was
     rtc-allow-validated-rtc_pie_on-for-non-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: allow validated RTC_PIE_ON for non-root
From: Bryan Kadzban <bryan@kadzban.is-a-geek.net>

drivers/char/rtc.c allowed RTC_PIE_ON ioctls for non-root users, as long as
the current interval (set via RTC_IRQP_SET) is <= max_user_freq.  Allow
RTC_PIE_ON under the same conditions when /dev/rtc* is handled by the rtc
subsystem.

Signed-off-by: Bryan Kadzban <bryan@kdzbn.homelinux.net>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-dev.c~rtc-allow-validated-rtc_pie_on-for-non-root drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-allow-validated-rtc_pie_on-for-non-root
+++ a/drivers/rtc/rtc-dev.c
@@ -233,7 +233,8 @@ static int rtc_dev_ioctl(struct inode *i
 		break;
 
 	case RTC_PIE_ON:
-		if (!capable(CAP_SYS_RESOURCE))
+		if (rtc->irq_freq > rtc->max_user_freq &&
+				!capable(CAP_SYS_RESOURCE))
 			return -EACCES;
 		break;
 	}
_

Patches currently in -mm which might be from bryan@kadzban.is-a-geek.net are

origin.patch
