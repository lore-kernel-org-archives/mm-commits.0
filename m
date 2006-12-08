From: akpm@osdl.org
Subject: - char-isicom-check-kmalloc-retval.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:45 -0800
Message-ID: <200612082008.kB8K8jYR002636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58333 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946371AbWLHUJA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, check kmalloc retval
has been removed from the -mm tree.  Its filename was
     char-isicom-check-kmalloc-retval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, check kmalloc retval
From: Jiri Slaby <jirislaby@gmail.com>

Value returned from kamlloc may be NULL, we should check if ENOMEM occured.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/isicom.c~char-isicom-check-kmalloc-retval drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-check-kmalloc-retval
+++ a/drivers/char/isicom.c
@@ -1709,6 +1709,11 @@ static int __devinit load_firmware(struc
 		}
 
 		data = kmalloc(word_count * 2, GFP_KERNEL);
+		if (data == NULL) {
+			dev_err(&pdev->dev, "Card%d, firmware upload "
+				"failed, not enough memory\n", index + 1);
+			goto errrelfw;
+		}
 		inw(base);
 		insw(base, data, word_count);
 		InterruptTheCard(base);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-isicom-check-kmalloc-retval.patch
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

