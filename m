From: akpm@linux-foundation.org
Subject: - char-moxa-serialise-timer.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:20 -0700
Message-ID: <200805010929.m419TKP2030665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757135AbYEAJ3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, serialise timer
has been removed from the -mm tree.  Its filename was
     char-moxa-serialise-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, serialise timer
From: Jiri Slaby <jirislaby@gmail.com>

- del timer after we are sure it won't be fired again
- make timer scheduling atomic
- don't reschedule timer when all cards have gone

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-serialise-timer drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-serialise-timer
+++ a/drivers/char/moxa.c
@@ -846,10 +846,11 @@ static int moxa_init_board(struct moxa_b
 	if (ret)
 		goto err_free;
 
+	spin_lock_bh(&moxa_lock);
 	brd->ready = 1;
-
 	if (!timer_pending(&moxaTimer))
 		mod_timer(&moxaTimer, jiffies + HZ / 50);
+	spin_unlock_bh(&moxa_lock);
 
 	return 0;
 err_free:
@@ -1041,13 +1042,6 @@ static void __exit moxa_exit(void)
 {
 	int i;
 
-	del_timer_sync(&moxaTimer);
-
-	if (tty_unregister_driver(moxaDriver))
-		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
-				"serial driver\n");
-	put_tty_driver(moxaDriver);
-
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&moxa_pci_driver);
 #endif
@@ -1055,6 +1049,13 @@ static void __exit moxa_exit(void)
 	for (i = 0; i < MAX_BOARDS; i++) /* ISA boards */
 		if (moxa_boards[i].ready)
 			moxa_board_deinit(&moxa_boards[i]);
+
+	del_timer_sync(&moxaTimer);
+
+	if (tty_unregister_driver(moxaDriver))
+		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
+				"serial driver\n");
+	put_tty_driver(moxaDriver);
 }
 
 module_init(moxa_init);
@@ -1432,7 +1433,7 @@ static void moxa_poll(unsigned long igno
 {
 	struct moxa_board_conf *brd;
 	u16 __iomem *ip;
-	unsigned int card, port;
+	unsigned int card, port, served = 0;
 
 	spin_lock(&moxa_lock);
 	for (card = 0; card < MAX_BOARDS; card++) {
@@ -1440,6 +1441,8 @@ static void moxa_poll(unsigned long igno
 		if (!brd->ready)
 			continue;
 
+		served++;
+
 		ip = NULL;
 		if (readb(brd->intPend) == 0xff)
 			ip = brd->intTable + readb(brd->intNdx);
@@ -1460,9 +1463,10 @@ static void moxa_poll(unsigned long igno
 		}
 	}
 	moxaLowWaterChk = 0;
-	spin_unlock(&moxa_lock);
 
-	mod_timer(&moxaTimer, jiffies + HZ / 50);
+	if (served)
+		mod_timer(&moxaTimer, jiffies + HZ / 50);
+	spin_unlock(&moxa_lock);
 }
 
 /******************************************************************************/
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

