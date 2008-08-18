From: akpm@linux-foundation.org
Subject: + char-sx-remove-bogus-iomap.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:44:53 -0700
Message-ID: <200808182144.m7ILirur014398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126AbYHRVuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: sx, remove bogus iomap
has been added to the -mm tree.  Its filename is
     char-sx-remove-bogus-iomap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: sx, remove bogus iomap
From: Jiri Slaby <jirislaby@gmail.com>

readl/writel are not expected to accept iomap return value. Replace
bogus mapping by standard ioremap.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <R.E.Wolff@BitWizard.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/sx.c~char-sx-remove-bogus-iomap drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-remove-bogus-iomap
+++ a/drivers/char/sx.c
@@ -2504,7 +2504,7 @@ static void __devexit sx_remove_card(str
 		del_timer(&board->timer);
 		if (pdev) {
 #ifdef CONFIG_PCI
-			pci_iounmap(pdev, board->base2);
+			iounmap(board->base2);
 			pci_release_region(pdev, IS_CF_BOARD(board) ? 3 : 2);
 #endif
 		} else {
@@ -2677,7 +2677,7 @@ static int __devinit sx_pci_probe(struct
 	}
 	board->hw_base = pci_resource_start(pdev, reg);
 	board->base2 =
-	board->base = pci_iomap(pdev, reg, WINDOW_LEN(board));
+	board->base = ioremap_nocache(board->hw_base, WINDOW_LEN(board));
 	if (!board->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		goto err_reg;
@@ -2703,7 +2703,7 @@ static int __devinit sx_pci_probe(struct
 
 	return 0;
 err_unmap:
-	pci_iounmap(pdev, board->base2);
+	iounmap(board->base2);
 err_reg:
 	pci_release_region(pdev, reg);
 err_flag:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
ath5k-unify-resets.patch
char-cyclades-remove-bogus-iomap.patch
char-sx-fix-io-unmapping.patch
char-sx-remove-bogus-iomap.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

