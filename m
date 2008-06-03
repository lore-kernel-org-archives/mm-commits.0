From: akpm@linux-foundation.org
Subject: - gcov-architecture-specific-compile-flag-adjustments.patch removed from -mm tree
Date: Tue, 03 Jun 2008 15:51:18 -0700
Message-ID: <200806032251.m53MpIM8024004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYFCWwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oberparleiter@de.ibm.com, andi@firstfloor.org, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de, mm-commits@


The patch titled
     gcov: architecture specific compile flag adjustments
has been removed from the -mm tree.  Its filename was
     gcov-architecture-specific-compile-flag-adjustments.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: architecture specific compile flag adjustments
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Exclude code from profiling which is not linked to the main kernel or
which is running in a context not compatible with the assumptions made by
gcc's profiling code.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/Makefile      |    1 +
 arch/ppc/boot/Makefile                 |    1 +
 arch/ppc/boot/common/Makefile          |    1 +
 arch/ppc/boot/simple/Makefile          |    1 +
 arch/x86/boot/Makefile                 |    1 +
 arch/x86/boot/compressed/Makefile      |    1 +
 arch/x86/kernel/acpi/realmode/Makefile |    1 +
 7 files changed, 7 insertions(+)

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
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch

