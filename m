From: akpm@linux-foundation.org
Subject: + char-stallion-fix-oops-during-init-with-isa-cards.patch added to -mm tree
Date: Tue, 19 Jun 2007 15:17:18 -0700
Message-ID: <200706192217.l5JMHI2G022503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbXFSWSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 18:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ml@akana.de, jirislaby@gmail.com


The patch titled
     Char: stallion, fix oops during init with ISA cards
has been added to the -mm tree.  Its filename is
     char-stallion-fix-oops-during-init-with-isa-cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+), 3 deletions(-)

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

char-stallion-fix-oops-during-init-with-isa-cards.patch
char-istallion-initlocking-fixes-try-2.patch
