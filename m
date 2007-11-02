From: akpm@linux-foundation.org
Subject: + add-configure-support-for-new-coldfire-serial-driver.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:22 -0700
Message-ID: <200711022135.lA2LZMcM012005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbXKBVgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     add configure support for new ColdFire serial driver
has been added to the -mm tree.  Its filename is
     add-configure-support-for-new-coldfire-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68knommu-fix-pread-pwrite-defines.patch
m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
add-build-support-for-new-coldfire-serial-driver.patch
add-configure-support-for-new-coldfire-serial-driver.patch
m68knommu-platform-setup-for-5206-coldfire-uarts.patch
m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
m68knommu-platform-setup-for-520x-coldfire-uarts.patch
m68knommu-platform-setup-for-5249-coldfire-uarts.patch
m68knommu-platform-setup-for-5272-coldfire-uarts.patch
add-cmpxchg_local-to-m68knommu.patch
