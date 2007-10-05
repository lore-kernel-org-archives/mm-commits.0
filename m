From: akpm@linux-foundation.org
Subject: - fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:36 -0700
Message-ID: <200710051957.l95Jva94022480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763491AbXJEUBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: micah.gruber@gmail.com, grundler@parisc-linux.org, jeff@garzik.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     Fix a potential NULL pointer dereference in uli526x_interrupt() in drivers/net/tulip/uli526x.c
has been removed from the -mm tree.  Its filename was
     fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix a potential NULL pointer dereference in uli526x_interrupt() in drivers/net/tulip/uli526x.c
From: Micah Gruber <micah.gruber@gmail.com>

This patch fixes an apparent potential null dereference bug where we
dereference dev before a null check.  This patch simply remvoes the
can't-happen test for a null pointer.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/uli526x.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/net/tulip/uli526x.c~fix-a-potential-null-pointer-dereference-in-uli526x_interrupt drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~fix-a-potential-null-pointer-dereference-in-uli526x_interrupt
+++ a/drivers/net/tulip/uli526x.c
@@ -664,11 +664,6 @@ static irqreturn_t uli526x_interrupt(int
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

git-net.patch
