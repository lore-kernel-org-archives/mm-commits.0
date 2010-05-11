From: akpm@linux-foundation.org
Subject: [merged] mfd-use-menuconfig-for-quicker-config-editing.patch removed from -mm tree
Date: Tue, 11 May 2010 12:17:02 -0400
Message-ID: <201005111918.o4BJIU7X018210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab0EKTSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     mfd: use menuconfig for quicker config editing
has been removed from the -mm tree.  Its filename was
     mfd-use-menuconfig-for-quicker-config-editing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: use menuconfig for quicker config editing
From: Randy Dunlap <randy.dunlap@oracle.com>

Change MFD 'menu' to 'menuconfig' to facilitate easy (one-click)
disabling of all MFD drivers.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/Kconfig~mfd-use-menuconfig-for-quicker-config-editing drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-use-menuconfig-for-quicker-config-editing
+++ a/drivers/mfd/Kconfig
@@ -2,8 +2,14 @@
 # Multifunction miscellaneous devices
 #
 
-menu "Multifunction device drivers"
+menuconfig MFD_SUPPORT
+	bool "Multifunction device drivers"
 	depends on HAS_IOMEM
+	default y
+	help
+	  Configure MFD device drivers.
+
+if MFD_SUPPORT
 
 config MFD_CORE
 	tristate
@@ -434,7 +440,7 @@ config MFD_JANZ_CMODIO
 	  host many different types of MODULbus daughterboards, including
 	  CAN and GPIO controllers.
 
-endmenu
+endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
virtio_9ph-include-linux-typesh.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
paride-fix-menu-indentation.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

