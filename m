From: akpm@linux-foundation.org
Subject: + um-implement-a-x86_64-vdso.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:55:21 -0700
Message-ID: <201107222255.p6MMtLid020045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1GVWz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: implement a x86_64 vDSO
has been added to the -mm tree.  Its filename is
     um-implement-a-x86_64-vdso.patch

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
Subject: um: implement a x86_64 vDSO
From: Richard Weinberger <richard@nod.at>

Until now UML had no x86_64 vDSO.  So glibc always used the vsyscall page
for gettimeday() and friends.  Calls to gettimeday() returned falsely the
host time and confused some programs.

This patch adds a vDSO which turns all __vdso_* calls into a system call
so that UML can trap them.

As glibc still uses the vsyscall page for static binaries this patch
improves the situation only for dynamic binaries.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/Makefile               |    2 
 arch/um/sys-x86_64/asm/elf.h              |    9 ++
 arch/um/sys-x86_64/vdso/Makefile          |   90 ++++++++++++++++++++
 arch/um/sys-x86_64/vdso/checkundef.sh     |   10 ++
 arch/um/sys-x86_64/vdso/um_vdso.c         |   71 +++++++++++++++
 arch/um/sys-x86_64/vdso/vdso-layout.lds.S |   64 ++++++++++++++
 arch/um/sys-x86_64/vdso/vdso-note.S       |   12 ++
 arch/um/sys-x86_64/vdso/vdso.S            |   10 ++
 arch/um/sys-x86_64/vdso/vdso.lds.S        |   32 +++++++
 arch/um/sys-x86_64/vdso/vma.c             |   74 ++++++++++++++++
 10 files changed, 374 insertions(+)

diff -puN arch/um/sys-x86_64/Makefile~um-implement-a-x86_64-vdso arch/um/sys-x86_64/Makefile
--- a/arch/um/sys-x86_64/Makefile~um-implement-a-x86_64-vdso
+++ a/arch/um/sys-x86_64/Makefile
@@ -8,6 +8,8 @@ obj-y = bug.o bugs.o delay.o fault.o ldt
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
+obj-y += vdso/
+
 subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
 		lib/rwsem.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
diff -puN arch/um/sys-x86_64/asm/elf.h~um-implement-a-x86_64-vdso arch/um/sys-x86_64/asm/elf.h
--- a/arch/um/sys-x86_64/asm/elf.h~um-implement-a-x86_64-vdso
+++ a/arch/um/sys-x86_64/asm/elf.h
@@ -120,4 +120,13 @@ extern long elf_aux_hwcap;
 #define SET_PERSONALITY(ex) do ; while(0)
 
 #define __HAVE_ARCH_GATE_AREA 1
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+	int uses_interp);
+
+extern unsigned long um_vdso_addr;
+#define AT_SYSINFO_EHDR 33
+#define ARCH_DLINFO	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr)
+
 #endif
diff -puN /dev/null arch/um/sys-x86_64/vdso/Makefile
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/Makefile
@@ -0,0 +1,90 @@
+#
+# Building vDSO images for x86.
+#
+
+VDSO64-y		:= y
+
+vdso-install-$(VDSO64-y)	+= vdso.so
+
+
+# files to link into the vdso
+vobjs-y := vdso-note.o um_vdso.o
+
+# files to link into kernel
+obj-$(VDSO64-y)			+= vdso.o vma.o
+
+vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
+
+$(obj)/vdso.o: $(obj)/vdso.so
+
+targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
+
+export CPPFLAGS_vdso.lds += -P -C
+
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
+       -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
+
+$(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
+
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
+	$(call if_changed,vdso)
+
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+#
+# Don't omit frame pointers for ease of userspace debugging, but do
+# optimize sibling calls.
+#
+CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
+       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector) \
+       -fno-omit-frame-pointer -foptimize-sibling-calls
+
+$(vobjs): KBUILD_CFLAGS += $(CFL)
+
+#
+# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
+#
+CFLAGS_REMOVE_vdso-note.o = -pg
+CFLAGS_REMOVE_um_vdso.o = -pg
+
+targets += vdso-syms.lds
+obj-$(VDSO64-y)			+= vdso-syms.lds
+
+#
+# Match symbols in the DSO that look like VDSO*; produce a file of constants.
+#
+sed-vdsosym := -e 's/^00*/0/' \
+	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
+quiet_cmd_vdsosym = VDSOSYM $@
+define cmd_vdsosym
+	$(NM) $< | LC_ALL=C sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
+endef
+
+$(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
+	$(call if_changed,vdsosym)
+
+#
+# The DSO images are built using a special linker script.
+#
+quiet_cmd_vdso = VDSO    $@
+      cmd_vdso = $(CC) -nostdlib -o $@ \
+		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
+		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) && \
+		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
+
+VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+GCOV_PROFILE := n
+
+#
+# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
+#
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+PHONY += vdso_install $(vdso-install-y)
+vdso_install: $(vdso-install-y)
diff -puN /dev/null arch/um/sys-x86_64/vdso/checkundef.sh
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/checkundef.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+nm="$1"
+file="$2"
+$nm "$file" | grep '^ *U' > /dev/null 2>&1
+if [ $? -eq 1 ]; then
+    exit 0
+else
+    echo "$file: undefined symbols found" >&2
+    exit 1
+fi
diff -puN /dev/null arch/um/sys-x86_64/vdso/um_vdso.c
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/um_vdso.c
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This vDSO turns all calls into a syscall so that UML can trap them.
+ */
+
+
+/* Disable profiling for userspace code */
+#define DISABLE_BRANCH_PROFILING
+
+#include <linux/time.h>
+#include <linux/getcpu.h>
+#include <asm/unistd.h>
+
+int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+{
+	long ret;
+
+	asm("syscall" : "=a" (ret) :
+		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+
+	return ret;
+}
+int clock_gettime(clockid_t, struct timespec *)
+	__attribute__((weak, alias("__vdso_clock_gettime")));
+
+int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+
+	asm("syscall" : "=a" (ret) :
+		"0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+
+	return ret;
+}
+int gettimeofday(struct timeval *, struct timezone *)
+	__attribute__((weak, alias("__vdso_gettimeofday")));
+
+time_t __vdso_time(time_t *t)
+{
+	long secs;
+
+	asm volatile("syscall"
+		: "=a" (secs)
+		: "0" (__NR_time), "D" (t) : "cc", "r11", "cx", "memory");
+
+	return secs;
+}
+int time(time_t *t) __attribute__((weak, alias("__vdso_time")));
+
+long
+__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
+{
+	/*
+	 * UML does not support SMP, we can cheat here. :)
+	 */
+
+	if (cpu)
+		*cpu = 0;
+	if (node)
+		*node = 0;
+
+	return 0;
+}
+
+long getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
+	__attribute__((weak, alias("__vdso_getcpu")));
diff -puN /dev/null arch/um/sys-x86_64/vdso/vdso-layout.lds.S
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/vdso-layout.lds.S
@@ -0,0 +1,64 @@
+/*
+ * Linker script for vDSO.  This is an ELF shared object prelinked to
+ * its virtual address, and with only one read-only segment.
+ * This script controls its layout.
+ */
+
+SECTIONS
+{
+	. = VDSO_PRELINK + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.rodata		: { *(.rodata*) }		:text
+	.data		: {
+	      *(.data*)
+	      *(.sdata*)
+	      *(.got.plt) *(.got)
+	      *(.gnu.linkonce.d.*)
+	      *(.bss*)
+	      *(.dynbss*)
+	      *(.gnu.linkonce.b.*)
+	}
+
+	.altinstructions	: { *(.altinstructions) }
+	.altinstr_replacement	: { *(.altinstr_replacement) }
+
+	/*
+	 * Align the actual code well away from the non-instruction data.
+	 * This is the best thing for the I-cache.
+	 */
+	. = ALIGN(0x100);
+
+	.text		: { *(.text*) }			:text	=0x90909090
+}
+
+/*
+ * Very old versions of ld do not recognize this name token; use the constant.
+ */
+#define PT_GNU_EH_FRAME	0x6474e550
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
+	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
+	note		PT_NOTE		FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
diff -puN /dev/null arch/um/sys-x86_64/vdso/vdso-note.S
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/vdso-note.S
@@ -0,0 +1,12 @@
+/*
+ * This supplies .note.* sections to go into the PT_NOTE inside the vDSO text.
+ * Here we can supply some information useful to userland.
+ */
+
+#include <linux/uts.h>
+#include <linux/version.h>
+#include <linux/elfnote.h>
+
+ELFNOTE_START(Linux, 0, "a")
+	.long LINUX_VERSION_CODE
+ELFNOTE_END
diff -puN /dev/null arch/um/sys-x86_64/vdso/vdso.S
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/vdso.S
@@ -0,0 +1,10 @@
+#include <linux/init.h>
+
+__INITDATA
+
+	.globl vdso_start, vdso_end
+vdso_start:
+	.incbin "arch/um/sys-x86_64/vdso/vdso.so"
+vdso_end:
+
+__FINIT
diff -puN /dev/null arch/um/sys-x86_64/vdso/vdso.lds.S
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/vdso.lds.S
@@ -0,0 +1,32 @@
+/*
+ * Linker script for 64-bit vDSO.
+ * We #include the file to define the layout details.
+ * Here we only choose the prelinked virtual address.
+ *
+ * This file defines the version script giving the user-exported symbols in
+ * the DSO.  We can define local symbols here called VDSO* to make their
+ * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ */
+
+#define VDSO_PRELINK 0xffffffffff700000
+#include "vdso-layout.lds.S"
+
+/*
+ * This controls what userland symbols we export from the vDSO.
+ */
+VERSION {
+	LINUX_2.6 {
+	global:
+		clock_gettime;
+		__vdso_clock_gettime;
+		gettimeofday;
+		__vdso_gettimeofday;
+		getcpu;
+		__vdso_getcpu;
+		time;
+		__vdso_time;
+	local: *;
+	};
+}
+
+VDSO64_PRELINK = VDSO_PRELINK;
diff -puN /dev/null arch/um/sys-x86_64/vdso/vma.c
--- /dev/null
+++ a/arch/um/sys-x86_64/vdso/vma.c
@@ -0,0 +1,74 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <linux/init.h>
+
+unsigned int __read_mostly vdso_enabled = 1;
+unsigned long um_vdso_addr;
+
+extern unsigned long task_size;
+extern char vdso_start[], vdso_end[];
+
+static struct page **vdsop;
+
+static int __init init_vdso(void)
+{
+	struct page *um_vdso;
+
+	BUG_ON(vdso_end - vdso_start > PAGE_SIZE);
+
+	um_vdso_addr = task_size - PAGE_SIZE;
+
+	vdsop = kmalloc(GFP_KERNEL, sizeof(struct page *));
+	if (!vdsop)
+		goto oom;
+
+	um_vdso = alloc_page(GFP_KERNEL);
+	if (!um_vdso) {
+		kfree(vdsop);
+
+		goto oom;
+	}
+
+	copy_page(page_address(um_vdso), vdso_start);
+	*vdsop = um_vdso;
+
+	return 0;
+
+oom:
+	printk(KERN_ERR "Cannot allocate vdso\n");
+	vdso_enabled = 0;
+
+	return -ENOMEM;
+}
+subsys_initcall(init_vdso);
+
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	int err;
+	struct mm_struct *mm = current->mm;
+
+	if (!vdso_enabled)
+		return 0;
+
+	down_write(&mm->mmap_sem);
+
+	err = install_special_mapping(mm, um_vdso_addr, PAGE_SIZE,
+		VM_READ|VM_EXEC|
+		VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+		VM_ALWAYSDUMP,
+		vdsop);
+
+	up_write(&mm->mmap_sem);
+
+	return err;
+}
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
um-add-netpoll-support.patch
um-reinstate-kernel-version-in-generated-config.patch
uml-drivers-net_userc-memory-leak-fix.patch
uml-cow_userc-warning-corrections.patch
uml-helperc-warning-corrections.patch
uml-drivers-slip_userc-memory-leak-fix.patch
uml-free-resources.patch
um-disable-scan_elf_aux-on-x86_64.patch
um-set-__have_arch_gate_area-for-i386.patch
um-set-__have_arch_gate_area-for-x86_64.patch
um-implement-a-x86_64-vdso.patch
um-ajdust-size-of-pid_buf.patch
um-remove-dead-code.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

