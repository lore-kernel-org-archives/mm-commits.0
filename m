From: akpm@linux-foundation.org
Subject: - git-net-fix-macec.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:28 -0700
Message-ID: <200709270143.l8R1hSWG013965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbXI0BvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh.babulal@gmail.com, davem@davemloft.net, kamalesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     git-net: fix mace.c
has been removed from the -mm tree.  Its filename was
     git-net-fix-macec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-net: fix mace.c
From: "Kamalesh Babulal" <kamalesh.babulal@gmail.com>

drivers/net/mace.c: In function 'mace_handle_misc_intrs':
drivers/net/mace.c:642: error: 'dev' undeclared (first use in this function)
drivers/net/mace.c:642: error: (Each undeclared identifier is reported only
once
drivers/net/mace.c:642: error: for each function it appears in.)

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/mace.c~git-net-fix-macec drivers/net/mace.c
--- a/drivers/net/mace.c~git-net-fix-macec
+++ a/drivers/net/mace.c
@@ -632,7 +632,7 @@ static void mace_set_multicast(struct ne
     spin_unlock_irqrestore(&mp->lock, flags);
 }
 
-static void mace_handle_misc_intrs(struct mace_data *mp, int intr)
+static void mace_handle_misc_intrs(struct mace_data *mp, int intr, struct net_device *dev)
 {
     volatile struct mace __iomem *mb = mp->mace;
     static int mace_babbles, mace_jabbers;
@@ -668,7 +668,7 @@ static irqreturn_t mace_interrupt(int ir
     spin_lock_irqsave(&mp->lock, flags);
     intr = in_8(&mb->ir);		/* read interrupt register */
     in_8(&mb->xmtrc);			/* get retries */
-    mace_handle_misc_intrs(mp, intr);
+    mace_handle_misc_intrs(mp, intr, dev);
 
     i = mp->tx_empty;
     while (in_8(&mb->pr) & XMTSV) {
@@ -681,7 +681,7 @@ static irqreturn_t mace_interrupt(int ir
 	 */
 	intr = in_8(&mb->ir);
 	if (intr != 0)
-	    mace_handle_misc_intrs(mp, intr);
+	    mace_handle_misc_intrs(mp, intr, dev);
 	if (mp->tx_bad_runt) {
 	    fs = in_8(&mb->xmtfs);
 	    mp->tx_bad_runt = 0;
@@ -816,7 +816,7 @@ static void mace_tx_timeout(unsigned lon
 	goto out;
 
     /* update various counters */
-    mace_handle_misc_intrs(mp, in_8(&mb->ir));
+    mace_handle_misc_intrs(mp, in_8(&mb->ir), dev);
 
     cp = mp->tx_cmds + NCMDS_TX * mp->tx_empty;
 
_

Patches currently in -mm which might be from kamalesh.babulal@gmail.com are
