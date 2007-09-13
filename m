From: akpm@linux-foundation.org
Subject: + fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch added to -mm tree
Date: Thu, 13 Sep 2007 02:04:21 -0700
Message-ID: <200709130904.l8D94Lk2011018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbXIMJEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 05:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: micah.gruber@gmail.com, grundler@parisc-linux.org, jeff@garzik.org


The patch titled
     Fix a potential NULL pointer dereference in uli526x_interrupt() in drivers/net/tulip/uli526x.c
has been added to the -mm tree.  Its filename is
     fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix a potential NULL pointer dereference in uli526x_interrupt() in drivers/net/tulip/uli526x.c
From: Micah Gruber <micah.gruber@gmail.com>

This patch fixes an apparent potential null dereference bug where we
dereference dev before a null check.  This patch simply remvoes the
can't-happen test for a null pointer.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/uli526x.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/net/tulip/uli526x.c~fix-a-potential-null-pointer-dereference-in-uli526x_interrupt drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~fix-a-potential-null-pointer-dereference-in-uli526x_interrupt
+++ a/drivers/net/tulip/uli526x.c
@@ -666,11 +666,6 @@ static irqreturn_t uli526x_interrupt(int
 	unsigned long ioaddr = dev->base_addr;
 	unsigned long flags;
 
-	if (!dev) {
-		ULI526X_DBUG(1, "uli526x_interrupt() without DEVICE arg", 0);
-		return IRQ_NONE;
-	}
-
 	spin_lock_irqsave(&db->lock, flags);
 	outl(0, ioaddr + DCR7);
 
_

Patches currently in -mm which might be from micah.gruber@gmail.com are

fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch
git-net.patch
