From: akpm@linux-foundation.org
Subject: - rtc-m41t80-use-pr_info-as-appropriate.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:59 -0700
Message-ID: <200807242329.m6ONTxAD011432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856AbYGXXaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: m41t80: use pr_info() as appropriate
has been removed from the -mm tree.  Its filename was
     rtc-m41t80-use-pr_info-as-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: m41t80: use pr_info() as appropriate
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Replace printk(KERN_INFO ...) calls with appropriate pr_info(...)
equivalents.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Bigga <ab@mycable.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-use-pr_info-as-appropriate drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-use-pr_info-as-appropriate
+++ a/drivers/rtc/rtc-m41t80.c
@@ -631,14 +631,12 @@ static int wdt_ioctl(struct inode *inode
 			return -EFAULT;
 
 		if (rv & WDIOS_DISABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: disable watchdog\n");
+			pr_info("rtc-m41t80: disable watchdog\n");
 			wdt_disable();
 		}
 
 		if (rv & WDIOS_ENABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: enable watchdog\n");
+			pr_info("rtc-m41t80: enable watchdog\n");
 			wdt_ping();
 		}
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch

