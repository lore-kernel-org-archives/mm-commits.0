From: akpm@linux-foundation.org
Subject: - add-configure-support-for-new-coldfire-serial-driver.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:49 -0800
Message-ID: <200802012229.m11MTnWY001829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758227AbYBAWbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:31:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     add configure support for new ColdFire serial driver
has been removed from the -mm tree.  Its filename was
     add-configure-support-for-new-coldfire-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add configure support for new ColdFire serial driver
From: Greg Ungerer <gerg@snapgear.com>

Add configure support for the new style ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/serial/Kconfig~add-configure-support-for-new-coldfire-serial-driver drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~add-configure-support-for-new-coldfire-serial-driver
+++ a/drivers/serial/Kconfig
@@ -960,6 +960,30 @@ config SERIAL_COLDFIRE
 	  This driver supports the built-in serial ports of the Motorola ColdFire
 	  family of CPUs.
 
+config SERIAL_MCF
+	bool "Coldfire serial support (new style driver)"
+	depends on COLDFIRE
+	select SERIAL_CORE
+	help
+	  This new serial driver supports the Freescale Coldfire serial ports
+	  using the new serial driver subsystem.
+
+config SERIAL_MCF_BAUDRATE
+	int "Default baudrate for Coldfire serial ports"
+	depends on SERIAL_MCF
+	default 19200
+	help
+	  This setting lets you define what the default baudrate is for the
+	  ColdFire serial ports. The usual default varies from board to board,
+	  and this setting is a way of catering for that.
+
+config SERIAL_MCF_CONSOLE
+	bool "Coldfire serial console support"
+	depends on SERIAL_MCF
+	select SERIAL_CORE_CONSOLE
+	help
+	  Enable a ColdFire internal serial port to be the system console.
+
 config SERIAL_68360_SMC
 	bool "68360 SMC uart support"
 	depends on M68360
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
add-cmpxchg_local-to-m68knommu.patch
