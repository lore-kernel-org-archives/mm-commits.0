From: akpm@linux-foundation.org
Subject: - fbdev-move-arch-specific-bits-to-their-respective.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:49 -0700
Message-ID: <200707172306.l6HN6nOj012053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936317AbXGQXPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, bunk@stusta.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: move arch-specific bits to their respective subdirectories
has been removed from the -mm tree.  Its filename was
     fbdev-move-arch-specific-bits-to-their-respective.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: move arch-specific bits to their respective subdirectories
From: "Antonino A. Daplas" <adaplas@gmail.com>

Move arch-specific bits of fb_mmap() to their respective subdirectories

[bob.picco@hp.com: efi_range_is_wc is referenced but not declared]
[bunk@stusta.de: fix include/asm-m68k/fb.h]
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c      |   62 ++---------------------------------
 include/asm-alpha/fb.h     |    7 +++
 include/asm-arm/fb.h       |   13 +++++++
 include/asm-arm26/fb.h     |    6 +++
 include/asm-avr32/fb.h     |   15 ++++++++
 include/asm-blackfin/fb.h  |    6 +++
 include/asm-cris/fb.h      |    6 +++
 include/asm-frv/fb.h       |    6 +++
 include/asm-h8300/fb.h     |    6 +++
 include/asm-i386/fb.h      |   14 +++++++
 include/asm-ia64/fb.h      |   17 +++++++++
 include/asm-m32r/fb.h      |   13 +++++++
 include/asm-m68k/fb.h      |   28 +++++++++++++++
 include/asm-m68knommu/fb.h |    6 +++
 include/asm-mips/fb.h      |   13 +++++++
 include/asm-parisc/fb.h    |   13 +++++++
 include/asm-powerpc/fb.h   |   15 ++++++++
 include/asm-s390/fb.h      |    6 +++
 include/asm-sh/fb.h        |   13 +++++++
 include/asm-sh64/fb.h      |   13 +++++++
 include/asm-sparc/fb.h     |    6 +++
 include/asm-sparc64/fb.h   |   12 ++++++
 include/asm-v850/fb.h      |    6 +++
 include/asm-x86_64/fb.h    |   14 +++++++
 include/asm-xtensa/fb.h    |    6 +++
 25 files changed, 264 insertions(+), 58 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-move-arch-specific-bits-to-their-respective drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-move-arch-specific-bits-to-their-respective
+++ a/drivers/video/fbmem.c
@@ -33,17 +33,10 @@
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/efi.h>
+#include <linux/fb.h>
 
-#if defined(__mc68000__) || defined(CONFIG_APUS)
-#include <asm/setup.h>
-#endif
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
+#include <asm/fb.h>
 
-#include <linux/fb.h>
 
     /*
      *  Frame buffer device initialization and setup routines
@@ -1155,17 +1148,15 @@ fb_compat_ioctl(struct file *file, unsig
 }
 #endif
 
-static int 
+static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	int fbidx = iminor(file->f_path.dentry->d_inode);
 	struct fb_info *info = registered_fb[fbidx];
 	struct fb_ops *fb = info->fbops;
 	unsigned long off;
-#if !defined(__sparc__) || defined(__sparc_v9__)
 	unsigned long start;
 	u32 len;
-#endif
 
 	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
 		return -EINVAL;
@@ -1180,12 +1171,6 @@ fb_mmap(struct file *file, struct vm_are
 		return res;
 	}
 
-#if defined(__sparc__) && !defined(__sparc_v9__)
-	/* Should never get here, all fb drivers should have their own
-	   mmap routines */
-	return -EINVAL;
-#else
-	/* !sparc32... */
 	lock_kernel();
 
 	/* frame buffer memory */
@@ -1209,50 +1194,11 @@ fb_mmap(struct file *file, struct vm_are
 	vma->vm_pgoff = off >> PAGE_SHIFT;
 	/* This is an IO map - tell maydump to skip this VMA */
 	vma->vm_flags |= VM_IO | VM_RESERVED;
-#if defined(__mc68000__)
-#if defined(CONFIG_SUN3)
-	pgprot_val(vma->vm_page_prot) |= SUN3_PAGE_NOCACHE;
-#elif defined(CONFIG_MMU)
-	if (CPU_IS_020_OR_030)
-		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
-	if (CPU_IS_040_OR_060) {
-		pgprot_val(vma->vm_page_prot) &= _CACHEMASK040;
-		/* Use no-cache mode, serialized */
-		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE_S;
-	}
-#endif
-#elif defined(__powerpc__)
-	vma->vm_page_prot = phys_mem_access_prot(file, off >> PAGE_SHIFT,
-						 vma->vm_end - vma->vm_start,
-						 vma->vm_page_prot);
-#elif defined(__alpha__)
-	/* Caching is off in the I/O space quadrant by design.  */
-#elif defined(__i386__) || defined(__x86_64__)
-	if (boot_cpu_data.x86 > 3)
-		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
-#elif defined(__mips__) || defined(__sparc_v9__)
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#elif defined(__hppa__)
-	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
-#elif defined(__arm__) || defined(__sh__) || defined(__m32r__)
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-#elif defined(__avr32__)
-	vma->vm_page_prot = __pgprot((pgprot_val(vma->vm_page_prot)
-				      & ~_PAGE_CACHABLE)
-				     | (_PAGE_BUFFER | _PAGE_DIRTY));
-#elif defined(__ia64__)
-	if (efi_range_is_wc(vma->vm_start, vma->vm_end - vma->vm_start))
-		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	else
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#else
-#warning What do we have to do here??
-#endif
+	fb_pgprotect(file, vma, off);
 	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
 			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
 		return -EAGAIN;
 	return 0;
-#endif /* !sparc32 */
 }
 
 static int
diff -puN /dev/null include/asm-alpha/fb.h
--- /dev/null
+++ a/include/asm-alpha/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+/* Caching is off in the I/O space quadrant by design.  */
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-arm/fb.h
--- /dev/null
+++ a/include/asm-arm/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-arm26/fb.h
--- /dev/null
+++ a/include/asm-arm26/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-avr32/fb.h
--- /dev/null
+++ a/include/asm-avr32/fb.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = __pgprot((pgprot_val(vma->vm_page_prot)
+				      & ~_PAGE_CACHABLE)
+				     | (_PAGE_BUFFER | _PAGE_DIRTY));
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-blackfin/fb.h
--- /dev/null
+++ a/include/asm-blackfin/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-cris/fb.h
--- /dev/null
+++ a/include/asm-cris/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-frv/fb.h
--- /dev/null
+++ a/include/asm-frv/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-h8300/fb.h
--- /dev/null
+++ a/include/asm-h8300/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-i386/fb.h
--- /dev/null
+++ a/include/asm-i386/fb.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	if (boot_cpu_data.x86 > 3)
+		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-ia64/fb.h
--- /dev/null
+++ a/include/asm-ia64/fb.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <linux/efi.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	if (efi_range_is_wc(vma->vm_start, vma->vm_end - vma->vm_start))
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-m32r/fb.h
--- /dev/null
+++ a/include/asm-m32r/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-m68k/fb.h
--- /dev/null
+++ a/include/asm-m68k/fb.h
@@ -0,0 +1,28 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+
+#ifdef CONFIG_SUN3
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	pgprot_val(vma->vm_page_prot) |= SUN3_PAGE_NOCACHE;
+}
+#else
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	if (CPU_IS_020_OR_030)
+		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
+	if (CPU_IS_040_OR_060) {
+		pgprot_val(vma->vm_page_prot) &= _CACHEMASK040;
+		/* Use no-cache mode, serialized */
+		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE_S;
+	}
+}
+#endif /* CONFIG_SUN3 */
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-m68knommu/fb.h
--- /dev/null
+++ a/include/asm-m68knommu/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-mips/fb.h
--- /dev/null
+++ a/include/asm-mips/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-parisc/fb.h
--- /dev/null
+++ a/include/asm-parisc/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-powerpc/fb.h
--- /dev/null
+++ a/include/asm-powerpc/fb.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = phys_mem_access_prot(file, off >> PAGE_SHIFT,
+						 vma->vm_end - vma->vm_start,
+						 vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-s390/fb.h
--- /dev/null
+++ a/include/asm-s390/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-sh/fb.h
--- /dev/null
+++ a/include/asm-sh/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-sh64/fb.h
--- /dev/null
+++ a/include/asm-sh64/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-sparc/fb.h
--- /dev/null
+++ a/include/asm-sparc/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-sparc64/fb.h
--- /dev/null
+++ a/include/asm-sparc64/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-v850/fb.h
--- /dev/null
+++ a/include/asm-v850/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-x86_64/fb.h
--- /dev/null
+++ a/include/asm-x86_64/fb.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	if (boot_cpu_data.x86 > 3)
+		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
+}
+
+#endif /* _ASM_FB_H_ */
diff -puN /dev/null include/asm-xtensa/fb.h
--- /dev/null
+++ a/include/asm-xtensa/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
