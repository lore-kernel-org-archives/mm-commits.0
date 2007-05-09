From: akpm@linux-foundation.org
Subject: - char-cyclades-timers-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:58:24 -0700
Message-ID: <200705090258.l492wOUd010292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968443AbXEIC61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, timers cleanup
has been removed from the -mm tree.  Its filename was
     char-cyclades-timers-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, timers cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-timers-cleanup drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-timers-cleanup
+++ a/drivers/char/cyclades.c
@@ -932,15 +932,9 @@ do_softint(struct work_struct *work)
 	if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event))
 		wake_up_interruptible(&info->open_wait);
 #ifdef CONFIG_CYZ_INTR
-	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event)) {
-		if (cyz_rx_full_timer[info->line].function == NULL) {
-			cyz_rx_full_timer[info->line].expires = jiffies + 1;
-			cyz_rx_full_timer[info->line].function = cyz_rx_restart;
-			cyz_rx_full_timer[info->line].data =
-						(unsigned long)info;
-			add_timer(&cyz_rx_full_timer[info->line]);
-		}
-	}
+	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event) &&
+			!timer_pending(&cyz_rx_full_timer[info->line]))
+		mod_timer(&cyz_rx_full_timer[info->line], jiffies + 1);
 #endif
 	if (test_and_clear_bit(Cy_EVENT_DELTA_WAKEUP, &info->event))
 		wake_up_interruptible(&info->delta_msr_wait);
@@ -1887,7 +1881,6 @@ static void cyz_rx_restart(unsigned long
 		printk(KERN_ERR "cyc:cyz_rx_restart retval on ttyC%d was %x\n",
 			info->line, retval);
 	}
-	cyz_rx_full_timer[info->line].function = NULL;
 	CY_UNLOCK(info, flags);
 }
 
@@ -4529,8 +4522,8 @@ static void __devinit cy_init_card(struc
 			else
 				info->xmit_fifo_size = 4 * CYZ_FIFO_SIZE;
 #ifdef CONFIG_CYZ_INTR
-			init_timer(&cyz_rx_full_timer[port]);
-			cyz_rx_full_timer[port].function = NULL;
+			setup_timer(&cyz_rx_full_timer[port],
+				cyz_rx_restart, (unsigned long)info);
 #endif
 		} else {
 			info->type = PORT_CIRRUS;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
