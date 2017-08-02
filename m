From: akpm@linux-foundation.org
Subject: + arm-implement-memset32-memset64.patch added to -mm tree
Date: Wed, 02 Aug 2017 13:57:02 -0700
Message-ID: <59823c9e.CNSAO7Dunxm5oWvn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdHBU5T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:57:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, minchan@kernel.org, mingo@elte.hu, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: Implement memset32 & memset64
has been added to the -mm tree.  Its filename is
     arm-implement-memset32-memset64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-implement-memset32-memset64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-implement-memset32-memset64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: ARM: Implement memset32 & memset64

Reuse the existing optimised memset implementation to implement an
optimised memset32 and memset64.

Link: http://lkml.kernel.org/r/20170720184539.31609-5-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/string.h |   14 ++++++++++++++
 arch/arm/kernel/armksyms.c    |    2 ++
 arch/arm/lib/memset.S         |   24 ++++++++++++++++++------
 3 files changed, 34 insertions(+), 6 deletions(-)

diff -puN arch/arm/include/asm/string.h~arm-implement-memset32-memset64 arch/arm/include/asm/string.h
--- a/arch/arm/include/asm/string.h~arm-implement-memset32-memset64
+++ a/arch/arm/include/asm/string.h
@@ -24,6 +24,20 @@ extern void * memchr(const void *, int,
 #define __HAVE_ARCH_MEMSET
 extern void * memset(void *, int, __kernel_size_t);
 
+#define __HAVE_ARCH_MEMSET32
+extern void *__memset32(uint32_t *, uint32_t v, __kernel_size_t);
+static inline void *memset32(uint32_t *p, uint32_t v, __kernel_size_t n)
+{
+	return __memset32(p, v, n * 4);
+}
+
+#define __HAVE_ARCH_MEMSET64
+extern void *__memset64(uint64_t *, uint32_t low, __kernel_size_t, uint32_t hi);
+static inline void *memset64(uint64_t *p, uint64_t v, __kernel_size_t n)
+{
+	return __memset64(p, v, n * 8, v >> 32);
+}
+
 extern void __memzero(void *ptr, __kernel_size_t n);
 
 #define memset(p,v,n)							\
diff -puN arch/arm/kernel/armksyms.c~arm-implement-memset32-memset64 arch/arm/kernel/armksyms.c
--- a/arch/arm/kernel/armksyms.c~arm-implement-memset32-memset64
+++ a/arch/arm/kernel/armksyms.c
@@ -87,6 +87,8 @@ EXPORT_SYMBOL(__raw_writesl);
 EXPORT_SYMBOL(strchr);
 EXPORT_SYMBOL(strrchr);
 EXPORT_SYMBOL(memset);
+EXPORT_SYMBOL(__memset32);
+EXPORT_SYMBOL(__memset64);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memmove);
 EXPORT_SYMBOL(memchr);
diff -puN arch/arm/lib/memset.S~arm-implement-memset32-memset64 arch/arm/lib/memset.S
--- a/arch/arm/lib/memset.S~arm-implement-memset32-memset64
+++ a/arch/arm/lib/memset.S
@@ -28,7 +28,7 @@ UNWIND( .fnstart         )
 1:	orr	r1, r1, r1, lsl #8
 	orr	r1, r1, r1, lsl #16
 	mov	r3, r1
-	cmp	r2, #16
+7:	cmp	r2, #16
 	blt	4f
 
 #if ! CALGN(1)+0
@@ -41,7 +41,7 @@ UNWIND( .fnend              )
 UNWIND( .fnstart            )
 UNWIND( .save {r8, lr}      )
 	mov	r8, r1
-	mov	lr, r1
+	mov	lr, r3
 
 2:	subs	r2, r2, #64
 	stmgeia	ip!, {r1, r3, r8, lr}	@ 64 bytes at a time.
@@ -73,11 +73,11 @@ UNWIND( .fnend                 )
 UNWIND( .fnstart               )
 UNWIND( .save {r4-r8, lr}      )
 	mov	r4, r1
-	mov	r5, r1
+	mov	r5, r3
 	mov	r6, r1
-	mov	r7, r1
+	mov	r7, r3
 	mov	r8, r1
-	mov	lr, r1
+	mov	lr, r3
 
 	cmp	r2, #96
 	tstgt	ip, #31
@@ -114,7 +114,7 @@ UNWIND( .fnstart            )
 	tst	r2, #4
 	strne	r1, [ip], #4
 /*
- * When we get here, we've got less than 4 bytes to zero.  We
+ * When we get here, we've got less than 4 bytes to set.  We
  * may have an unaligned pointer as well.
  */
 5:	tst	r2, #2
@@ -135,3 +135,15 @@ UNWIND( .fnstart            )
 UNWIND( .fnend   )
 ENDPROC(memset)
 ENDPROC(mmioset)
+
+ENTRY(__memset32)
+UNWIND( .fnstart         )
+	mov	r3, r1			@ copy r1 to r3 and fall into memset64
+UNWIND( .fnend   )
+ENDPROC(__memset32)
+ENTRY(__memset64)
+UNWIND( .fnstart         )
+	mov	ip, r0			@ preserve r0 as return value
+	b	7b			@ jump into the middle of memset
+UNWIND( .fnend   )
+ENDPROC(__memset64)
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

add-multibyte-memset-functions.patch
add-testcases-for-memset16-32-64.patch
x86-implement-memset16-memset32-memset64.patch
arm-implement-memset32-memset64.patch
alpha-add-support-for-memset16.patch
zram-convert-to-using-memset_l.patch
sym53c8xx_2-convert-to-use-memset32.patch
vga-optimise-console-scrolling.patch

