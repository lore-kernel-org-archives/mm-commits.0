From: akpm@linux-foundation.org
Subject: + rtc-fix-double-lock-on-uie-emulation.patch added to -mm tree
Date: Tue, 19 Aug 2008 13:15:59 -0700
Message-ID: <200808192015.m7JKFxop004192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbYHSUQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 16:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, rmk@arm.linux.org.uk


The patch titled
     rtc: fix double lock on UIE emulation
has been added to the -mm tree.  Its filename is
     rtc-fix-double-lock-on-uie-emulation.patch

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

rtc-fix-double-lock-on-uie-emulation.patch
cramfs-fix-named-pipe-handling.patch
linux-next.patch
rtc-file-close-consistently-disables-repeating-irqs.patch

