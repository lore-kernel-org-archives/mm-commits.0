From: akpm@linux-foundation.org
Subject: + purgatory-core-purgatory-functionality.patch added to -mm tree
Date: Thu, 26 Jun 2014 14:09:47 -0700
Message-ID: <53ac8c1b.4SYQfLKNbk5DU3MG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaFZVJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 17:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: purgatory: core purgatory functionality
has been added to the -mm tree.  Its filename is
     purgatory-core-purgatory-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/purgatory-core-purgatory-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/purgatory-core-purgatory-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: purgatory: core purgatory functionality

Create a stand alone relocatable object purgatory which runs between two
kernels.  This name, concept and some code has been taken from
kexec-tools.  Idea is that this code runs after a crash and it runs in
minimal environment.  So keep it separate from rest of the kernel and in
long term we will have to practically do no maintenance of this code.

This code also has the logic to do verify sha256 hashes of various
segments which have been loaded into memory.  So first we verify that the
kernel we are jumping to is fine and has not been corrupted and make
progress only if checsums are verified.

This code also takes care of copying some memory contents to backup region.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kbuild                   |    4 +
 arch/x86/Makefile                 |    8 ++
 arch/x86/purgatory/Makefile       |   30 ++++++++
 arch/x86/purgatory/entry64.S      |  101 ++++++++++++++++++++++++++++
 arch/x86/purgatory/purgatory.c    |   72 +++++++++++++++++++
 arch/x86/purgatory/setup-x86_64.S |   58 ++++++++++++++++
 arch/x86/purgatory/stack.S        |   19 +++++
 arch/x86/purgatory/string.c       |   13 +++
 8 files changed, 305 insertions(+)

diff -puN arch/x86/Kbuild~purgatory-core-purgatory-functionality arch/x86/Kbuild
--- a/arch/x86/Kbuild~purgatory-core-purgatory-functionality
+++ a/arch/x86/Kbuild
@@ -16,3 +16,7 @@ obj-$(CONFIG_IA32_EMULATION) += ia32/
 
 obj-y += platform/
 obj-y += net/
+
+ifeq ($(CONFIG_X86_64),y)
+obj-$(CONFIG_KEXEC) += purgatory/
+endif
diff -puN arch/x86/Makefile~purgatory-core-purgatory-functionality arch/x86/Makefile
--- a/arch/x86/Makefile~purgatory-core-purgatory-functionality
+++ a/arch/x86/Makefile
@@ -186,6 +186,14 @@ archscripts: scripts_basic
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
 
+archprepare:
+ifeq ($(CONFIG_KEXEC),y)
+# Build only for 64bit. No loaders for 32bit yet.
+ ifeq ($(CONFIG_X86_64),y)
+	$(Q)$(MAKE) $(build)=arch/x86/purgatory arch/x86/purgatory/kexec-purgatory.c
+ endif
+endif
+
 ###
 # Kernel objects
 
diff -puN /dev/null arch/x86/purgatory/Makefile
--- /dev/null
+++ a/arch/x86/purgatory/Makefile
@@ -0,0 +1,30 @@
+purgatory-y := purgatory.o stack.o setup-x86_$(BITS).o sha256.o entry64.o string.o
+
+targets += $(purgatory-y)
+PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
+
+LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
+targets += purgatory.ro
+
+# Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
+# in turn leaves some undefined symbols like __fentry__ in purgatory and not
+# sure how to relocate those. Like kexec-tools, use custom flags.
+
+KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os -mcmodel=large
+
+$(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
+		$(call if_changed,ld)
+
+targets += kexec-purgatory.c
+
+quiet_cmd_bin2c = BIN2C   $@
+      cmd_bin2c = cat $(obj)/purgatory.ro | $(srctree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
+
+$(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
+	$(call if_changed,bin2c)
+
+
+# No loaders for 32bits yet.
+ifeq ($(CONFIG_X86_64),y)
+ obj-$(CONFIG_KEXEC)		+= kexec-purgatory.o
+endif
diff -puN /dev/null arch/x86/purgatory/entry64.S
--- /dev/null
+++ a/arch/x86/purgatory/entry64.S
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2003,2004  Eric Biederman (ebiederm@xmission.com)
+ * Copyright (C) 2014  Red Hat Inc.
+
+ * Author(s): Vivek Goyal <vgoyal@redhat.com>
+ *
+ * This code has been taken from kexec-tools.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+	.text
+	.balign 16
+	.code64
+	.globl entry64, entry64_regs
+
+
+entry64:
+	/* Setup a gdt that should be preserved */
+	lgdt gdt(%rip)
+
+	/* load the data segments */
+	movl    $0x18, %eax     /* data segment */
+	movl    %eax, %ds
+	movl    %eax, %es
+	movl    %eax, %ss
+	movl    %eax, %fs
+	movl    %eax, %gs
+
+	/* Setup new stack */
+	leaq    stack_init(%rip), %rsp
+	pushq   $0x10 /* CS */
+	leaq    new_cs_exit(%rip), %rax
+	pushq   %rax
+	lretq
+new_cs_exit:
+
+	/* Load the registers */
+	movq	rax(%rip), %rax
+	movq	rbx(%rip), %rbx
+	movq	rcx(%rip), %rcx
+	movq	rdx(%rip), %rdx
+	movq	rsi(%rip), %rsi
+	movq	rdi(%rip), %rdi
+	movq    rsp(%rip), %rsp
+	movq	rbp(%rip), %rbp
+	movq	r8(%rip), %r8
+	movq	r9(%rip), %r9
+	movq	r10(%rip), %r10
+	movq	r11(%rip), %r11
+	movq	r12(%rip), %r12
+	movq	r13(%rip), %r13
+	movq	r14(%rip), %r14
+	movq	r15(%rip), %r15
+
+	/* Jump to the new code... */
+	jmpq	*rip(%rip)
+
+	.section ".rodata"
+	.balign 4
+entry64_regs:
+rax:	.quad 0x0
+rbx:	.quad 0x0
+rcx:	.quad 0x0
+rdx:	.quad 0x0
+rsi:	.quad 0x0
+rdi:	.quad 0x0
+rsp:	.quad 0x0
+rbp:	.quad 0x0
+r8:	.quad 0x0
+r9:	.quad 0x0
+r10:	.quad 0x0
+r11:	.quad 0x0
+r12:	.quad 0x0
+r13:	.quad 0x0
+r14:	.quad 0x0
+r15:	.quad 0x0
+rip:	.quad 0x0
+	.size entry64_regs, . - entry64_regs
+
+	/* GDT */
+	.section ".rodata"
+	.balign 16
+gdt:
+	/* 0x00 unusable segment
+	 * 0x08 unused
+	 * so use them as gdt ptr
+	 */
+	.word gdt_end - gdt - 1
+	.quad gdt
+	.word 0, 0, 0
+
+	/* 0x10 4GB flat code segment */
+	.word 0xFFFF, 0x0000, 0x9A00, 0x00AF
+
+	/* 0x18 4GB flat data segment */
+	.word 0xFFFF, 0x0000, 0x9200, 0x00CF
+gdt_end:
+stack:	.quad   0, 0
+stack_init:
diff -puN /dev/null arch/x86/purgatory/purgatory.c
--- /dev/null
+++ a/arch/x86/purgatory/purgatory.c
@@ -0,0 +1,72 @@
+/*
+ * purgatory: Runs between two kernels
+ *
+ * Copyright (C) 2014 Red Hat Inc.
+ *
+ * Author:
+ *       Vivek Goyal <vgoyal@redhat.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include "sha256.h"
+#include "../boot/string.h"
+
+struct sha_region {
+	unsigned long start;
+	unsigned long len;
+};
+
+unsigned long backup_dest = 0;
+unsigned long backup_src = 0;
+unsigned long backup_sz = 0;
+
+u8 sha256_digest[SHA256_DIGEST_SIZE] = { 0 };
+
+struct sha_region sha_regions[16] = {};
+
+/*
+ * On x86, second kernel requries first 640K of memory to boot. Copy
+ * first 640K to a backup region in reserved memory range so that second
+ * kernel can use first 640K.
+ */
+static int copy_backup_region(void)
+{
+	if (backup_dest)
+		memcpy((void *)backup_dest, (void *)backup_src, backup_sz);
+
+	return 0;
+}
+
+int verify_sha256_digest(void)
+{
+	struct sha_region *ptr, *end;
+	u8 digest[SHA256_DIGEST_SIZE];
+	struct sha256_state sctx;
+
+	sha256_init(&sctx);
+	end = &sha_regions[sizeof(sha_regions)/sizeof(sha_regions[0])];
+	for (ptr = sha_regions; ptr < end; ptr++)
+		sha256_update(&sctx, (uint8_t *)(ptr->start), ptr->len);
+
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
+	int ret;
+
+	ret = verify_sha256_digest();
+	if (ret) {
+		/* loop forever */
+		for (;;)
+			;
+	}
+	copy_backup_region();
+}
diff -puN /dev/null arch/x86/purgatory/setup-x86_64.S
--- /dev/null
+++ a/arch/x86/purgatory/setup-x86_64.S
@@ -0,0 +1,58 @@
+/*
+ * purgatory:  setup code
+ *
+ * Copyright (C) 2003,2004  Eric Biederman (ebiederm@xmission.com)
+ * Copyright (C) 2014 Red Hat Inc.
+ *
+ * This code has been taken from kexec-tools.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+	.text
+	.globl purgatory_start
+	.balign 16
+purgatory_start:
+	.code64
+
+	/* Load a gdt so I know what the segment registers are */
+	lgdt	gdt(%rip)
+
+	/* load the data segments */
+	movl	$0x18, %eax	/* data segment */
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %ss
+	movl	%eax, %fs
+	movl	%eax, %gs
+
+	/* Setup a stack */
+	leaq	lstack_end(%rip), %rsp
+
+	/* Call the C code */
+	call purgatory
+	jmp	entry64
+
+	.section ".rodata"
+	.balign 16
+gdt:	/* 0x00 unusable segment
+	 * 0x08 unused
+	 * so use them as the gdt ptr
+	 */
+	.word	gdt_end - gdt - 1
+	.quad	gdt
+	.word	0, 0, 0
+
+	/* 0x10 4GB flat code segment */
+	.word	0xFFFF, 0x0000, 0x9A00, 0x00AF
+
+	/* 0x18 4GB flat data segment */
+	.word	0xFFFF, 0x0000, 0x9200, 0x00CF
+gdt_end:
+
+	.bss
+	.balign 4096
+lstack:
+	.skip 4096
+lstack_end:
diff -puN /dev/null arch/x86/purgatory/stack.S
--- /dev/null
+++ a/arch/x86/purgatory/stack.S
@@ -0,0 +1,19 @@
+/*
+ * purgatory:  stack
+ *
+ * Copyright (C) 2014 Red Hat Inc.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+	/* A stack for the loaded kernel.
+	 * Seperate and in the data section so it can be prepopulated.
+	 */
+	.data
+	.balign 4096
+	.globl stack, stack_end
+
+stack:
+	.skip 4096
+stack_end:
diff -puN /dev/null arch/x86/purgatory/string.c
--- /dev/null
+++ a/arch/x86/purgatory/string.c
@@ -0,0 +1,13 @@
+/*
+ * Simple string functions.
+ *
+ * Copyright (C) 2014 Red Hat Inc.
+ *
+ * Author:
+ *       Vivek Goyal <vgoyal@redhat.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include "../boot/string.c"
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch
linux-next.patch

