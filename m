From: akpm@linux-foundation.org
Subject: + paride-fix-menu-indentation.patch added to -mm tree
Date: Mon, 10 May 2010 15:42:52 -0700
Message-ID: <201005102242.o4AMgqQf027043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836Ab0EJWn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jens.axboe@oracle.com


The patch titled
     paride: fix menu indentation
has been added to the -mm tree.  Its filename is
     paride-fix-menu-indentation.patch

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
Subject: paride: fix menu indentation
From: Randy Dunlap <randy.dunlap@oracle.com>

Make the PARIDE menu be displayed correctly, with proper/expected
indentation, by moving the GDROM kconfig symbol, which was splitting the
PARIDE kconfig symbol from its dependent symbols.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/block/Kconfig~paride-fix-menu-indentation drivers/block/Kconfig
--- a/drivers/block/Kconfig~paride-fix-menu-indentation
+++ a/drivers/block/Kconfig
@@ -76,6 +76,17 @@ config BLK_DEV_XD
 
 	  It's pretty unlikely that you have one of these: say N.
 
+config GDROM
+	tristate "SEGA Dreamcast GD-ROM drive"
+	depends on SH_DREAMCAST
+	help
+	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
+	  "GD-ROM" by SEGA to signify it is capable of reading special disks
+	  with up to 1 GB of data. This drive will also read standard CD ROM
+	  disks. Select this option to access any disks in your GD ROM drive.
+	  Most users will want to say "Y" here.
+	  You can also build this as a module which will be called gdrom.
+
 config PARIDE
 	tristate "Parallel port IDE device support"
 	depends on PARPORT_PC
@@ -103,17 +114,6 @@ config PARIDE
 	  "MicroSolutions backpack protocol", "DataStor Commuter protocol"
 	  etc.).
 
-config GDROM
-	tristate "SEGA Dreamcast GD-ROM drive"
-	depends on SH_DREAMCAST
-	help
-	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
-	  "GD-ROM" by SEGA to signify it is capable of reading special disks
-	  with up to 1 GB of data. This drive will also read standard CD ROM
-	  disks. Select this option to access any disks in your GD ROM drive.
-	  Most users will want to say "Y" here.
-	  You can also build this as a module which will be called gdrom.
-
 source "drivers/block/paride/Kconfig"
 
 config BLK_CPQ_DA
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
virtio_9ph-include-linux-typesh.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mfd-use-menuconfig-for-quicker-config-editing.patch
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

