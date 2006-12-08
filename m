From: akpm@osdl.org
Subject: - char-isicom-remove-cvs-stuff.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:54 -0800
Message-ID: <200612082008.kB8K8sUp002646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58339 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946372AbWLHUJA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, remove cvs stuff
has been removed from the -mm tree.  Its filename was
     char-isicom-remove-cvs-stuff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, remove cvs stuff
From: Jiri Slaby <jirislaby@gmail.com>

We don't need RCS_ID & co. Extract them from the code and define only one
macro -- SX_VERSION.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/char/sx.c~char-isicom-remove-cvs-stuff drivers/char/sx.c
--- a/drivers/char/sx.c~char-isicom-remove-cvs-stuff
+++ a/drivers/char/sx.c
@@ -32,7 +32,6 @@
  *      USA.
  *
  * Revision history:
- * $Log: sx.c,v $
  * Revision 1.33  2000/03/09 10:00:00  pvdl,wolff
  * - Fixed module and port counting
  * - Fixed signal handling
@@ -199,9 +198,7 @@
  *
  * */
 
-
-#define RCS_ID "$Id: sx.c,v 1.33 2000/03/08 10:01:02 wolff, pvdl Exp $"
-#define RCS_REV "$Revision: 1.33 $"
+#define SX_VERSION	1.33
 
 #include <linux/module.h>
 #include <linux/kdev_t.h>
@@ -2052,7 +2049,7 @@ static void printheader(void)
 	if (!header_printed) {
 		printk (KERN_INFO "Specialix SX driver "
 		        "(C) 1998/1999 R.E.Wolff@BitWizard.nl \n");
-		printk (KERN_INFO "sx: version %s\n", RCS_ID);
+		printk (KERN_INFO "sx: version " __stringify(SX_VERSION) "\n");
 		header_printed = 1;
 	}
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

