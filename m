From: akpm@osdl.org
Subject: - hpt36x-pci-clock-detection-fix.patch removed from -mm tree
Date: Mon, 22 Jan 2007 13:11:14 -0800
Message-ID: <200701222111.l0MLBErH002234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbXAVVL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:11:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide: HPT36x PCI clock detection fix
has been removed from the -mm tree.  Its filename was
     hpt36x-pci-clock-detection-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: HPT36x PCI clock detection fix
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fix minor coding mistake in the HPT36x PCI clock detection code noticed by
Bartlomiej Zolnierkiewicz -- it always reported 33 MHz due to the missing
'break' statements.  This, however, most probably never mattered -- in fact, I
was thinking of removing the 25/40 MHz cases completely since HPT36x BIOSes
didn't seem to set any other value than 7 into the 'cmd_high_time' field, i.e.
 supported only 33 MHz PCI.

Note that in the original driver there was another bug: 25 and 40 MHz cases
were interchanged.  Since the 'cmd_high_time' field is in units of PCI clocks,
a lower clock count just *cannot* correspond to a higher frequency, i.  e.  it
should be 5 for 25 MHz PCI and 9 for 40 MHz PCI, not the other way around.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~hpt36x-pci-clock-detection-fix drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~hpt36x-pci-clock-detection-fix
+++ a/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.00	Jun 25, 2006
+ * linux/drivers/ide/pci/hpt366.c		Version 1.01	Dec 23, 2006
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -107,7 +107,8 @@
  *   frequency
  * - switch to using the  DPLL clock and enable UltraATA/133 mode by default on
  *   anything  newer than HPT370/A
- * - fold PCI clock detection and DPLL setup code into init_chipset_hpt366();
+ * - fold PCI clock detection and DPLL setup code into init_chipset_hpt366(),
+ *   also fixing the interchanged 25/40 MHz PCI clock cases for HPT36x chips;
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
  *   the register setting lists into the table indexed by the clock selected
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
@@ -1125,11 +1126,14 @@ static unsigned int __devinit init_chips
 		switch((itr1 >> 8) & 0x07) {
 			case 0x09:
 				pci_clk = 40;
+				break;
 			case 0x05:
 				pci_clk = 25;
+				break;
 			case 0x07:
 			default:
 				pci_clk = 33;
+				break;
 		}
 	}
 
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
