From: akpm@linux-foundation.org
Subject: + kernel-call-constructors.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:01:52 -0700
Message-ID: <200806032301.m53N1qXF024424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbYFCXDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     gcov: kernel: call constructors
has been added to the -mm tree.  Its filename is
     kernel-call-constructors.patch

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
Subject: gcov: kernel: call constructors
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Call constructors during kernel init and module load.  Required by the
gcov profiling infrastructure: gcc's profiling code uses constructors to
register profiling data structures.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    3 +++
 include/asm-generic/sections.h    |    1 +
 include/asm-generic/vmlinux.lds.h |    5 +++++
 include/linux/init.h              |    2 ++
 include/linux/module.h            |    3 +++
 init/main.c                       |   10 ++++++++++
 kernel/module.c                   |   13 +++++++++++++
 7 files changed, 37 insertions(+)

diff -puN arch/powerpc/kernel/vmlinux.lds.S~kernel-call-constructors arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~kernel-call-constructors
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -193,6 +193,9 @@ SECTIONS
 		*(.toc)
 	}
 #endif
+	.data.gcov : {
+		CONSTRUCTORS
+	}
 
 	. = ALIGN(PAGE_SIZE);
 	_edata  =  .;
diff -puN include/asm-generic/sections.h~kernel-call-constructors include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~kernel-call-constructors
+++ a/include/asm-generic/sections.h
@@ -13,5 +13,6 @@ extern char __per_cpu_start[], __per_cpu
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
+extern char __ctor_start[], __ctor_end[];
 
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
diff -puN include/asm-generic/vmlinux.lds.h~kernel-call-constructors include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~kernel-call-constructors
+++ a/include/asm-generic/vmlinux.lds.h
@@ -373,3 +373,8 @@
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+
+#define CONSTRUCTORS							\
+		VMLINUX_SYMBOL(__ctor_start) = .;			\
+		*(.ctors)						\
+		VMLINUX_SYMBOL(__ctor_end) = .;
diff -puN include/linux/init.h~kernel-call-constructors include/linux/init.h
--- a/include/linux/init.h~kernel-call-constructors
+++ a/include/linux/init.h
@@ -138,6 +138,8 @@ typedef void (*exitcall_t)(void);
 extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
+typedef void (*ctorcall_t)(void);
+
 /* Defined in init/main.c */
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
diff -puN include/linux/module.h~kernel-call-constructors include/linux/module.h
--- a/include/linux/module.h~kernel-call-constructors
+++ a/include/linux/module.h
@@ -342,6 +342,9 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+	/* Constructor calls. */
+	ctorcall_t *ctors;
+	unsigned long num_ctors;
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff -puN init/main.c~kernel-call-constructors init/main.c
--- a/init/main.c~kernel-call-constructors
+++ a/init/main.c
@@ -689,6 +689,15 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
+static void __init do_ctors(void)
+{
+	ctorcall_t *call;
+
+	for (call = (ctorcall_t *) __ctor_start;
+	     call < (ctorcall_t *) __ctor_end; call++)
+		(*call)();
+}
+
 static int __initdata initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
@@ -769,6 +778,7 @@ static void __init do_basic_setup(void)
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 
diff -puN kernel/module.c~kernel-call-constructors kernel/module.c
--- a/kernel/module.c~kernel-call-constructors
+++ a/kernel/module.c
@@ -1770,6 +1770,7 @@ static struct module *load_module(void _
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int ctorsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1866,6 +1867,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	ctorsindex = find_sec(hdr, sechdrs, secstrings, ".ctors");
 
 	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -2076,6 +2078,8 @@ static struct module *load_module(void _
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+	mod->ctors = (void *) sechdrs[ctorsindex].sh_addr;
+	mod->num_ctors = sechdrs[ctorsindex].sh_size / sizeof(*mod->ctors);
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2188,6 +2192,14 @@ static struct module *load_module(void _
 	goto free_hdr;
 }
 
+static void do_mod_ctors(struct module *mod)
+{
+	unsigned long i;
+
+	for (i = 0; i < mod->num_ctors; i++)
+		mod->ctors[i]();
+}
+
 /* This is where the real work happens */
 asmlinkage long
 sys_init_module(void __user *umod,
@@ -2218,6 +2230,7 @@ sys_init_module(void __user *umod,
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = mod->init();
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

