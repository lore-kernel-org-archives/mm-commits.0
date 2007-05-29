From: akpm@linux-foundation.org
Subject: + fbdev-detect-primary-display-device.patch added to -mm tree
Date: Tue, 29 May 2007 15:52:40 -0700
Message-ID: <200705292252.l4TMqed4013678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbXE2Wwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, davem@davemloft.net


The patch titled
     fbdev: detect primary display device
has been added to the -mm tree.  Its filename is
     fbdev-detect-primary-display-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: detect primary display device
From: "Antonino A. Daplas" <adaplas@gmail.com>

Add function helper, fb_is_primary_device().  Given struct fb_info, it will
return a nonzero value if the device is the primary display.

Currently, only the i386 is supported where the function checks for the
IORESOURCE_ROM_SHADOW flag.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Makefile         |    1 +
 arch/i386/video/Makefile   |    1 +
 arch/i386/video/fbdev.c    |   34 ++++++++++++++++++++++++++++++++++
 include/asm-alpha/fb.h     |    6 ++++++
 include/asm-arm/fb.h       |    6 ++++++
 include/asm-arm26/fb.h     |    6 ++++++
 include/asm-avr32/fb.h     |    6 ++++++
 include/asm-blackfin/fb.h  |    6 ++++++
 include/asm-cris/fb.h      |    6 ++++++
 include/asm-frv/fb.h       |    6 ++++++
 include/asm-h8300/fb.h     |    6 ++++++
 include/asm-i386/fb.h      |    3 +++
 include/asm-ia64/fb.h      |    6 ++++++
 include/asm-m32r/fb.h      |    6 ++++++
 include/asm-m68k/fb.h      |    6 ++++++
 include/asm-m68knommu/fb.h |    6 ++++++
 include/asm-mips/fb.h      |    6 ++++++
 include/asm-parisc/fb.h    |    6 ++++++
 include/asm-powerpc/fb.h   |    6 ++++++
 include/asm-s390/fb.h      |    6 ++++++
 include/asm-sh/fb.h        |    6 ++++++
 include/asm-sh64/fb.h      |    6 ++++++
 include/asm-sparc/fb.h     |    6 ++++++
 include/asm-sparc64/fb.h   |    6 ++++++
 include/asm-v850/fb.h      |    6 ++++++
 include/asm-x86_64/fb.h    |    7 ++++++-
 include/asm-xtensa/fb.h    |    6 ++++++
 27 files changed, 177 insertions(+), 1 deletion(-)

diff -puN arch/i386/Makefile~fbdev-detect-primary-display-device arch/i386/Makefile
--- a/arch/i386/Makefile~fbdev-detect-primary-display-device
+++ a/arch/i386/Makefile
@@ -111,6 +111,7 @@ drivers-$(CONFIG_PCI)			+= arch/i386/pci
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE)		+= arch/i386/oprofile/
 drivers-$(CONFIG_PM)			+= arch/i386/power/
+drivers-$(CONFIG_FB)                    += arch/i386/video/
 
 CFLAGS += $(mflags-y)
 AFLAGS += $(mflags-y)
diff -puN /dev/null arch/i386/video/Makefile
--- /dev/null
+++ a/arch/i386/video/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_FB)               += fbdev.o
diff -puN /dev/null arch/i386/video/fbdev.c
--- /dev/null
+++ a/arch/i386/video/fbdev.c
@@ -0,0 +1,34 @@
+/*
+ * arch/i386/video/fbdev.c - i386 Framebuffer
+ *
+ * Copyright (C) 2007 Antonino Daplas <adaplas@gmail.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ */
+#include <linux/fb.h>
+#include <linux/pci.h>
+
+int fb_is_primary_device(struct fb_info *info)
+{
+	struct device *device;
+	struct pci_dev *pci_dev = NULL;
+	struct resource *res = NULL;
+	int retval = 0;
+
+	device = info->device;
+
+	if (device)
+		pci_dev = to_pci_dev(device);
+
+	if (pci_dev)
+		res = &pci_dev->resource[PCI_ROM_RESOURCE];
+
+	if (res && res->flags & IORESOURCE_ROM_SHADOW)
+		retval = 1;
+
+	return retval;
+}
+EXPORT_SYMBOL(fb_is_primary_device);
diff -puN include/asm-alpha/fb.h~fbdev-detect-primary-display-device include/asm-alpha/fb.h
--- a/include/asm-alpha/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-alpha/fb.h
@@ -1,7 +1,13 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/device.h>
 
 /* Caching is off in the I/O space quadrant by design.  */
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-arm/fb.h~fbdev-detect-primary-display-device include/asm-arm/fb.h
--- a/include/asm-arm/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-arm/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-arm26/fb.h~fbdev-detect-primary-display-device include/asm-arm26/fb.h
--- a/include/asm-arm26/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-arm26/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-avr32/fb.h~fbdev-detect-primary-display-device include/asm-avr32/fb.h
--- a/include/asm-avr32/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-avr32/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -12,4 +13,9 @@ static inline void fb_pgprotect(struct f
 				     | (_PAGE_BUFFER | _PAGE_DIRTY));
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-blackfin/fb.h~fbdev-detect-primary-display-device include/asm-blackfin/fb.h
--- a/include/asm-blackfin/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-blackfin/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-cris/fb.h~fbdev-detect-primary-display-device include/asm-cris/fb.h
--- a/include/asm-cris/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-cris/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-frv/fb.h~fbdev-detect-primary-display-device include/asm-frv/fb.h
--- a/include/asm-frv/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-frv/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-h8300/fb.h~fbdev-detect-primary-display-device include/asm-h8300/fb.h
--- a/include/asm-h8300/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-h8300/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-i386/fb.h~fbdev-detect-primary-display-device include/asm-i386/fb.h
--- a/include/asm-i386/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-i386/fb.h
@@ -1,9 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
+extern int fb_is_primary_device(struct fb_info *info);
+
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 				unsigned long off)
 {
diff -puN include/asm-ia64/fb.h~fbdev-detect-primary-display-device include/asm-ia64/fb.h
--- a/include/asm-ia64/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-ia64/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -13,4 +14,9 @@ static inline void fb_pgprotect(struct f
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-m32r/fb.h~fbdev-detect-primary-display-device include/asm-m32r/fb.h
--- a/include/asm-m32r/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-m32r/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-m68k/fb.h~fbdev-detect-primary-display-device include/asm-m68k/fb.h
--- a/include/asm-m68k/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-m68k/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 #include <asm/setup.h>
@@ -24,4 +25,9 @@ static inline void fb_pgprotect(struct f
 }
 #endif /* CONFIG_SUN3 */
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-m68knommu/fb.h~fbdev-detect-primary-display-device include/asm-m68knommu/fb.h
--- a/include/asm-m68knommu/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-m68knommu/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-mips/fb.h~fbdev-detect-primary-display-device include/asm-mips/fb.h
--- a/include/asm-mips/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-mips/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-parisc/fb.h~fbdev-detect-primary-display-device include/asm-parisc/fb.h
--- a/include/asm-parisc/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-parisc/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-powerpc/fb.h~fbdev-detect-primary-display-device include/asm-powerpc/fb.h
--- a/include/asm-powerpc/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-powerpc/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -12,4 +13,9 @@ static inline void fb_pgprotect(struct f
 						 vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-s390/fb.h~fbdev-detect-primary-display-device include/asm-s390/fb.h
--- a/include/asm-s390/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-s390/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-sh/fb.h~fbdev-detect-primary-display-device include/asm-sh/fb.h
--- a/include/asm-sh/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-sh/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-sh64/fb.h~fbdev-detect-primary-display-device include/asm-sh64/fb.h
--- a/include/asm-sh64/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-sh64/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-sparc/fb.h~fbdev-detect-primary-display-device include/asm-sparc/fb.h
--- a/include/asm-sparc/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-sparc/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-sparc64/fb.h~fbdev-detect-primary-display-device include/asm-sparc64/fb.h
--- a/include/asm-sparc64/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-sparc64/fb.h
@@ -1,5 +1,6 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -9,4 +10,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-v850/fb.h~fbdev-detect-primary-display-device include/asm-v850/fb.h
--- a/include/asm-v850/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-v850/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-x86_64/fb.h~fbdev-detect-primary-display-device include/asm-x86_64/fb.h
--- a/include/asm-x86_64/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-x86_64/fb.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
-
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -11,4 +11,9 @@ static inline void fb_pgprotect(struct f
 		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff -puN include/asm-xtensa/fb.h~fbdev-detect-primary-display-device include/asm-xtensa/fb.h
--- a/include/asm-xtensa/fb.h~fbdev-detect-primary-display-device
+++ a/include/asm-xtensa/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
_

Patches currently in -mm which might be from adaplas@gmail.com are

skeletonfb-fix-of-xxxfb_setup-ifdef.patch
vt8623fb-arkfb-null-pointer-dereference-fix.patch
cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch
fbdev-move-declaration-of-fb_class-to-linux-fbh.patch
fbcon-smart-blitter-usage-for-scrolling.patch
nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
fbcon-cursor-blink-control.patch
fbcon-use-struct-device-instead-of-struct-class_device.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
fbdev-detect-primary-display-device.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch
