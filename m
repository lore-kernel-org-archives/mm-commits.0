From: akpm@linux-foundation.org
Subject: + remove-remaining-unwinder-code.patch added to -mm tree
Date: Tue, 04 Nov 2008 12:29:07 -0800
Message-ID: <200811042029.mA4KT7Zm010988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088AbYKDU3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 15:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, andi@firstfloor.org, gombasg@sztaki.hu, jbeulich@novell.com, mingo@elte.hu


The patch titled
     Remove remaining unwinder code
has been added to the -mm tree.  Its filename is
     remove-remaining-unwinder-code.patch

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
Subject: Remove remaining unwinder code
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/unwind.h |   13 ------
 arch/x86/kernel/traps.c       |    2 
 include/linux/module.h        |    3 -
 include/linux/unwind.h        |   68 --------------------------------
 init/main.c                   |    3 -
 kernel/module.c               |   15 -------
 lib/fault-inject.c            |    1 
 7 files changed, 105 deletions(-)

diff -puN arch/x86/include/asm/unwind.h~remove-remaining-unwinder-code /dev/null
--- a/arch/x86/include/asm/unwind.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef _ASM_X86_UNWIND_H
-#define _ASM_X86_UNWIND_H
-
-#define UNW_PC(frame) ((void)(frame), 0UL)
-#define UNW_SP(frame) ((void)(frame), 0UL)
-#define UNW_FP(frame) ((void)(frame), 0UL)
-
-static inline int arch_unw_user_mode(const void *info)
-{
-	return 0;
-}
-
-#endif /* _ASM_X86_UNWIND_H */
diff -puN arch/x86/kernel/traps.c~remove-remaining-unwinder-code arch/x86/kernel/traps.c
--- a/arch/x86/kernel/traps.c~remove-remaining-unwinder-code
+++ a/arch/x86/kernel/traps.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/string.h>
-#include <linux/unwind.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/kexec.h>
@@ -52,7 +51,6 @@
 #include <asm/debugreg.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/unwind.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
diff -puN include/linux/module.h~remove-remaining-unwinder-code include/linux/module.h
--- a/include/linux/module.h~remove-remaining-unwinder-code
+++ a/include/linux/module.h
@@ -294,9 +294,6 @@ struct module
 	/* The size of the executable code in each section.  */
 	unsigned int init_text_size, core_text_size;
 
-	/* The handle returned from unwind_add_table. */
-	void *unwind_info;
-
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;
 
diff -puN include/linux/unwind.h~remove-remaining-unwinder-code /dev/null
--- a/include/linux/unwind.h
+++ /dev/null
@@ -1,68 +0,0 @@
-#ifndef _LINUX_UNWIND_H
-#define _LINUX_UNWIND_H
-
-/*
- * Copyright (C) 2002-2006 Novell, Inc.
- *	Jan Beulich <jbeulich@novell.com>
- * This code is released under version 2 of the GNU GPL.
- *
- * A simple API for unwinding kernel stacks.  This is used for
- * debugging and error reporting purposes.  The kernel doesn't need
- * full-blown stack unwinding with all the bells and whistles, so there
- * is not much point in implementing the full Dwarf2 unwind API.
- */
-
-struct module;
-
-struct unwind_frame_info {};
-
-static inline void unwind_init(void) {}
-static inline void unwind_setup(void) {}
-
-#ifdef CONFIG_MODULES
-
-static inline void *unwind_add_table(struct module *mod,
-                                     const void *table_start,
-                                     unsigned long table_size)
-{
-	return NULL;
-}
-
-static inline void unwind_remove_table(void *handle, int init_only)
-{
-}
-
-#endif
-
-static inline int unwind_init_frame_info(struct unwind_frame_info *info,
-                                         struct task_struct *tsk,
-                                         const struct pt_regs *regs)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind_init_blocked(struct unwind_frame_info *info,
-                                      struct task_struct *tsk)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind_init_running(struct unwind_frame_info *info,
-                                      asmlinkage int (*cb)(struct unwind_frame_info *,
-                                                           void *arg),
-                                      void *arg)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind(struct unwind_frame_info *info)
-{
-	return -ENOSYS;
-}
-
-static inline int unwind_to_user(struct unwind_frame_info *info)
-{
-	return -ENOSYS;
-}
-
-#endif /* _LINUX_UNWIND_H */
diff -puN init/main.c~remove-remaining-unwinder-code init/main.c
--- a/init/main.c~remove-remaining-unwinder-code
+++ a/init/main.c
@@ -51,7 +51,6 @@
 #include <linux/rmap.h>
 #include <linux/mempolicy.h>
 #include <linux/key.h>
-#include <linux/unwind.h>
 #include <linux/buffer_head.h>
 #include <linux/page_cgroup.h>
 #include <linux/debug_locks.h>
@@ -572,7 +571,6 @@ asmlinkage void __init start_kernel(void
 	 * Need to run as early as possible, to initialize the
 	 * lockdep hash:
 	 */
-	unwind_init();
 	lockdep_init();
 	debug_objects_early_init();
 
@@ -600,7 +598,6 @@ asmlinkage void __init start_kernel(void
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
-	unwind_setup();
 	cpu_alloc_init();
 	setup_per_cpu_areas();
 	setup_nr_cpu_ids();
diff -puN kernel/module.c~remove-remaining-unwinder-code kernel/module.c
--- a/kernel/module.c~remove-remaining-unwinder-code
+++ a/kernel/module.c
@@ -43,7 +43,6 @@
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
-#include <linux/unwind.h>
 #include <linux/rculist.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1283,8 +1282,6 @@ static void free_module(struct module *m
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
-	unwind_remove_table(mod->unwind_info, 0);
-
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
@@ -1691,7 +1688,6 @@ static noinline struct module *load_modu
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
 	unsigned int modindex, versindex, infoindex, pcpuindex;
-	unsigned int unwindex = 0;
 	unsigned int num_kp, num_mcount;
 	struct kernel_param *kp;
 	struct module *mod;
@@ -1775,9 +1771,6 @@ static noinline struct module *load_modu
 	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");
 	infoindex = find_sec(hdr, sechdrs, secstrings, ".modinfo");
 	pcpuindex = find_pcpusec(hdr, sechdrs, secstrings);
-#ifdef ARCH_UNWIND_SECTION_NAME
-	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
-#endif
 
 	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1787,8 +1780,6 @@ static noinline struct module *load_modu
 	sechdrs[symindex].sh_flags |= SHF_ALLOC;
 	sechdrs[strindex].sh_flags |= SHF_ALLOC;
 #endif
-	if (unwindex)
-		sechdrs[unwindex].sh_flags |= SHF_ALLOC;
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -2099,11 +2090,6 @@ static noinline struct module *load_modu
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
-	/* Size of section 0 is 0, so this works well if no unwind info. */
-	mod->unwind_info = unwind_add_table(mod,
-					    (void *)sechdrs[unwindex].sh_addr,
-					    sechdrs[unwindex].sh_size);
-
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
@@ -2200,7 +2186,6 @@ sys_init_module(void __user *umod,
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
-	unwind_remove_table(mod->unwind_info, 1);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
diff -puN lib/fault-inject.c~remove-remaining-unwinder-code lib/fault-inject.c
--- a/lib/fault-inject.c~remove-remaining-unwinder-code
+++ a/lib/fault-inject.c
@@ -6,7 +6,6 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/unwind.h>
 #include <linux/stacktrace.h>
 #include <linux/kallsyms.h>
 #include <linux/fault-inject.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
tags-skip-in-filenames.patch
kconfig-add-module_name-shortcut.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
remove-remaining-unwinder-code.patch
profile-likely-unlikely-macros.patch

