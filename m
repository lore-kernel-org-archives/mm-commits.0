From: akpm@linux-foundation.org
Subject: + rtc-tweak-driver-documentation-for-rtc-periodic.patch added to -mm tree
Date: Fri, 09 Nov 2007 12:53:13 -0800
Message-ID: <200711092053.lA9KrDE8031399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbXKIUx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 15:53:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, vapier@gentoo.org


The patch titled
     rtc: tweak driver documentation for rtc periodic
has been added to the -mm tree.  Its filename is
     rtc-tweak-driver-documentation-for-rtc-periodic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-tweak-driver-documentation-for-rtc-periodic.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-inclusions-of-linux-autoconfh.patch
