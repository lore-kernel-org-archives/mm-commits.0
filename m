From: akpm@linux-foundation.org
Subject: [merged] vga-optimise-console-scrolling.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:41:10 -0700
Message-ID: <20170911194110.lkTDjiLI6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdIKTlL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, mawilcox@microsoft.com, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de


The patch titled
     Subject: vga: optimise console scrolling
has been removed from the -mm tree.  Its filename was
     vga-optimise-console-scrolling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: vga: optimise console scrolling

Where possible, call memset16(), memmove() or memcpy() instead of using
open-coded loops.  I don't like the calling convention that uses a byte
count instead of a count of u16s, but it's a little late to change that.
Reduces code size of fbcon.o by almost 400 bytes on my laptop build.

[akpm@linux-foundation.org: fix build]
Link: http://lkml.kernel.org/r/20170720184539.31609-9-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/vga.h    |    7 +++++++
 arch/powerpc/include/asm/vga.h |    8 ++++++++
 arch/sparc/include/asm/vga.h   |   25 +++++++++++++++++++++++++
 include/linux/vt_buffer.h      |   13 +++++++++++++
 4 files changed, 53 insertions(+)

diff -puN arch/mips/include/asm/vga.h~vga-optimise-console-scrolling arch/mips/include/asm/vga.h
--- a/arch/mips/include/asm/vga.h~vga-optimise-console-scrolling
+++ a/arch/mips/include/asm/vga.h
@@ -6,6 +6,7 @@
 #ifndef _ASM_VGA_H
 #define _ASM_VGA_H
 
+#include <linux/string.h>
 #include <asm/addrspace.h>
 #include <asm/byteorder.h>
 
@@ -40,9 +41,15 @@ static inline u16 scr_readw(volatile con
 	return le16_to_cpu(*addr);
 }
 
+static inline void scr_memsetw(u16 *s, u16 v, unsigned int count)
+{
+	memset16(s, cpu_to_le16(v), count / 2);
+}
+
 #define scr_memcpyw(d, s, c) memcpy(d, s, c)
 #define scr_memmovew(d, s, c) memmove(d, s, c)
 #define VT_BUF_HAVE_MEMCPYW
 #define VT_BUF_HAVE_MEMMOVEW
+#define VT_BUF_HAVE_MEMSETW
 
 #endif /* _ASM_VGA_H */
diff -puN arch/powerpc/include/asm/vga.h~vga-optimise-console-scrolling arch/powerpc/include/asm/vga.h
--- a/arch/powerpc/include/asm/vga.h~vga-optimise-console-scrolling
+++ a/arch/powerpc/include/asm/vga.h
@@ -33,8 +33,16 @@ static inline u16 scr_readw(volatile con
 	return le16_to_cpu(*addr);
 }
 
+#define VT_BUF_HAVE_MEMSETW
+static inline void scr_memsetw(u16 *s, u16 v, unsigned int n)
+{
+	memset16(s, cpu_to_le16(v), n / 2);
+}
+
 #define VT_BUF_HAVE_MEMCPYW
+#define VT_BUF_HAVE_MEMMOVEW
 #define scr_memcpyw	memcpy
+#define scr_memmovew	memmove
 
 #endif /* !CONFIG_VGA_CONSOLE && !CONFIG_MDA_CONSOLE */
 
diff -puN arch/sparc/include/asm/vga.h~vga-optimise-console-scrolling arch/sparc/include/asm/vga.h
--- a/arch/sparc/include/asm/vga.h~vga-optimise-console-scrolling
+++ a/arch/sparc/include/asm/vga.h
@@ -8,9 +8,13 @@
 #define _LINUX_ASM_VGA_H_
 
 #include <linux/bug.h>
+#include <linux/string.h>
 #include <asm/types.h>
 
 #define VT_BUF_HAVE_RW
+#define VT_BUF_HAVE_MEMSETW
+#define VT_BUF_HAVE_MEMCPYW
+#define VT_BUF_HAVE_MEMMOVEW
 
 #undef scr_writew
 #undef scr_readw
@@ -29,6 +33,27 @@ static inline u16 scr_readw(const u16 *a
 	return *addr;
 }
 
+static inline void scr_memsetw(u16 *p, u16 v, unsigned int n)
+{
+	BUG_ON((long) p >= 0);
+
+	memset16(p, cpu_to_le16(v), n / 2);
+}
+
+static inline void scr_memcpyw(u16 *d, u16 *s, unsigned int n)
+{
+	BUG_ON((long) d >= 0);
+
+	memcpy(d, s, n);
+}
+
+static inline void scr_memmovew(u16 *d, u16 *s, unsigned int n)
+{
+	BUG_ON((long) d >= 0);
+
+	memmove(d, s, n);
+}
+
 #define VGA_MAP_MEM(x,s) (x)
 
 #endif
diff -puN include/linux/vt_buffer.h~vga-optimise-console-scrolling include/linux/vt_buffer.h
--- a/include/linux/vt_buffer.h~vga-optimise-console-scrolling
+++ a/include/linux/vt_buffer.h
@@ -13,6 +13,7 @@
 #ifndef _LINUX_VT_BUFFER_H_
 #define _LINUX_VT_BUFFER_H_
 
+#include <linux/string.h>
 
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_MDA_CONSOLE)
 #include <asm/vga.h>
@@ -26,24 +27,33 @@
 #ifndef VT_BUF_HAVE_MEMSETW
 static inline void scr_memsetw(u16 *s, u16 c, unsigned int count)
 {
+#ifdef VT_BUF_HAVE_RW
 	count /= 2;
 	while (count--)
 		scr_writew(c, s++);
+#else
+	memset16(s, c, count / 2);
+#endif
 }
 #endif
 
 #ifndef VT_BUF_HAVE_MEMCPYW
 static inline void scr_memcpyw(u16 *d, const u16 *s, unsigned int count)
 {
+#ifdef VT_BUF_HAVE_RW
 	count /= 2;
 	while (count--)
 		scr_writew(scr_readw(s++), d++);
+#else
+	memcpy(d, s, count);
+#endif
 }
 #endif
 
 #ifndef VT_BUF_HAVE_MEMMOVEW
 static inline void scr_memmovew(u16 *d, const u16 *s, unsigned int count)
 {
+#ifdef VT_BUF_HAVE_RW
 	if (d < s)
 		scr_memcpyw(d, s, count);
 	else {
@@ -53,6 +63,9 @@ static inline void scr_memmovew(u16 *d,
 		while (count--)
 			scr_writew(scr_readw(--s), --d);
 	}
+#else
+	memmove(d, s, count);
+#endif
 }
 #endif
 
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


