From: akpm@linux-foundation.org
Subject: - sfc-use-resource_size_t-for-pci-bus-address.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:17 -0700
Message-ID: <200805231859.m4NIxHT1004225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbYEWS7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: use resource_size_t for PCI bus address
has been removed from the -mm tree.  Its filename was
     sfc-use-resource_size_t-for-pci-bus-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: use resource_size_t for PCI bus address
From: Ben Hutchings <bhutchings@solarflare.com>

This should make the driver work on 32-bit systems with 64-bit PCI support.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c        |   11 ++++++-----
 drivers/net/sfc/net_driver.h |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-use-resource_size_t-for-pci-bus-address drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-use-resource_size_t-for-pci-bus-address
+++ a/drivers/net/sfc/efx.c
@@ -778,15 +778,16 @@ static int efx_init_io(struct efx_nic *e
 	efx->membase = ioremap_nocache(efx->membase_phys,
 				       efx->type->mem_map_size);
 	if (!efx->membase) {
-		EFX_ERR(efx, "could not map memory BAR %d at %lx+%x\n",
-			efx->type->mem_bar, efx->membase_phys,
+		EFX_ERR(efx, "could not map memory BAR %d at %llx+%x\n",
+			efx->type->mem_bar,
+			(unsigned long long)efx->membase_phys,
 			efx->type->mem_map_size);
 		rc = -ENOMEM;
 		goto fail4;
 	}
-	EFX_LOG(efx, "memory BAR %u at %lx+%x (virtual %p)\n",
-		efx->type->mem_bar, efx->membase_phys, efx->type->mem_map_size,
-		efx->membase);
+	EFX_LOG(efx, "memory BAR %u at %llx+%x (virtual %p)\n",
+		efx->type->mem_bar, (unsigned long long)efx->membase_phys,
+		efx->type->mem_map_size, efx->membase);
 
 	return 0;
 
diff -puN drivers/net/sfc/net_driver.h~sfc-use-resource_size_t-for-pci-bus-address drivers/net/sfc/net_driver.h
--- a/drivers/net/sfc/net_driver.h~sfc-use-resource_size_t-for-pci-bus-address
+++ a/drivers/net/sfc/net_driver.h
@@ -686,7 +686,7 @@ struct efx_nic {
 	struct workqueue_struct *workqueue;
 	struct work_struct reset_work;
 	struct delayed_work monitor_work;
-	unsigned long membase_phys;
+	resource_size_t membase_phys;
 	void __iomem *membase;
 	spinlock_t biu_lock;
 	enum efx_int_mode interrupt_mode;
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

