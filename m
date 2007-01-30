From: akpm@osdl.org
Subject: - fs_enet-of-related-fixup-for-fec-and-scc-macs.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:43 -0800
Message-ID: <200701302147.l0ULlhfZ030201@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52003 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbXA3Vr4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbordug@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     FS_ENET: OF-related fixup for FEC and SCC MAC's
has been removed from the -mm tree.  Its filename was
     fs_enet-of-related-fixup-for-fec-and-scc-macs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FS_ENET: OF-related fixup for FEC and SCC MAC's
From: Vitaly Bordug <vbordug@ru.mvista.com>

Updated direct resource pass with ioremap call, make it grant proper IRQ
mapping, stuff incompatible with the new approach were respectively put
under #ifndef CONFIG_PPC_MERGE.  It is required so that both ppc and
powerpc could utilize fs_enet effectively.

Signed-off-by: Vitaly Bordug <vbordug@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/fs_enet/mac-fec.c |   13 +++++++++----
 drivers/net/fs_enet/mac-scc.c |    6 ++++--
 drivers/net/phy/fixed.c       |    2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff -puN drivers/net/fs_enet/mac-fec.c~fs_enet-of-related-fixup-for-fec-and-scc-macs drivers/net/fs_enet/mac-fec.c
--- a/drivers/net/fs_enet/mac-fec.c~fs_enet-of-related-fixup-for-fec-and-scc-macs
+++ a/drivers/net/fs_enet/mac-fec.c
@@ -104,9 +104,9 @@ static int do_pd_setup(struct fs_enet_pr
 	fep->interrupt = platform_get_irq_byname(pdev,"interrupt");
 	if (fep->interrupt < 0)
 		return -EINVAL;
-	
+
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
-	fep->fec.fecp =(void*)r->start;
+	fep->fec.fecp = ioremap(r->start, r->end - r->start + 1);
 
 	if(fep->fec.fecp == NULL)
 		return -EINVAL;
@@ -319,11 +319,14 @@ static void restart(struct net_device *d
 	 * Clear any outstanding interrupt.
 	 */
 	FW(fecp, ievent, 0xffc0);
+#ifndef CONFIG_PPC_MERGE
 	FW(fecp, ivec, (fep->interrupt / 2) << 29);
-	
+#else
+	FW(fecp, ivec, (virq_to_hw(fep->interrupt) / 2) << 29);
+#endif
 
 	/*
-	 * adjust to speed (only for DUET & RMII) 
+	 * adjust to speed (only for DUET & RMII)
 	 */
 #ifdef CONFIG_DUET
 	if (fpi->use_rmii) {
@@ -418,6 +421,7 @@ static void stop(struct net_device *dev)
 
 static void pre_request_irq(struct net_device *dev, int irq)
 {
+#ifndef CONFIG_PPC_MERGE
 	immap_t *immap = fs_enet_immap;
 	u32 siel;
 
@@ -431,6 +435,7 @@ static void pre_request_irq(struct net_d
 			siel &= ~(0x80000000 >> (irq & ~1));
 		out_be32(&immap->im_siu_conf.sc_siel, siel);
 	}
+#endif
 }
 
 static void post_free_irq(struct net_device *dev, int irq)
diff -puN drivers/net/fs_enet/mac-scc.c~fs_enet-of-related-fixup-for-fec-and-scc-macs drivers/net/fs_enet/mac-scc.c
--- a/drivers/net/fs_enet/mac-scc.c~fs_enet-of-related-fixup-for-fec-and-scc-macs
+++ a/drivers/net/fs_enet/mac-scc.c
@@ -121,13 +121,13 @@ static int do_pd_setup(struct fs_enet_pr
 		return -EINVAL;
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
-	fep->scc.sccp = (void *)r->start;
+	fep->scc.sccp = ioremap(r->start, r->end - r->start + 1);
 
 	if (fep->scc.sccp == NULL)
 		return -EINVAL;
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pram");
-	fep->scc.ep = (void *)r->start;
+	fep->scc.ep = ioremap(r->start, r->end - r->start + 1);
 
 	if (fep->scc.ep == NULL)
 		return -EINVAL;
@@ -397,6 +397,7 @@ static void stop(struct net_device *dev)
 
 static void pre_request_irq(struct net_device *dev, int irq)
 {
+#ifndef CONFIG_PPC_MERGE
 	immap_t *immap = fs_enet_immap;
 	u32 siel;
 
@@ -410,6 +411,7 @@ static void pre_request_irq(struct net_d
 			siel &= ~(0x80000000 >> (irq & ~1));
 		out_be32(&immap->im_siu_conf.sc_siel, siel);
 	}
+#endif
 }
 
 static void post_free_irq(struct net_device *dev, int irq)
diff -puN drivers/net/phy/fixed.c~fs_enet-of-related-fixup-for-fec-and-scc-macs drivers/net/phy/fixed.c
--- a/drivers/net/phy/fixed.c~fs_enet-of-related-fixup-for-fec-and-scc-macs
+++ a/drivers/net/phy/fixed.c
@@ -349,7 +349,7 @@ static int __init fixed_init(void)
 	fixed_mdio_register_device(0, 100, 1);
 #endif
 
-#ifdef CONFIX_FIXED_MII_10_FDX
+#ifdef CONFIG_FIXED_MII_10_FDX
 	fixed_mdio_register_device(0, 10, 1);
 #endif
 	return 0;
_

Patches currently in -mm which might be from vbordug@ru.mvista.com are

origin.patch
