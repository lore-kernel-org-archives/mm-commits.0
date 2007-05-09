From: akpm@linux-foundation.org
Subject: - uml-turn-on-scsi-support.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:30 -0700
Message-ID: <200705092149.l49LnUVc002700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758552AbXEIVtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: turn on SCSI support
has been removed from the -mm tree.  Its filename was
     uml-turn-on-scsi-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: turn on SCSI support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Enable (i)SCSI on UML, dunno why SCSI was deemed broken, it works like a
charm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig      |   16 -----------
 arch/um/Kconfig.scsi |   58 -----------------------------------------
 2 files changed, 1 insertion(+), 73 deletions(-)

diff -puN arch/um/Kconfig~uml-turn-on-scsi-support arch/um/Kconfig
--- a/arch/um/Kconfig~uml-turn-on-scsi-support
+++ a/arch/um/Kconfig
@@ -320,21 +320,7 @@ source "crypto/Kconfig"
 
 source "lib/Kconfig"
 
-menu "SCSI support"
-depends on BROKEN
-
-config SCSI
-	tristate "SCSI support"
-
-# This gives us free_dma, which scsi.c wants.
-config GENERIC_ISA_DMA
-	bool
-	depends on SCSI
-	default y
-
-source "arch/um/Kconfig.scsi"
-
-endmenu
+source "drivers/scsi/Kconfig"
 
 source "drivers/md/Kconfig"
 
diff -puN arch/um/Kconfig.scsi~uml-turn-on-scsi-support /dev/null
--- a/arch/um/Kconfig.scsi
+++ /dev/null
@@ -1,58 +0,0 @@
-comment "SCSI support type (disk, tape, CD-ROM)"
-	depends on SCSI
-
-config BLK_DEV_SD
-	tristate "SCSI disk support"
-	depends on SCSI
-
-config SD_EXTRA_DEVS
-	int "Maximum number of SCSI disks that can be loaded as modules"
-	depends on BLK_DEV_SD
-	default "40"
-
-config CHR_DEV_ST
-	tristate "SCSI tape support"
-	depends on SCSI
-
-config BLK_DEV_SR
-	tristate "SCSI CD-ROM support"
-	depends on SCSI
-
-config BLK_DEV_SR_VENDOR
-	bool "Enable vendor-specific extensions (for SCSI CDROM)"
-	depends on BLK_DEV_SR
-
-config SR_EXTRA_DEVS
-	int "Maximum number of CDROM devices that can be loaded as modules"
-	depends on BLK_DEV_SR
-	default "2"
-
-config CHR_DEV_SG
-	tristate "SCSI generic support"
-	depends on SCSI
-
-comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
-	depends on SCSI
-
-#if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-config SCSI_DEBUG_QUEUES
-	bool "Enable extra checks in new queueing code"
-	depends on SCSI
-
-#fi
-config SCSI_MULTI_LUN
-	bool "Probe all LUNs on each SCSI device"
-	depends on SCSI
-
-config SCSI_CONSTANTS
-	bool "Verbose SCSI error reporting (kernel size +=12K)"
-	depends on SCSI
-
-config SCSI_LOGGING
-	bool "SCSI logging facility"
-	depends on SCSI
-
-config SCSI_DEBUG
-	tristate "SCSI debugging host simulator (EXPERIMENTAL)"
-	depends on SCSI
-
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
sunrpc-fix-crash-in-rpc_malloc.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
