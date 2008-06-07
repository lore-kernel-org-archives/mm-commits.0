From: akpm@linux-foundation.org
Subject: - fbdev-convert-sticorec-to-pci-rom-api.patch removed from -mm tree
Date: Fri, 06 Jun 2008 18:42:10 -0700
Message-ID: <200806070142.m571gAWp029774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbYFGBnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 21:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, James.Bottomley@HansenPartnership.com, deller@gmx.de, grundler@parisc-linux.org, jonsmirl@yahoo.com, matthew@wil.cx, mrmacman_g4@mac.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: convert sticore.c to PCI ROM API
has been removed from the -mm tree.  Its filename was
     fbdev-convert-sticorec-to-pci-rom-api.patch

This patch was dropped because it seems rather up in the air

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: convert sticore.c to PCI ROM API
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Convert console/sticore.c file to use PCI ROM API.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9425

This patch was fixed and tested by Helge Deller on his PARISC machine.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Jon Smirl <jonsmirl@yahoo.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/sticore.c |   35 +++++++++++++-----------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff -puN drivers/video/console/sticore.c~fbdev-convert-sticorec-to-pci-rom-api drivers/video/console/sticore.c
--- a/drivers/video/console/sticore.c~fbdev-convert-sticorec-to-pci-rom-api
+++ a/drivers/video/console/sticore.c
@@ -780,11 +780,13 @@ out_err:
 }
 
 static struct sti_struct * __devinit
-sti_try_rom_generic(unsigned long address, unsigned long hpa, struct pci_dev *pd)
+sti_try_rom_generic(unsigned long address, unsigned long hpa,
+		    struct pci_dev *pd)
 {
+	char __iomem *rom_base = (char __iomem *) address;
 	struct sti_struct *sti;
 	int ok;
-	u32 sig;
+	__le32 sig;
 
 	if (num_sti_roms >= MAX_STI_ROMS) {
 		printk(KERN_WARNING "maximum number of STI ROMS reached !\n");
@@ -808,7 +810,7 @@ test_rom:
 	sig = gsc_readl(address);
 
 	/* check for a PCI ROM structure */
-	if ((le32_to_cpu(sig)==0xaa55)) {
+	if (sig == cpu_to_le32(0xaa55)) {
 		unsigned int i, rm_offset;
 		u32 *rm;
 		i = gsc_readl(address+0x04);
@@ -868,10 +870,8 @@ test_rom:
 	/* disable STI PCI ROM. ROM and card RAM overlap and
 	 * leaving it enabled would force HPMCs
 	 */
-	if (sti->pd) {
-		unsigned long rom_base;
-		rom_base = pci_resource_start(sti->pd, PCI_ROM_RESOURCE);	
-		pci_write_config_dword(sti->pd, PCI_ROM_ADDRESS, rom_base & ~PCI_ROM_ADDRESS_ENABLE);
+	if (sti->pd && rom_base) {
+		pci_unmap_rom(sti->pd, rom_base);
 		DPRINTK((KERN_DEBUG "STI PCI ROM disabled\n"));
 	}
 
@@ -930,28 +930,25 @@ static int __devinit sticore_pci_init(st
 		const struct pci_device_id *ent)
 {
 #ifdef CONFIG_PCI
-	unsigned long fb_base, rom_base;
-	unsigned int fb_len, rom_len;
+	unsigned long fb_base;
+	unsigned int fb_len;
+	char __iomem *rom_base;
+	size_t rom_len;
 	struct sti_struct *sti;
 	
 	pci_enable_device(pd);
 
 	fb_base = pci_resource_start(pd, 0);
 	fb_len = pci_resource_len(pd, 0);
-	rom_base = pci_resource_start(pd, PCI_ROM_RESOURCE);
-	rom_len = pci_resource_len(pd, PCI_ROM_RESOURCE);
-	if (rom_base) {
-		pci_write_config_dword(pd, PCI_ROM_ADDRESS, rom_base | PCI_ROM_ADDRESS_ENABLE);
-		DPRINTK((KERN_DEBUG "STI PCI ROM enabled at 0x%08lx\n", rom_base));
-	}
+	rom_base = pci_map_rom(pd, &rom_len);
 
-	printk(KERN_INFO "STI PCI graphic ROM found at %08lx (%u kB), fb at %08lx (%u MB)\n",
+	printk(KERN_INFO "STI PCI graphic ROM found at %p (%u kB), fb at %08lx (%u MB)\n",
 		rom_base, rom_len/1024, fb_base, fb_len/1024/1024);
 
-	DPRINTK((KERN_DEBUG "Trying PCI STI ROM at %08lx, PCI hpa at %08lx\n",
+	DPRINTK((KERN_DEBUG "Trying PCI STI ROM at %p, PCI hpa at %08lx\n",
 		    rom_base, fb_base));
 
-	sti = sti_try_rom_generic(rom_base, fb_base, pd);
+	sti = sti_try_rom_generic((unsigned long)rom_base, fb_base, pd);
 	if (sti) {
 		char pa_path[30];
 		print_pci_hwpath(pd, pa_path);
@@ -975,7 +972,7 @@ static void __devexit sticore_pci_remove
 }
 
 
-static struct pci_device_id sti_pci_tbl[] = {
+DEFINE_PCI_DEVICE_TABLE(sti_pci_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, PCI_DEVICE_ID_HP_VISUALIZE_EG) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, PCI_DEVICE_ID_HP_VISUALIZE_FX6) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, PCI_DEVICE_ID_HP_VISUALIZE_FX4) },
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch
fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
tridentfb-fix-224-color-logo-at-8-bpp.patch
tridentfb-y-panning-fixes.patch
tridentfb-blade3d-clock-fixes.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch
vfb-only-enable-if-explicitly-requested-when-compiled-in.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch
skeletonfb-update-to-correct-platform-driver-usage.patch
fbdev-convert-sticorec-to-pci-rom-api.patch

