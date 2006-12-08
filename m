From: akpm@osdl.org
Subject: - char-isicom-simplify-timer.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:51 -0800
Message-ID: <200612082008.kB8K8pNf002642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946304AbWLHUI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, simplify timer
has been removed from the -mm tree.  Its filename was
     char-isicom-simplify-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, simplify timer
From: Jiri Slaby <jirislaby@gmail.com>

Don't init timer in such complicated way. Use DEFINE_TIMER and then only
mod_timer to reset the expiration.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-simplify-timer drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-simplify-timer
+++ a/drivers/char/isicom.c
@@ -173,12 +173,13 @@ static int prev_card = 3;	/*	start servi
 static struct tty_driver *isicom_normal;
 
 static DECLARE_COMPLETION(isi_timerdone);
-static struct timer_list tx;
 static char re_schedule = 1;
 
 static void isicom_tx(unsigned long _data);
 static void isicom_start(struct tty_struct *tty);
 
+static DEFINE_TIMER(tx, isicom_tx, 0, 0);
+
 /*   baud index mappings from linux defns to isi */
 
 static signed char linuxb_to_isib[] = {
@@ -519,13 +520,7 @@ sched_again:
  		return;
 	}
 
-	init_timer(&tx);
-	tx.expires = jiffies + HZ/100;
-	tx.data = 0;
-	tx.function = isicom_tx;
-	add_timer(&tx);
-
-	return;
+	mod_timer(&tx, jiffies + msecs_to_jiffies(10));
 }
 
 /* 	Interrupt handlers 	*/
@@ -1907,12 +1902,7 @@ static int __init isicom_init(void)
 		goto err_unrtty;
 	}
 
-	init_timer(&tx);
-	tx.expires = jiffies + 1;
-	tx.data = 0;
-	tx.function = isicom_tx;
-	re_schedule = 1;
-	add_timer(&tx);
+	mod_timer(&tx, jiffies + 1);
 
 	return 0;
 err_unrtty:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

