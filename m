From: akpm@osdl.org
Subject: + add-memcpy_uncached_read.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:10:56 -0800
Message-ID: <200612140010.kBE0AusC025611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbWLNALa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:11:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bos@pathscale.com, ak@suse.de, bryan.osullivan@qlogic.com, rolandd@cisco.com


The patch titled
     Add memcpy_uncached_read(): a memcpy that tries to reduce cache pressure
has been added to the -mm tree.  Its filename is
     add-memcpy_uncached_read.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add memcpy_uncached_read(): a memcpy that tries to reduce cache pressure
From: "Bryan O'Sullivan" <bos@pathscale.com>

This copy routine is memcpy-compatible, but on some architectures will use
cache-bypassing loads to avoid bringing the source data into the cache.

One case where this is useful is when a device issues a DMA to a memory
region, and the CPU must copy the DMAed data elsewhere before doing any work
with it.  Since the source data is read-once, write-never from the CPU's
perspective, caching the data at those addresses can only evict potentially
useful data.

We provide an x86_64 implementation that uses SSE non-temporal loads, and a
generic version that falls back to plain memcpy.

Implementors for other arches should not use cache-bypassing stores to the
destination, as in most cases, the destination is accessed almost immediately
after a copy finishes.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/lib/Makefile               |    3 
 arch/x86_64/lib/memcpy_uncached_read.S |  142 +++++++++++++++++++++++
 include/asm-x86_64/string.h            |    2 
 include/linux/string.h                 |    3 
 4 files changed, 149 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/lib/Makefile~add-memcpy_uncached_read arch/x86_64/lib/Makefile
--- a/arch/x86_64/lib/Makefile~add-memcpy_uncached_read
+++ a/arch/x86_64/lib/Makefile
@@ -9,4 +9,5 @@ obj-y := io.o iomap_copy.o
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
 	thunk.o clear_page.o copy_page.o bitstr.o bitops.o
-lib-y += memcpy.o memmove.o memset.o copy_user.o rwlock.o
+lib-y += memcpy.o memmove.o memset.o copy_user.o rwlock.o \
+	memcpy_uncached_read.o
diff -puN /dev/null arch/x86_64/lib/memcpy_uncached_read.S
--- /dev/null
+++ a/arch/x86_64/lib/memcpy_uncached_read.S
@@ -0,0 +1,142 @@
+/*
+ * Copyright (c) 2006 QLogic Corporation.  All Rights Reserved.
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+/*
+ * memcpy_uncached_read - memcpy-compatible copy routine, using streaming loads
+ * @dest: destination address
+ * @src: source address (will not be cached)
+ * @count: number of bytes to copy
+ *
+ * Use streaming loads and normal stores for a special-case copy where
+ * we know we won't be reading the source again, but will be reading the
+ * destination again soon.
+ */
+	.text
+	.p2align 4,,15
+	/* rdi  destination, rsi source, rdx count */
+	.globl	memcpy_uncached_read
+	.type	memcpy_uncached_read, @function
+memcpy_uncached_read:
+	movq	%rdi, %rax
+.L5:
+	cmpq	$15, %rdx
+	ja	.L34
+.L3:
+	cmpl	$8, %edx	/* rdx is 0..15 */
+	jbe	.L9
+.L6:
+	testb	$8, %dxl	/* rdx is 3,5,6,7,9..15 */
+	je	.L13
+	movq	(%rsi), %rcx
+	addq	$8, %rsi
+	movq	%rcx, (%rdi)
+	addq	$8, %rdi
+.L13:
+	testb	$4, %dxl
+	je	.L15
+	movl	(%rsi), %ecx
+	addq	$4, %rsi
+	movl	%ecx, (%rdi)
+	addq	$4, %rdi
+.L15:
+	testb	$2, %dxl
+	je	.L17
+	movzwl	(%rsi), %ecx
+	addq	$2, %rsi
+	movw	%cx, (%rdi)
+	addq	$2, %rdi
+.L17:
+	testb	$1, %dxl
+	je	.L33
+.L1:
+	movzbl	(%rsi), %ecx
+	movb	%cl, (%rdi)
+.L33:
+	ret
+.L34:
+	cmpq	$63, %rdx	/* rdx is > 15 */
+	ja	.L64
+	movl	$16, %ecx	/* rdx is 16..63 */
+.L25:
+	movq	8(%rsi), %r8
+	movq	(%rsi), %r9
+	addq	%rcx, %rsi
+	movq	%r8, 8(%rdi)
+	movq	%r9, (%rdi)
+	addq	%rcx, %rdi
+	subq	%rcx, %rdx
+	cmpl	%edx, %ecx	/* is rdx >= 16? */
+	jbe	.L25
+	jmp	.L3		/* rdx is 0..15 */
+	.p2align 4,,7
+.L64:
+	movl	$64, %ecx
+.L42:
+	prefetchnta	128(%rsi)
+	movq	(%rsi), %r8
+	movq	8(%rsi), %r9
+	movq	16(%rsi), %r10
+	movq	24(%rsi), %r11
+	subq	%rcx, %rdx
+	movq	%r8, (%rdi)
+	movq	32(%rsi), %r8
+	movq	%r9, 8(%rdi)
+	movq	40(%rsi), %r9
+	movq	%r10, 16(%rdi)
+	movq	48(%rsi), %r10
+	movq	%r11, 24(%rdi)
+	movq	56(%rsi), %r11
+	addq	%rcx, %rsi
+	movq	%r8, 32(%rdi)
+	movq	%r9, 40(%rdi)
+	movq	%r10, 48(%rdi)
+	movq	%r11, 56(%rdi)
+	addq	%rcx, %rdi
+	cmpq	%rdx, %rcx	/* is rdx >= 64? */
+	jbe	.L42
+	sfence
+	orl	%edx, %edx
+	je	.L33
+	jmp	.L5
+.L9:
+	jmp	*.L12(,%rdx,8)	/* rdx is 0..8 */
+	.section	.rodata
+	.align 8
+	.align 4
+.L12:
+	.quad	.L33
+	.quad	.L1
+	.quad	.L2
+	.quad	.L6
+	.quad	.L4
+	.quad	.L6
+	.quad	.L6
+	.quad	.L6
+	.quad	.L8
+	.text
+.L2:
+	movzwl	(%rsi), %ecx
+	movw	%cx, (%rdi)
+	ret
+.L4:
+	movl	(%rsi), %ecx
+	movl	%ecx, (%rdi)
+	ret
+.L8:
+	movq	(%rsi), %rcx
+	movq	%rcx, (%rdi)
+	ret
diff -puN include/asm-x86_64/string.h~add-memcpy_uncached_read include/asm-x86_64/string.h
--- a/include/asm-x86_64/string.h~add-memcpy_uncached_read
+++ a/include/asm-x86_64/string.h
@@ -39,6 +39,8 @@ extern void *__memcpy(void *to, const vo
 		 __ret = __builtin_memcpy((dst),(src),__len);	\
 	   __ret; }) 
 
+#define __HAVE_ARCH_MEMCPY_UNCACHED_READ
+extern void *memcpy_uncached_read(void *to, const void *from, size_t len);
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
diff -puN include/linux/string.h~add-memcpy_uncached_read include/linux/string.h
--- a/include/linux/string.h~add-memcpy_uncached_read
+++ a/include/linux/string.h
@@ -85,6 +85,9 @@ extern void * memset(void *,int,__kernel
 #ifndef __HAVE_ARCH_MEMCPY
 extern void * memcpy(void *,const void *,__kernel_size_t);
 #endif
+#ifndef __HAVE_ARCH_MEMCPY_UNCACHED_READ
+#define memcpy_uncached_read(dest, src, count) memcpy((dest), (src), (count))
+#endif
 #ifndef __HAVE_ARCH_MEMMOVE
 extern void * memmove(void *,const void *,__kernel_size_t);
 #endif
_

Patches currently in -mm which might be from bos@pathscale.com are

add-memcpy_uncached_read.patch
ib-ipath-use-memcpy_uncached_read-in-rdma-interrupt.patch

