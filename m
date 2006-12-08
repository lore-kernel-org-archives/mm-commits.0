From: akpm@osdl.org
Subject: - char-sx-fix-return-in-module-init.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:25 -0800
Message-ID: <200612082009.kB8K9PVJ002700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946254AbWLHUJ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, fix return in module init
has been removed from the -mm tree.  Its filename was
     char-sx-fix-return-in-module-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, fix return in module init
From: Jiri Slaby <jirislaby@gmail.com>

If pci_register_driver fails, but eisa_driver_register doesn't, we don't call
misc_deregister, but returns error.  Return OK in such cases.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/sx.c~char-sx-fix-return-in-module-init drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-fix-return-in-module-init
+++ a/drivers/char/sx.c
@@ -2791,6 +2791,7 @@ static int __init sx_init(void)
 		retval = 0;
 	} else if (retval) {
 #ifdef CONFIG_EISA
+		retval = retval1;
 		if (retval1)
 #endif
 			misc_deregister(&sx_fw_device);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

