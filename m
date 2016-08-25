From: akpm@linux-foundation.org
Subject: + powerpc-add-purgatory-for-kexec_file_load-implementation.patch
 added to -mm tree
Date: Thu, 25 Aug 2016 14:13:34 -0700
Message-ID: <57bf5f7e.3c3eZF8uB2QNZfvG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755466AbcHYVN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add purgatory for kexec_file_load implementation
has been added to the -mm tree.  Its filename is
     powerpc-add-purgatory-for-kexec_file_load-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-purgatory-for-kexec_file_load-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-purgatory-for-kexec_file_load-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: add purgatory for kexec_file_load implementation

This purgatory implementation comes from kexec-tools, almost unchanged.

The only changes were that the sha256_regions global variable was
renamed to sha_regions to match what kexec_file_load expects, and to
use the sha256.c file from x86's purgatory to avoid adding yet another
SHA-256 implementation.

Also, some formatting warnings found by checkpatch.pl were fixed.

In order to use boot/string.S in ppc64 big endian mode, the functions
defined in it need to have dot symbols so that they can be called
from C code. Therefore,  change the file to use a DOTSYM macro
if one is defined, so that the purgatory can add those dot symbols.

Link: http://lkml.kernel.org/r/1471652242-14436-12-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile                     |    4 
 arch/powerpc/boot/string.S                |   67 ++++----
 arch/powerpc/purgatory/.gitignore         |    2 
 arch/powerpc/purgatory/Makefile           |   46 +++++
 arch/powerpc/purgatory/console-ppc64.c    |   38 ++++
 arch/powerpc/purgatory/crashdump-ppc64.h  |   42 +++++
 arch/powerpc/purgatory/crashdump_backup.c |   36 ++++
 arch/powerpc/purgatory/crtsavres.S        |    5 
 arch/powerpc/purgatory/hvCall.S           |   27 +++
 arch/powerpc/purgatory/hvCall.h           |    8 
 arch/powerpc/purgatory/kexec-sha256.h     |   11 +
 arch/powerpc/purgatory/ppc64_asm.h        |   20 ++
 arch/powerpc/purgatory/printf.c           |  164 ++++++++++++++++++++
 arch/powerpc/purgatory/purgatory-ppc64.c  |   41 +++++
 arch/powerpc/purgatory/purgatory-ppc64.h  |    6 
 arch/powerpc/purgatory/purgatory.c        |   62 +++++++
 arch/powerpc/purgatory/purgatory.h        |   11 +
 arch/powerpc/purgatory/sha256.c           |    6 
 arch/powerpc/purgatory/sha256.h           |    1 
 arch/powerpc/purgatory/string.S           |    2 
 arch/powerpc/purgatory/v2wrap.S           |  134 ++++++++++++++++
 21 files changed, 704 insertions(+), 29 deletions(-)

diff -puN arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation
+++ a/arch/powerpc/Makefile
@@ -256,6 +256,7 @@ core-y				+= arch/powerpc/kernel/ \
 core-$(CONFIG_XMON)		+= arch/powerpc/xmon/
 core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 core-$(CONFIG_PERF_EVENTS)	+= arch/powerpc/perf/
+core-$(CONFIG_KEXEC_FILE)	+= arch/powerpc/purgatory/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
 
@@ -377,6 +378,9 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
 archprepare: checkbin
+ifeq ($(CONFIG_KEXEC_FILE),y)
+	$(Q)$(MAKE) $(build)=arch/powerpc/purgatory arch/powerpc/purgatory/kexec-purgatory.c
+endif
 
 # Use the file '.tmp_gas_check' for binutils tests, as gas won't output
 # to stdout and these checks are run even on install targets.
diff -puN arch/powerpc/boot/string.S~powerpc-add-purgatory-for-kexec_file_load-implementation arch/powerpc/boot/string.S
--- a/arch/powerpc/boot/string.S~powerpc-add-purgatory-for-kexec_file_load-implementation
+++ a/arch/powerpc/boot/string.S
@@ -11,9 +11,18 @@
 
 #include "ppc_asm.h"
 
+/*
+ * The ppc64 kexec purgatory uses this file and packages it in ELF64,
+ * so it needs dot symbols for the ppc64 big endian ABI. This macro
+ * allows it to create those symbols.
+ */
+#ifndef DOTSYM
+#define DOTSYM(a)	a
+#endif
+
 	.text
-	.globl	strcpy
-strcpy:
+	.globl	DOTSYM(strcpy)
+DOTSYM(strcpy):
 	addi	r5,r3,-1
 	addi	r4,r4,-1
 1:	lbzu	r0,1(r4)
@@ -22,8 +31,8 @@ strcpy:
 	bne	1b
 	blr
 
-	.globl	strncpy
-strncpy:
+	.globl	DOTSYM(strncpy)
+DOTSYM(strncpy):
 	cmpwi	0,r5,0
 	beqlr
 	mtctr	r5
@@ -35,8 +44,8 @@ strncpy:
 	bdnzf	2,1b		/* dec ctr, branch if ctr != 0 && !cr0.eq */
 	blr
 
-	.globl	strcat
-strcat:
+	.globl	DOTSYM(strcat)
+DOTSYM(strcat):
 	addi	r5,r3,-1
 	addi	r4,r4,-1
 1:	lbzu	r0,1(r5)
@@ -49,8 +58,8 @@ strcat:
 	bne	1b
 	blr
 
-	.globl	strchr
-strchr:
+	.globl	DOTSYM(strchr)
+DOTSYM(strchr):
 	addi	r3,r3,-1
 1:	lbzu	r0,1(r3)
 	cmpw	0,r0,r4
@@ -60,8 +69,8 @@ strchr:
 	li	r3,0
 	blr
 
-	.globl	strcmp
-strcmp:
+	.globl	DOTSYM(strcmp)
+DOTSYM(strcmp):
 	addi	r5,r3,-1
 	addi	r4,r4,-1
 1:	lbzu	r3,1(r5)
@@ -72,8 +81,8 @@ strcmp:
 	beq	1b
 	blr
 
-	.globl	strncmp
-strncmp:
+	.globl	DOTSYM(strncmp)
+DOTSYM(strncmp):
 	mtctr	r5
 	addi	r5,r3,-1
 	addi	r4,r4,-1
@@ -85,8 +94,8 @@ strncmp:
 	bdnzt	eq,1b
 	blr
 
-	.globl	strlen
-strlen:
+	.globl	DOTSYM(strlen)
+DOTSYM(strlen):
 	addi	r4,r3,-1
 1:	lbzu	r0,1(r4)
 	cmpwi	0,r0,0
@@ -94,8 +103,8 @@ strlen:
 	subf	r3,r3,r4
 	blr
 
-	.globl	memset
-memset:
+	.globl	DOTSYM(memset)
+DOTSYM(memset):
 	rlwimi	r4,r4,8,16,23
 	rlwimi	r4,r4,16,0,15
 	addi	r6,r3,-4
@@ -120,14 +129,14 @@ memset:
 	bdnz	8b
 	blr
 
-	.globl	memmove
-memmove:
+	.globl	DOTSYM(memmove)
+DOTSYM(memmove):
 	cmplw	0,r3,r4
-	bgt	backwards_memcpy
+	bgt	DOTSYM(backwards_memcpy)
 	/* fall through */
 
-	.globl	memcpy
-memcpy:
+	.globl	DOTSYM(memcpy)
+DOTSYM(memcpy):
 	rlwinm.	r7,r5,32-3,3,31		/* r7 = r5 >> 3 */
 	addi	r6,r3,-4
 	addi	r4,r4,-4
@@ -175,8 +184,8 @@ memcpy:
 	mtctr	r7
 	b	1b
 
-	.globl	backwards_memcpy
-backwards_memcpy:
+	.globl	DOTSYM(backwards_memcpy)
+DOTSYM(backwards_memcpy):
 	rlwinm.	r7,r5,32-3,3,31		/* r7 = r5 >> 3 */
 	add	r6,r3,r5
 	add	r4,r4,r5
@@ -219,8 +228,8 @@ backwards_memcpy:
 	mtctr	r7
 	b	1b
 
-	.globl	memchr
-memchr:
+	.globl	DOTSYM(memchr)
+DOTSYM(memchr):
 	cmpwi	0,r5,0
 	blelr
 	mtctr	r5
@@ -232,8 +241,8 @@ memchr:
 	li	r3,0
 	blr
 
-	.globl	memcmp
-memcmp:
+	.globl	DOTSYM(memcmp)
+DOTSYM(memcmp):
 	cmpwi	0,r5,0
 	ble	2f
 	mtctr	r5
@@ -253,8 +262,8 @@ memcmp:
  *
  * flush_cache(addr, len)
  */
-	.global	flush_cache
-flush_cache:
+	.globl	DOTSYM(flush_cache)
+DOTSYM(flush_cache):
 	addi	4,4,0x1f	/* len = (len + 0x1f) / 0x20 */
 	rlwinm.	4,4,27,5,31
 	mtctr	4
diff -puN /dev/null arch/powerpc/purgatory/.gitignore
--- /dev/null
+++ a/arch/powerpc/purgatory/.gitignore
@@ -0,0 +1,2 @@
+kexec-purgatory.c
+purgatory.ro
diff -puN /dev/null arch/powerpc/purgatory/Makefile
--- /dev/null
+++ a/arch/powerpc/purgatory/Makefile
@@ -0,0 +1,46 @@
+OBJECT_FILES_NON_STANDARD := y
+
+purgatory-y := purgatory.o printf.o string.o v2wrap.o hvCall.o \
+		purgatory-ppc64.o console-ppc64.o crashdump_backup.o \
+		crtsavres.o sha256.o
+
+targets += $(purgatory-y)
+PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
+
+LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostartfiles \
+			-nostdlib -nodefaultlibs
+targets += purgatory.ro
+
+# Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
+# in turn leaves some undefined symbols like __fentry__ in purgatory and not
+# sure how to relocate those. Like kexec-tools, use custom flags.
+
+KBUILD_CFLAGS := -Wall -Wstrict-prototypes -fno-strict-aliasing \
+		-fno-zero-initialized-in-bss -fno-builtin -ffreestanding \
+		-fno-PIC -fno-PIE -fno-stack-protector  -fno-exceptions \
+		-msoft-float -MD -Os -m$(CONFIG_WORD_SIZE)
+KBUILD_AFLAGS := -fno-exceptions -msoft-float -m$(CONFIG_WORD_SIZE) \
+		-D__ASSEMBLY__
+
+ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
+KBUILD_CFLAGS += $(call cc-option,-mabi=elfv2,$(call cc-option,-mcall-aixdesc))
+KBUILD_AFLAGS += $(call cc-option,-mabi=elfv2)
+else
+KBUILD_CFLAGS += $(call cc-option,-mcall-aixdesc)
+endif
+
+$(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
+		$(call if_changed,ld)
+
+targets += kexec-purgatory.c
+
+CMD_BIN2C = $(objtree)/scripts/basic/bin2c
+quiet_cmd_bin2c = BIN2C   $@
+      cmd_bin2c = $(CMD_BIN2C) kexec_purgatory < $< > $@
+
+$(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
+	$(call if_changed,bin2c)
+	@:
+
+
+obj-$(CONFIG_KEXEC_FILE)	+= kexec-purgatory.o
diff -puN /dev/null arch/powerpc/purgatory/console-ppc64.c
--- /dev/null
+++ a/arch/powerpc/purgatory/console-ppc64.c
@@ -0,0 +1,38 @@
+/*
+ * kexec: Linux boots Linux
+ *
+ * Created by: Mohan Kumar M (mohan@in.ibm.com)
+ *
+ * Copyright (C) IBM Corporation, 2005. All rights reserved
+ *
+ * Code taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "hvCall.h"
+#include <asm/byteorder.h>
+
+extern int debug;
+
+void putchar(int c)
+{
+	char buff[8];
+	unsigned long *lbuf = (unsigned long *)buff;
+
+	if (!debug) /* running on non pseries */
+		return;
+
+	if (c == '\n')
+		putchar('\r');
+
+	buff[0] = c;
+	plpar_hcall_norets(H_PUT_TERM_CHAR, 0, 1, __cpu_to_be64(*lbuf), 0);
+}
diff -puN /dev/null arch/powerpc/purgatory/crashdump-ppc64.h
--- /dev/null
+++ a/arch/powerpc/purgatory/crashdump-ppc64.h
@@ -0,0 +1,42 @@
+#ifndef CRASHDUMP_PPC64_H
+#define CRASHDUMP_PPC64_H
+
+#include <linux/types.h>
+
+struct kexec_info;
+int load_crashdump_segments(struct kexec_info *info, char *mod_cmdline,
+				uint64_t max_addr, unsigned long min_base);
+void add_usable_mem_rgns(unsigned long long base, unsigned long long size);
+
+#define PAGE_OFFSET     0xC000000000000000ULL
+#define KERNELBASE      PAGE_OFFSET
+#define VMALLOCBASE     0xD000000000000000ULL
+
+#define __pa(x)         ((unsigned long)(x)-PAGE_OFFSET)
+#define MAXMEM          (-KERNELBASE-VMALLOCBASE)
+
+#define COMMAND_LINE_SIZE       512 /* from kernel */
+/* Backup Region, First 64K of System RAM. */
+#define BACKUP_SRC_START    0x0000
+#define BACKUP_SRC_END      0xffff
+#define BACKUP_SRC_SIZE     (BACKUP_SRC_END - BACKUP_SRC_START + 1)
+
+#define KDUMP_BACKUP_LIMIT	BACKUP_SRC_SIZE
+
+#define KERNEL_RUN_AT_ZERO_MAGIC 0x72756e30	/* "run0" */
+
+extern uint64_t crash_base;
+extern uint64_t crash_size;
+extern uint64_t memory_limit;
+extern unsigned int rtas_base;
+extern unsigned int rtas_size;
+extern uint64_t opal_base;
+extern uint64_t opal_size;
+
+uint64_t lmb_size;
+unsigned int num_of_lmbs;
+
+#define DRCONF_ADDR	0
+#define DRCONF_FLAGS	20
+
+#endif /* CRASHDUMP_PPC64_H */
diff -puN /dev/null arch/powerpc/purgatory/crashdump_backup.c
--- /dev/null
+++ a/arch/powerpc/purgatory/crashdump_backup.c
@@ -0,0 +1,36 @@
+/*
+ * kexec: Linux boots Linux
+ *
+ * Created by: Mohan Kumar M (mohan@in.ibm.com)
+ *
+ * Copyright (C) IBM Corporation, 2005. All rights reserved
+ *
+ * Code taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "../boot/string.h"
+#include "crashdump-ppc64.h"
+
+extern unsigned long backup_start;
+
+/* Backup first 32KB of memory to backup region reserved by kexec */
+void crashdump_backup_memory(void)
+{
+	void *dest, *src;
+
+	src = (void *)BACKUP_SRC_START;
+
+	if (backup_start) {
+		dest = (void *)(backup_start);
+		memcpy(dest, src, BACKUP_SRC_SIZE);
+	}
+}
diff -puN /dev/null arch/powerpc/purgatory/crtsavres.S
--- /dev/null
+++ a/arch/powerpc/purgatory/crtsavres.S
@@ -0,0 +1,5 @@
+#ifndef CONFIG_CC_OPTIMIZE_FOR_SIZE
+#define CONFIG_CC_OPTIMIZE_FOR_SIZE 1
+#endif
+
+#include "../lib/crtsavres.S"
diff -puN /dev/null arch/powerpc/purgatory/hvCall.S
--- /dev/null
+++ a/arch/powerpc/purgatory/hvCall.S
@@ -0,0 +1,27 @@
+/*
+ * This file contains the generic function to perform a call to the
+ * pSeries LPAR hypervisor.
+ *
+ * Taken from linux/arch/powerpc/platforms/pseries/hvCall.S
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include "ppc64_asm.h"
+
+#define HVSC	.long 0x44000022
+.text
+	.machine ppc64
+.globl DOTSYM(plpar_hcall_norets)
+DOTSYM(plpar_hcall_norets):
+	or	6,6,6			# medium low priority
+        mfcr	0
+        stw	0,8(1)
+
+        HVSC 				/* invoke the hypervisor */
+
+        lwz	0,8(1)
+        mtcrf	0xff,0
+        blr                             /* return r3 = status */
diff -puN /dev/null arch/powerpc/purgatory/hvCall.h
--- /dev/null
+++ a/arch/powerpc/purgatory/hvCall.h
@@ -0,0 +1,8 @@
+#ifndef HVCALL_H
+#define HVCALL_H
+
+#define H_PUT_TERM_CHAR	0x58
+
+long plpar_hcall_norets(unsigned long opcode, ...);
+
+#endif
diff -puN /dev/null arch/powerpc/purgatory/kexec-sha256.h
--- /dev/null
+++ a/arch/powerpc/purgatory/kexec-sha256.h
@@ -0,0 +1,11 @@
+#ifndef KEXEC_SHA256_H
+#define KEXEC_SHA256_H
+
+struct kexec_sha_region {
+	unsigned long start;
+	unsigned long len;
+};
+
+#define SHA256_REGIONS 16
+
+#endif /* KEXEC_SHA256_H */
diff -puN /dev/null arch/powerpc/purgatory/ppc64_asm.h
--- /dev/null
+++ a/arch/powerpc/purgatory/ppc64_asm.h
@@ -0,0 +1,20 @@
+/*
+ * ppc64_asm.h - common defines for PPC64 assembly parts
+ *
+ * Code taken from kexec-tools.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <asm/types.h>
+
+/*
+ * ABIv1 requires dot symbol while ABIv2 does not.
+ */
+#ifdef PPC64_ELF_ABI_v2
+#define DOTSYM(a)	a
+#else
+#define GLUE(a, b)	a##b
+#define DOTSYM(a)	GLUE(., a)
+#endif
diff -puN /dev/null arch/powerpc/purgatory/printf.c
--- /dev/null
+++ a/arch/powerpc/purgatory/printf.c
@@ -0,0 +1,164 @@
+/*
+ * Code taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <stdarg.h>
+#include "purgatory.h"
+#include "../boot/string.h"
+
+#define CHAR_BIT 8
+
+/*
+ * Output
+ * =============================================================================
+ */
+
+#define LONG_LONG_SHIFT  ((int)((sizeof(unsigned long long)*CHAR_BIT) - 4))
+#define LONG_SHIFT  ((int)((sizeof(unsigned long)*CHAR_BIT) - 4))
+#define INT_SHIFT   ((int)((sizeof(unsigned int)*CHAR_BIT) - 4))
+#define SHRT_SHIFT  ((int)((sizeof(unsigned short)*CHAR_BIT) - 4))
+#define CHAR_SHIFT  ((int)((sizeof(unsigned char)*CHAR_BIT) - 4))
+
+/**************************************************************************
+PRINTF and friends
+
+	Formats:
+		%x	- 4 bytes int (8 hex digits, lower case)
+		%X	- 4 bytes int (8 hex digits, upper case)
+		%lx     - 8 bytes long (16 hex digits, lower case)
+		%lX     - 8 bytes long (16 hex digits, upper case)
+		%hx	- 2 bytes int (4 hex digits, lower case)
+		%hX	- 2 bytes int (4 hex digits, upper case)
+		%hhx	- 1 byte int (2 hex digits, lower case)
+		%hhX	- 1 byte int (2 hex digits, upper case)
+			- optional # prefixes 0x or 0X
+		%d	- decimal int
+		%c	- char
+		%s	- string
+	Note: width specification not supported
+**************************************************************************/
+void vsprintf(char *buffer, const char *fmt, va_list args)
+{
+	char *p;
+
+	for ( ; *fmt != '\0'; ++fmt) {
+		if (*fmt != '%') {
+			if (buffer)
+				*buffer++ = *fmt;
+			else
+				putchar(*fmt);
+			continue;
+		}
+		if (*++fmt == 's') {
+			for (p = va_arg(args, char *); *p != '\0'; p++)
+				if (buffer)
+					*buffer++ = *p;
+				else
+					putchar(*p);
+		} else {	/* Length of item is bounded */
+			char tmp[40], *q = tmp;
+			int shift = INT_SHIFT;
+
+			if (*fmt == 'L') {
+				shift = LONG_LONG_SHIFT;
+				fmt++;
+			} else if (*fmt == 'l') {
+				shift = LONG_SHIFT;
+				fmt++;
+			} else if (*fmt == 'h') {
+				shift = SHRT_SHIFT;
+				fmt++;
+				if (*fmt == 'h') {
+					shift = CHAR_SHIFT;
+					fmt++;
+				}
+			}
+
+			/*
+			 * Before each format q points to tmp buffer
+			 * After each format q points past end of item
+			 */
+			if ((*fmt | 0x20) == 'x') {
+				/* With x86 gcc, sizeof(long) == sizeof(int) */
+				unsigned long long h;
+				int ncase;
+
+				if (shift > LONG_SHIFT)
+					h = va_arg(args, unsigned long long);
+				else if (shift > INT_SHIFT)
+					h = va_arg(args, unsigned long);
+				else
+					h = va_arg(args, unsigned int);
+
+				ncase = (*fmt & 0x20);
+				for ( ; shift >= 0; shift -= 4)
+					*q++ = "0123456789ABCDEF"[(h >> shift) & 0xF] | ncase;
+			} else if (*fmt == 'd') {
+				char *r;
+				long i;
+
+				if (shift > LONG_SHIFT)
+					i = va_arg(args, long long);
+				else if (shift > INT_SHIFT)
+					i = va_arg(args, long);
+				else
+					i = va_arg(args, int);
+
+				if (i < 0) {
+					*q++ = '-';
+					i = -i;
+				}
+				p = q;		/* save beginning of digits */
+				do {
+					*q++ = '0' + (i % 10);
+					i /= 10;
+				} while (i);
+				/* reverse digits, stop in middle */
+				r = q;		/* don't alter q */
+				while (--r > p) {
+					i = *r;
+					*r = *p;
+					*p++ = i;
+				}
+			} else if (*fmt == 'c')
+				*q++ = va_arg(args, int);
+			else
+				*q++ = *fmt;
+			/* now output the saved string */
+			for (p = tmp; p < q; ++p)
+				if (buffer)
+					*buffer++ = *p;
+				else
+					putchar(*p);
+		}
+	}
+	if (buffer)
+		*buffer = '\0';
+}
+
+void sprintf(char *buffer, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vsprintf(buffer, fmt, args);
+	va_end(args);
+}
+
+void printf(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vsprintf(0, fmt, args);
+	va_end(args);
+}
diff -puN /dev/null arch/powerpc/purgatory/purgatory-ppc64.c
--- /dev/null
+++ a/arch/powerpc/purgatory/purgatory-ppc64.c
@@ -0,0 +1,41 @@
+/*
+ * kexec: Linux boots Linux
+ *
+ * Created by: Mohan Kumar M (mohan@in.ibm.com)
+ *
+ * Copyright (C) IBM Corporation, 2005. All rights reserved
+ *
+ * Code taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "purgatory.h"
+#include "purgatory-ppc64.h"
+
+unsigned int panic_kernel = 0;
+unsigned long backup_start = 0;
+unsigned long stack = 0;
+unsigned long dt_offset = 0;
+unsigned long my_toc = 0;
+unsigned long kernel = 0;
+unsigned int debug = 0;
+unsigned long opal_base = 0;
+unsigned long opal_entry = 0;
+
+void setup_arch(void)
+{
+}
+
+void post_verification_setup_arch(void)
+{
+	if (panic_kernel)
+		crashdump_backup_memory();
+}
diff -puN /dev/null arch/powerpc/purgatory/purgatory-ppc64.h
--- /dev/null
+++ a/arch/powerpc/purgatory/purgatory-ppc64.h
@@ -0,0 +1,6 @@
+#ifndef PURGATORY_PPC64_H
+#define PURGATORY_PPC64_H
+
+void crashdump_backup_memory(void);
+
+#endif /* PURGATORY_PPC64_H */
diff -puN /dev/null arch/powerpc/purgatory/purgatory.c
--- /dev/null
+++ a/arch/powerpc/purgatory/purgatory.c
@@ -0,0 +1,62 @@
+/*
+ * Code taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "purgatory.h"
+#include "sha256.h"
+#include "../boot/string.h"
+#include "kexec-sha256.h"
+
+struct kexec_sha_region sha_regions[SHA256_REGIONS] = {};
+u8 sha256_digest[SHA256_DIGEST_SIZE] = { 0 };
+
+int verify_sha256_digest(void)
+{
+	struct kexec_sha_region *ptr, *end;
+	u8 digest[SHA256_DIGEST_SIZE];
+	size_t i;
+	struct sha256_state sctx;
+
+	sha256_init(&sctx);
+	end = &sha_regions[sizeof(sha_regions)/sizeof(sha_regions[0])];
+	for (ptr = sha_regions; ptr < end; ptr++)
+		sha256_update(&sctx, (uint8_t *)(ptr->start), ptr->len);
+	sha256_final(&sctx, digest);
+
+	if (memcmp(digest, sha256_digest, sizeof(digest)) != 0) {
+		printf("sha256 digests do not match :(\n");
+		printf("       digest: ");
+		for (i = 0; i < sizeof(digest); i++)
+			printf("%hhx ", digest[i]);
+		printf("\n");
+
+		printf("sha256_digest: ");
+		for (i = 0; i < sizeof(sha256_digest); i++)
+			printf("%hhx ", sha256_digest[i]);
+
+		printf("\n");
+		return 1;
+	}
+	return 0;
+}
+
+void purgatory(void)
+{
+	printf("I'm in purgatory\n");
+	setup_arch();
+	if (verify_sha256_digest()) {
+		/* loop forever */
+		for (;;)
+			;
+	}
+	post_verification_setup_arch();
+}
diff -puN /dev/null arch/powerpc/purgatory/purgatory.h
--- /dev/null
+++ a/arch/powerpc/purgatory/purgatory.h
@@ -0,0 +1,11 @@
+#ifndef PURGATORY_H
+#define PURGATORY_H
+
+void putchar(int ch);
+void sprintf(char *buffer, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+void printf(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
+void setup_arch(void);
+void post_verification_setup_arch(void);
+
+#endif /* PURGATORY_H */
diff -puN /dev/null arch/powerpc/purgatory/sha256.c
--- /dev/null
+++ a/arch/powerpc/purgatory/sha256.c
@@ -0,0 +1,6 @@
+#include "../boot/string.h"
+
+/* Avoid including x86's boot/string.h in sha256.c. */
+#define BOOT_STRING_H
+
+#include "../../x86/purgatory/sha256.c"
diff -puN /dev/null arch/powerpc/purgatory/sha256.h
--- /dev/null
+++ a/arch/powerpc/purgatory/sha256.h
@@ -0,0 +1 @@
+#include "../../x86/purgatory/sha256.h"
diff -puN /dev/null arch/powerpc/purgatory/string.S
--- /dev/null
+++ a/arch/powerpc/purgatory/string.S
@@ -0,0 +1,2 @@
+#include "ppc64_asm.h"
+#include "../boot/string.S"
diff -puN /dev/null arch/powerpc/purgatory/v2wrap.S
--- /dev/null
+++ a/arch/powerpc/purgatory/v2wrap.S
@@ -0,0 +1,134 @@
+#
+#  kexec: Linux boots Linux
+#
+#  Copyright (C) 2004 - 2005, Milton D Miller II, IBM Corporation
+#  Copyright (C) 2006, Mohan Kumar M (mohan@in.ibm.com), IBM Corporation
+#
+# Code taken from kexec-tools.
+#
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation (version 2 of the License).
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+
+#include "ppc64_asm.h"
+
+# v2wrap.S
+# a wrapper to call purgatory code to backup first
+# 32kB of first kernel into the backup region
+# reserved by kexec-tools.
+# Invokes ppc64 kernel with the expected arguments
+# of kernel(device-tree, phys-offset, 0)
+
+#
+# calling convention:
+#   r3 = physical number of this cpu (all cpus)
+#   r4 = address of this chunk (master only)
+# master enters at purgatory_start (aka first byte of this chunk)
+# slaves (additional cpus), if any, enter a copy of the
+# first 0x100 bytes of this code relocated to 0x0
+#
+# in other words,
+#   a copy of the first 0x100 bytes of this code is copied to 0
+#   and the slaves are sent to address 0x60
+#   with r3 = their physical cpu number.
+
+#define LOADADDR(rn,name) \
+	lis     rn,name##@highest;      \
+	ori     rn,rn,name##@higher;    \
+	rldicr  rn,rn,32,31;            \
+	oris    rn,rn,name##@h;         \
+	ori     rn,rn,name##@l
+
+	.machine ppc64
+	.align 8
+	.globl purgatory_start
+purgatory_start:	b	master
+	.org purgatory_start + 0x5c     # ABI: possible run_at_load flag at 0x5c
+	.globl run_at_load
+run_at_load:
+	.long 0
+	.size run_at_load, . - run_at_load
+	.org purgatory_start + 0x60     # ABI: slaves start at 60 with r3=phys
+slave:	b $
+	.org purgatory_start + 0x100    # ABI: end of copied region
+	.size purgatory_start, . - purgatory_start
+
+#
+# The above 0x100 bytes at purgatory_start are replaced with the
+# code from the kernel (or next stage) by kexec/arch/ppc64/kexec-elf-ppc64.c
+#
+
+master:
+	or	1,1,1		# low priority to let other threads catchup
+	isync
+	mr      17,3            # save cpu id to r17
+	mr      15,4            # save physical address in reg15
+
+	LOADADDR(6,my_toc)
+	ld      2,0(6)          #setup toc
+
+	LOADADDR(6,stack)
+	ld      1,0(6)          #setup stack
+
+	subi    1,1,112
+	bl      DOTSYM(purgatory)
+	nop
+
+	or	3,3,3		# ok now to high priority, lets boot
+	lis	6,0x1
+	mtctr	6		# delay a bit for slaves to catch up
+83:	bdnz	83b		# before we overwrite 0-100 again
+
+	LOADADDR(16, dt_offset)
+	ld      3,0(16)         # load device-tree address
+	mr      16,3            # save dt address in reg16
+#ifdef __BIG_ENDIAN__
+	lwz     6,20(3)         # fetch version number
+#else
+	li	4,20
+	lwbrx	6,3,4		# fetch BE version number
+#endif
+	cmpwi   0,6,2           # v2 ?
+	blt     80f
+#ifdef __BIG_ENDIAN__
+	stw     17,28(3)        # save my cpu number as boot_cpu_phys
+#else
+	li	4,28
+	stwbrx	17,3,4		# Store my cpu as BE value
+#endif
+80:
+	LOADADDR(6,opal_base)	# For OPAL early debug
+	ld      8,0(6)          # load the OPAL base address in r8
+	LOADADDR(6,opal_entry)	# For OPAL early debug
+	ld      9,0(6)          # load the OPAL entry address in r9
+	LOADADDR(6,kernel)
+	ld      4,0(6)          # load the kernel address
+	LOADADDR(6,run_at_load) # the load flag
+	lwz	7,0(6)		# possibly patched by kexec-elf-ppc64
+	stw	7,0x5c(4)	# and patch it into the kernel
+	mr      3,16            # restore dt address
+
+	mfmsr	5
+	andi.	10,5,1		# test MSR_LE
+	bne	little_endian
+
+	li	5,0		# r5 will be 0 for kernel
+	mtctr	4		# prepare branch to
+	bctr			# start kernel
+
+little_endian:			# book3s-only
+	mtsrr0	4		# prepare branch to
+
+	clrrdi	5,5,1		# clear MSR_LE
+	mtsrr1	5
+
+	li	5,0		# r5 will be 0 for kernel
+
+				# skip cache flush, do we care?
+
+	rfid			# update MSR and start kernel
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-demonstration-code-for-kexec-buffer-passing.patch

