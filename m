From: akpm@linux-foundation.org
Subject: - hpt366-dont-check-enablebits-for-hpt36x.patch removed from -mm tree
Date: Sun, 06 May 2007 23:49:46 -0700
Message-ID: <200705070649.l476nkpB020499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092AbXEGGxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, michal.kepien@poczta.onet.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hpt366: don't check enablebits for HPT36x
has been removed from the -mm tree.  Its filename was
     hpt366-dont-check-enablebits-for-hpt36x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hpt366: don't check enablebits for HPT36x
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

HPT36x chip don't seem to have the channel enable bits, so prevent the IDE
core from checking them...

Hopefully addresses http://lkml.org/lkml/2007/5/4/337

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Michal Kepien <michal.kepien@poczta.onet.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: <stable@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/hpt366.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/ide/pci/hpt366.c~hpt366-dont-check-enablebits-for-hpt36x drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~hpt366-dont-check-enablebits-for-hpt36x
+++ a/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.02	Apr 18, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.03	May 4, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -1512,7 +1512,12 @@ static int __devinit init_setup_hpt366(s
 	if (rev > 2)
 		goto init_single;
 
+	/*
+	 * HPT36x chips are single channel and
+	 * do not seem to have the channel enable bit...
+	 */
 	d->channels = 1;
+	d->enablebits[0].reg = 0;
 
 	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
 	  	u8  pin1 = 0, pin2 = 0;
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
sl82c105-switch-to-ref-counting-api.patch
3x59x-fix-pci-resource-management.patch
clockchipsh-kernel-doc-fix.patch
