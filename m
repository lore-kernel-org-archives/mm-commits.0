From: akpm@linux-foundation.org
Subject: [to-be-updated]
 powerpc-add-purgatory-for-kexec_file_load-implementation.patch removed from -mm tree
Date: Tue, 29 Nov 2016 10:59:21 -0800
Message-ID: <583dd009.uUZnnxGCQfcgQBMu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbcK2S7I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2016 13:59:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add purgatory for kexec_file_load implementation
has been removed from the -mm tree.  Its filename was
     powerpc-add-purgatory-for-kexec_file_load-implementation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: add purgatory for kexec_file_load implementation

This purgatory implementation comes from kexec-tools and was trimmed
down a bit.

It uses the memset, memcpy and memcmp implementations from lib/string.c.
It's not straightforward to #include "lib/string.c" so we simply
copy those functions.

The changes made to the purgatory code relative to the version in
kexec-tools were:

The support for printing messages to the console was removed.

Also, since we don't support loading a crashdump kernel via
kexec_file_load yet, the code related to that functionality has been
removed for now.

The sha256_regions global variable was renamed to sha_regions to match
what kexec_file_load expects, and to use the sha256.c file from x86's
purgatory (this avoids adding yet another SHA-256 implementation).

The global variables in purgatory.c and purgatory-ppc64.c now use a
__section attribute to put them in the .data section instead of being
initialized to zero. It doesn't matter what their initial value is,
because they will be set by the kernel when preparing the kexec image.

Finally, some checkpatch.pl warnings were fixed.

Link: http://lkml.kernel.org/r/1478748449-3894-10-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile                          |    1 
 arch/powerpc/purgatory/.gitignore              |    2 
 arch/powerpc/purgatory/Makefile                |   40 ++++
 arch/powerpc/purgatory/crtsavres.S             |    5 
 arch/powerpc/purgatory/kexec-sha256.h          |   11 +
 arch/powerpc/purgatory/purgatory-ppc64.c       |   36 ++++
 arch/powerpc/purgatory/purgatory.c             |   48 +++++
 arch/powerpc/purgatory/purgatory.h             |   10 +
 arch/powerpc/purgatory/sha256.c                |    6 
 arch/powerpc/purgatory/sha256.h                |    1 
 arch/powerpc/purgatory/string.c                |   60 ++++++
 arch/powerpc/purgatory/v2wrap.S                |  132 +++++++++++++++
 arch/powerpc/scripts/check-purgatory-relocs.sh |   47 +++++
 13 files changed, 399 insertions(+)

diff -puN arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-add-purgatory-for-kexec_file_load-implementation
+++ a/arch/powerpc/Makefile
@@ -249,6 +249,7 @@ core-y				+= arch/powerpc/kernel/ \
 core-$(CONFIG_XMON)		+= arch/powerpc/xmon/
 core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 core-$(CONFIG_PERF_EVENTS)	+= arch/powerpc/perf/
+core-$(CONFIG_KEXEC_FILE)	+= arch/powerpc/purgatory/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
 
diff -puN /dev/null arch/powerpc/purgatory/.gitignore
--- /dev/null
+++ a/arch/powerpc/purgatory/.gitignore
@@ -0,0 +1,2 @@
+kexec-purgatory.c
+purgatory.ro
diff -puN /dev/null arch/powerpc/purgatory/Makefile
--- /dev/null
+++ a/arch/powerpc/purgatory/Makefile
@@ -0,0 +1,40 @@
+OBJECT_FILES_NON_STANDARD := y
+
+purgatory-y := purgatory.o string.o v2wrap.o purgatory-ppc64.o crtsavres.o \
+		sha256.o
+
+targets += $(purgatory-y)
+PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
+
+LDFLAGS_purgatory.ro := -pie --no-dynamic-linker -e purgatory_start \
+			--no-undefined -nostartfiles -nostdlib -nodefaultlibs
+targets += purgatory.ro
+
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE), $(KBUILD_CFLAGS))
+
+KBUILD_CFLAGS += -fno-zero-initialized-in-bss -fno-builtin -ffreestanding \
+		 -fno-stack-protector -fno-exceptions -fpie
+KBUILD_AFLAGS += -fno-exceptions -msoft-float -fpie
+
+$(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
+		$(call if_changed,ld)
+
+targets += kexec-purgatory.c
+
+quiet_cmd_relocs_check = CALL    $<
+      cmd_relocs_check = $(CONFIG_SHELL) $< "$(OBJDUMP)" "$(obj)/purgatory.ro"
+
+PHONY += relocs_check
+relocs_check: arch/powerpc/scripts/check-purgatory-relocs.sh $(obj)/purgatory.ro
+	$(call cmd,relocs_check)
+
+CMD_BIN2C = $(objtree)/scripts/basic/bin2c
+quiet_cmd_bin2c = BIN2C   $@
+      cmd_bin2c = $(CMD_BIN2C) kexec_purgatory < $< > $@
+
+$(obj)/kexec-purgatory.c: $(obj)/purgatory.ro relocs_check FORCE
+	$(call if_changed,bin2c)
+	@:
+
+
+obj-$(CONFIG_KEXEC_FILE)	+= kexec-purgatory.o
diff -puN /dev/null arch/powerpc/purgatory/crtsavres.S
--- /dev/null
+++ a/arch/powerpc/purgatory/crtsavres.S
@@ -0,0 +1,5 @@
+#ifndef CONFIG_CC_OPTIMIZE_FOR_SIZE
+#define CONFIG_CC_OPTIMIZE_FOR_SIZE 1
+#endif
+
+#include "../lib/crtsavres.S"
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
diff -puN /dev/null arch/powerpc/purgatory/purgatory-ppc64.c
--- /dev/null
+++ a/arch/powerpc/purgatory/purgatory-ppc64.c
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
+#include <linux/compiler.h>
+#include "purgatory.h"
+
+unsigned long stack __section(".data");
+unsigned long dt_offset __section(".data");
+unsigned long my_toc __section(".data");
+unsigned long kernel __section(".data");
+unsigned long opal_base __section(".data");
+unsigned long opal_entry __section(".data");
+
+void setup_arch(void)
+{
+}
+
+void post_verification_setup_arch(void)
+{
+}
diff -puN /dev/null arch/powerpc/purgatory/purgatory.c
--- /dev/null
+++ a/arch/powerpc/purgatory/purgatory.c
@@ -0,0 +1,48 @@
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
+#include "kexec-sha256.h"
+
+struct kexec_sha_region sha_regions[SHA256_REGIONS] __section(".data");
+u8 sha256_digest[SHA256_DIGEST_SIZE] __section(".data");
+
+int verify_sha256_digest(void)
+{
+	struct kexec_sha_region *ptr, *end;
+	u8 digest[SHA256_DIGEST_SIZE];
+	struct sha256_state sctx;
+
+	sha256_init(&sctx);
+	end = &sha_regions[sizeof(sha_regions)/sizeof(sha_regions[0])];
+	for (ptr = sha_regions; ptr < end; ptr++)
+		sha256_update(&sctx, (uint8_t *)(ptr->start), ptr->len);
+	sha256_final(&sctx, digest);
+
+	if (memcmp(digest, sha256_digest, sizeof(digest)))
+		return 1;
+
+	return 0;
+}
+
+void purgatory(void)
+{
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
@@ -0,0 +1,10 @@
+#ifndef PURGATORY_H
+#define PURGATORY_H
+
+#include <linux/types.h>
+
+int memcmp(const void *cs, const void *ct, size_t count);
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
diff -puN /dev/null arch/powerpc/purgatory/string.c
--- /dev/null
+++ a/arch/powerpc/purgatory/string.c
@@ -0,0 +1,60 @@
+/*
+ * Copied from linux/lib/string.c.
+ */
+
+#include <linux/types.h>
+
+/**
+ * memset - Fill a region of memory with the given value
+ * @s: Pointer to the start of the area.
+ * @c: The byte to fill the area with
+ * @count: The size of the area.
+ *
+ * Do not use memset() to access IO space, use memset_io() instead.
+ */
+void *memset(void *s, int c, size_t count)
+{
+	char *xs = s;
+
+	while (count--)
+		*xs++ = c;
+	return s;
+}
+
+/**
+ * memcpy - Copy one area of memory to another
+ * @dest: Where to copy to
+ * @src: Where to copy from
+ * @count: The size of the area.
+ *
+ * You should not use this function to access IO space, use memcpy_toio()
+ * or memcpy_fromio() instead.
+ */
+void *memcpy(void *dest, const void *src, size_t count)
+{
+	char *tmp = dest;
+	const char *s = src;
+
+	while (count--)
+		*tmp++ = *s++;
+	return dest;
+}
+
+/**
+ * memcmp - Compare two areas of memory
+ * @cs: One area of memory
+ * @ct: Another area of memory
+ * @count: The size of the area.
+ */
+int memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res = 0;
+
+	for (su1 = cs, su2 = ct; count > 0; ++su1, ++su2, count--) {
+		res = *su1 - *su2;
+		if (res != 0)
+			break;
+	}
+	return res;
+}
diff -puN /dev/null arch/powerpc/purgatory/v2wrap.S
--- /dev/null
+++ a/arch/powerpc/purgatory/v2wrap.S
@@ -0,0 +1,132 @@
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
+	bl      purgatory
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
diff -puN /dev/null arch/powerpc/scripts/check-purgatory-relocs.sh
--- /dev/null
+++ a/arch/powerpc/scripts/check-purgatory-relocs.sh
@@ -0,0 +1,47 @@
+#!/bin/sh
+
+# Copyright © 2016 IBM Corporation
+
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation; either version
+# 2 of the License, or (at your option) any later version.
+
+# This script checks the relocations of a purgatory executable for
+# relocations that are not handled by the kernel.
+
+# Based on relocs_check.sh.
+# Copyright © 2015 IBM Corporation
+
+if [ $# -lt 2 ]; then
+	echo "$0 [path to objdump] [path to purgatory.ro]" 1>&2
+	exit 1
+fi
+
+# Have Kbuild supply the path to objdump so we handle cross compilation.
+objdump="$1"
+purgatory="$2"
+
+bad_relocs=$(
+"$objdump" -R "$purgatory" |
+	# Only look at relocation lines.
+	grep -E '\<R_' |
+	# These relocations are okay
+	# On PPC64:
+	#	R_PPC64_ADDR16_LO, R_PPC64_ADDR16_HI,
+	#	R_PPC64_ADDR16_HIGHER, R_PPC64_ADDR16_HIGHEST,
+	#	R_PPC64_RELATIVE
+	grep -F -w -v 'R_PPC64_ADDR16_LO
+R_PPC64_ADDR16_HI
+R_PPC64_ADDR16_HIGHER
+R_PPC64_ADDR16_HIGHEST
+R_PPC64_RELATIVE'
+)
+
+if [ -z "$bad_relocs" ]; then
+	exit 0
+fi
+
+num_bad=$(echo "$bad_relocs" | wc -l)
+echo "WARNING: $num_bad bad relocations in $2"
+echo "$bad_relocs"
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

