From: akpm@linux-foundation.org
Subject: + x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch added to -mm tree
Date: Mon, 14 May 2007 17:41:14 -0700
Message-ID: <200705150041.l4F0fEYs030290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756691AbXEOAlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 20:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ak@suse.de, ebiederm@xmission.com, vgoyal@in.ibm.com


The patch titled
     x86_64: build and use GDT on copied compressed kernel
has been added to the -mm tree.  Its filename is
     x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: build and use GDT on copied compressed kernel
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

In arch/x86_64/boot/compressed/head.S it switches to 64 bit mode and then
copies the compressed image to a higher address then jumps to the copied
image, then decompressed the compressed image to final uncompressed kernel and
it may overlapped with original loaded compressed kernel image.

Before jumping to 64 bit mode, it will create new page table in some place
higher in copied compressed kernel image.  But it still uses the GDT in place
of original loaded compressed image.  So the GDT will be overwriten in the
middle of decompressing.

So we could change to build the GDT like page table together with copied
compressed kernel.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/boot/compressed/head.S      |   30 ++++++++++++----------
 arch/x86_64/boot/compressed/vmlinux.lds |    2 +
 2 files changed, 19 insertions(+), 13 deletions(-)

diff -puN arch/x86_64/boot/compressed/head.S~x86_64-build-and-use-gdt-on-copied-compressed-kernel arch/x86_64/boot/compressed/head.S
--- a/arch/x86_64/boot/compressed/head.S~x86_64-build-and-use-gdt-on-copied-compressed-kernel
+++ a/arch/x86_64/boot/compressed/head.S
@@ -94,10 +94,23 @@ startup_32:
  * Prepare for entering 64 bit mode
  */
 
+/*
+ * Build early GDT table on copied compressed kernel image position, So GDT
+ * is not be overwriten when decompressing the compressed kernel.
+ */
+	movw	$0x0020, gdt+0x00(%ebx)
+	movw	$0x0000, gdt+0x06(%ebx)
+	movl	$0x00000000, gdt+0x08(%ebx) /* NULL descriptor */
+	movl	$0x00000000, gdt+0x0c(%ebx)
+	movl	$0x0000ffff, gdt+0x10(%ebx) /* __KERNEL_CS */
+	movl	$0x00af9a00, gdt+0x14(%ebx)
+	movl	$0x0000ffff, gdt+0x18(%ebx) /* __KERNEL_DS */
+	movl	$0x00cf9200, gdt+0x1c(%ebx)
+
 	/* Load new GDT with the 64bit segments using 32bit descriptor */
-	leal	gdt(%ebp), %eax
-	movl	%eax, gdt+2(%ebp)
-	lgdt	gdt(%ebp)
+	leal	gdt(%ebx), %eax
+	movl	%eax, gdt+2(%ebx)
+	lgdt	gdt(%ebx)
 
 	/* Enable PAE mode */
 	xorl	%eax, %eax
@@ -182,7 +195,7 @@ no_longmode:
 	 * it may change in the future.
 	 */
 	.code64
-	.org 0x200
+	.org 0x400
 ENTRY(startup_64)
 	/* We come here either from startup_32 or directly from a
 	 * 64bit bootloader.  If we come here from a bootloader we depend on
@@ -287,15 +300,6 @@ relocated:
  */
 	jmp	*%rbp
 
-	.data
-gdt:
-	.word	gdt_end - gdt
-	.long	gdt
-	.word	0
-	.quad	0x0000000000000000	/* NULL descriptor */
-	.quad	0x00af9a000000ffff	/* __KERNEL_CS */
-	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
-gdt_end:
 	.bss
 /* Stack for uncompression */
 	.balign 4
diff -puN arch/x86_64/boot/compressed/vmlinux.lds~x86_64-build-and-use-gdt-on-copied-compressed-kernel arch/x86_64/boot/compressed/vmlinux.lds
--- a/arch/x86_64/boot/compressed/vmlinux.lds~x86_64-build-and-use-gdt-on-copied-compressed-kernel
+++ a/arch/x86_64/boot/compressed/vmlinux.lds
@@ -36,6 +36,8 @@ SECTIONS
 		*(COMMON)
 		. = ALIGN(8);
 		_end = . ;
+		gdt = . ;
+		. = . + 8 * 4;
 		. = ALIGN(4096);
 		pgtable = . ;
 		. = . + 4096 * 6;
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch
