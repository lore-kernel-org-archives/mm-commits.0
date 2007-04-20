From: akpm@linux-foundation.org
Subject: + hpt366-fix-kernel-oops-with-hpt302n.patch added to -mm tree
Date: Thu, 19 Apr 2007 20:14:08 -0700
Message-ID: <200704200314.l3K3E8LO005746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409AbXDTDOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 23:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, codermattie@gmail.com


The patch titled
     hpt366: fix kernel oops with HPT302N
has been added to the -mm tree.  Its filename is
     hpt366-fix-kernel-oops-with-hpt302n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hpt366: fix kernel oops with HPT302N
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

The driver crashes the kernel on HPT302N chips due to the missing
initializer for 'hpt302n.settings' having been unfortunately overlooked so
far.  :-<

Much thanks to Mike Mattie for pin-pointing the reason of crash.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Mike Mattie <codermattie@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/hpt366.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~hpt366-fix-kernel-oops-with-hpt302n drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~hpt366-fix-kernel-oops-with-hpt302n
+++ a/drivers/ide/pci/hpt366.c
@@ -1,10 +1,10 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.01	Dec 23, 2006
+ * linux/drivers/ide/pci/hpt366.c		Version 1.02	Apr 18, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2006	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
  *
  * Thanks to HighPoint Technologies for their assistance, and hardware.
  * Special Thanks to Jon Burchmore in SanDiego for the deep pockets, his
@@ -494,6 +494,7 @@ static struct hpt_info hpt302n __devinit
 	.chip_type	= HPT302N,
 	.max_mode	= HPT302_ALLOW_ATA133_6 ? 4 : 3,
 	.dpll_clk	= 77,
+	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt371n __devinitdata = {
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

3x59x-fix-pci-resource-management.patch
pci-define-pci_request-release_regions-for-config_pci=n.patch
hpt366-fix-kernel-oops-with-hpt302n.patch
