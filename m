From: akpm@linux-foundation.org
Subject: - pcie-remove-spin_lock_unlocked.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:13 -0700
Message-ID: <200708250518.l7P5IDUj031846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbXHYFSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pcie: remove SPIN_LOCK_UNLOCKED
has been removed from the -mm tree.  Its filename was
     pcie-remove-spin_lock_unlocked.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: pcie: remove SPIN_LOCK_UNLOCKED
From: Milind Arun Choudhary <milindchoudhary@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pcie/aer/aerdrv.c~pcie-remove-spin_lock_unlocked drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~pcie-remove-spin_lock_unlocked
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -157,7 +157,7 @@ static struct aer_rpc* aer_alloc_rpc(str
 	 * Initialize Root lock access, e_lock, to Root Error Status Reg,
 	 * Root Error ID Reg, and Root error producer/consumer index.
 	 */
-	rpc->e_lock = SPIN_LOCK_UNLOCKED;
+	spin_lock_init(&rpc->e_lock);
 
 	rpc->rpd = dev;
 	INIT_WORK(&rpc->dpc_handler, aer_isr);
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are
