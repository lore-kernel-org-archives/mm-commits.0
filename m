From: akpm@linux-foundation.org
Subject: - rtc-tweak-driver-documentation-for-rtc-periodic.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:26 -0800
Message-ID: <200711152108.lAFL8QTU015360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765796AbXKOVIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     rtc: tweak driver documentation for rtc periodic
has been removed from the -mm tree.  Its filename was
     rtc-tweak-driver-documentation-for-rtc-periodic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: tweak driver documentation for rtc periodic
From: Mike Frysinger <vapier.adi@gmail.com>

The max_user_freq member is not really meant for RTC drivers to modify, so
update the rtc documentation so drivers writers know what is expected of
them when handling periodic events.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/rtc.txt~rtc-tweak-driver-documentation-for-rtc-periodic Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-tweak-driver-documentation-for-rtc-periodic
+++ a/Documentation/rtc.txt
@@ -180,9 +180,10 @@ driver returns ENOIOCTLCMD.  Some common
     *	RTC_IRQP_SET, RTC_IRQP_READ: the irq_set_freq function will be called
 	to set the frequency while the framework will handle the read for you
 	since the frequency is stored in the irq_freq member of the rtc_device
-	structure.  Also make sure you set the max_user_freq member in your
-	initialization routines so the framework can sanity check the user
-	input for you.
+	structure.  Your driver needs to initialize the irq_freq member during
+	init.  Make sure you check the requested frequency is in range of your
+	hardware in the irq_set_freq function.  If you cannot actually change
+	the frequency, just return -ENOTTY.
 
 If all else fails, check out the rtc-test.c driver!
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
git-watchdog.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-inclusions-of-linux-autoconfh.patch
