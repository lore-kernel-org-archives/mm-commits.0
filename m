From: akpm@osdl.org
Subject: - char-istallion-fix-enabling.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:22 -0800
Message-ID: <200612082010.kB8KAM2F002802@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58770 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946254AbWLHUK0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, fix enabling
has been removed from the -mm tree.  Its filename was
     char-istallion-fix-enabling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, fix enabling
From: Jiri Slaby <jirislaby@gmail.com>

Enable ISA cards before pci_register_driver and then, enable each PCI card in
probe function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-fix-enabling drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-fix-enabling
+++ a/drivers/char/istallion.c
@@ -3968,6 +3968,10 @@ static int __devinit stli_pciprobe(struc
 	brdp->state |= BST_PROBED;
 	pci_set_drvdata(pdev, brdp);
 
+	EBRDENABLE(brdp);
+	brdp->enable = NULL;
+	brdp->disable = NULL;
+
 	return 0;
 err_null:
 	stli_brds[brdp->brdnr] = NULL;
@@ -4054,13 +4058,6 @@ static int stli_initbrds(void)
 	if (retval > 0)
 		found += retval;
 
-	retval = pci_register_driver(&stli_pcidriver);
-	if (retval && found == 0) {
-		printk(KERN_ERR "Neither isa nor eisa cards found nor pci "
-				"driver can be registered!\n");
-		goto err;
-	}
-
 /*
  *	All found boards are initialized. Now for a little optimization, if
  *	no boards are sharing the "shared memory" regions then we can just
@@ -4099,6 +4096,13 @@ static int stli_initbrds(void)
 		}
 	}
 
+	retval = pci_register_driver(&stli_pcidriver);
+	if (retval && found == 0) {
+		printk(KERN_ERR "Neither isa nor eisa cards found nor pci "
+				"driver can be registered!\n");
+		goto err;
+	}
+
 	return 0;
 err:
 	return retval;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

