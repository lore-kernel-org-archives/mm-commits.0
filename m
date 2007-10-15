From: akpm@linux-foundation.org
Subject: + rtc-allow-validated-rtc_pie_on-for-non-root.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:13:22 -0700
Message-ID: <200710151913.l9FJDMZQ020390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575AbXJOTOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan@kadzban.is-a-geek.net, alessandro.zummo@towertech.it, bryan@kdzbn.homelinux.net, david-b@pacbell.net


The patch titled
     rtc: allow validated RTC_PIE_ON for non-root
has been added to the -mm tree.  Its filename is
     rtc-allow-validated-rtc_pie_on-for-non-root.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-allow-validated-rtc_pie_on-for-non-root.patch
