From: akpm@osdl.org
Subject: - char-sx-use-kcalloc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:02 -0800
Message-ID: <200612082009.kB8K92il002660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946220AbWLHUJM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, use kcalloc
has been removed from the -mm tree.  Its filename was
     char-sx-use-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, use kcalloc
From: Jiri Slaby <jirislaby@gmail.com>

Convert self-implemented kzalloc to kernel kcalloc.

Cc: <R.E.Wolff@BitWizard.nl>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/char/sx.c~char-sx-use-kcalloc drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-use-kcalloc
+++ a/drivers/char/sx.c
@@ -2267,18 +2267,6 @@ static int sx_init_drivers(void)
 	return 0;
 }
 
-
-static void * ckmalloc (int size)
-{
-	void *p;
-
-	p = kmalloc(size, GFP_KERNEL);
-	if (p) 
-		memset(p, 0, size);
-	return p;
-}
-
-
 static int sx_init_portstructs (int nboards, int nports)
 {
 	struct sx_board *board;
@@ -2291,7 +2279,7 @@ static int sx_init_portstructs (int nboa
 
 	/* Many drivers statically allocate the maximum number of ports
 	   There is no reason not to allocate them dynamically. Is there? -- REW */
-	sx_ports          = ckmalloc(nports * sizeof (struct sx_port));
+	sx_ports = kcalloc(nports, sizeof(struct sx_port), GFP_KERNEL);
 	if (!sx_ports)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

