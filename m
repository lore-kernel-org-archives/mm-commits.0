From: akpm@linux-foundation.org
Subject: + ixgbe-fix-vlan-filtering.patch added to -mm tree
Date: Tue, 26 Aug 2008 16:50:59 -0700
Message-ID: <200808262350.m7QNoxKW001661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYHZXvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 19:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.h.duyck@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com


The patch titled
     ixgbe: fix vlan filtering
has been added to the -mm tree.  Its filename is
     ixgbe-fix-vlan-filtering.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ixgbe: fix vlan filtering
From: Alexander Duyck <alexander.h.duyck@intel.com>

There are no vlan filter settings in the fctrl register.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ixgbe/ixgbe_main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/net/ixgbe/ixgbe_main.c~ixgbe-fix-vlan-filtering drivers/net/ixgbe/ixgbe_main.c
--- a/drivers/net/ixgbe/ixgbe_main.c~ixgbe-fix-vlan-filtering
+++ a/drivers/net/ixgbe/ixgbe_main.c
@@ -1636,16 +1636,17 @@ static void ixgbe_set_multi(struct net_d
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct dev_mc_list *mc_ptr;
 	u8 *mta_list;
-	u32 fctrl;
+	u32 fctrl, vlnctrl;
 	int i;
 
 	/* Check for Promiscuous and All Multicast modes */
 
 	fctrl = IXGBE_READ_REG(hw, IXGBE_FCTRL);
+	vlnctrl = IXGBE_READ_REG(hw, IXGBE_VLNCTRL);
 
 	if (netdev->flags & IFF_PROMISC) {
 		fctrl |= (IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
-		fctrl &= ~IXGBE_VLNCTRL_VFE;
+		vlnctrl &= ~IXGBE_VLNCTRL_VFE;
 	} else {
 		if (netdev->flags & IFF_ALLMULTI) {
 			fctrl |= IXGBE_FCTRL_MPE;
@@ -1653,10 +1654,11 @@ static void ixgbe_set_multi(struct net_d
 		} else {
 			fctrl &= ~(IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
 		}
-		fctrl |= IXGBE_VLNCTRL_VFE;
+		vlnctrl |= IXGBE_VLNCTRL_VFE;
 	}
 
 	IXGBE_WRITE_REG(hw, IXGBE_FCTRL, fctrl);
+	IXGBE_WRITE_REG(hw, IXGBE_VLNCTRL, vlnctrl);
 
 	if (netdev->mc_count) {
 		mta_list = kcalloc(netdev->mc_count, ETH_ALEN, GFP_ATOMIC);
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

ixgbe-fix-vlan-filtering.patch
igb-remove-82576-quad-adapter.patch

