From: akpm@linux-foundation.org
Subject: + uml-remove-__u64-usage-from-physical-memory-subsystem.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:26 -0700
Message-ID: <200708162114.l7GLEQ0e007098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758233AbXHPVOg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove __u64 usage from physical memory subsystem
has been added to the -mm tree.  Its filename is
     uml-remove-__u64-usage-from-physical-memory-subsystem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove __u64 usage from physical memory subsystem
From: Jeff Dike <jdike@addtoit.com>

Eliminate some uses of __u64 in the physical memory support.  It's hard to get
a definition of __u64 in both kernel and userspace code on x86_64, so this
changes them to unsigned long long.

There are also a copyright update and formatting comment removal from the
affected header.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/mem.h           |   21 ++-------------------
 arch/um/kernel/physmem.c        |    2 +-
 arch/um/os-Linux/skas/process.c |    6 +++---
 3 files changed, 6 insertions(+), 23 deletions(-)

diff -puN arch/um/include/mem.h~uml-remove-__u64-usage-from-physical-memory-subsystem arch/um/include/mem.h
--- a/arch/um/include/mem.h~uml-remove-__u64-usage-from-physical-memory-subsystem
+++ a/arch/um/include/mem.h
@@ -1,18 +1,12 @@
 /* 
- * Copyright (C) 2002, 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __MEM_H__
 #define __MEM_H__
 
-#include "linux/types.h"
-
-extern int phys_mapping(unsigned long phys, __u64 *offset_out);
-extern int physmem_subst_mapping(void *virt, int fd, __u64 offset, int w);
-extern int is_remapped(void *virt);
-extern int physmem_remove_mapping(void *virt);
-extern void physmem_forget_descriptor(int fd);
+extern int phys_mapping(unsigned long phys, unsigned long long *offset_out);
 
 extern unsigned long uml_physmem;
 static inline unsigned long to_phys(void *virt)
@@ -26,14 +20,3 @@ static inline void *to_virt(unsigned lon
 }
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/physmem.c~uml-remove-__u64-usage-from-physical-memory-subsystem arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-remove-__u64-usage-from-physical-memory-subsystem
+++ a/arch/um/kernel/physmem.c
@@ -115,7 +115,7 @@ void __init setup_physmem(unsigned long 
 		     len - bootmap_size - reserve);
 }
 
-int phys_mapping(unsigned long phys, __u64 *offset_out)
+int phys_mapping(unsigned long phys, unsigned long long *offset_out)
 {
 	int fd = -1;
 
diff -puN arch/um/os-Linux/skas/process.c~uml-remove-__u64-usage-from-physical-memory-subsystem arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-remove-__u64-usage-from-physical-memory-subsystem
+++ a/arch/um/os-Linux/skas/process.c
@@ -382,7 +382,7 @@ int copy_context_skas0(unsigned long new
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
 	struct stub_data *child_data = (struct stub_data *) new_stack;
-	__u64 new_offset;
+	unsigned long long new_offset;
 	int new_fd = phys_mapping(to_phys((void *)new_stack), &new_offset);
 
 	/*
@@ -444,7 +444,7 @@ void map_stub_pages(int fd, unsigned lon
 {
 	struct proc_mm_op mmop;
 	int n;
-	__u64 code_offset;
+	unsigned long long code_offset;
 	int code_fd = phys_mapping(to_phys((void *) &__syscall_stub_start),
 				   &code_offset);
 
@@ -469,7 +469,7 @@ void map_stub_pages(int fd, unsigned lon
 	}
 
 	if (stack) {
-		__u64 map_offset;
+		unsigned long long map_offset;
 		int map_fd = phys_mapping(to_phys((void *)stack), &map_offset);
 		mmop = ((struct proc_mm_op)
 				{ .op        = MM_MMAP,
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
