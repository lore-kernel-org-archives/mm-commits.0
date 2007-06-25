From: akpm@linux-foundation.org
Subject: - char-stallion-fix-oops-during-init-with-isa-cards.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:01 -0700
Message-ID: <200706250921.l5P9L180031065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbXFYJVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ml@akana.de, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, fix oops during init with ISA cards
has been removed from the -mm tree.  Its filename was
     char-stallion-fix-oops-during-init-with-isa-cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, fix oops during init with ISA cards
From: Ingo Korb <ml@akana.de>

The stallion driver oopses while initializing ISA cards due to an
uninitialized variable.  This patch changes the initialisation order to
match the PCI code path.

Signed-off-by: Ingo Korb <ml@akana.de>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-fix-oops-during-init-with-isa-cards drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-fix-oops-during-init-with-isa-cards
+++ a/drivers/char/stallion.c
@@ -4753,13 +4753,14 @@ static int __init stallion_module_init(v
 		brdp->ioaddr2 = conf.ioaddr2;
 		brdp->irq = conf.irq;
 		brdp->irqtype = conf.irqtype;
-		if (stl_brdinit(brdp))
+		stl_brds[brdp->brdnr] = brdp;
+		if (stl_brdinit(brdp)) {
+			stl_brds[brdp->brdnr] = NULL;
 			kfree(brdp);
-		else {
+		} else {
 			for (j = 0; j < brdp->nrports; j++)
 				tty_register_device(stl_serial,
 					brdp->brdnr * STL_MAXPORTS + j, NULL);
-			stl_brds[brdp->brdnr] = brdp;
 			stl_nrbrds = i + 1;
 		}
 	}
_

Patches currently in -mm which might be from ml@akana.de are

char-istallion-initlocking-fixes-try-2.patch
