From: akpm@linux-foundation.org
Subject: + fbmem-fix-fb_read-fb_write-unaligned-accesses.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:19:56 -0700
Message-ID: <201009212319.o8LNJuqB008797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab0IUXU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:20:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james@albanarts.com, FlorianSchandinat@gmx.de, davem@davemloft.net


The patch titled
     fbmem: fix fb_read, fb_write unaligned accesses.
has been added to the -mm tree.  Its filename is
     fbmem-fix-fb_read-fb_write-unaligned-accesses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbmem: fix fb_read, fb_write unaligned accesses.
From: James Hogan <james@albanarts.com>

fb_{read,write} access the framebuffer using lots of fb_{read,write}l's
but don't check that the file position is aligned which can cause problems
on some architectures which do not support unaligned accesses.

Since the operations are essentially memcpy_{from,to}io, new
fb_memcpy_{from,to}fb macros have been defined and these are used instead.

For Sparc, fb_{read,write} macros use sbus_{read,write}, so this defines
new sbus_memcpy_{from,to}io functions the same as memcpy_{from,to}io but
using sbus_{read,write}b instead of {read,write}b.

Signed-off-by: James Hogan <james@albanarts.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/io_32.h |   31 ++++++++++++++++++++
 arch/sparc/include/asm/io_64.h |   31 ++++++++++++++++++++
 drivers/video/fbmem.c          |   46 +++++++++----------------------
 include/linux/fb.h             |    6 ++++
 4 files changed, 82 insertions(+), 32 deletions(-)

diff -puN arch/sparc/include/asm/io_32.h~fbmem-fix-fb_read-fb_write-unaligned-accesses arch/sparc/include/asm/io_32.h
--- a/arch/sparc/include/asm/io_32.h~fbmem-fix-fb_read-fb_write-unaligned-accesses
+++ a/arch/sparc/include/asm/io_32.h
@@ -208,6 +208,21 @@ _memset_io(volatile void __iomem *dst, i
 #define memset_io(d,c,sz)	_memset_io(d,c,sz)
 
 static inline void
+_sbus_memcpy_fromio(void *dst, const volatile void __iomem *src,
+		    __kernel_size_t n)
+{
+	char *d = dst;
+
+	while (n--) {
+		char tmp = sbus_readb(src);
+		*d++ = tmp;
+		src++;
+	}
+}
+
+#define sbus_memcpy_fromio(d, s, sz)	_sbus_memcpy_fromio(d, s, sz)
+
+static inline void
 _memcpy_fromio(void *dst, const volatile void __iomem *src, __kernel_size_t n)
 {
 	char *d = dst;
@@ -222,6 +237,22 @@ _memcpy_fromio(void *dst, const volatile
 #define memcpy_fromio(d,s,sz)	_memcpy_fromio(d,s,sz)
 
 static inline void
+_sbus_memcpy_toio(volatile void __iomem *dst, const void *src,
+		  __kernel_size_t n)
+{
+	const char *s = src;
+	volatile void __iomem *d = dst;
+
+	while (n--) {
+		char tmp = *s++;
+		sbus_writeb(tmp, d);
+		d++;
+	}
+}
+
+#define sbus_memcpy_toio(d, s, sz)	_sbus_memcpy_toio(d, s, sz)
+
+static inline void
 _memcpy_toio(volatile void __iomem *dst, const void *src, __kernel_size_t n)
 {
 	const char *s = src;
diff -puN arch/sparc/include/asm/io_64.h~fbmem-fix-fb_read-fb_write-unaligned-accesses arch/sparc/include/asm/io_64.h
--- a/arch/sparc/include/asm/io_64.h~fbmem-fix-fb_read-fb_write-unaligned-accesses
+++ a/arch/sparc/include/asm/io_64.h
@@ -419,6 +419,21 @@ _memset_io(volatile void __iomem *dst, i
 #define memset_io(d,c,sz)	_memset_io(d,c,sz)
 
 static inline void
+_sbus_memcpy_fromio(void *dst, const volatile void __iomem *src,
+		    __kernel_size_t n)
+{
+	char *d = dst;
+
+	while (n--) {
+		char tmp = sbus_readb(src);
+		*d++ = tmp;
+		src++;
+	}
+}
+
+#define sbus_memcpy_fromio(d, s, sz)	_sbus_memcpy_fromio(d, s, sz)
+
+static inline void
 _memcpy_fromio(void *dst, const volatile void __iomem *src, __kernel_size_t n)
 {
 	char *d = dst;
@@ -433,6 +448,22 @@ _memcpy_fromio(void *dst, const volatile
 #define memcpy_fromio(d,s,sz)	_memcpy_fromio(d,s,sz)
 
 static inline void
+_sbus_memcpy_toio(volatile void __iomem *dst, const void *src,
+		  __kernel_size_t n)
+{
+	const char *s = src;
+	volatile void __iomem *d = dst;
+
+	while (n--) {
+		char tmp = *s++;
+		sbus_writeb(tmp, d);
+		d++;
+	}
+}
+
+#define sbus_memcpy_toio(d, s, sz)	_sbus_memcpy_toio(d, s, sz)
+
+static inline void
 _memcpy_toio(volatile void __iomem *dst, const void *src, __kernel_size_t n)
 {
 	const char *s = src;
diff -puN drivers/video/fbmem.c~fbmem-fix-fb_read-fb_write-unaligned-accesses drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbmem-fix-fb_read-fb_write-unaligned-accesses
+++ a/drivers/video/fbmem.c
@@ -697,9 +697,9 @@ fb_read(struct file *file, char __user *
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
-	u32 *buffer, *dst;
-	u32 __iomem *src;
-	int c, i, cnt = 0, err = 0;
+	u8 *buffer, *dst;
+	u8 __iomem *src;
+	int c, cnt = 0, err = 0;
 	unsigned long total_size;
 
 	if (!info || ! info->screen_base)
@@ -730,7 +730,7 @@ fb_read(struct file *file, char __user *
 	if (!buffer)
 		return -ENOMEM;
 
-	src = (u32 __iomem *) (info->screen_base + p);
+	src = (u8 __iomem *) (info->screen_base + p);
 
 	if (info->fbops->fb_sync)
 		info->fbops->fb_sync(info);
@@ -738,17 +738,9 @@ fb_read(struct file *file, char __user *
 	while (count) {
 		c  = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		dst = buffer;
-		for (i = c >> 2; i--; )
-			*dst++ = fb_readl(src++);
-		if (c & 3) {
-			u8 *dst8 = (u8 *) dst;
-			u8 __iomem *src8 = (u8 __iomem *) src;
-
-			for (i = c & 3; i--;)
-				*dst8++ = fb_readb(src8++);
-
-			src = (u32 __iomem *) src8;
-		}
+		fb_memcpy_fromfb(dst, src, c);
+		dst += c;
+		src += c;
 
 		if (copy_to_user(buf, buffer, c)) {
 			err = -EFAULT;
@@ -772,9 +764,9 @@ fb_write(struct file *file, const char _
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
-	u32 *buffer, *src;
-	u32 __iomem *dst;
-	int c, i, cnt = 0, err = 0;
+	u8 *buffer, *src;
+	u8 __iomem *dst;
+	int c, cnt = 0, err = 0;
 	unsigned long total_size;
 
 	if (!info || !info->screen_base)
@@ -811,7 +803,7 @@ fb_write(struct file *file, const char _
 	if (!buffer)
 		return -ENOMEM;
 
-	dst = (u32 __iomem *) (info->screen_base + p);
+	dst = (u8 __iomem *) (info->screen_base + p);
 
 	if (info->fbops->fb_sync)
 		info->fbops->fb_sync(info);
@@ -825,19 +817,9 @@ fb_write(struct file *file, const char _
 			break;
 		}
 
-		for (i = c >> 2; i--; )
-			fb_writel(*src++, dst++);
-
-		if (c & 3) {
-			u8 *src8 = (u8 *) src;
-			u8 __iomem *dst8 = (u8 __iomem *) dst;
-
-			for (i = c & 3; i--; )
-				fb_writeb(*src8++, dst8++);
-
-			dst = (u32 __iomem *) dst8;
-		}
-
+		fb_memcpy_tofb(dst, src, c);
+		dst += c;
+		src += c;
 		*ppos += c;
 		buf += c;
 		cnt += c;
diff -puN include/linux/fb.h~fbmem-fix-fb_read-fb_write-unaligned-accesses include/linux/fb.h
--- a/include/linux/fb.h~fbmem-fix-fb_read-fb_write-unaligned-accesses
+++ a/include/linux/fb.h
@@ -931,6 +931,8 @@ static inline struct apertures_struct *a
 #define fb_writel sbus_writel
 #define fb_writeq sbus_writeq
 #define fb_memset sbus_memset_io
+#define fb_memcpy_fromfb sbus_memcpy_fromio
+#define fb_memcpy_tofb sbus_memcpy_toio
 
 #elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__) || defined(__bfin__)
 
@@ -943,6 +945,8 @@ static inline struct apertures_struct *a
 #define fb_writel __raw_writel
 #define fb_writeq __raw_writeq
 #define fb_memset memset_io
+#define fb_memcpy_fromfb memcpy_fromio
+#define fb_memcpy_tofb memcpy_toio
 
 #else
 
@@ -955,6 +959,8 @@ static inline struct apertures_struct *a
 #define fb_writel(b,addr) (*(volatile u32 *) (addr) = (b))
 #define fb_writeq(b,addr) (*(volatile u64 *) (addr) = (b))
 #define fb_memset memset
+#define fb_memcpy_fromfb memcpy
+#define fb_memcpy_tofb memcpy
 
 #endif
 
_

Patches currently in -mm which might be from james@albanarts.com are

fbmem-ix-whitespace.patch
fbmem-fix-fb_read-fb_write-unaligned-accesses.patch

