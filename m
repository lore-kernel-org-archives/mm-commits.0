From: akpm@linux-foundation.org
Subject: - rapidio-add-rapidio-option-to-kernel-configuration.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:05 -0700
Message-ID: <200804300551.m3U5p5kw030191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759279AbYD3FvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: add RapidIO option to kernel configuration
has been removed from the -mm tree.  Its filename was
     rapidio-add-rapidio-option-to-kernel-configuration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add RapidIO option to kernel configuration
From: Zhang Wei <wei.zhang@freescale.com>

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                |   13 +++++++++++++
 arch/powerpc/platforms/86xx/Kconfig |    1 +
 2 files changed, 14 insertions(+)

diff -puN arch/powerpc/Kconfig~rapidio-add-rapidio-option-to-kernel-configuration arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~rapidio-add-rapidio-option-to-kernel-configuration
+++ a/arch/powerpc/Kconfig
@@ -590,6 +590,19 @@ source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
 
+config HAS_RAPIDIO
+	bool
+	default n
+
+config RAPIDIO
+	bool "RapidIO support"
+	depends on HAS_RAPIDIO
+	help
+	  If you say Y here, the kernel will include drivers and
+	  infrastructure code to support RapidIO interconnect devices.
+
+source "drivers/rapidio/Kconfig"
+
 endmenu
 
 menu "Advanced setup"
diff -puN arch/powerpc/platforms/86xx/Kconfig~rapidio-add-rapidio-option-to-kernel-configuration arch/powerpc/platforms/86xx/Kconfig
--- a/arch/powerpc/platforms/86xx/Kconfig~rapidio-add-rapidio-option-to-kernel-configuration
+++ a/arch/powerpc/platforms/86xx/Kconfig
@@ -8,6 +8,7 @@ config MPC8641_HPCN
 	select PPC_I8259
 	select DEFAULT_UIMAGE
 	select FSL_ULI1575
+	select HAS_RAPIDIO
 	help
 	  This option enables support for the MPC8641 HPCN board.
 
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

