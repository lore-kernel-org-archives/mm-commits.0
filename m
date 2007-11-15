From: akpm@linux-foundation.org
Subject: - powerpc-fix-fs_enet-module-build.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:27 -0800
Message-ID: <200711152112.lAFLCRJ8015873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732AbXKOVSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@scram.de, benh@kernel.crashing.org, jeff@garzik.org, paulus@samba.org, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: fix fs_enet module build
has been removed from the -mm tree.  Its filename was
     powerpc-fix-fs_enet-module-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: fix fs_enet module build
From: Jochen Friedrich <jochen@scram.de>

If fs_enet is build as module, on PPC_CPM_NEW_BINDING platforms
mii-fec/mii-bitbang should be build as module, as well.  On other
platforms, mii-fec/mii-bitbang must be included into the main module. 
Otherwise some symbols remain undefined.  Additionally, fs_enet uses
libphy, so add a select PHYLIB.

  Building modules, stage 2.
  MODPOST 5 modules
ERROR: "fs_scc_ops" [drivers/net/fs_enet/fs_enet.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Scott Wood <scottwood@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fs_enet/Kconfig  |   11 ++++++++++-
 drivers/net/fs_enet/Makefile |   15 ++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff -puN drivers/net/fs_enet/Kconfig~powerpc-fix-fs_enet-module-build drivers/net/fs_enet/Kconfig
--- a/drivers/net/fs_enet/Kconfig~powerpc-fix-fs_enet-module-build
+++ a/drivers/net/fs_enet/Kconfig
@@ -2,6 +2,7 @@ config FS_ENET
        tristate "Freescale Ethernet Driver"
        depends on CPM1 || CPM2
        select MII
+       select PHYLIB
 
 config FS_ENET_HAS_SCC
 	bool "Chip has an SCC usable for ethernet"
@@ -11,11 +12,19 @@ config FS_ENET_HAS_SCC
 config FS_ENET_HAS_FCC
 	bool "Chip has an FCC usable for ethernet"
 	depends on FS_ENET && CPM2
-	select MDIO_BITBANG
 	default y
 
 config FS_ENET_HAS_FEC
 	bool "Chip has an FEC usable for ethernet"
 	depends on FS_ENET && CPM1
+	select FS_ENET_MDIO_FEC
 	default y
 
+config FS_ENET_MDIO_FEC
+	tristate "MDIO driver for FEC"
+	depends on FS_ENET && CPM1
+
+config FS_ENET_MDIO_FCC
+	tristate "MDIO driver for FCC"
+	depends on FS_ENET && CPM2
+	select MDIO_BITBANG
diff -puN drivers/net/fs_enet/Makefile~powerpc-fix-fs_enet-module-build drivers/net/fs_enet/Makefile
--- a/drivers/net/fs_enet/Makefile~powerpc-fix-fs_enet-module-build
+++ a/drivers/net/fs_enet/Makefile
@@ -4,7 +4,16 @@
 
 obj-$(CONFIG_FS_ENET) += fs_enet.o
 
-obj-$(CONFIG_8xx) += mac-fec.o mac-scc.o mii-fec.o
-obj-$(CONFIG_CPM2) += mac-fcc.o mii-bitbang.o
+fs_enet-$(CONFIG_FS_ENET_HAS_SCC) += mac-scc.o
+fs_enet-$(CONFIG_FS_ENET_HAS_FEC) += mac-fec.o
+fs_enet-$(CONFIG_FS_ENET_HAS_FCC) += mac-fcc.o
 
-fs_enet-objs := fs_enet-main.o
+ifeq ($(CONFIG_PPC_CPM_NEW_BINDING),y)
+obj-$(CONFIG_FS_ENET_MDIO_FEC) += mii-fec.o
+obj-$(CONFIG_FS_ENET_MDIO_FCC) += mii-bitbang.o
+else
+fs_enet-$(CONFIG_FS_ENET_MDIO_FEC) += mii-fec.o
+fs_enet-$(CONFIG_FS_ENET_MDIO_FCC) += mii-bitbang.o
+endif
+
+fs_enet-objs := fs_enet-main.o $(fs_enet-m)
_

Patches currently in -mm which might be from jochen@scram.de are

origin.patch
powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch
powerpc-fix-typo-ifdef-ifndef.patch
