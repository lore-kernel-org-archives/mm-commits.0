From: akpm@linux-foundation.org
Subject: + kernel-constructor-support.patch added to -mm tree
Date: Tue, 02 Jun 2009 15:03:37 -0700
Message-ID: <200906022203.n52M3cVP011512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbZFBWE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 18:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, W.Li@Sun.COM, andi@firstfloor.org, heicars2@linux.vnet.ibm.com, jdike@addtoit.com, michaele@au1.ibm.com, mingo@elte.hu, mschwid2@linux.vnet.ibm.com, rusty@rustcorp.com.au, sam@ravnborg.org, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com, ying.huang@intel.com


The patch titled
     kernel: constructor support
has been added to the -mm tree.  Its filename is
     kernel-constructor-support.patch

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
Subject: kernel: constructor support
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Call constructors (gcc-generated initcall-like functions) during kernel
start and module load.  Constructors are e.g.  used for gcov data
initialization.

Disable constructor support for usermode Linux to prevent conflicts with
host glibc.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Li Wei <W.Li@Sun.COM>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heicars2@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h    |    3 +++
 include/asm-generic/vmlinux.lds.h |    9 +++++++++
 include/linux/init.h              |    3 +++
 include/linux/module.h            |    6 ++++++
 init/Kconfig                      |    5 +++++
 init/main.c                       |   12 ++++++++++++
 kernel/module.c                   |   16 ++++++++++++++++
 7 files changed, 54 insertions(+)

diff -puN include/asm-generic/sections.h~kernel-constructor-support include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~kernel-constructor-support
+++ a/include/asm-generic/sections.h
@@ -14,6 +14,9 @@ extern char __kprobes_text_start[], __kp
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
 
+/* Start and end of .ctors section - used for constructor calls. */
+extern char __ctors_start[], __ctors_end[];
+
 /* function descriptor handling (if any).  Override
  * in asm/sections.h */
 #ifndef dereference_function_descriptor
diff -puN include/asm-generic/vmlinux.lds.h~kernel-constructor-support include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~kernel-constructor-support
+++ a/include/asm-generic/vmlinux.lds.h
@@ -332,12 +332,21 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
 
+#ifdef CONFIG_CONSTRUCTORS
+#define KERNEL_CTORS()	VMLINUX_SYMBOL(__ctors_start) = .; \
+			*(.ctors)			   \
+			VMLINUX_SYMBOL(__ctors_end) = .;
+#else
+#define KERNEL_CTORS()
+#endif
+
 /* init and exit section handling */
 #define INIT_DATA							\
 	*(.init.data)							\
 	DEV_DISCARD(init.data)						\
 	CPU_DISCARD(init.data)						\
 	MEM_DISCARD(init.data)						\
+	KERNEL_CTORS()							\
 	*(.init.rodata)							\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
diff -puN include/linux/init.h~kernel-constructor-support include/linux/init.h
--- a/include/linux/init.h~kernel-constructor-support
+++ a/include/linux/init.h
@@ -136,6 +136,9 @@ typedef void (*exitcall_t)(void);
 extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
+/* Used for contructor calls. */
+typedef void (*ctor_fn_t)(void);
+
 /* Defined in init/main.c */
 extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
diff -puN include/linux/module.h~kernel-constructor-support include/linux/module.h
--- a/include/linux/module.h~kernel-constructor-support
+++ a/include/linux/module.h
@@ -362,6 +362,12 @@ struct module
 	local_t ref;
 #endif
 #endif
+
+#ifdef CONFIG_CONSTRUCTORS
+	/* Constructor functions. */
+	ctor_fn_t *ctors;
+	unsigned int num_ctors;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff -puN init/Kconfig~kernel-constructor-support init/Kconfig
--- a/init/Kconfig~kernel-constructor-support
+++ a/init/Kconfig
@@ -16,6 +16,11 @@ config DEFCONFIG_LIST
 	default "$ARCH_DEFCONFIG"
 	default "arch/$ARCH/defconfig"
 
+config CONSTRUCTORS
+	bool
+	depends on !UML
+	default y
+
 menu "General setup"
 
 config EXPERIMENTAL
diff -puN init/main.c~kernel-constructor-support init/main.c
--- a/init/main.c~kernel-constructor-support
+++ a/init/main.c
@@ -701,6 +701,17 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
+/* Call all constructor functions linked into the kernel. */
+static void __init do_ctors(void)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	ctor_fn_t *call = (ctor_fn_t *) __ctors_start;
+
+	for (; call < (ctor_fn_t *) __ctors_end; call++)
+		(*call)();
+#endif
+}
+
 int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
@@ -782,6 +793,7 @@ static void __init do_basic_setup(void)
 	init_tmpfs();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 
diff -puN kernel/module.c~kernel-constructor-support kernel/module.c
--- a/kernel/module.c~kernel-constructor-support
+++ a/kernel/module.c
@@ -2216,6 +2216,10 @@ static noinline struct module *load_modu
 	mod->unused_gpl_crcs = section_addr(hdr, sechdrs, secstrings,
 					    "__kcrctab_unused_gpl");
 #endif
+#ifdef CONFIG_CONSTRUCTORS
+	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
+				  sizeof(*mod->ctors), &mod->num_ctors);
+#endif
 
 #ifdef CONFIG_MARKERS
 	mod->markers = section_objs(hdr, sechdrs, secstrings, "__markers",
@@ -2389,6 +2393,17 @@ static noinline struct module *load_modu
 	goto free_hdr;
 }
 
+/* Call module constructors. */
+static void do_mod_ctors(struct module *mod)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	unsigned long i;
+
+	for (i = 0; i < mod->num_ctors; i++)
+		mod->ctors[i]();
+#endif
+}
+
 /* This is where the real work happens */
 SYSCALL_DEFINE3(init_module, void __user *, umod,
 		unsigned long, len, const char __user *, uargs)
@@ -2417,6 +2432,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

kernel-constructor-support.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-enable-gcov_profile_all-for-x86_64.patch

