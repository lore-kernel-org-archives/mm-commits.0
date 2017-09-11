From: akpm@linux-foundation.org
Subject: [merged] x86-implement-memset16-memset32-memset64.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:40:55 -0700
Message-ID: <20170911194055.43QbTkWWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdIKTk4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, mawilcox@microsoft.com, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de


The patch titled
     Subject: x86: implement memset16, memset32 & memset64
has been removed from the -mm tree.  Its filename was
     x86-implement-memset16-memset32-memset64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: x86: implement memset16, memset32 & memset64

These are single instructions on x86.  There's no 64-bit instruction for
x86-32, but we don't yet have any user for memset64() on 32-bit
architectures, so don't bother to implement it.

Link: http://lkml.kernel.org/r/20170720184539.31609-4-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/string_32.h |   24 +++++++++++++++++++
 arch/x86/include/asm/string_64.h |   36 +++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff -puN arch/x86/include/asm/string_32.h~x86-implement-memset16-memset32-memset64 arch/x86/include/asm/string_32.h
--- a/arch/x86/include/asm/string_32.h~x86-implement-memset16-memset32-memset64
+++ a/arch/x86/include/asm/string_32.h
@@ -340,6 +340,30 @@ extern void *memset(void *, int, size_t)
 #endif
 #endif /* !CONFIG_FORTIFY_SOURCE */
 
+#define __HAVE_ARCH_MEMSET16
+static inline void *memset16(uint16_t *s, uint16_t v, size_t n)
+{
+	int d0, d1;
+	asm volatile("rep\n\t"
+		     "stosw"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (v), "1" (s), "0" (n)
+		     : "memory");
+	return s;
+}
+
+#define __HAVE_ARCH_MEMSET32
+static inline void *memset32(uint32_t *s, uint32_t v, size_t n)
+{
+	int d0, d1;
+	asm volatile("rep\n\t"
+		     "stosl"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (v), "1" (s), "0" (n)
+		     : "memory");
+	return s;
+}
+
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
  */
diff -puN arch/x86/include/asm/string_64.h~x86-implement-memset16-memset32-memset64 arch/x86/include/asm/string_64.h
--- a/arch/x86/include/asm/string_64.h~x86-implement-memset16-memset32-memset64
+++ a/arch/x86/include/asm/string_64.h
@@ -58,6 +58,42 @@ extern void *__memcpy(void *to, const vo
 void *memset(void *s, int c, size_t n);
 void *__memset(void *s, int c, size_t n);
 
+#define __HAVE_ARCH_MEMSET16
+static inline void *memset16(uint16_t *s, uint16_t v, size_t n)
+{
+	long d0, d1;
+	asm volatile("rep\n\t"
+		     "stosw"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (v), "1" (s), "0" (n)
+		     : "memory");
+	return s;
+}
+
+#define __HAVE_ARCH_MEMSET32
+static inline void *memset32(uint32_t *s, uint32_t v, size_t n)
+{
+	long d0, d1;
+	asm volatile("rep\n\t"
+		     "stosl"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (v), "1" (s), "0" (n)
+		     : "memory");
+	return s;
+}
+
+#define __HAVE_ARCH_MEMSET64
+static inline void *memset64(uint64_t *s, uint64_t v, size_t n)
+{
+	long d0, d1;
+	asm volatile("rep\n\t"
+		     "stosq"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (v), "1" (s), "0" (n)
+		     : "memory");
+	return s;
+}
+
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);
 void *__memmove(void *dest, const void *src, size_t count);
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


