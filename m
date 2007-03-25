From: akpm@linux-foundation.org
Subject: + drivers-spi-fix-section-mismatches.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:35:22 -0800
Message-ID: <200703250935.l2P9ZM5Y024813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXCYJim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dbrownell@users.sourceforge.net


The patch titled
     drivers/spi/: fix section mismatches
has been added to the -mm tree.  Its filename is
     drivers-spi-fix-section-mismatches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/spi/: fix section mismatches
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:spi_register_master from .text between 'spi_bitbang_start' (at offset 0x84e11a) and 'bitbang_work'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:spi_alloc_master from .text between 'butterfly_attach' (at offset 0x84e681) and 'at25_remove'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:spi_new_device from .text between 'butterfly_attach' (at offset 0x84e7e4) and 'at25_remove'

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/spi/spi.c~drivers-spi-fix-section-mismatches drivers/spi/spi.c
--- a/drivers/spi/spi.c~drivers-spi-fix-section-mismatches
+++ a/drivers/spi/spi.c
@@ -189,8 +189,8 @@ static DECLARE_MUTEX(board_lock);
  * this is exported so that for example a USB or parport based adapter
  * driver could add devices (which it would learn about out-of-band).
  */
-struct spi_device *__init_or_module
-spi_new_device(struct spi_master *master, struct spi_board_info *chip)
+struct spi_device *spi_new_device(struct spi_master *master,
+				  struct spi_board_info *chip)
 {
 	struct spi_device	*proxy;
 	struct device		*dev = master->cdev.dev;
@@ -352,8 +352,7 @@ static struct class spi_master_class = {
  * the master's methods before calling spi_register_master(); and (after errors
  * adding the device) calling spi_master_put() to prevent a memory leak.
  */
-struct spi_master * __init_or_module
-spi_alloc_master(struct device *dev, unsigned size)
+struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
 {
 	struct spi_master	*master;
 
@@ -392,8 +391,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
  * After a successful return, the caller is responsible for calling
  * spi_unregister_master().
  */
-int __init_or_module
-spi_register_master(struct spi_master *master)
+int spi_register_master(struct spi_master *master)
 {
 	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<16) - 1);
 	struct device		*dev = master->cdev.dev;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-spi-fix-section-mismatches.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
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
make-struct-v9fs_cached_file_operations-static.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
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
