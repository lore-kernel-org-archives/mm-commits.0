From: akpm@linux-foundation.org
Subject: + initramfs-fix-initramfs-size-calculation.patch added to -mm tree
Date: Fri, 17 Sep 2010 15:24:11 -0700
Message-ID: <201009172224.o8HMOBKq013436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566Ab0IQWYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 18:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brueckner@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, hpa@zytor.com, mmarek@suse.cz, schwidefsky@de.ibm.com, xiyou.wangcong@gmail.com


The patch titled
     initramfs: fix initramfs size calculation
has been added to the -mm tree.  Its filename is
     initramfs-fix-initramfs-size-calculation.patch

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
Subject: initramfs: fix initramfs size calculation
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

The size of a built-in initramfs is calculated in init/initramfs.c by
"__initramfs_end - __initramfs_start".  Those symbols are defined in the
linker script include/asm-generic/vmlinux.lds.h:

#define INIT_RAM_FS                                                     \
        . = ALIGN(PAGE_SIZE);                                           \
        VMLINUX_SYMBOL(__initramfs_start) = .;                          \
        *(.init.ramfs)                                                  \
        VMLINUX_SYMBOL(__initramfs_end) = .;

If the initramfs file has an odd number of bytes, the "__initramfs_end"
symbol points to an odd address, for example, the symbols in the
System.map might look like:

    0000000000572000 T __initramfs_start
    00000000005bcd05 T __initramfs_end	  <-- odd address

At least on s390 this causes a problem:

Certain s390 instructions, especially instructions for loading addresses
(larl) or branch addresses must be on even addresses.  The compiler loads
the symbol addresses with the "larl" instruction.  This instruction sets
the last bit to 0 and, therefore, for odd size files, the calculated size
is one byte less than it should be:

    0000000000540a9c <populate_rootfs>:
      540a9c:     eb cf f0 78 00 24       stmg    %r12,%r15,120(%r15),
      540aa2:     c0 10 00 01 8a af       larl    %r1,572000 <__initramfs_start>
      540aa8:     c0 c0 00 03 e1 2e       larl    %r12,5bcd04 <initramfs_end>
                                                  (Instead of  5bcd05)
      ...
      540abe:     1b c1                   sr      %r12,%r1

To fix the problem, this patch introduces the global variable
__initramfs_size, which is calculated in the "usr/initramfs_data.S" file. 
The populate_rootfs() function can then use the start marker of the
.init.ramfs section and the value of __initramfs_size for loading the
initramfs.  Because the start marker and size is sufficient, the
__initramfs_end symbol is no longer needed and is removed.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    3 ++-
 init/initramfs.c                  |    9 ++++-----
 usr/initramfs_data.S              |   16 +++++++++++-----
 3 files changed, 17 insertions(+), 11 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~initramfs-fix-initramfs-size-calculation include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~initramfs-fix-initramfs-size-calculation
+++ a/include/asm-generic/vmlinux.lds.h
@@ -629,7 +629,8 @@
 	. = ALIGN(PAGE_SIZE);						\
 	VMLINUX_SYMBOL(__initramfs_start) = .;				\
 	*(.init.ramfs)							\
-	VMLINUX_SYMBOL(__initramfs_end) = .;
+	. = ALIGN(8);							\
+	*(.init.ramfs.info)
 #else
 #define INIT_RAM_FS
 #endif
diff -puN init/initramfs.c~initramfs-fix-initramfs-size-calculation init/initramfs.c
--- a/init/initramfs.c~initramfs-fix-initramfs-size-calculation
+++ a/init/initramfs.c
@@ -485,7 +485,8 @@ static int __init retain_initrd_param(ch
 }
 __setup("retain_initrd", retain_initrd_param);
 
-extern char __initramfs_start[], __initramfs_end[];
+extern char __initramfs_start[];
+extern unsigned long __initramfs_size;
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
@@ -572,8 +573,7 @@ static void __init clean_rootfs(void)
 
 static int __init populate_rootfs(void)
 {
-	char *err = unpack_to_rootfs(__initramfs_start,
-			 __initramfs_end - __initramfs_start);
+	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
 		panic(err);	/* Failed to decompress INTERNAL initramfs */
 	if (initrd_start) {
@@ -587,8 +587,7 @@ static int __init populate_rootfs(void)
 			return 0;
 		} else {
 			clean_rootfs();
-			unpack_to_rootfs(__initramfs_start,
-				 __initramfs_end - __initramfs_start);
+			unpack_to_rootfs(__initramfs_start, __initramfs_size);
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
diff -puN usr/initramfs_data.S~initramfs-fix-initramfs-size-calculation usr/initramfs_data.S
--- a/usr/initramfs_data.S~initramfs-fix-initramfs-size-calculation
+++ a/usr/initramfs_data.S
@@ -11,11 +11,7 @@
   -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
    ld -m elf_i386  -r -o built-in.o initramfs_data.o
 
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
+  For including the .init.ramfs sections, see include/asm-generic/vmlinux.lds.
 
   The above example is for i386 - the parameters vary from architectures.
   Eventually look up LDFLAGS_BLOB in an older version of the
@@ -28,4 +24,14 @@ SECTIONS
 #include <linux/stringify.h>
 
 .section .init.ramfs,"a"
+__irf_start:
 .incbin __stringify(INITRAMFS_IMAGE)
+__irf_end:
+.section .init.ramfs.info,"a"
+.globl __initramfs_size
+__initramfs_size:
+#ifdef CONFIG_32BIT
+	.long __irf_end - __irf_start
+#else
+	.quad __irf_end - __irf_start
+#endif
_

Patches currently in -mm which might be from brueckner@linux.vnet.ibm.com are

initramfs-generalize-initramfs_dataxxxs-variants.patch
initramfs-fix-initramfs-size-calculation.patch

