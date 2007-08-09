From: akpm@linux-foundation.org
Subject: + x86_64-efi-boot-support-efi-frame-buffer-driver.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:22:59 -0700
Message-ID: <200708092122.l79LMxic020180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932570AbXHIVXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:23:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, adaplas@pol.net, ak@suse.de, mouli@linux.intel.com


The patch titled
     x86_64 EFI boot support: EFI frame buffer driver
has been added to the -mm tree.  Its filename is
     x86_64-efi-boot-support-efi-frame-buffer-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 EFI boot support: EFI frame buffer driver
From: "Huang, Ying" <ying.huang@intel.com>

Following sets of patches add EFI/UEFI (Unified Extensible Firmware Interface)
boot support to x86_64 architecture.  The EFI runtime service support is not
added by the patches.  The patches have been tested against 2.6.23-rc2 kernel
on Intel platforms with EFI1.10 and UEFI2.0 firmware.  With this set of
patches applied, the 64bit and 32bit x86 kernel can be booted on x86_64
machine with UEFI64 firmware.

Because the EFI memory map is converted to E820 map in bootloader, now the
only needed code for booting Linux kernel on x86_64 UEFI platform is the
framebuffer driver.

UEFI specification can be found here: http://www.uefi.org

For booting the UEFI x86_64 enabled kernel, the machine with EFI/UEFI firmware
and the support of bootloader is required.  Detailed usage guide can be found
in Documentation/x86_64/uefi.txt, which is added in the patch: EFI boot
document

Known issues:

- Boot protocol: because the real mode BIOS call can not be used in
  EFI platform, the standard boot protocol defined in
  Documentation/i386/boot.txt can not be used by EFI based
  bootloader. So, a internal boot protocol defined in
  Documentation/i386/zero-page.txt is used instead. Since this
  internal boot protocol is also used by many other bootloaders, such
  as kexec, LinuxBIOS and Gujin etc, maybe it is better to make this
  internal boot protocol become a public 32bit boot protocol for Linux
  kernel.

- Firmware information, such as ACPI root pointer, smbios pointer,
  etc. In orignal EFI supporting code, various firmware information is
  gotten through EFI configuration tables. But, I think the
  corresponding firmware support code need not depend on the EFI
  support. So, I think maybe it is a better idea to add these firmware
  information to 32bit boot protocol proposed previously, and they can
  be filled by bootloader if available.


This patch:

Add Graphics Output Protocol support to the kernel.  UEFI2.0 spec deprecates
Universal Graphics Adapter (UGA) protocol and only Graphics Output Protocol
(GOP) is produced.  Therefore, the boot loader needs to query the UEFI
firmware with appropriate Output Protocol and pass the video information to
the kernel.  As a result of GOP protocol, an EFI framebuffer driver is needed
for displaying console messages.  The patch adds a EFI framebuffer driver. 
The EFI frame buffer driver in this patch is based on the Intel Mac
framebuffer driver.

The ELILO bootloader takes care of passing the video information as
appropriate for EFI firmware.

The framebuffer driver has been tested in i386 kernel and x86_64 kernel on EFI
platform.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig       |   11 +
 drivers/video/Makefile      |    1 
 drivers/video/efifb.c       |  232 ++++++++++++++++++++++++++++++++++
 include/linux/screen_info.h |    1 
 4 files changed, 245 insertions(+)

diff -puN drivers/video/Kconfig~x86_64-efi-boot-support-efi-frame-buffer-driver drivers/video/Kconfig
--- a/drivers/video/Kconfig~x86_64-efi-boot-support-efi-frame-buffer-driver
+++ a/drivers/video/Kconfig
@@ -604,6 +604,17 @@ config FB_VESA
 	  You will get a boot time penguin logo at no additional cost. Please
 	  read <file:Documentation/fb/vesafb.txt>. If unsure, say Y.
 
+config FB_EFI
+	bool "EFI-based Framebuffer Support"
+	depends on (FB = y) && X86
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the EFI frame buffer device driver. If the firmware on
+	  your platform is UEFI2.0, select Y to add support for
+	  Graphics Output Protocol for early console messages to appear.
+
 config FB_IMAC
 	bool "Intel-based Macintosh Framebuffer Support"
 	depends on (FB = y) && X86 && EFI
diff -puN drivers/video/Makefile~x86_64-efi-boot-support-efi-frame-buffer-driver drivers/video/Makefile
--- a/drivers/video/Makefile~x86_64-efi-boot-support-efi-frame-buffer-driver
+++ a/drivers/video/Makefile
@@ -117,6 +117,7 @@ obj-$(CONFIG_FB_OMAP)             += oma
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_VESA)             += vesafb.o
 obj-$(CONFIG_FB_IMAC)             += imacfb.o
+obj-$(CONFIG_FB_EFI)              += efifb.o
 obj-$(CONFIG_FB_VGA16)            += vga16fb.o
 obj-$(CONFIG_FB_OF)               += offb.o
 
diff -puN /dev/null drivers/video/efifb.c
--- /dev/null
+++ a/drivers/video/efifb.c
@@ -0,0 +1,232 @@
+/*
+ * framebuffer driver for EFI/UEFI based system
+ *
+ * (c) 2006 Edgar Hucek <gimli@dark-green.com>
+ * Original efi driver written by Gerd Knorr <kraxel@goldbach.in-berlin.de>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/platform_device.h>
+#include <linux/screen_info.h>
+
+#include <video/vga.h>
+
+static struct fb_var_screeninfo efifb_defined __initdata = {
+	.activate		= FB_ACTIVATE_NOW,
+	.height			= -1,
+	.width			= -1,
+	.right_margin		= 32,
+	.upper_margin		= 16,
+	.lower_margin		= 4,
+	.vsync_len		= 4,
+	.vmode			= FB_VMODE_NONINTERLACED,
+};
+
+static struct fb_fix_screeninfo efifb_fix __initdata = {
+	.id			= "EFI VGA",
+	.type			= FB_TYPE_PACKED_PIXELS,
+	.accel			= FB_ACCEL_NONE,
+	.visual			= FB_VISUAL_TRUECOLOR,
+};
+
+static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info)
+{
+	/*
+	 *  Set a single color register. The values supplied are
+	 *  already rounded down to the hardware's capabilities
+	 *  (according to the entries in the `var' structure). Return
+	 *  != 0 for invalid regno.
+	 */
+
+	if (regno >= info->cmap.len)
+		return 1;
+
+	if (regno < 16) {
+		red   >>= 8;
+		green >>= 8;
+		blue  >>= 8;
+		((u32 *)(info->pseudo_palette))[regno] =
+			(red   << info->var.red.offset)   |
+			(green << info->var.green.offset) |
+			(blue  << info->var.blue.offset);
+	}
+	return 0;
+}
+
+static struct fb_ops efifb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_setcolreg	= efifb_setcolreg,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+static int __init efifb_probe(struct platform_device *dev)
+{
+	struct fb_info *info;
+	int err;
+	unsigned int size_vmode;
+	unsigned int size_remap;
+	unsigned int size_total;
+
+	efifb_fix.smem_start = screen_info.lfb_base;
+	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
+	efifb_defined.xres = screen_info.lfb_width;
+	efifb_defined.yres = screen_info.lfb_height;
+	efifb_fix.line_length = screen_info.lfb_linelength;
+
+	/*   size_vmode -- that is the amount of memory needed for the
+	 *                 used video mode, i.e. the minimum amount of
+	 *                 memory we need. */
+	size_vmode = efifb_defined.yres * efifb_fix.line_length;
+
+	/*   size_total -- all video memory we have. Used for
+	 *                 entries, ressource allocation and bounds
+	 *                 checking. */
+	size_total = screen_info.lfb_size;
+	if (size_total < size_vmode)
+		size_total = size_vmode;
+
+	/*   size_remap -- the amount of video memory we are going to
+	 *                 use for efifb.  With modern cards it is no
+	 *                 option to simply use size_total as that
+	 *                 wastes plenty of kernel address space. */
+	size_remap  = size_vmode * 2;
+	if (size_remap < size_vmode)
+		size_remap = size_vmode;
+	if (size_remap > size_total)
+		size_remap = size_total;
+	efifb_fix.smem_len = size_remap;
+
+	if (!request_mem_region(efifb_fix.smem_start, size_total, "efifb"))
+		/* We cannot make this fatal. Sometimes this comes from magic
+		   spaces our resource handlers simply don't know about */
+		printk(KERN_WARNING
+		       "efifb: cannot reserve video memory at 0x%lx\n",
+			efifb_fix.smem_start);
+
+	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
+	if (!info) {
+		err = -ENOMEM;
+		goto err_release_mem;
+	}
+	info->pseudo_palette = info->par;
+	info->par = NULL;
+
+	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
+	if (!info->screen_base) {
+		printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
+				"0x%x @ 0x%lx\n",
+			efifb_fix.smem_len, efifb_fix.smem_start);
+		err = -EIO;
+		goto err_unmap;
+	}
+
+	printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
+	       "using %dk, total %dk\n",
+	       efifb_fix.smem_start, info->screen_base,
+	       size_remap/1024, size_total/1024);
+	printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+	       efifb_defined.xres, efifb_defined.yres,
+	       efifb_defined.bits_per_pixel, efifb_fix.line_length,
+	       screen_info.pages);
+
+	efifb_defined.xres_virtual = efifb_defined.xres;
+	efifb_defined.yres_virtual = efifb_fix.smem_len /
+					efifb_fix.line_length;
+	printk(KERN_INFO "efifb: scrolling: redraw\n");
+	efifb_defined.yres_virtual = efifb_defined.yres;
+
+	/* some dummy values for timing to make fbset happy */
+	efifb_defined.pixclock     = 10000000 / efifb_defined.xres *
+					1000 / efifb_defined.yres;
+	efifb_defined.left_margin  = (efifb_defined.xres / 8) & 0xf8;
+	efifb_defined.hsync_len    = (efifb_defined.xres / 8) & 0xf8;
+
+	efifb_defined.red.offset    = screen_info.red_pos;
+	efifb_defined.red.length    = screen_info.red_size;
+	efifb_defined.green.offset  = screen_info.green_pos;
+	efifb_defined.green.length  = screen_info.green_size;
+	efifb_defined.blue.offset   = screen_info.blue_pos;
+	efifb_defined.blue.length   = screen_info.blue_size;
+	efifb_defined.transp.offset = screen_info.rsvd_pos;
+	efifb_defined.transp.length = screen_info.rsvd_size;
+
+	printk(KERN_INFO "efifb: %s: "
+	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
+	       "Truecolor",
+	       screen_info.rsvd_size,
+	       screen_info.red_size,
+	       screen_info.green_size,
+	       screen_info.blue_size,
+	       screen_info.rsvd_pos,
+	       screen_info.red_pos,
+	       screen_info.green_pos,
+	       screen_info.blue_pos);
+
+	efifb_fix.ypanstep  = 0;
+	efifb_fix.ywrapstep = 0;
+
+	info->fbops = &efifb_ops;
+	info->var = efifb_defined;
+	info->fix = efifb_fix;
+	info->flags = FBINFO_FLAG_DEFAULT;
+
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		err = -ENOMEM;
+		goto err_unmap;
+	}
+	if (register_framebuffer(info) < 0) {
+		err = -EINVAL;
+		goto err_fb_dealoc;
+	}
+	printk(KERN_INFO "fb%d: %s frame buffer device\n",
+	       info->node, info->fix.id);
+	return 0;
+
+err_fb_dealoc:
+	fb_dealloc_cmap(&info->cmap);
+err_unmap:
+	iounmap(info->screen_base);
+	framebuffer_release(info);
+err_release_mem:
+	release_mem_region(efifb_fix.smem_start, size_total);
+	return err;
+}
+
+static struct platform_driver efifb_driver = {
+	.probe	= efifb_probe,
+	.driver	= {
+		.name	= "efifb",
+	},
+};
+
+static struct platform_device efifb_device = {
+	.name	= "efifb",
+};
+
+static int __init efifb_init(void)
+{
+	int ret;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return -ENODEV;
+
+	ret = platform_driver_register(&efifb_driver);
+
+	if (!ret) {
+		ret = platform_device_register(&efifb_device);
+		if (ret)
+			platform_driver_unregister(&efifb_driver);
+	}
+	return ret;
+}
+module_init(efifb_init);
+
+MODULE_LICENSE("GPL");
diff -puN include/linux/screen_info.h~x86_64-efi-boot-support-efi-frame-buffer-driver include/linux/screen_info.h
--- a/include/linux/screen_info.h~x86_64-efi-boot-support-efi-frame-buffer-driver
+++ a/include/linux/screen_info.h
@@ -62,6 +62,7 @@ extern struct screen_info screen_info;
 #define VIDEO_TYPE_EGAC		0x21	/* EGA in Color Mode		*/
 #define VIDEO_TYPE_VGAC		0x22	/* VGA+ in Color Mode		*/
 #define VIDEO_TYPE_VLFB		0x23	/* VESA VGA in graphic mode	*/
+#define VIDEO_TYPE_EFI		0x24	/* EFI graphic mode		*/
 
 #define VIDEO_TYPE_PICA_S3	0x30	/* ACER PICA-61 local S3 video	*/
 #define VIDEO_TYPE_MIPS_G364	0x31    /* MIPS Magnum 4000 G364 video  */
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-boot-support-efi-frame-buffer-driver.patch
x86_64-efi-boot-support-efi-boot-document.patch
