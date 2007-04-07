From: akpm@linux-foundation.org
Subject: + char-cyclades-timer-cleanup.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:14:18 -0700
Message-ID: <200704070014.l370EINg023456@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573AbXDGAOV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:14:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, timer cleanup
has been added to the -mm tree.  Its filename is
     char-cyclades-timer-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, timer cleanup
From: Jiri Slaby <jirislaby@gmail.com>

cyclades, timer cleanup

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-timer-cleanup drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-timer-cleanup
+++ a/drivers/char/cyclades.c
@@ -851,7 +851,6 @@ static void cyz_poll(unsigned long);
 /* The Cyclades-Z polling cycle is defined by this variable */
 static long cyz_polling_cycle = CZ_DEF_POLL;
 
-static int cyz_timeron = 0;
 static DEFINE_TIMER(cyz_timerlist, cyz_poll, 0, 0);
 
 #else				/* CONFIG_CYZ_INTR */
@@ -1906,9 +1905,9 @@ static void cyz_poll(unsigned long arg)
 	static volatile struct BOARD_CTRL *board_ctrl;
 	static volatile struct CH_CTRL *ch_ctrl;
 	static volatile struct BUF_CTRL *buf_ctrl;
+	unsigned long expires = jiffies + HZ;
 	int card, port;
 
-	cyz_timerlist.expires = jiffies + (HZ);
 	for (card = 0; card < NR_CARDS; card++) {
 		cinfo = &cy_card[card];
 
@@ -1942,9 +1941,9 @@ static void cyz_poll(unsigned long arg)
 			cyz_handle_tx(info, ch_ctrl, buf_ctrl);
 		}
 		/* poll every 'cyz_polling_cycle' period */
-		cyz_timerlist.expires = jiffies + cyz_polling_cycle;
+		expires = jiffies + cyz_polling_cycle;
 	}
-	add_timer(&cyz_timerlist);
+	mod_timer(&cyz_timerlist, expires);
 }				/* cyz_poll */
 
 #endif				/* CONFIG_CYZ_INTR */
@@ -5504,10 +5503,8 @@ static int __init cy_init(void)
 	}
 
 #ifndef CONFIG_CYZ_INTR
-	if (number_z_boards && !cyz_timeron) {
-		cyz_timeron++;
-		cyz_timerlist.expires = jiffies + 1;
-		add_timer(&cyz_timerlist);
+	if (number_z_boards) {
+		mod_timer(&cyz_timerlist, jiffies + 1);
 #ifdef CY_PCI_DEBUG
 		printk("Cyclades-Z polling initialized\n");
 #endif
@@ -5523,10 +5520,7 @@ static void __exit cy_cleanup_module(voi
 	int i, e1;
 
 #ifndef CONFIG_CYZ_INTR
-	if (cyz_timeron){
-		cyz_timeron = 0;
-		del_timer(&cyz_timerlist);
-	}
+	del_timer_sync(&cyz_timerlist);
 #endif /* CONFIG_CYZ_INTR */
 
 	if ((e1 = tty_unregister_driver(cy_serial_driver)))
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
shrink_slab-handle-bad-shrinkers.patch
