From: akpm@linux-foundation.org
Subject: - rtc-ratelimit-lost-interrupts-message.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:32 -0700
Message-ID: <200707162054.l6GKsW58001832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370AbXGPVSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcollins@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     RTC: Ratelimit "lost interrupts" message
has been removed from the -mm tree.  Its filename was
     rtc-ratelimit-lost-interrupts-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTC: Ratelimit "lost interrupts" message
From: Ben Collins <bcollins@ubuntu.com>

We gets lots of these when the kernel is running on a hypervisor.  Zach says
"a guest kernel trying to get high frequency RTC will also be inaccurate, and
inevitably will have unhidable interrupt lateness."

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
pm-do-not-require-dev-spew-to-get-pm_debug.patch
