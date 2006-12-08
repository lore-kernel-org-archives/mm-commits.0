From: akpm@osdl.org
Subject: - char-istallion-free-only-isa.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:18 -0800
Message-ID: <200612082010.kB8KAIdT002793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946478AbWLHUKX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, free only isa
has been removed from the -mm tree.  Its filename was
     char-istallion-free-only-isa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, free only isa
From: Jiri Slaby <jirislaby@gmail.com>

Only ISA cards should be freed in module exit.  Pci probed are freed in
pci_remove.  Define a flag, where we store this info a what to check against.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/istallion.c~char-istallion-free-only-isa drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-free-only-isa
+++ a/drivers/char/istallion.c
@@ -202,6 +202,7 @@ static int		stli_shared;
  */
 #define	BST_FOUND	0x1
 #define	BST_STARTED	0x2
+#define	BST_PROBED	0x4
 
 /*
  *	Define the set of port state flags. These are marked for internal
@@ -791,7 +792,7 @@ static void __exit istallion_module_exit
 	kfree(stli_txcookbuf);
 
 	for (j = 0; (j < stli_nrbrds); j++) {
-		if ((brdp = stli_brds[j]) == NULL)
+		if ((brdp = stli_brds[j]) == NULL || (brdp->state & BST_PROBED))
 			continue;
 
 		stli_cleanup_ports(brdp);
@@ -3956,6 +3957,7 @@ static int __devinit stli_pciprobe(struc
 	if (retval)
 		goto err_null;
 
+	brdp->state |= BST_PROBED;
 	pci_set_drvdata(pdev, brdp);
 
 	return 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

