From: akpm@linux-foundation.org
Subject: + rtc-ratelimit-lost-interrupts-message.patch added to -mm tree
Date: Thu, 24 May 2007 13:47:44 -0700
Message-ID: <200705242047.l4OKlioU002235@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbXEXUrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 16:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bcollins@ubuntu.com


The patch titled
     ] RTC: Ratelimit "lost interrupts" message
has been added to the -mm tree.  Its filename is
     rtc-ratelimit-lost-interrupts-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ] RTC: Ratelimit "lost interrupts" message
From: Ben Collins <bcollins@ubuntu.com>

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/rtc.c~rtc-ratelimit-lost-interrupts-message drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-ratelimit-lost-interrupts-message
+++ a/drivers/char/rtc.c
@@ -1159,7 +1159,8 @@ static void rtc_dropped_irq(unsigned lon
 
 	spin_unlock_irq(&rtc_lock);
 
-	printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
+	if (printk_ratelimit())
+		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
 
 	/* Now we have new data */
 	wake_up_interruptible(&rtc_wait);
_

Patches currently in -mm which might be from bcollins@ubuntu.com are

origin.patch
avoid-zero-size-allocation-in-cache_k8_northbridges.patch
cleanup-libata-hpa-support.patch
hciusb-initialize-the-broadcom-usb-bluetooth-device-in-dell-laptops.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
rtc-ratelimit-lost-interrupts-message.patch
