From: akpm@linux-foundation.org
Subject: - isdn-spinlock-initializer-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:29 -0700
Message-ID: <200705090253.l492rTGb009704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032229AbXEICxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN: Spinlock initializer cleanup
has been removed from the -mm tree.  Its filename was
     isdn-spinlock-initializer-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN: Spinlock initializer cleanup
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/boardergo.c   |    2 +-
 drivers/isdn/isdnloop/isdnloop.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/hysdn/boardergo.c~isdn-spinlock-initializer-cleanup drivers/isdn/hysdn/boardergo.c
--- a/drivers/isdn/hysdn/boardergo.c~isdn-spinlock-initializer-cleanup
+++ a/drivers/isdn/hysdn/boardergo.c
@@ -443,7 +443,7 @@ ergo_inithardware(hysdn_card * card)
 	card->waitpofready = ergo_waitpofready;
 	card->set_errlog_state = ergo_set_errlog_state;
 	INIT_WORK(&card->irq_queue, ergo_irq_bh);
-	card->hysdn_lock = SPIN_LOCK_UNLOCKED;
+	spin_lock_init(&card->hysdn_lock);
 
 	return (0);
 }				/* ergo_inithardware */
diff -puN drivers/isdn/isdnloop/isdnloop.c~isdn-spinlock-initializer-cleanup drivers/isdn/isdnloop/isdnloop.c
--- a/drivers/isdn/isdnloop/isdnloop.c~isdn-spinlock-initializer-cleanup
+++ a/drivers/isdn/isdnloop/isdnloop.c
@@ -1462,7 +1462,7 @@ isdnloop_initcard(char *id)
 		skb_queue_head_init(&card->bqueue[i]);
 	}
 	skb_queue_head_init(&card->dqueue);
-	card->isdnloop_lock = SPIN_LOCK_UNLOCKED;
+	spin_lock_init(&card->isdnloop_lock);
 	card->next = cards;
 	cards = card;
 	if (!register_isdn(&card->interface)) {
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
arm-spinlock-initializer-cleanup.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
git-ieee1394.patch
git-mtd.patch
s390-spinlock-initializer-cleanup.patch
fix-printk-format-warnings-in-timer_listc.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
declare-struct-ktime.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic-updated-version.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
