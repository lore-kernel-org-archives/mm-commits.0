From: akpm@osdl.org
Subject: - char-sx-ifdef-isa-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:11 -0800
Message-ID: <200612082009.kB8K9BAq002676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbWLHUJV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, ifdef ISA code
has been removed from the -mm tree.  Its filename was
     char-sx-ifdef-isa-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, ifdef ISA code
From: Jiri Slaby <jirislaby@gmail.com>

Most users won't need old probe code -- make it depndent on CONFIG_(E)ISA.

Cc: <R.E.Wolff@BitWizard.nl>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/char/sx.c~char-sx-ifdef-isa-code drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-ifdef-isa-code
+++ a/drivers/char/sx.c
@@ -323,6 +323,8 @@ static int sx_slowpoll;
 
 static int sx_maxints = 100;
 
+#ifdef CONFIG_ISA
+
 /* These are the only open spaces in my computer. Yours may have more
    or less.... -- REW 
    duh: Card at 0xa0000 is possible on HP Netserver?? -- pvdl
@@ -337,13 +339,14 @@ static int si1_probe_addrs[]= { 0xd0000}
 #define NR_SI_ADDRS ARRAY_SIZE(si_probe_addrs)
 #define NR_SI1_ADDRS ARRAY_SIZE(si1_probe_addrs)
 
+module_param_array(sx_probe_addrs, int, NULL, 0);
+module_param_array(si_probe_addrs, int, NULL, 0);
+#endif
 
 /* Set the mask to all-ones. This alas, only supports 32 interrupts. 
    Some architectures may need more. */
 static int sx_irqmask = -1;
 
-module_param_array(sx_probe_addrs, int, NULL, 0);
-module_param_array(si_probe_addrs, int, NULL, 0);
 module_param(sx_poll, int, 0);
 module_param(sx_slowpoll, int, 0);
 module_param(sx_maxints, int, 0);
@@ -2118,7 +2121,7 @@ static int __devinit probe_sx (struct sx
 	return 1;
 }
 
-
+#if defined(CONFIG_ISA) || defined(CONFIG_EISA)
 
 /* Specialix probes for this card at 32k increments from 640k to 16M.
    I consider machines with less than 16M unlikely nowadays, so I'm
@@ -2213,6 +2216,7 @@ static int __devinit probe_si (struct sx
 	func_exit();
 	return 1;
 }
+#endif
 
 static const struct tty_operations sx_ops = {
 	.break_ctl = sx_break,
@@ -2576,9 +2580,12 @@ static int __init sx_init(void) 
 #ifdef CONFIG_EISA
 	int retval1;
 #endif
-	int retval, i;
-	int found = 0;
+#ifdef CONFIG_ISA
 	struct sx_board *board;
+	unsigned int i;
+#endif
+	unsigned int found = 0;
+	int retval;
 
 	func_enter();
 	sx_dprintk (SX_DEBUG_INIT, "Initing sx module... (sx_debug=%d)\n", sx_debug);
@@ -2593,7 +2600,7 @@ static int __init sx_init(void) 
 		printk(KERN_ERR "SX: Unable to register firmware loader driver.\n");
 		return -EIO;
 	}
-
+#ifdef CONFIG_ISA
 	for (i=0;i<NR_SX_ADDRS;i++) {
 		board = &boards[found];
 		board->hw_base = sx_probe_addrs[i];
@@ -2640,6 +2647,7 @@ static int __init sx_init(void) 
 			iounmap (board->base);
 		}
 	}
+#endif
 #ifdef CONFIG_EISA
 	retval1 = eisa_driver_register(&sx_eisadriver);
 #endif
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

