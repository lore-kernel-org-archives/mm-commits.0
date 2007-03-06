From: akpm@linux-foundation.org
Subject: - fix-the-romfs_-dependencies.patch removed from -mm tree
Date: Mon, 05 Mar 2007 19:53:42 -0800
Message-ID: <200703060353.l263rgBV011110@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49453 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933925AbXCFD5C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:57:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix the ROMFS_* dependencies
has been removed from the -mm tree.  Its filename was
     fix-the-romfs_-dependencies.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fix the ROMFS_* dependencies
From: Adrian Bunk <bunk@stusta.de>

- adds the missing dependency of ROMFS_FS on BLOCK || MTD
- disallows the illegal ROMFS_FS=y, MTD=m, ROMFS_ON_MTD=y
- ensures that at least one of ROMFS_ON_BLOCK and ROMFS_ON_MTD is always
  enabled:
  - automatically enable ROMFS_ON_MTD if BLOCK=n
  - automatically enable ROMFS_ON_BLOCK if ROMFS_ON_MTD=n
- if EMBEDDED=n, ROMFS_ON_BLOCK is always enabled
  - the "(which may have been disabled)" that could now confuse
    users has therefore been removed from the help text

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN fs/Kconfig~fix-the-romfs_-dependencies fs/Kconfig
--- a/fs/Kconfig~fix-the-romfs_-dependencies
+++ a/fs/Kconfig
@@ -482,6 +482,7 @@ endif
 
 config ROMFS_FS
 	tristate "ROM file system support"
+	depends on BLOCK || MTD
 	---help---
 	  This is a very small read-only file system mainly intended for
 	  initial ram disks of installation disks, but it could be used for
@@ -497,8 +498,9 @@ config ROMFS_FS
 	  answer N.
 
 config ROMFS_ON_BLOCK
-	bool "Block device-backed ROM file system support"
+	bool "Block device-backed ROM file system support" if (ROMFS_ON_MTD && EMBEDDED)
 	depends on ROMFS_FS && BLOCK
+	default y
 	help
 	  This permits ROMFS to use block devices buffered through the page
 	  cache as the medium from which to retrieve data.  It does not allow
@@ -507,14 +509,15 @@ config ROMFS_ON_BLOCK
 	  If unsure, answer Y.
 
 config ROMFS_ON_MTD
-	bool "MTD-backed ROM file system support"
-	depends on ROMFS_FS && MTD
+	bool "MTD-backed ROM file system support" if BLOCK
+	depends on ROMFS_FS
+	depends on MTD=y || (ROMFS_FS=m && MTD)
+	default y
 	help
 	  This permits ROMFS to use MTD based devices directly, without the
-	  intercession of the block layer (which may have been disabled).  It
-	  also allows direct mapping of MTD devices through romfs files under
-	  NOMMU conditions if the underlying device is directly addressable by
-	  the CPU.
+	  intercession of the block layer.  It also allows direct mapping of
+	  MTD devices through romfs files under NOMMU conditions if the
+	  underlying device is directly addressable by the CPU.
 
 	  If unsure, answer Y.
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-arch-i386-kernel-tscccustom_sched_clock.patch
drivers-cpuidle-make-code-static.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
