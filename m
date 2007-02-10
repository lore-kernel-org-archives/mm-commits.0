From: akpm@linux-foundation.org
Subject: - drivers-add-lcd-support-update-4.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:10:26 -0800
Message-ID: <200702100810.l1A8AQYD006935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39259 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbXBJIKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:10:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers: add LCD support (update 4)
has been removed from the -mm tree.  Its filename was
     drivers-add-lcd-support-update-4.patch

This patch was dropped because it was folded into drivers-add-lcd-suppo=
rt-3.patch

------------------------------------------------------
Subject: drivers: add LCD support (update 4)
=46rom: Miguel Ojeda Sandonis <maxextreme@gmail.com>

- Adds mmaping support for the cfag12864bfb.

- Exchange the wiring drawing URL to a local ASCII drawing at
  Documentation/auxdisplay/cfag12864b.

- Minor coding style and documentation fixes.

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/auxdisplay/cfag12864b |   53 +++++++++++++++++++-------
 Documentation/auxdisplay/ks0108     |   14 ++----
 drivers/auxdisplay/Kconfig          |    7 ---
 drivers/auxdisplay/cfag12864b.c     |   28 ++++++++-----
 drivers/auxdisplay/cfag12864bfb.c   |   28 ++++++++++++-
 5 files changed, 90 insertions(+), 40 deletions(-)

diff -puN Documentation/auxdisplay/cfag12864b~drivers-add-lcd-support-u=
pdate-4 Documentation/auxdisplay/cfag12864b
--- a/Documentation/auxdisplay/cfag12864b~drivers-add-lcd-support-updat=
e-4
+++ a/Documentation/auxdisplay/cfag12864b
@@ -4,7 +4,7 @@
=20
 License:		GPLv2
 Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
-Date:			2006-10-11
+Date:			2006-10-27
=20
=20
=20
@@ -15,7 +15,7 @@ Date:			2006-10-11
 	1. DRIVER INFORMATION
 	2. DEVICE INFORMATION
 	3. WIRING
-	4. USER-SPACE PROGRAMMING
+	4. USERSPACE PROGRAMMING
=20
=20
 ---------------------
@@ -42,7 +42,8 @@ Controller:	ks0108
 Controllers:	2
 Pages:		8 each controller
 Addresses:	64 each page
-
+Data size:	1 byte each address
+Memory size:	2 * 8 * 64 * 1 =3D 1024 bytes =3D 1 Kbyte
=20
=20
 ---------
@@ -51,25 +52,53 @@ Addresses:	64 each page
=20
 The cfag12864b LCD Series don't have official wiring.
=20
-The common wiring is done to the parallel port:
+The common wiring is done to the parallel port as shown:
=20
-http://www.skippari.net/lcd/sekalaista/crystalfontz_cfag12864B-TMI-V.p=
ng
+Parallel Port                          cfag12864b
=20
-You can get help at Crystalfontz and LCDInfo forums.
+  Name Pin#                            Pin# Name
=20
+Strobe ( 1)------------------------------(17) Enable
+Data 0 ( 2)------------------------------( 4) Data 0
+Data 1 ( 3)------------------------------( 5) Data 1
+Data 2 ( 4)------------------------------( 6) Data 2
+Data 3 ( 5)------------------------------( 7) Data 3
+Data 4 ( 6)------------------------------( 8) Data 4
+Data 5 ( 7)------------------------------( 9) Data 5
+Data 6 ( 8)------------------------------(10) Data 6
+Data 7 ( 9)------------------------------(11) Data 7
+       (10)                      [+5v]---( 1) Vdd
+       (11)                      [GND]---( 2) Ground
+       (12)                      [+5v]---(14) Reset
+       (13)                      [GND]---(15) Read / Write
+  Line (14)------------------------------(13) Controller Select 1
+       (15)
+  Init (16)------------------------------(12) Controller Select 2
+Select (17)------------------------------(16) Data / Instruction
+Ground (18)---[GND]              [+5v]---(19) LED +
+Ground (19)---[GND]
+Ground (20)---[GND]              E    A             Values:
+Ground (21)---[GND]       [GND]---[P1]---(18) Vee    =B7 R =3D Resisto=
r =3D 22 ohm
+Ground (22)---[GND]                |                 =B7 P1 =3D Preset=
 =3D 10 Kohm
+Ground (23)---[GND]       ----   S ------( 3) V0     =B7 P2 =3D Preset=
 =3D 1 Kohm
+Ground (24)---[GND]       |  |
+Ground (25)---[GND] [GND]---[P2]---[R]---(20) LED -
=20
=20
 ------------------------
 4. USERSPACE PROGRAMMING
 ------------------------
=20
-The cfag12864bfb describes a framebuffer driver (/dev/fbX).
+The cfag12864bfb describes a framebuffer device (/dev/fbX).
=20
-It has a size of 128 * 64 / 8 =3D 1024 bytes =3D 1 kB.
+It has a size of 1024 bytes =3D 1 Kbyte.
 Each bit represents one pixel. If the bit is high, the pixel will
 turn on. If the pixel is low, the pixel will turn off.
=20
-You can mmap the framebuffer as usual.
+You can use the framebuffer as a file: fopen, fwrite, fclose...
+
+Also, you can mmap the framebuffer: open & mmap, munmap & close...
+which is the best option.
=20
 You can use a copy of this header in your userspace programs.
=20
@@ -79,7 +108,7 @@ You can use a copy of this header in you
  * Description: cfag12864b LCD Display Driver Header for user-space ap=
ps
  *
  *      Author: Miguel Ojeda Sandonis <maxextreme@gmail.com>
- *        Date: 2006-10-11
+ *        Date: 2006-10-27
  */
=20
 #ifndef _CFAG12864B_H_
@@ -87,9 +116,7 @@ You can use a copy of this header in you
=20
 #define CFAG12864B_WIDTH	(128)
 #define CFAG12864B_HEIGHT	(64)
-#define CFAG12864B_SIZE		((CFAG12864B_CONTROLLERS) * \
-				(CFAG12864B_PAGES) * \
-				(CFAG12864B_ADDRESSES))
+#define CFAG12864B_SIZE		(1024)
=20
 #endif // _CFAG12864B_H_
 ---8<---
diff -puN Documentation/auxdisplay/ks0108~drivers-add-lcd-support-updat=
e-4 Documentation/auxdisplay/ks0108
--- a/Documentation/auxdisplay/ks0108~drivers-add-lcd-support-update-4
+++ a/Documentation/auxdisplay/ks0108
@@ -4,7 +4,7 @@
=20
 License:		GPLv2
 Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
-Date:			2006-10-04
+Date:			2006-10-27
=20
=20
=20
@@ -39,7 +39,8 @@ Height:		64
 Colors:		2 (B/N)
 Pages:		8
 Addresses:	64 each page
-
+Data size:	1 byte each address
+Memory size:	8 * 64 * 1 =3D 512 bytes
=20
=20
 ---------
@@ -48,12 +49,9 @@ Addresses:	64 each page
=20
 The driver supports data parallel port wiring.
=20
-If you aren't creating a LCD related hardware, you should check
-your LCD specific wiring information in the same folder, not this one.
-
-
-Wiring example of a cfag12864b LCD which has two ks0108 controllers:
+If you aren't building LCD related hardware, you should check
+your LCD specific wiring information in the same folder.
=20
-http://www.skippari.net/lcd/sekalaista/crystalfontz_cfag12864B-TMI-V.p=
ng
+For example, check Documentation/auxdisplay/cfag12864b.
=20
 EOF
diff -puN drivers/auxdisplay/Kconfig~drivers-add-lcd-support-update-4 d=
rivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~drivers-add-lcd-support-update-4
+++ a/drivers/auxdisplay/Kconfig
@@ -71,12 +71,7 @@ config CFAG12864B
 	  say Y. You also need the ks0108 LCD Controller driver.
=20
 	  For help about how to wire your LCD to the parallel port,
-	  check this image:
-
-	  http://www.skippari.net/lcd/sekalaista/crystalfontz_cfag12864B-TMI-=
V.png
-
-	  Also, you can find help in Crystalfontz and LCDStudio forums.
-	  Check Documentation/lcddisplay/cfag12864b for more information.
+	  check Documentation/auxdisplay/cfag12864b
=20
 	  The LCD framebuffer driver can be attached to a console.
 	  It will work fine. However, you can't attach it to the fbdev driver
diff -puN drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-updat=
e-4 drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-update-4
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -6,7 +6,7 @@
  *     Depends: ks0108
  *
  *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
- *        Date: 2006-10-13
+ *        Date: 2006-10-26
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
  *  it under the terms of the GNU General Public License as published =
by
@@ -182,7 +182,7 @@ static void cfag12864b_nop(void)
  * cfag12864b Internal Commands
  */
=20
-unsigned char *cfag12864b_cache;
+static unsigned char *cfag12864b_cache;
 unsigned char *cfag12864b_buffer;
 EXPORT_SYMBOL_GPL(cfag12864b_buffer);
=20
@@ -226,7 +226,7 @@ static void cfag12864b_update(void *arg)
 	unsigned char c;
 	unsigned short i, j, k, b;
=20
-	if(memcmp(cfag12864b_cache, cfag12864b_buffer, CFAG12864B_SIZE)) {
+	if (memcmp(cfag12864b_cache, cfag12864b_buffer, CFAG12864B_SIZE)) {
 		for (i =3D 0; i < CFAG12864B_CONTROLLERS; i++) {
 			cfag12864b_controller(i);
 			cfag12864b_nop();
@@ -251,7 +251,7 @@ static void cfag12864b_update(void *arg)
 		memcpy(cfag12864b_cache, cfag12864b_buffer, CFAG12864B_SIZE);
 	}
=20
-	if(cfag12864b_updating)
+	if (cfag12864b_updating)
 		queue_delayed_work(cfag12864b_workqueue, &cfag12864b_work,
 			HZ / cfag12864b_rate);
 }
@@ -264,12 +264,18 @@ static int __init cfag12864b_init(void)
 {
 	int ret =3D -EINVAL;
=20
-	cfag12864b_buffer =3D vmalloc(sizeof(unsigned char) *
-		CFAG12864B_SIZE);
+	if (PAGE_SIZE < CFAG12864B_SIZE) {
+		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
+			"page size (%i) < cfag12864b size (%i)\n",
+			(unsigned int)PAGE_SIZE, CFAG12864B_SIZE);
+		ret =3D -ENOMEM;
+		goto none;
+	}
+
+	cfag12864b_buffer =3D (unsigned char *) __get_free_page(GFP_KERNEL);
 	if (cfag12864b_buffer =3D=3D NULL) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
-			"can't v-alloc buffer (%i bytes)\n",
-			CFAG12864B_SIZE);
+			"can't get a free page\n");
 		ret =3D -ENOMEM;
 		goto none;
 	}
@@ -290,7 +296,7 @@ static int __init cfag12864b_init(void)
 	cfag12864b_on();
=20
 	cfag12864b_workqueue =3D create_singlethread_workqueue(CFAG12864B_NAM=
E);
-	if(cfag12864b_workqueue =3D=3D NULL)
+	if (cfag12864b_workqueue =3D=3D NULL)
 		goto cachealloced;
=20
 	cfag12864b_updating =3D 1;
@@ -302,7 +308,7 @@ cachealloced:
 	kfree(cfag12864b_cache);
=20
 bufferalloced:
-	vfree(cfag12864b_buffer);
+	free_page((unsigned long) cfag12864b_buffer);
=20
 none:
 	return ret;
@@ -317,7 +323,7 @@ static void __exit cfag12864b_exit(void)
 	cfag12864b_off();
=20
 	kfree(cfag12864b_cache);
-	vfree(cfag12864b_buffer);
+	free_page((unsigned long) cfag12864b_buffer);
 }
=20
 module_init(cfag12864b_init);
diff -puN drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-upd=
ate-4 drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-update-=
4
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -6,7 +6,7 @@
  *     Depends: cfag12864b
  *
  *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.=
com>
- *        Date: 2006-10-13
+ *        Date: 2006-10-26
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
  *  it under the terms of the GNU General Public License as published =
by
@@ -66,11 +66,35 @@ static struct fb_var_screeninfo cfag1286
 	.vmode =3D FB_VMODE_NONINTERLACED,
 };
=20
+static struct page *cfag12864bfb_vma_nopage(struct vm_area_struct *vma=
,
+	unsigned long address, int *type)
+{
+	struct page *page =3D virt_to_page(cfag12864b_buffer);
+	get_page(page);
+
+	if(type)
+		*type =3D VM_FAULT_MINOR;
+
+	return page;
+}
+
+static struct vm_operations_struct cfag12864bfb_vm_ops =3D {
+	.nopage =3D cfag12864bfb_vma_nopage,
+};
+
+static int cfag12864bfb_mmap(struct fb_info *info, struct vm_area_stru=
ct *vma)
+{
+	vma->vm_ops =3D &cfag12864bfb_vm_ops;
+	vma->vm_flags |=3D VM_RESERVED;
+	return 0;
+}
+
 static struct fb_ops cfag12864bfb_ops =3D {
 	.owner =3D THIS_MODULE,
 	.fb_fillrect =3D cfb_fillrect,
 	.fb_copyarea =3D cfb_copyarea,
 	.fb_imageblit =3D cfb_imageblit,
+	.fb_mmap =3D cfag12864bfb_mmap,
 };
=20
 static int __init cfag12864bfb_probe(struct platform_device *device)
@@ -81,7 +105,7 @@ static int __init cfag12864bfb_probe(str
 	if (!info)
 		goto none;
=20
-	info->screen_base =3D (char __iomem *)cfag12864b_buffer;
+	info->screen_base =3D (char __iomem *) cfag12864b_buffer;
 	info->screen_size =3D CFAG12864B_SIZE;
 	info->fbops =3D &cfag12864bfb_ops;
 	info->fix =3D cfag12864bfb_fix;
_

Patches currently in -mm which might be from maxextreme@gmail.com are

drivers-add-lcd-support-3.patch
drivers-add-lcd-support-update-4.patch
drivers-add-lcd-support-update-5.patch
drivers-add-lcd-support-update6.patch
drivers-add-lcd-support-update-7.patch
drivers-add-lcd-support-update-8.patch
drivers-add-lcd-support-update-9.patch
drivers-add-lcd-support-workqueue-fixups.patch
