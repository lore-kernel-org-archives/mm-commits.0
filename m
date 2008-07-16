From: akpm@linux-foundation.org
Subject: - net-phy-fix-missing-exports-for-net-phy-mdio-bitbangc.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:34 -0700
Message-ID: <200807162135.m6GLZYc2014102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756486AbYGPVhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     net/phy: fix missing exports for net/phy/mdio-bitbang.c
has been removed from the -mm tree.  Its filename was
     net-phy-fix-missing-exports-for-net-phy-mdio-bitbangc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/phy: fix missing exports for net/phy/mdio-bitbang.c
From: Takashi Iwai <tiwai@suse.de>

{alloc,free}_mdio_bitbang() are not exported while they are used in
mdio-ofgpio driver.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/mdio-bitbang.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/phy/mdio-bitbang.c~net-phy-fix-missing-exports-for-net-phy-mdio-bitbangc drivers/net/phy/mdio-bitbang.c
--- a/drivers/net/phy/mdio-bitbang.c~net-phy-fix-missing-exports-for-net-phy-mdio-bitbangc
+++ a/drivers/net/phy/mdio-bitbang.c
@@ -177,6 +177,7 @@ struct mii_bus *alloc_mdio_bitbang(struc
 
 	return bus;
 }
+EXPORT_SYMBOL(alloc_mdio_bitbang);
 
 void free_mdio_bitbang(struct mii_bus *bus)
 {
@@ -185,5 +186,6 @@ void free_mdio_bitbang(struct mii_bus *b
 	module_put(ctrl->ops->owner);
 	kfree(bus);
 }
+EXPORT_SYMBOL(free_mdio_bitbang);
 
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
use-sysdev_class-in-schedc.patch
use-sysdev_class-in-schedc-fix.patch
kcalloc-remove-runtime-division.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch

