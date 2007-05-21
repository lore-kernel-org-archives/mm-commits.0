From: akpm@linux-foundation.org
Subject: + char-isicom-del_timer-at-exit.patch added to -mm tree
Date: Sun, 20 May 2007 21:19:52 -0700
Message-ID: <200705210419.l4L4JpS1002215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbXEUEVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:21:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, del_timer at exit
has been added to the -mm tree.  Its filename is
     char-isicom-del_timer-at-exit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-misc-phantom-move-to-unlocked_ioctl-fix.patch
misc-phantom-take-care-of-pci-posting.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
shrink_slab-handle-bad-shrinkers.patch
