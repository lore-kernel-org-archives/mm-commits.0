From: akpm@linux-foundation.org
Subject: + no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch added to -mm tree
Date: Thu, 15 Feb 2007 22:13:53 -0800
Message-ID: <200702160613.l1G6Dr49021635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423325AbXBPGOF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 01:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@muc.de, jeremy@xensource.com, sam@ravnborg.org


The patch titled
     No need to use -traditional for processing asm in i386/kernel/
has been added to the -mm tree.  Its filename is
     no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: No need to use -traditional for processing asm in i386/kernel/
From: Jeremy Fitzhardinge <jeremy@goop.org>

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/Makefile            |    4 ++--
 arch/i386/boot/compressed/Makefile |    1 -
 arch/i386/kernel/Makefile          |    2 --
 arch/i386/kernel/entry.S           |    2 +-
 include/asm-i386/percpu.h          |    4 ++--
 5 files changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/i386/boot/compressed/Makefile~no-need-to-use-traditional-for-processing-asm-in-i386-kernel arch/i386/boot/compressed/Makefile
--- a/arch/i386/boot/compressed/Makefile~no-need-to-use-traditional-for-processing-asm-in-i386-kernel
+++ a/arch/i386/boot/compressed/Makefile
@@ -6,7 +6,6 @@
 
 targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
 			vmlinux.bin.all vmlinux.relocs
-EXTRA_AFLAGS	:= -traditional
 
 LDFLAGS_vmlinux := -T
 CFLAGS_misc.o += -fPIC
diff -puN arch/i386/boot/Makefile~no-need-to-use-traditional-for-processing-asm-in-i386-kernel arch/i386/boot/Makefile
--- a/arch/i386/boot/Makefile~no-need-to-use-traditional-for-processing-asm-in-i386-kernel
+++ a/arch/i386/boot/Makefile
@@ -36,9 +36,9 @@ HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 # ---------------------------------------------------------------------------
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-$(obj)/zImage:  EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
diff -puN arch/i386/kernel/entry.S~no-need-to-use-traditional-for-processing-asm-in-i386-kernel arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~no-need-to-use-traditional-for-processing-asm-in-i386-kernel
+++ a/arch/i386/kernel/entry.S
@@ -635,7 +635,7 @@ ENTRY(name)				\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
-	call smp_/**/name;		\
+	call smp_##name;		\
 	jmp ret_from_intr;		\
 	CFI_ENDPROC;			\
 ENDPROC(name)
diff -puN arch/i386/kernel/Makefile~no-need-to-use-traditional-for-processing-asm-in-i386-kernel arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~no-need-to-use-traditional-for-processing-asm-in-i386-kernel
+++ a/arch/i386/kernel/Makefile
@@ -44,8 +44,6 @@ obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-y				+= pcspeaker.o
 
-EXTRA_AFLAGS   := -traditional
-
 obj-$(CONFIG_SCx200)		+= scx200.o
 
 # vsyscall.o contains the vsyscall DSO images as __initdata.
diff -puN include/asm-i386/percpu.h~no-need-to-use-traditional-for-processing-asm-in-i386-kernel include/asm-i386/percpu.h
--- a/include/asm-i386/percpu.h~no-need-to-use-traditional-for-processing-asm-in-i386-kernel
+++ a/include/asm-i386/percpu.h
@@ -20,10 +20,10 @@
 #ifdef CONFIG_SMP
 #define PER_CPU(var, cpu) \
 	movl __per_cpu_offset(,cpu,4), cpu;	\
-	addl $per_cpu__/**/var, cpu;
+	addl $per_cpu__##var, cpu;
 #else /* ! SMP */
 #define PER_CPU(var, cpu) \
-	movl $per_cpu__/**/var, cpu;
+	movl $per_cpu__##var, cpu;
 #endif	/* SMP */
 
 #endif /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
uninline-jiffiesh-functions.patch
