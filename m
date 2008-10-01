From: akpm@linux-foundation.org
Subject: - atl1e-remove-the-unneeded-struct-atl1e_adapter.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:30 -0700
Message-ID: <200810012151.m91LpUFJ005933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016AbYJAVvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jie.yang@atheros.com, mm-commits@vger.kernel.org


The patch titled
     atl1e: remove the unneeded (struct atl1e_adapter *)
has been removed from the -mm tree.  Its filename was
     atl1e-remove-the-unneeded-struct-atl1e_adapter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atl1e: remove the unneeded (struct atl1e_adapter *)
From: Jie Yang <jie.yang@atheros.com>

Remove the unneeded (struct atl1e_adapter *) casts, for hw->adapter
already has type atl1e_adapter *.

Signed-off-by: Jie Yang <jie.yang@atheros.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1e/atl1e_hw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/atl1e/atl1e_hw.c~atl1e-remove-the-unneeded-struct-atl1e_adapter drivers/net/atl1e/atl1e_hw.c
--- a/drivers/net/atl1e/atl1e_hw.c~atl1e-remove-the-unneeded-struct-atl1e_adapter
+++ a/drivers/net/atl1e/atl1e_hw.c
@@ -397,7 +397,7 @@ static int atl1e_phy_setup_autoneg_adv(s
  */
 int atl1e_phy_commit(struct atl1e_hw *hw)
 {
-	struct atl1e_adapter *adapter = (struct atl1e_adapter *)hw->adapter;
+	struct atl1e_adapter *adapter = hw->adapter;
 	struct pci_dev *pdev = adapter->pdev;
 	int ret_val;
 	u16 phy_data;
@@ -431,7 +431,7 @@ int atl1e_phy_commit(struct atl1e_hw *hw
 
 int atl1e_phy_init(struct atl1e_hw *hw)
 {
-	struct atl1e_adapter *adapter = (struct atl1e_adapter *)hw->adapter;
+	struct atl1e_adapter *adapter = hw->adapter;
 	struct pci_dev *pdev = adapter->pdev;
 	s32 ret_val;
 	u16 phy_val;
@@ -525,7 +525,7 @@ int atl1e_phy_init(struct atl1e_hw *hw)
  */
 int atl1e_reset_hw(struct atl1e_hw *hw)
 {
-	struct atl1e_adapter *adapter = (struct atl1e_adapter *)hw->adapter;
+	struct atl1e_adapter *adapter = hw->adapter;
 	struct pci_dev *pdev = adapter->pdev;
 
 	u32 idle_status_data = 0;
_

Patches currently in -mm which might be from jie.yang@atheros.com are

git-net.patch

