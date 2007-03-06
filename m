From: akpm@linux-foundation.org
Subject: + initramfs-should-not-depend-on-config_block.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:38:12 -0800
Message-ID: <200703060438.l264cC1e011993@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50559 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965781AbXCFEiX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:38:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dimitri.gorokhovik@free.fr, dhowells@redhat.com


The patch titled
     initramfs should not depend on CONFIG_BLOCK
has been added to the -mm tree.  Its filename is
     initramfs-should-not-depend-on-config_block.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: initramfs should not depend on CONFIG_BLOCK
From: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>

initramfs ended up depending on BLOCK:

  INITRAMFS_SOURCE <-- BLK_DEV_INITRD <-- BLOCK

This inhibits use of customized-initramfs-over-ramfs without block layer
(ramfs would still be enabled), useful in embedded applications.

Move BLK_DEV_INITRD out of 'drivers/block/Kconfig' and into 'init/Kconfig',
make it unconditional.

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig |   16 ----------------
 init/Kconfig          |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/block/Kconfig~initramfs-should-not-depend-on-config_block drivers/block/Kconfig
--- a/drivers/block/Kconfig~initramfs-should-not-depend-on-config_block
+++ a/drivers/block/Kconfig
@@ -406,22 +406,6 @@ config BLK_DEV_RAM_BLOCKSIZE
 	  setups function - apparently needed by the rd_load_image routine
 	  that supposes the filesystem in the image uses a 1024 blocksize.
 
-config BLK_DEV_INITRD
-	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
-	depends on BROKEN || !FRV
-	help
-	  The initial RAM filesystem is a ramfs which is loaded by the
-	  boot loader (loadlin or lilo) and that is mounted as root
-	  before the normal boot procedure. It is typically used to
-	  load modules needed to mount the "real" root file system,
-	  etc. See <file:Documentation/initrd.txt> for details.
-
-	  If RAM disk support (BLK_DEV_RAM) is also included, this
-	  also enables initial RAM disk (initrd) support and adds
-	  15 Kbytes (more on some other architectures) to the kernel size.
-
-	  If unsure say Y.
-
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff -puN init/Kconfig~initramfs-should-not-depend-on-config_block init/Kconfig
--- a/init/Kconfig~initramfs-should-not-depend-on-config_block
+++ a/init/Kconfig
@@ -304,6 +304,22 @@ config RELAY
 
 	  If unsure, say N.
 
+config BLK_DEV_INITRD
+	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
+	depends on BROKEN || !FRV
+	help
+	  The initial RAM filesystem is a ramfs which is loaded by the
+	  boot loader (loadlin or lilo) and that is mounted as root
+	  before the normal boot procedure. It is typically used to
+	  load modules needed to mount the "real" root file system,
+	  etc. See <file:Documentation/initrd.txt> for details.
+
+	  If RAM disk support (BLK_DEV_RAM) is also included, this
+	  also enables initial RAM disk (initrd) support and adds
+	  15 Kbytes (more on some other architectures) to the kernel size.
+
+	  If unsure say Y.
+
 if BLK_DEV_INITRD
 
 source "usr/Kconfig"
_

Patches currently in -mm which might be from dimitri.gorokhovik@free.fr are

initramfs-should-not-depend-on-config_block.patch
