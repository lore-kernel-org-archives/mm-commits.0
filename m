From: akpm@linux-foundation.org
Subject: - fix-irq-flags-in-rtc-ds1511.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:22 -0700
Message-ID: <200805092146.m49LkM8e027103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbYEIVrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, a.zummo@towertech.it, david-b@pacbell.net, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix irq flags in rtc-ds1511
has been removed from the -mm tree.  Its filename was
     fix-irq-flags-in-rtc-ds1511.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
git-v9fs.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch

