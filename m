From: akpm@linux-foundation.org
Subject: + gcov-architecture-specific-compile-flag-adjustments.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:02:36 -0700
Message-ID: <200806032302.m53N2ajI024465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756829AbYFCXEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     gcov: architecture specific compile flag adjustments
has been added to the -mm tree.  Its filename is
     gcov-architecture-specific-compile-flag-adjustments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: architecture specific compile flag adjustments
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Exclude code from profiling which is not linked to the main kernel or
which is running in a context not compatible with the assumptions made by
gcc's profiling code.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/Makefile      |    1 +
 arch/powerpc/kernel/vdso32/Makefile    |    1 +
 arch/powerpc/kernel/vdso64/Makefile    |    1 +
 arch/ppc/boot/Makefile                 |    1 +
 arch/ppc/boot/common/Makefile          |    1 +
 arch/ppc/boot/simple/Makefile          |    1 +
 arch/x86/boot/Makefile                 |    1 +
 arch/x86/boot/compressed/Makefile      |    1 +
 arch/x86/kernel/acpi/realmode/Makefile |    1 +
 9 files changed, 9 insertions(+)

diff -puN arch/arm/boot/compressed/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/arm/boot/compressed/Makefile
--- a/arch/arm/boot/compressed/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/arm/boot/compressed/Makefile
@@ -7,6 +7,7 @@
 HEAD	= head.o
 OBJS	= misc.o
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
+GCOV	:= n
 
 #
 # Architecture dependencies
diff -puN arch/powerpc/kernel/vdso32/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/powerpc/kernel/vdso32/Makefile
--- a/arch/powerpc/kernel/vdso32/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/powerpc/kernel/vdso32/Makefile
@@ -17,6 +17,7 @@ EXTRA_CFLAGS := -shared -fno-common -fno
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO32__ -s
+GCOV := n
 
 obj-y += vdso32_wrapper.o
 extra-y += vdso32.lds
diff -puN arch/powerpc/kernel/vdso64/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/powerpc/kernel/vdso64/Makefile
--- a/arch/powerpc/kernel/vdso64/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/powerpc/kernel/vdso64/Makefile
@@ -11,6 +11,7 @@ EXTRA_CFLAGS := -shared -fno-common -fno
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO64__ -s
+GCOV := n
 
 obj-y += vdso64_wrapper.o
 extra-y += vdso64.lds
diff -puN arch/ppc/boot/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/ppc/boot/Makefile
--- a/arch/ppc/boot/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/ppc/boot/Makefile
@@ -16,6 +16,7 @@
 # KBUILD_CFLAGS used when building rest of boot (takes effect recursively)
 KBUILD_CFLAGS 	+= -fno-builtin -D__BOOTER__ -Iarch/$(ARCH)/boot/include
 HOSTCFLAGS	+= -Iarch/$(ARCH)/boot/include
+GCOV		:= n
 
 BOOT_TARGETS	= zImage zImage.initrd znetboot znetboot.initrd
 
diff -puN arch/ppc/boot/common/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/ppc/boot/common/Makefile
--- a/arch/ppc/boot/common/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/ppc/boot/common/Makefile
@@ -5,6 +5,7 @@
 # Tom Rini	January 2001
 #
 
+GCOV := n
 lib-y					:= string.o util.o misc-common.o \
 						serial_stub.o bootinfo.o
 lib-$(CONFIG_SERIAL_8250_CONSOLE)	+= ns16550.o
diff -puN arch/ppc/boot/simple/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/ppc/boot/simple/Makefile
--- a/arch/ppc/boot/simple/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/ppc/boot/simple/Makefile
@@ -21,6 +21,7 @@
 # XXX_memory.o file for this to work, as well as editing the
 # misc-$(CONFIG_MACHINE) variable.
 
+GCOV				:= n
 boot				:= arch/ppc/boot
 common				:= $(boot)/common
 utils				:= $(boot)/utils
diff -puN arch/x86/boot/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/x86/boot/Makefile
@@ -71,6 +71,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS +=   $(call cc-option,-m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV		:= n
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
 $(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
diff -puN arch/x86/boot/compressed/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/x86/boot/compressed/Makefile
@@ -12,6 +12,7 @@ cflags-$(CONFIG_X86_64) := -mcmodel=smal
 KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
+GCOV := n
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
diff -puN arch/x86/kernel/acpi/realmode/Makefile~gcov-architecture-specific-compile-flag-adjustments arch/x86/kernel/acpi/realmode/Makefile
--- a/arch/x86/kernel/acpi/realmode/Makefile~gcov-architecture-specific-compile-flag-adjustments
+++ a/arch/x86/kernel/acpi/realmode/Makefile
@@ -42,6 +42,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV		:= n
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
kernel-call-constructors.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-create-links-to-gcda-files-in-build-directory.patch
gcov-architecture-specific-compile-flag-adjustments.patch

