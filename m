From: akpm@linux-foundation.org
Subject: + fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:06:54 -0700
Message-ID: <200708311906.l7VJ6xgf022207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932654AbXHaTHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, adaplas@gmail.com


The patch titled
     fbcon: Convert struct font_desc to use ISO C initializers (update)
has been added to the -mm tree.  Its filename is
     fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.pa=
tch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: fbcon: Convert struct font_desc to use ISO C initializers (upd=
ate)
=46rom: Ralf Baechle <ralf@linux-mips.org>

Akpm's patch "newport_con warning fix" got me to look at the console
drivers again and one thing that I noticed was that none of the fonts
was using ISO initializers for it's fonts.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/cr_bllcd.c |  146 +--------------------------
 1 files changed, 10 insertions(+), 136 deletions(-)

diff -puN drivers/video/backlight/cr_bllcd.c~fbcon-convert-struct-font_=
desc-to-use-iso-c-initializers-update drivers/video/backlight/cr_bllcd.=
c
--- a/drivers/video/backlight/cr_bllcd.c~fbcon-convert-struct-font_desc=
-to-use-iso-c-initializers-update
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -25,7 +25,6 @@
  * Authors:
  *   Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
  *   Alan Hourihane <alanh-at-tungstengraphics-dot-com>
- *   Michel D=E4nzer <michel-at-tungstengraphics-dot-com>
  */
=20
 #include <linux/module.h>
@@ -39,8 +38,6 @@
 #include <linux/pci.h>
 #include <asm/uaccess.h>
=20
-#define MODULE_NAME "cr_bllcd"
-
 /* The LVDS- and panel power controls sits on the
  * GPIO port of the ISA bridge.
  */
@@ -54,25 +51,19 @@
 #define CRVML_PANEL_ON      0x00000002
 #define CRVML_BACKLIGHT_OFF 0x00000004
=20
+/* The PLL Clock register sits on Host bridge */
+#define CRVML_DEVICE_MCH   0x5001
+#define CRVML_REG_MCHBAR   0x44
+#define CRVML_REG_MCHEN    0x54
+#define CRVML_MCHEN_BIT    (1 << 28)
+#define CRVML_MCHMAP_SIZE  4096
+#define CRVML_REG_CLOCK    0xc3c
+#define CRVML_CLOCK_SHIFT  8
+#define CRVML_CLOCK_MASK   0x00000f00
+
 static struct pci_dev *lpc_dev;
 static u32 gpio_bar;
=20
-#ifdef CONFIG_PM
-
-#define NUM_LPC_EXTRA_CONFIG_SPACE 45
-static int lpc_saved_config_space[NUM_LPC_EXTRA_CONFIG_SPACE];
-
-#define CRVML_REG_RCBABAR   0xF0
-#define CRVML_RCBAEN_BIT    (1 << 0)
-#define CRVML_RCBAMAP_SIZE  16384
-static u32 rcba_bar;
-static void __iomem *rcba_regs_base;
-
-#define REGSAVE_SIZE (CRVML_RCBAMAP_SIZE + 4)
-static u32 *regsave;
-
-#endif /* CONFIG_PM */
-
 struct cr_panel {
 	struct backlight_device *cr_backlight_device;
 	struct lcd_device *cr_lcd_device;
@@ -178,94 +169,6 @@ static struct lcd_ops cr_lcd_ops =3D {
 	.set_power =3D cr_lcd_set_power,
 };
=20
-#ifdef CONFIG_PM
-
-static int cr_backlight_suspend(struct platform_device *pdev,
-				pm_message_t state)
-{
-	int i;
-	int reg;
-	int saveidx =3D 0;
-
-	printk(KERN_DEBUG MODULE_NAME ": suspending to state: %d\n",
-	       state.event);
-
-	regsave =3D kmalloc(REGSAVE_SIZE, GFP_ATOMIC);
-
-	if (!regsave) {
-		printk(KERN_ERR MODULE_NAME
-		       ": Could not allocate %d bytes for saving registers\n",
-		       REGSAVE_SIZE);
-		return -ENOMEM;
-	}
-
-	/* Save registers and config space */
-
-	regsave[saveidx++] =3D inl(gpio_bar + CRVML_PANEL_PORT);
-
-	for (reg =3D 0; reg < CRVML_RCBAMAP_SIZE; reg +=3D 4)
-		regsave[saveidx++] =3D ioread32(rcba_regs_base + reg);
-
-	pci_save_state(lpc_dev);
-	for (i =3D 0; i < NUM_LPC_EXTRA_CONFIG_SPACE; i++)
-		pci_read_config_dword(lpc_dev, (i + 16) * 4,
-				      &lpc_saved_config_space[i]);
-	pci_disable_device(lpc_dev);
-	pci_set_power_state(lpc_dev, pci_choose_state(lpc_dev, state));
-
-	pdev->dev.power.power_state =3D state;
-
-	return 0;
-}
-
-static int cr_backlight_resume(struct platform_device *pdev)
-{
-	int i;
-	int reg;
-	int val;
-	int restoreidx =3D 0;
-
-	if (pdev->dev.power.power_state.event =3D=3D PM_EVENT_ON)
-		return 0;
-
-	pci_set_power_state(lpc_dev, PCI_D0);
-	pci_restore_state(lpc_dev);
-	for (i =3D 0; i < NUM_LPC_EXTRA_CONFIG_SPACE; i++) {
-		if (i =3D=3D 0x70 / 4)
-			continue;
-
-		pci_read_config_dword(lpc_dev, (i + 16) * 4, &val);
-		if (val !=3D lpc_saved_config_space[i]) {
-			printk(KERN_DEBUG MODULE_NAME ": Writing back config "
-			       "space on device %s at offset %x (was %x, "
-			       "writing %x)\n", pci_name(lpc_dev), (i + 16),
-			       val, lpc_saved_config_space[i]);
-			pci_write_config_dword(lpc_dev, (i + 16) * 4,
-					       lpc_saved_config_space[i]);
-		}
-	}
-	if (pci_enable_device(lpc_dev))
-		return -1;
-
-	outl(regsave[restoreidx++], gpio_bar + CRVML_PANEL_PORT);
-
-	for (reg =3D 0; reg < CRVML_RCBAMAP_SIZE; reg +=3D 4)
-		iowrite32(regsave[restoreidx++], rcba_regs_base + reg);
-
-	/* Flush posted writes */
-	ioread32(rcba_regs_base);
-
-	kfree(regsave);
-
-	pdev->dev.power.power_state =3D PMSG_ON;
-
-	printk(KERN_DEBUG MODULE_NAME ": resumed\n");
-
-	return 0;
-}
-
-#endif /* CONFIG_PM */
-
 static int cr_backlight_probe(struct platform_device *pdev)
 {
 	struct backlight_device *bdp;
@@ -325,26 +228,6 @@ static int cr_backlight_probe(struct pla
=20
 	platform_set_drvdata(pdev, crp);
=20
-#ifdef CONFIG_PM
-	pci_read_config_dword(lpc_dev, CRVML_REG_RCBABAR, &rcba_bar);
-
-	if (!(rcba_bar & CRVML_RCBAEN_BIT)) {
-		printk(KERN_ERR MODULE_NAME
-		       ": Carillo Ranch LPC device RCBA BAR was not enabled\n");
-		pci_dev_put(lpc_dev);
-		return -ENODEV;
-	}
-
-	rcba_regs_base =3D
-	    ioremap_nocache(rcba_bar, CRVML_RCBAMAP_SIZE);
-	if (!rcba_regs_base) {
-		printk(KERN_ERR MODULE_NAME
-		       ": Could not map Carillo Ranch RCBA BAR\n");
-		pci_dev_put(lpc_dev);
-		return -ENODEV;
-	}
-#endif /* CONFIG_PM */
-
 	return 0;
 }
=20
@@ -358,11 +241,6 @@ static int cr_backlight_remove(struct pl
 	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
-	platform_set_drvdata(pdev, NULL);
-#ifdef CONFIG_PM
-	iounmap(rcba_regs_base);
-#endif
-	kfree(crp);
 	pci_dev_put(lpc_dev);
=20
 	return 0;
@@ -374,10 +252,6 @@ static struct platform_driver cr_backlig
 	.driver =3D {
 		   .name =3D "cr_backlight",
 		   },
-#ifdef CONFIG_PM
-	.suspend =3D cr_backlight_suspend,
-	.resume =3D cr_backlight_resume,
-#endif
 };
=20
 static struct platform_device *crp;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlook=
ed-files.patch
git-mtd.patch
git-netdev-all.patch
ioc3-program-uart-predividers.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
