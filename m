From: akpm@linux-foundation.org
Subject: - spidernet-transmit-race.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:06 -0800
Message-ID: <200702282353.l1SNr6U7031059@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48340 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbXB1XxP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:53:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, lins@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: transmit race
has been removed from the -mm tree.  Its filename was
     spidernet-transmit-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spidernet: transmit race
From: Linas Vepstas <linas@austin.ibm.com>

Multiple threads performing a transmit can race into the spidernet tx ring
cleanup code.  This puts the relevant check under a lock.

Signed-off-by: Linas Vepstas <lins@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/net/spider_net.c~spidernet-transmit-race drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-transmit-race
+++ a/drivers/net/spider_net.c
@@ -803,8 +803,12 @@ spider_net_release_tx_chain(struct spide
 	unsigned long flags;
 	int status;
 
-	while (chain->tail != chain->head) {
+	while (1) {
 		spin_lock_irqsave(&chain->lock, flags);
+		if (chain->tail == chain->head) {
+			spin_unlock_irqrestore(&chain->lock, flags);
+			return 0;
+		}
 		descr = chain->tail;
 		hwdescr = descr->hwdescr;
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

s2io-add-pci-error-recovery-support.patch
