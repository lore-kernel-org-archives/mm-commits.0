From: akpm@linux-foundation.org
Subject: + fix-irq-flags-in-rtc-ds1511.patch added to -mm tree
Date: Thu, 01 May 2008 15:58:21 -0700
Message-ID: <200805012258.m41MwLmX029845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761696AbYEAW7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 18:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, a.zummo@towertech.it, david-b@pacbell.net, srostedt@redhat.com


The patch titled
     fix irq flags in rtc-ds1511
has been added to the -mm tree.  Its filename is
     fix-irq-flags-in-rtc-ds1511.patch

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
Subject: fix irq flags in rtc-ds1511
From: Steven Rostedt <rostedt@goodmis.org>

The file in drivers/rtc/rtc-ds1551.c uses "int" for flags.  This can cause
hard to find bugs on some architectures.  This patch converts the flags to use
"long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel where
checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1511.c~fix-irq-flags-in-rtc-ds1511 drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~fix-irq-flags-in-rtc-ds1511
+++ a/drivers/rtc/rtc-ds1511.c
@@ -184,7 +184,7 @@ ds1511_wdog_disable(void)
 static int ds1511_rtc_set_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	u8 mon, day, dow, hrs, min, sec, yrs, cen;
-	unsigned int flags;
+	unsigned long flags;
 
 	/*
 	 * won't have to change this for a while
@@ -247,7 +247,7 @@ static int ds1511_rtc_set_time(struct de
 static int ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	unsigned int century;
-	unsigned int flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&ds1511_lock, flags);
 	rtc_disable_update();
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
9p-use-correct-type-for-processor-flags.patch
fix-irq-flags-in-mac80211-code.patch
fix-irq-flags-in-saa7134.patch
fix-irq-flags-in-rtc-ds1511.patch
fix-irq-flags-for-iuu_phoenixc.patch
git-sched.patch

