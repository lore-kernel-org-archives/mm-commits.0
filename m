From: akpm@linux-foundation.org
Subject: - char-isicom-del_timer-at-exit.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:17 -0700
Message-ID: <200707172306.l6HN6HCL012000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947AbXGQXPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, del_timer at exit
has been removed from the -mm tree.  Its filename was
     char-isicom-del_timer-at-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, del_timer at exit
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-del_timer-at-exit drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-del_timer-at-exit
+++ a/drivers/char/isicom.c
@@ -171,9 +171,6 @@ static struct pci_driver isicom_driver =
 static int prev_card = 3;	/*	start servicing isi_card[0]	*/
 static struct tty_driver *isicom_normal;
 
-static DECLARE_COMPLETION(isi_timerdone);
-static char re_schedule = 1;
-
 static void isicom_tx(unsigned long _data);
 static void isicom_start(struct tty_struct *tty);
 
@@ -502,11 +499,6 @@ unlock:
 	spin_unlock_irqrestore(&isi_card[card].card_lock, flags);
 	/*	schedule another tx for hopefully in about 10ms	*/
 sched_again:
-	if (!re_schedule) {
-		complete(&isi_timerdone);
- 		return;
-	}
-
 	mod_timer(&tx, jiffies + msecs_to_jiffies(10));
 }
 
@@ -1890,9 +1882,7 @@ error:
 
 static void __exit isicom_exit(void)
 {
-	re_schedule = 0;
-
-	wait_for_completion_timeout(&isi_timerdone, HZ);
+	del_timer_sync(&tx);
 
 	pci_unregister_driver(&isicom_driver);
 	tty_unregister_driver(isicom_normal);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
