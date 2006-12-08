From: akpm@osdl.org
Subject: - char-isicom-fix-tty-index-check.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:57 -0800
Message-ID: <200612082008.kB8K8v4I002650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58344 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946295AbWLHUJC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, fix tty index check
has been removed from the -mm tree.  Its filename was
     char-isicom-fix-tty-index-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, fix tty index check
From: Jiri Slaby <jirislaby@gmail.com>

Since tty->index is signed and may be < 0, we should assign this to int not
uint.  There is already a check to ensure if it is not negative, but gcc
complains with -W flag enabled and it is perfectly correct:
drivers/char/isicom.c:953: warning: comparison of unsigned expression < 0
is always false

Fix this issue by converting `line' variable from uint to int.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-fix-tty-index-check drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-fix-tty-index-check
+++ a/drivers/char/isicom.c
@@ -946,8 +946,8 @@ static int isicom_open(struct tty_struct
 {
 	struct isi_port *port;
 	struct isi_board *card;
-	unsigned int line, board;
-	int error;
+	unsigned int board;
+	int error, line;
 
 	line = tty->index;
 	if (line < 0 || line > PORT_COUNT-1)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

