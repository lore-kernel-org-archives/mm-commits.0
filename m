From: akpm@linux-foundation.org
Subject: [merged] alpha-add-support-for-memset16.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:41:01 -0700
Message-ID: <20170911194101.HO88YikeO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdIKTlC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, mawilcox@microsoft.com, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de


The patch titled
     Subject: alpha: add support for memset16
has been removed from the -mm tree.  Its filename was
     alpha-add-support-for-memset16.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: alpha: add support for memset16

Alpha already had an optimised fill-memory-with-16-bit-quantity assembler
routine called memsetw().  It has a slightly different calling convention
from memset16() in that it takes a byte count, not a count of words. 
That's the same convention used by ARM's __memset routines, so rename
Alpha's routine to match and add a memset16() wrapper around it.  Then
convert Alpha's scr_memsetw() to call memset16() instead of memsetw().

Link: http://lkml.kernel.org/r/20170720184539.31609-6-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/string.h |   15 ++++++++-------
 arch/alpha/include/asm/vga.h    |    2 +-
 arch/alpha/lib/memset.S         |   10 +++++-----
 3 files changed, 14 insertions(+), 13 deletions(-)

diff -puN arch/alpha/include/asm/string.h~alpha-add-support-for-memset16 arch/alpha/include/asm/string.h
--- a/arch/alpha/include/asm/string.h~alpha-add-support-for-memset16
+++ a/arch/alpha/include/asm/string.h
@@ -65,13 +65,14 @@ extern void * memchr(const void *, int,
    aligned values.  The DEST and COUNT parameters must be even for 
    correct operation.  */
 
-#define __HAVE_ARCH_MEMSETW
-extern void * __memsetw(void *dest, unsigned short, size_t count);
-
-#define memsetw(s, c, n)						 \
-(__builtin_constant_p(c)						 \
- ? __constant_c_memset((s),0x0001000100010001UL*(unsigned short)(c),(n)) \
- : __memsetw((s),(c),(n)))
+#define __HAVE_ARCH_MEMSET16
+extern void * __memset16(void *dest, unsigned short, size_t count);
+static inline void *memset16(uint16_t *p, uint16_t v, size_t n)
+{
+	if (__builtin_constant_p(v))
+		return __constant_c_memset(p, 0x0001000100010001UL * v, n * 2);
+	return __memset16(p, v, n * 2);
+}
 
 #endif /* __KERNEL__ */
 
diff -puN arch/alpha/include/asm/vga.h~alpha-add-support-for-memset16 arch/alpha/include/asm/vga.h
--- a/arch/alpha/include/asm/vga.h~alpha-add-support-for-memset16
+++ a/arch/alpha/include/asm/vga.h
@@ -34,7 +34,7 @@ static inline void scr_memsetw(u16 *s, u
 	if (__is_ioaddr(s))
 		memsetw_io((u16 __iomem *) s, c, count);
 	else
-		memsetw(s, c, count);
+		memset16(s, c, count / 2);
 }
 
 /* Do not trust that the usage will be correct; analyze the arguments.  */
diff -puN arch/alpha/lib/memset.S~alpha-add-support-for-memset16 arch/alpha/lib/memset.S
--- a/arch/alpha/lib/memset.S~alpha-add-support-for-memset16
+++ a/arch/alpha/lib/memset.S
@@ -20,7 +20,7 @@
 	.globl memset
 	.globl __memset
 	.globl ___memset
-	.globl __memsetw
+	.globl __memset16
 	.globl __constant_c_memset
 
 	.ent ___memset
@@ -110,8 +110,8 @@ EXPORT_SYMBOL(___memset)
 EXPORT_SYMBOL(__constant_c_memset)
 
 	.align 5
-	.ent __memsetw
-__memsetw:
+	.ent __memset16
+__memset16:
 	.prologue 0
 
 	inswl $17,0,$1		/* E0 */
@@ -123,8 +123,8 @@ __memsetw:
 	or $1,$4,$17		/* E0 */
 	br __constant_c_memset	/* .. E1 */
 
-	.end __memsetw
-EXPORT_SYMBOL(__memsetw)
+	.end __memset16
+EXPORT_SYMBOL(__memset16)
 
 memset = ___memset
 __memset = ___memset
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


