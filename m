From: akpm@linux-foundation.org
Subject: + spidernet-transmit-race.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:01:46 -0800
Message-ID: <200702251301.l1PD1mLg029842@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964923AbXBYNFJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:05:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, lins@austin.ibm.com


The patch titled
     spidernet: transmit race
has been added to the -mm tree.  Its filename is
     spidernet-transmit-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
sungem_phy-support-bcm5461-phy-autoneg.patch
spidernet-compile-break.patch
spidernet-autoneg-support-for-celleb.patch
spidernet-load-firmware-when-open.patch
spidernet-spidernet-add-support-for-celleb.patch
spidernet-remove-txram-full-logging.patch
spidernet-move-medium-variable-into-card-struct.patch
spidernet-separate-hardware-state-from-driver-state.patch
spidernet-fix-racy-double-free-of-skb.patch
spidernet-transmit-race.patch
spidernet-janitorial-typos.patch
spidernet-maintainership.patch
