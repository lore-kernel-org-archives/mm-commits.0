From: akpm@linux-foundation.org
Subject: - m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:35 -0800
Message-ID: <200802052234.m15MYGRb012498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762693AbYBEWml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: Balance ioremap and iounmap in m68k/atari/hades-pci.c
has been removed from the -mm tree.  Its filename was
     m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: Balance ioremap and iounmap in m68k/atari/hades-pci.c
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/atari/hades-pci.c |   56 ++++++++++++++++------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff -puN arch/m68k/atari/hades-pci.c~m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic arch/m68k/atari/hades-pci.c
--- a/arch/m68k/atari/hades-pci.c~m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic
+++ a/arch/m68k/atari/hades-pci.c
@@ -376,8 +376,8 @@ struct pci_bus_info * __init init_hades_
 	 */
 
 	bus = kzalloc(sizeof(struct pci_bus_info), GFP_KERNEL);
-	if (!bus)
-		return NULL;
+	if (unlikely(!bus))
+		goto iounmap_base_virt;
 
 	/*
 	 * Claim resources. The m68k has no separate I/O space, both
@@ -385,43 +385,25 @@ struct pci_bus_info * __init init_hades_
 	 * the I/O resources are requested in memory space as well.
 	 */
 
-	if (request_resource(&iomem_resource, &config_space) != 0)
-	{
-		kfree(bus);
-		return NULL;
-	}
-
-	if (request_resource(&iomem_resource, &io_space) != 0)
-	{
-		release_resource(&config_space);
-		kfree(bus);
-		return NULL;
-	}
+	if (unlikely(request_resource(&iomem_resource, &config_space) != 0))
+		goto free_bus;
+
+	if (unlikely(request_resource(&iomem_resource, &io_space) != 0))
+		goto release_config_space;
 
 	bus->mem_space.start = HADES_MEM_BASE;
 	bus->mem_space.end = HADES_MEM_BASE + HADES_MEM_SIZE - 1;
 	bus->mem_space.name = pci_mem_name;
 #if 1
-	if (request_resource(&iomem_resource, &bus->mem_space) != 0)
-	{
-		release_resource(&io_space);
-		release_resource(&config_space);
-		kfree(bus);
-		return NULL;
-	}
+	if (unlikely(request_resource(&iomem_resource, &bus->mem_space) != 0))
+		goto release_io_space;
 #endif
 	bus->io_space.start = pci_io_base_virt;
 	bus->io_space.end = pci_io_base_virt + HADES_VIRT_IO_SIZE - 1;
 	bus->io_space.name = pci_io_name;
 #if 1
-	if (request_resource(&ioport_resource, &bus->io_space) != 0)
-	{
-		release_resource(&bus->mem_space);
-		release_resource(&io_space);
-		release_resource(&config_space);
-		kfree(bus);
-		return NULL;
-	}
+	if (unlikely(request_resource(&ioport_resource, &bus->io_space) != 0))
+		goto release_bus_mem_space;
 #endif
 	/*
 	 * Set hardware dependent functions.
@@ -438,5 +420,21 @@ struct pci_bus_info * __init init_hades_
 	tt_mfp.active_edge &= ~0x27;
 
 	return bus;
+
+release_bus_mem_space:
+	release_resource(&bus->mem_space);
+release_io_space:
+	release_resource(&io_space);
+release_config_space:
+	release_resource(&config_space);
+free_bus:
+	kfree(bus);
+iounmap_base_virt:
+	iounmap((void *)pci_io_base_virt);
+
+	for (i = 0; i < N_SLOTS; i++)
+		iounmap((void *)pci_conf_base_virt[i]);
+
+	return NULL;
 }
 #endif
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-alsa.patch
git-dvb.patch
git-mtd.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
fix-and-typo-in-eicons-addinfo.patch
