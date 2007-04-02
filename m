From: akpm@linux-foundation.org
Subject: - pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the.patch removed from -mm tree
Date: Sun, 01 Apr 2007 23:14:51 -0700
Message-ID: <200704020614.l326Epua025955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39787 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740AbXDBGO5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 02:14:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, James.Bottomley@steeleye.com, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     PCMCIA: allow PCMCIA SCSI drivers to be built into the kernel
has been removed from the -mm tree.  Its filename was
     pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCMCIA: allow PCMCIA SCSI drivers to be built into the kernel
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the Kconfig requirement that the PCMCIA SCSI drivers be built
only as modules, and allow them to be built into the kernel.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pcmcia/Kconfig |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/pcmcia/Kconfig~pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the drivers/scsi/pcmcia/Kconfig
--- a/drivers/scsi/pcmcia/Kconfig~pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the
+++ a/drivers/scsi/pcmcia/Kconfig
@@ -3,11 +3,11 @@
 #
 
 menu "PCMCIA SCSI adapter support"
-	depends on SCSI!=n && PCMCIA!=n && MODULES
+	depends on SCSI!=n && PCMCIA!=n
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
-	depends on m && !64BIT
+	depends on !64BIT
 	select SCSI_SPI_ATTRS
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
@@ -18,7 +18,6 @@ config PCMCIA_AHA152X
 
 config PCMCIA_FDOMAIN
 	tristate "Future Domain PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -28,7 +27,7 @@ config PCMCIA_FDOMAIN
 
 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
-	depends on m && !64BIT
+	depends on !64BIT
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
 	  your computer, say Y here and read
@@ -62,7 +61,6 @@ config PCMCIA_NINJA_SCSI
 
 config PCMCIA_QLOGIC
 	tristate "Qlogic PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -72,7 +70,6 @@ config PCMCIA_QLOGIC
 
 config PCMCIA_SYM53C500
 	tristate "Symbios 53c500 PCMCIA support"
-	depends on m
 	help
 	  Say Y here if you have a New Media Bus Toaster or other PCMCIA
 	  SCSI adapter based on the Symbios 53c500 controller.
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-input.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
git-netdev-all.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
