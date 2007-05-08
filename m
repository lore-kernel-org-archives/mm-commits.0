From: akpm@linux-foundation.org
Subject: + fbdev-add-support-for-avr32.patch added to -mm tree
Date: Tue, 08 May 2007 14:27:25 -0700
Message-ID: <200705082127.l48LRPh4002158@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968022AbXEHV1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, adaplas@pol.net


The patch titled
     fbdev: add support for AVR32
has been added to the -mm tree.  Its filename is
     fbdev-add-support-for-avr32.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: add support for AVR32
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Provide framebuffer page protection flags and definitions of
fb_readl/fb_writel for AVR32.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    4 ++++
 include/linux/fb.h    |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/video/fbmem.c~fbdev-add-support-for-avr32 drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-support-for-avr32
+++ a/drivers/video/fbmem.c
@@ -1236,6 +1236,10 @@ fb_mmap(struct file *file, struct vm_are
 	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
 #elif defined(__arm__) || defined(__sh__) || defined(__m32r__)
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+#elif defined(__avr32__)
+	vma->vm_page_prot = __pgprot((pgprot_val(vma->vm_page_prot)
+				      & ~_PAGE_CACHABLE)
+				     | (_PAGE_BUFFER | _PAGE_DIRTY));
 #elif defined(__ia64__)
 	if (efi_range_is_wc(vma->vm_start, vma->vm_end - vma->vm_start))
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
diff -puN include/linux/fb.h~fbdev-add-support-for-avr32 include/linux/fb.h
--- a/include/linux/fb.h~fbdev-add-support-for-avr32
+++ a/include/linux/fb.h
@@ -868,7 +868,7 @@ struct fb_info {
 #define fb_writeq sbus_writeq
 #define fb_memset sbus_memset_io
 
-#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || (defined(__sh__) && !defined(__SH5__)) || defined(__powerpc__)
+#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || (defined(__sh__) && !defined(__SH5__)) || defined(__powerpc__) || defined(__avr32__)
 
 #define fb_readb __raw_readb
 #define fb_readw __raw_readw
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
fbdev-add-support-for-avr32.patch
