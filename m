From: akpm@osdl.org
Subject: - char-isicom-use-completion.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:48 -0800
Message-ID: <200612082008.kB8K8mAL002639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946270AbWLHUI5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, use completion
has been removed from the -mm tree.  Its filename was
     char-isicom-use-completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, use completion
From: Jiri Slaby <jirislaby@gmail.com>

Use wait_for_completion+complete instead of variables+msleep hack.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-use-completion drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-use-completion
+++ a/drivers/char/isicom.c
@@ -172,6 +172,7 @@ static struct pci_driver isicom_driver =
 static int prev_card = 3;	/*	start servicing isi_card[0]	*/
 static struct tty_driver *isicom_normal;
 
+static DECLARE_COMPLETION(isi_timerdone);
 static struct timer_list tx;
 static char re_schedule = 1;
 
@@ -514,7 +515,7 @@ static void isicom_tx(unsigned long _dat
 	/*	schedule another tx for hopefully in about 10ms	*/
 sched_again:
 	if (!re_schedule) {
-		re_schedule = 2;
+		complete(&isi_timerdone);
  		return;
 	}
 
@@ -1924,12 +1925,9 @@ error:
 
 static void __exit isicom_exit(void)
 {
-	unsigned int index = 0;
-
 	re_schedule = 0;
 
-	while (re_schedule != 2 && index++ < 100)
-		msleep(10);
+	wait_for_completion_timeout(&isi_timerdone, HZ);
 
 	pci_unregister_driver(&isicom_driver);
 	tty_unregister_driver(isicom_normal);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-isicom-use-completion.patch
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

