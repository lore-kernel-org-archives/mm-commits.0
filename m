From: akpm@linux-foundation.org
Subject: + fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:20 -0700
Message-ID: <200708272223.l7RMNKw4031623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055AbXH0WXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, adaplas@gmail.com


The patch titled
     fbcon: Convert struct font_desc to use ISO C initializers
has been added to the -mm tree.  Its filename is
     fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: fbcon: Convert struct font_desc to use ISO C initializers
=46rom: Ralf Baechle <ralf@linux-mips.org>

Akpm's patch "newport_con warning fix" got me to look at the console dr=
ivers
again and one thing that I noticed was that none of the fonts was using=
 ISO
initializers for it's fonts.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/cr_bllcd.c     |  146 +++++++++++++++++++++--
 drivers/video/console/font_10x18.c     |   14 +-
 drivers/video/console/font_6x11.c      |   13 +-
 drivers/video/console/font_7x14.c      |   12 -
 drivers/video/console/font_8x16.c      |   12 -
 drivers/video/console/font_8x8.c       |   12 -
 drivers/video/console/font_acorn_8x8.c |   14 +-
 drivers/video/console/font_mini_4x6.c  |   12 -
 drivers/video/console/font_pearl_8x8.c |   12 -
 drivers/video/console/font_sun12x22.c  |   14 +-
 drivers/video/console/font_sun8x16.c   |   14 +-
 11 files changed, 201 insertions(+), 74 deletions(-)

diff -puN drivers/video/backlight/cr_bllcd.c~fbcon-convert-struct-font_=
desc-to-use-iso-c-initializers drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~fbcon-convert-struct-font_desc=
-to-use-iso-c-initializers
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -25,6 +25,7 @@
  * Authors:
  *   Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
  *   Alan Hourihane <alanh-at-tungstengraphics-dot-com>
+ *   Michel D=E4nzer <michel-at-tungstengraphics-dot-com>
  */
=20
 #include <linux/module.h>
@@ -38,6 +39,8 @@
 #include <linux/pci.h>
 #include <asm/uaccess.h>
=20
+#define MODULE_NAME "cr_bllcd"
+
 /* The LVDS- and panel power controls sits on the
  * GPIO port of the ISA bridge.
  */
@@ -51,19 +54,25 @@
 #define CRVML_PANEL_ON      0x00000002
 #define CRVML_BACKLIGHT_OFF 0x00000004
=20
-/* The PLL Clock register sits on Host bridge */
-#define CRVML_DEVICE_MCH   0x5001
-#define CRVML_REG_MCHBAR   0x44
-#define CRVML_REG_MCHEN    0x54
-#define CRVML_MCHEN_BIT    (1 << 28)
-#define CRVML_MCHMAP_SIZE  4096
-#define CRVML_REG_CLOCK    0xc3c
-#define CRVML_CLOCK_SHIFT  8
-#define CRVML_CLOCK_MASK   0x00000f00
-
 static struct pci_dev *lpc_dev;
 static u32 gpio_bar;
=20
+#ifdef CONFIG_PM
+
+#define NUM_LPC_EXTRA_CONFIG_SPACE 45
+static int lpc_saved_config_space[NUM_LPC_EXTRA_CONFIG_SPACE];
+
+#define CRVML_REG_RCBABAR   0xF0
+#define CRVML_RCBAEN_BIT    (1 << 0)
+#define CRVML_RCBAMAP_SIZE  16384
+static u32 rcba_bar;
+static void __iomem *rcba_regs_base;
+
+#define REGSAVE_SIZE (CRVML_RCBAMAP_SIZE + 4)
+static u32 *regsave;
+
+#endif /* CONFIG_PM */
+
 struct cr_panel {
 	struct backlight_device *cr_backlight_device;
 	struct lcd_device *cr_lcd_device;
@@ -169,6 +178,94 @@ static struct lcd_ops cr_lcd_ops =3D {
 	.set_power =3D cr_lcd_set_power,
 };
=20
+#ifdef CONFIG_PM
+
+static int cr_backlight_suspend(struct platform_device *pdev,
+				pm_message_t state)
+{
+	int i;
+	int reg;
+	int saveidx =3D 0;
+
+	printk(KERN_DEBUG MODULE_NAME ": suspending to state: %d\n",
+	       state.event);
+
+	regsave =3D kmalloc(REGSAVE_SIZE, GFP_ATOMIC);
+
+	if (!regsave) {
+		printk(KERN_ERR MODULE_NAME
+		       ": Could not allocate %d bytes for saving registers\n",
+		       REGSAVE_SIZE);
+		return -ENOMEM;
+	}
+
+	/* Save registers and config space */
+
+	regsave[saveidx++] =3D inl(gpio_bar + CRVML_PANEL_PORT);
+
+	for (reg =3D 0; reg < CRVML_RCBAMAP_SIZE; reg +=3D 4)
+		regsave[saveidx++] =3D ioread32(rcba_regs_base + reg);
+
+	pci_save_state(lpc_dev);
+	for (i =3D 0; i < NUM_LPC_EXTRA_CONFIG_SPACE; i++)
+		pci_read_config_dword(lpc_dev, (i + 16) * 4,
+				      &lpc_saved_config_space[i]);
+	pci_disable_device(lpc_dev);
+	pci_set_power_state(lpc_dev, pci_choose_state(lpc_dev, state));
+
+	pdev->dev.power.power_state =3D state;
+
+	return 0;
+}
+
+static int cr_backlight_resume(struct platform_device *pdev)
+{
+	int i;
+	int reg;
+	int val;
+	int restoreidx =3D 0;
+
+	if (pdev->dev.power.power_state.event =3D=3D PM_EVENT_ON)
+		return 0;
+
+	pci_set_power_state(lpc_dev, PCI_D0);
+	pci_restore_state(lpc_dev);
+	for (i =3D 0; i < NUM_LPC_EXTRA_CONFIG_SPACE; i++) {
+		if (i =3D=3D 0x70 / 4)
+			continue;
+
+		pci_read_config_dword(lpc_dev, (i + 16) * 4, &val);
+		if (val !=3D lpc_saved_config_space[i]) {
+			printk(KERN_DEBUG MODULE_NAME ": Writing back config "
+			       "space on device %s at offset %x (was %x, "
+			       "writing %x)\n", pci_name(lpc_dev), (i + 16),
+			       val, lpc_saved_config_space[i]);
+			pci_write_config_dword(lpc_dev, (i + 16) * 4,
+					       lpc_saved_config_space[i]);
+		}
+	}
+	if (pci_enable_device(lpc_dev))
+		return -1;
+
+	outl(regsave[restoreidx++], gpio_bar + CRVML_PANEL_PORT);
+
+	for (reg =3D 0; reg < CRVML_RCBAMAP_SIZE; reg +=3D 4)
+		iowrite32(regsave[restoreidx++], rcba_regs_base + reg);
+
+	/* Flush posted writes */
+	ioread32(rcba_regs_base);
+
+	kfree(regsave);
+
+	pdev->dev.power.power_state =3D PMSG_ON;
+
+	printk(KERN_DEBUG MODULE_NAME ": resumed\n");
+
+	return 0;
+}
+
+#endif /* CONFIG_PM */
+
 static int cr_backlight_probe(struct platform_device *pdev)
 {
 	struct backlight_device *bdp;
@@ -228,6 +325,26 @@ static int cr_backlight_probe(struct pla
=20
 	platform_set_drvdata(pdev, crp);
=20
+#ifdef CONFIG_PM
+	pci_read_config_dword(lpc_dev, CRVML_REG_RCBABAR, &rcba_bar);
+
+	if (!(rcba_bar & CRVML_RCBAEN_BIT)) {
+		printk(KERN_ERR MODULE_NAME
+		       ": Carillo Ranch LPC device RCBA BAR was not enabled\n");
+		pci_dev_put(lpc_dev);
+		return -ENODEV;
+	}
+
+	rcba_regs_base =3D
+	    ioremap_nocache(rcba_bar, CRVML_RCBAMAP_SIZE);
+	if (!rcba_regs_base) {
+		printk(KERN_ERR MODULE_NAME
+		       ": Could not map Carillo Ranch RCBA BAR\n");
+		pci_dev_put(lpc_dev);
+		return -ENODEV;
+	}
+#endif /* CONFIG_PM */
+
 	return 0;
 }
=20
@@ -241,6 +358,11 @@ static int cr_backlight_remove(struct pl
 	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
+	platform_set_drvdata(pdev, NULL);
+#ifdef CONFIG_PM
+	iounmap(rcba_regs_base);
+#endif
+	kfree(crp);
 	pci_dev_put(lpc_dev);
=20
 	return 0;
@@ -252,6 +374,10 @@ static struct platform_driver cr_backlig
 	.driver =3D {
 		   .name =3D "cr_backlight",
 		   },
+#ifdef CONFIG_PM
+	.suspend =3D cr_backlight_suspend,
+	.resume =3D cr_backlight_resume,
+#endif
 };
=20
 static struct platform_device *crp;
diff -puN drivers/video/console/font_10x18.c~fbcon-convert-struct-font_=
desc-to-use-iso-c-initializers drivers/video/console/font_10x18.c
--- a/drivers/video/console/font_10x18.c~fbcon-convert-struct-font_desc=
-to-use-iso-c-initializers
+++ a/drivers/video/console/font_10x18.c
@@ -5133,14 +5133,14 @@ static const unsigned char fontdata_10x1
=20
=20
 const struct font_desc font_10x18 =3D {
-	FONT10x18_IDX,
-	"10x18",
-	10,
-	18,
-	fontdata_10x18,
+	.idx	=3D FONT10x18_IDX,
+	.name	=3D "10x18",
+	.width	=3D 10,
+	.height	=3D 18,
+	.data	=3D fontdata_10x18,
 #ifdef __sparc__
-	5
+	.pref	=3D 5,
 #else
-	-1
+	.pref	=3D -1,
 #endif
 };
diff -puN drivers/video/console/font_6x11.c~fbcon-convert-struct-font_d=
esc-to-use-iso-c-initializers drivers/video/console/font_6x11.c
--- a/drivers/video/console/font_6x11.c~fbcon-convert-struct-font_desc-=
to-use-iso-c-initializers
+++ a/drivers/video/console/font_6x11.c
@@ -3342,10 +3342,11 @@ static const unsigned char fontdata_6x11
=20
=20
 const struct font_desc font_vga_6x11 =3D {
-	VGA6x11_IDX,
-	"ProFont6x11",
-	6,
-	11,
-	fontdata_6x11,
-	-2000	/* Try avoiding this font if possible unless on MAC */
+	.idx	=3D VGA6x11_IDX,
+	.name	=3D "ProFont6x11",
+	.width	=3D 6,
+	.height	=3D 11,
+	.data	=3D fontdata_6x11,
+	/* Try avoiding this font if possible unless on MAC */
+	.pref	=3D -2000,
 };
diff -puN drivers/video/console/font_7x14.c~fbcon-convert-struct-font_d=
esc-to-use-iso-c-initializers drivers/video/console/font_7x14.c
--- a/drivers/video/console/font_7x14.c~fbcon-convert-struct-font_desc-=
to-use-iso-c-initializers
+++ a/drivers/video/console/font_7x14.c
@@ -4109,10 +4109,10 @@ static const unsigned char fontdata_7x14
=20
=20
 const struct font_desc font_7x14 =3D {
-	FONT7x14_IDX,
-	"7x14",
-	7,
-	14,
-	fontdata_7x14,
-	0
+	.idx	=3D FONT7x14_IDX,
+	.name	=3D "7x14",
+	.width	=3D 7,
+	.height	=3D 14,
+	.data	=3D fontdata_7x14,
+	.pref	=3D 0,
 };
diff -puN drivers/video/console/font_8x16.c~fbcon-convert-struct-font_d=
esc-to-use-iso-c-initializers drivers/video/console/font_8x16.c
--- a/drivers/video/console/font_8x16.c~fbcon-convert-struct-font_desc-=
to-use-iso-c-initializers
+++ a/drivers/video/console/font_8x16.c
@@ -4622,10 +4622,10 @@ static const unsigned char fontdata_8x16
=20
=20
 const struct font_desc font_vga_8x16 =3D {
-	VGA8x16_IDX,
-	"VGA8x16",
-	8,
-	16,
-	fontdata_8x16,
-	0
+	.idx	=3D VGA8x16_IDX,
+	.name	=3D "VGA8x16",
+	.width	=3D 8,
+	.height	=3D 16,
+	.data	=3D fontdata_8x16,
+	.pref	=3D 0,
 };
diff -puN drivers/video/console/font_8x8.c~fbcon-convert-struct-font_de=
sc-to-use-iso-c-initializers drivers/video/console/font_8x8.c
--- a/drivers/video/console/font_8x8.c~fbcon-convert-struct-font_desc-t=
o-use-iso-c-initializers
+++ a/drivers/video/console/font_8x8.c
@@ -2574,10 +2574,10 @@ static const unsigned char fontdata_8x8[
=20
=20
 const struct font_desc font_vga_8x8 =3D {
-	VGA8x8_IDX,
-	"VGA8x8",
-	8,
-	8,
-	fontdata_8x8,
-	0
+	.idx	=3D VGA8x8_IDX,
+	.name	=3D "VGA8x8",
+	.width	=3D 8,
+	.height	=3D 8,
+	.data	=3D fontdata_8x8,
+	.pref	=3D 0,
 };
diff -puN drivers/video/console/font_acorn_8x8.c~fbcon-convert-struct-f=
ont_desc-to-use-iso-c-initializers drivers/video/console/font_acorn_8x8=
=2Ec
--- a/drivers/video/console/font_acorn_8x8.c~fbcon-convert-struct-font_=
desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_acorn_8x8.c
@@ -262,14 +262,14 @@ static const unsigned char acorndata_8x8
 };
=20
 const struct font_desc font_acorn_8x8 =3D {
-	ACORN8x8_IDX,
-	"Acorn8x8",
-	8,
-	8,
-	acorndata_8x8,
+	.idx	=3D ACORN8x8_IDX,
+	.name	=3D "Acorn8x8",
+	.width	=3D 8,
+	.height	=3D 8,
+	.data	=3D acorndata_8x8,
 #ifdef CONFIG_ARCH_ACORN
-	20
+	.pref	=3D 20,
 #else
-	0
+	.pref	=3D 0,
 #endif
 };
diff -puN drivers/video/console/font_mini_4x6.c~fbcon-convert-struct-fo=
nt_desc-to-use-iso-c-initializers drivers/video/console/font_mini_4x6.c
--- a/drivers/video/console/font_mini_4x6.c~fbcon-convert-struct-font_d=
esc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_mini_4x6.c
@@ -2148,11 +2148,11 @@ static const unsigned char fontdata_mini
 };
=20
 const struct font_desc font_mini_4x6 =3D {
-	MINI4x6_IDX,
-	"MINI4x6",
-	4,
-	6,
-	fontdata_mini_4x6,
-	3
+	.idx	=3D MINI4x6_IDX,
+	.name	=3D "MINI4x6",
+	.width	=3D 4,
+	.height	=3D 6,
+	.data	=3D fontdata_mini_4x6,
+	.pref	=3D 3,
 };
=20
diff -puN drivers/video/console/font_pearl_8x8.c~fbcon-convert-struct-f=
ont_desc-to-use-iso-c-initializers drivers/video/console/font_pearl_8x8=
=2Ec
--- a/drivers/video/console/font_pearl_8x8.c~fbcon-convert-struct-font_=
desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_pearl_8x8.c
@@ -2578,10 +2578,10 @@ static const unsigned char fontdata_pear
 };
=20
 const struct font_desc font_pearl_8x8 =3D {
-	PEARL8x8_IDX,
-	"PEARL8x8",
-	8,
-	8,
-	fontdata_pearl8x8,
-	2
+	.idx	=3D PEARL8x8_IDX,
+	.name	=3D "PEARL8x8",
+	.width	=3D 8,
+	.height	=3D 8,
+	.data	=3D fontdata_pearl8x8,
+	.pref	=3D 2,
 };
diff -puN drivers/video/console/font_sun12x22.c~fbcon-convert-struct-fo=
nt_desc-to-use-iso-c-initializers drivers/video/console/font_sun12x22.c
--- a/drivers/video/console/font_sun12x22.c~fbcon-convert-struct-font_d=
esc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_sun12x22.c
@@ -6152,14 +6152,14 @@ static const unsigned char fontdata_sun1
=20
=20
 const struct font_desc font_sun_12x22 =3D {
-	SUN12x22_IDX,
-	"SUN12x22",
-	12,
-	22,
-	fontdata_sun12x22,
+	.idx	=3D SUN12x22_IDX,
+	.name	=3D "SUN12x22",
+	.width	=3D 12,
+	.height	=3D 22,
+	.data	=3D fontdata_sun12x22,
 #ifdef __sparc__
-	5
+	.pref	=3D 5,
 #else
-	-1
+	.pref	=3D -1,
 #endif
 };
diff -puN drivers/video/console/font_sun8x16.c~fbcon-convert-struct-fon=
t_desc-to-use-iso-c-initializers drivers/video/console/font_sun8x16.c
--- a/drivers/video/console/font_sun8x16.c~fbcon-convert-struct-font_de=
sc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_sun8x16.c
@@ -262,14 +262,14 @@ static const unsigned char fontdata_sun8
 };
=20
 const struct font_desc font_sun_8x16 =3D {
-	SUN8x16_IDX,
-	"SUN8x16",
-	8,
-	16,
-	fontdata_sun8x16,
+	.idx	=3D SUN8x16_IDX,
+	.name	=3D "SUN8x16",
+	.width	=3D 8,
+	.height	=3D 16,
+	.data	=3D fontdata_sun8x16,
 #ifdef __sparc__
-	10
+	.pref	=3D 10,
 #else
-	-1
+	.pref	=3D -1,
 #endif
 };
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
fix-font-dependency-for-sgi-newport-console-driver.patch
add-maintainers-entry-for-ioc3-serial-driver.patch
fix-modpost-warning-in-serial-driver.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-irix_getcontext-will-always-fail-efault.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlook=
ed-files.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
sgiseeq-fix-return-type-of-sgiseeq_remove.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
serio-fix-modpost-warning.patch
pci-section-warning-fix.patch
pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
vt-fix-warnings-in-selectionh.patch
define-global-bit-macro.patch
