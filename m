From: akpm@linux-foundation.org
Subject: - rtc-dev-make-rtc-driver-return-enotty.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:46 -0700
Message-ID: <200707312354.l6VNskqk029173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759101AbXGaXzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.hommel@gefanuc.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-dev: Make RTC driver return ENOTTY instead of ENOIOCTLCMD
has been removed from the -mm tree.  Its filename was
     rtc-dev-make-rtc-driver-return-enotty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
