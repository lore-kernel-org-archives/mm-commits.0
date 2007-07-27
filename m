From: akpm@linux-foundation.org
Subject: + rtc-dev-make-rtc-driver-return-enotty.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:31:13 -0700
Message-ID: <200707270431.l6R4VDAI005379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663AbXG0Eb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.hommel@gefanuc.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-dev: Make RTC driver return ENOTTY instead of ENOIOCTLCMD
has been added to the -mm tree.  Its filename is
     rtc-dev-make-rtc-driver-return-enotty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-dev: Make RTC driver return ENOTTY instead of ENOIOCTLCMD
From: Thomas Hommel <thomas.hommel@gefanuc.com>

Prevent the RTC driver from returning ENOIOCTLCMD to userspace.

Signed-off-by: Thomas Hommel <thomas.hommel@gefanuc.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-dev.c~rtc-dev-make-rtc-driver-return-enotty drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-dev-make-rtc-driver-return-enotty
+++ a/drivers/rtc/rtc-dev.c
@@ -348,6 +348,8 @@ static int rtc_dev_ioctl(struct inode *i
 	case RTC_IRQP_SET:
 		if (ops->irq_set_freq)
 			err = rtc_irq_set_freq(rtc, rtc->irq_task, arg);
+		else
+			err = -ENOTTY;
 		break;
 
 #if 0
_

Patches currently in -mm which might be from thomas.hommel@gefanuc.com are

rtc-dev-make-rtc-driver-return-enotty.patch
