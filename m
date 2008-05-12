From: akpm@linux-foundation.org
Subject: + rtc-m41t80-use-pr_info-as-appropriate.patch added to -mm tree
Date: Mon, 12 May 2008 16:13:23 -0700
Message-ID: <200805122313.m4CNDNKD013962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYELXON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:14:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net


The patch titled
     rtc: m41t80: use pr_info() as appropriate
has been added to the -mm tree.  Its filename is
     rtc-m41t80-use-pr_info-as-appropriate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -630,14 +630,12 @@ static int wdt_ioctl(struct inode *inode
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
rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch
rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch
rtc-m41t80-include-linux-kernelh-for-printk.patch
linux-next.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

