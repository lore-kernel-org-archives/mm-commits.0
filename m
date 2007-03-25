From: akpm@linux-foundation.org
Subject: + drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:25:36 -0800
Message-ID: <200703252225.l2PMPa3k004168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXCYW2u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, greg@kroah.com


The patch titled
     drivers/eisa/pci_eisa.c:pci_eisa_init() should be init
has been added to the -mm tree.  Its filename is
     drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/eisa/pci_eisa.c:pci_eisa_init() should be init
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:eisa_root_register from .text between 'pci_eisa_init' (at offset 0xabf670) and 'virtual_eisa_release'

AFAIK a PCI to EISA bridge isn't anything hotpluggable, so
pci_eisa_init() can become __init.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/eisa/pci_eisa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/eisa/pci_eisa.c~drivers-eisa-pci_eisacpci_eisa_init-should-be-init drivers/eisa/pci_eisa.c
--- a/drivers/eisa/pci_eisa.c~drivers-eisa-pci_eisacpci_eisa_init-should-be-init
+++ a/drivers/eisa/pci_eisa.c
@@ -19,8 +19,8 @@
 /* There is only *one* pci_eisa device per machine, right ? */
 static struct eisa_root_device pci_eisa_root;
 
-static int __devinit pci_eisa_init (struct pci_dev *pdev,
-				    const struct pci_device_id *ent)
+static int __init pci_eisa_init(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
 {
 	int rc;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-spi-fix-section-mismatches.patch
dynticks-fix-hrtimer-rounding-error-in.patch
clocksource-fix-thinko-in-watchdog-selection.patch
drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
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
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
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
