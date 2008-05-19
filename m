From: akpm@linux-foundation.org
Subject: + kernel-call-constructors.patch added to -mm tree
Date: Mon, 19 May 2008 15:12:31 -0700
Message-ID: <200805192212.m4JMCV8e023379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765564AbYESWOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 18:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, frankeh@us.ibm.com


The patch titled
     kernel: call constructors
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
Subject: kernel: call constructors
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

This set of patches enables the use of GCC's coverage testing tool gcov
[1] with kernel 2.6.25.  Coverage data for the running kernel is exported
via debugfs in a gcov-compatible format.  To get coverage data for a
specific file, simply use gcov with the -o option:

# gcov -o /sys/kernel/debug/gcov/tmp/linux-2.6.25/kernel spinlock.c

This will create source code files annotated with execution counts in the
current directory.  In addition, graphical gcov front-ends such as lcov
[2] can be used to automate the process of collecting data for the entire
kernel and provide coverage overviews in HTML format.

Possible uses:

* debugging (has this line been executed at all?)
* test improvement (how do I change my test to cover these lines?)
* minimizing kernel configurations (do I need this option if the
  associated code is never executed?)


Known issues:

* some architecture specific problems: the patch has been tested
  successfully on s390 and i386. Known problems exist on x86_64 and
  arm (to be investigated)
* GCC's profiling mechanism together with optimization sometimes
  produces skewed data (see [1])
* GCC's profiling code assumes single-threaded execution
* gcov assumes that a program has finished when coverage data is
  analyzed

Despite these issues, the data which can be obtained has been proven to be
sufficiently accurate for most practical uses.


History:

Hubertus Franke <frankeh@us.ibm.com> wrote the first version of this patch
around 2002.  Since then it has been adapted to new versions of the kernel
and GCC with contributions by several people (see file kernel/gcov/fs.c,
write me if I missed anyone).  Due to regular requests, I rewrote the
gcov-kernel patch from scratch so that it would (hopefully) be fit for
inclusion into the upstream kernel.


This patch:

Call constructors during kernel init and module load.  Required by the
gcov profiling infrastructure: gcc's profiling code uses constructors to
register profiling data structures.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Hubertus Franke <frankeh@us.ibm.com>
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
@@ -353,3 +353,8 @@
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
@@ -683,6 +683,15 @@ asmlinkage void __init start_kernel(void
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
@@ -762,6 +771,7 @@ static void __init do_basic_setup(void)
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 
diff -puN kernel/module.c~kernel-call-constructors kernel/module.c
--- a/kernel/module.c~kernel-call-constructors
+++ a/kernel/module.c
@@ -1758,6 +1758,7 @@ static struct module *load_module(void _
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int ctorsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1854,6 +1855,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	ctorsindex = find_sec(hdr, sechdrs, secstrings, ".ctors");
 
 	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -2064,6 +2066,8 @@ static struct module *load_module(void _
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+	mod->ctors = (void *) sechdrs[ctorsindex].sh_addr;
+	mod->num_ctors = sechdrs[ctorsindex].sh_size / sizeof(*mod->ctors);
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2176,6 +2180,14 @@ static struct module *load_module(void _
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
@@ -2206,6 +2218,7 @@ sys_init_module(void __user *umod,
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = mod->init();
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

linux-next.patch
kernel-call-constructors.patch
kernel-introduce-gcc_version_lower-macro.patch
kbuild-delay-object-file-renaming-during-module-versioning.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
kbuild-make-source-and-include-paths-absolute.patch
gcov-architecture-specific-compile-flag-adjustments.patch

