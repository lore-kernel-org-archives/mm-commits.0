From: akpm@linux-foundation.org
Subject: + max3100-spi-uart-driver-select-serial_core.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:51:24 -0800
Message-ID: <200811122251.mACMpODZ004274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbYKLWvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, chripell@evolware.org


The patch titled
     max3100: select SERIAL_CORE
has been added to the -mm tree.  Its filename is
     max3100-spi-uart-driver-select-serial_core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: max3100: select SERIAL_CORE
From: Randy Dunlap <randy.dunlap@oracle.com>

max3100 driver need to select SERIAL_CORE like most other serial drivers do.

max3100.c:(.text+0x524c5): undefined reference to `uart_write_wakeup'
max3100.c:(.text+0x526eb): undefined reference to `uart_write_wakeup'
max3100.c:(.text+0x529f7): undefined reference to `uart_update_timeout'
max3100.c:(.text+0x52cfa): undefined reference to `uart_resume_port'
max3100.c:(.text+0x52d6a): undefined reference to `uart_suspend_port'
max3100.c:(.devinit.text+0x23e3): undefined reference to `uart_register_driver'
max3100.c:(.devinit.text+0x265a): undefined reference to `uart_add_one_port'
max3100.c:(.devexit.text+0x1aa): undefined reference to `uart_remove_one_port'
max3100.c:(.devexit.text+0x1e5): undefined reference to `uart_unregister_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christian Pellegrin <chripell@evolware.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/Kconfig~max3100-spi-uart-driver-select-serial_core drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~max3100-spi-uart-driver-select-serial_core
+++ a/drivers/serial/Kconfig
@@ -511,6 +511,7 @@ config SERIAL_S3C2440
 config SERIAL_MAX3100
         tristate "MAX3100 support"
         depends on SPI
+	select SERIAL_CORE
         help
           MAX3100 chip support
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
doc-add-printk-formatstxt.patch
doc-update-xip-method-info.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

