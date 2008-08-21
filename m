From: akpm@linux-foundation.org
Subject: - rtc-fix-double-lock-on-uie-emulation.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:28 -0700
Message-ID: <200808210349.m7L3nShU015641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876AbYHUDty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, rjw@sisk.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     rtc: fix double lock on UIE emulation
has been removed from the -mm tree.  Its filename was
     rtc-fix-double-lock-on-uie-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix double lock on UIE emulation
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
		
With commit 5ad31a575157147b43fa84ef1e21471661653878 ("rtc: remove BKL
for ioctl()"), RTC_UIE_ON ioctl cause double lock on rtc->ops_lock.
The ops_lock must not be held while set_uie() calls rtc_read_time()
which takes the lock.  Also clear_uie() does not need ops_lock.  This
patch fixes return value of RTC_UIE_OFF ioctl too.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-dev.c~rtc-fix-double-lock-on-uie-emulation drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-fix-double-lock-on-uie-emulation
+++ a/drivers/rtc/rtc-dev.c
@@ -403,11 +403,14 @@ static long rtc_dev_ioctl(struct file *f
 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	case RTC_UIE_OFF:
+		mutex_unlock(&rtc->ops_lock);
 		clear_uie(rtc);
-		break;
+		return 0;
 
 	case RTC_UIE_ON:
+		mutex_unlock(&rtc->ops_lock);
 		err = set_uie(rtc);
+		return err;
 #endif
 	default:
 		err = -ENOTTY;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
rtc-file-close-consistently-disables-repeating-irqs.patch

