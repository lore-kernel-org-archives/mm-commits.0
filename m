From: akpm@osdl.org
Subject: - generic-bug-implementation.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:42 -0800
Message-ID: <200612082000.kB8K0goB001778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57388 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426303AbWLHUEv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@muc.de, benh@kernel.crashing.org, bunk@stusta.de, hugh@veritas.com, michael@ellerman.id.au, paulus@samba.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Generic BUG implementation
has been removed from the -mm tree.  Its filename was
     generic-bug-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic BUG implementation
From: Jeremy Fitzhardinge <jeremy@goop.org>

This patch adds common handling for kernel BUGs, for use by architectures as
they wish.  The code is derived from arch/powerpc.

The advantages of having common BUG handling are:
 - consistent BUG reporting across architectures
 - shared implementation of out-of-line file/line data
 - implement CONFIG_DEBUG_BUGVERBOSE consistently

This means that in inline impact of BUG is just the illegal instruction
itself, which is an improvement for i386 and x86-64.

A BUG is represented in the instruction stream as an illegal instruction,
which has file/line information associated with it.  This extra information is
stored in the __bug_table section in the ELF file.

When the kernel gets an illegal instruction, it first confirms it might
possibly be from a BUG (ie, in kernel mode, the right illegal instruction). 
It then calls report_bug().  This searches __bug_table for a matching
instruction pointer, and if found, prints the corresponding file/line
information.  If report_bug() determines that it wasn't a BUG which caused the
trap, it returns BUG_TRAP_TYPE_NONE.

Some architectures (powerpc) implement WARN using the same mechanism; if the
illegal instruction was the result of a WARN, then report_bug(Q) returns
CONFIG_DEBUG_BUGVERBOSE; otherwise it returns BUG_TRAP_TYPE_BUG.

lib/bug.c keeps a list of loaded modules which can be searched for __bug_table
entries.  The architecture must call
module_bug_finalize()/module_bug_cleanup() from its corresponding
module_finalize/cleanup functions.

Unsetting CONFIG_DEBUG_BUGVERBOSE will reduce the kernel size by some amount. 
At the very least, filename and line information will not be recorded for each
but, but architectures may decide to store no extra information per BUG at
all.

Unfortunately, gcc doesn't have a general way to mark an asm() as noreturn, so
architectures will generally have to include an infinite loop (or similar) in
the BUG code, so that gcc knows execution won't continue beyond that point. 
gcc does have a __builtin_trap() operator which may be useful to achieve the
same effect, unfortunately it cannot be used to actually implement the BUG
itself, because there's no way to get the instruction's address for use in
generating the __bug_table entry.

[randy.dunlap@oracle.com: Handle BUG=n, GENERIC_BUG=n to prevent build errors]
[bunk@stusta.de: include/linux/bug.h must always #include <linux/module.h]
Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Hugh Dickens <hugh@veritas.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/bug.h         |   16 ++
 include/asm-generic/vmlinux.lds.h |    8 +
 include/linux/bug.h               |   47 ++++++++
 include/linux/module.h            |    7 +
 lib/Kconfig.debug                 |    2 
 lib/Makefile                      |    2 
 lib/bug.c                         |  163 ++++++++++++++++++++++++++++
 7 files changed, 244 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/bug.h~generic-bug-implementation include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~generic-bug-implementation
+++ a/include/asm-generic/bug.h
@@ -4,6 +4,22 @@
 #include <linux/compiler.h>
 
 #ifdef CONFIG_BUG
+
+#ifdef CONFIG_GENERIC_BUG
+#ifndef __ASSEMBLY__
+struct bug_entry {
+	unsigned long	bug_addr;
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+	const char	*file;
+	unsigned short	line;
+#endif
+	unsigned short	flags;
+};
+#endif		/* __ASSEMBLY__ */
+
+#define BUGFLAG_WARNING	(1<<0)
+#endif	/* CONFIG_GENERIC_BUG */
+
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
diff -puN include/asm-generic/vmlinux.lds.h~generic-bug-implementation include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~generic-bug-implementation
+++ a/include/asm-generic/vmlinux.lds.h
@@ -218,6 +218,14 @@
 		.stab.indexstr 0 : { *(.stab.indexstr) }		\
 		.comment 0 : { *(.comment) }
 
+#define BUG_TABLE							\
+	. = ALIGN(8);							\
+	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
+		__start___bug_table = .;				\
+		*(__bug_table)						\
+		__stop___bug_table = .;					\
+	}
+
 #define NOTES								\
 		.notes : { *(.note.*) } :note
 
diff -puN /dev/null include/linux/bug.h
--- /dev/null
+++ a/include/linux/bug.h
@@ -0,0 +1,47 @@
+#ifndef _LINUX_BUG_H
+#define _LINUX_BUG_H
+
+#include <linux/module.h>
+#include <asm/bug.h>
+
+enum bug_trap_type {
+	BUG_TRAP_TYPE_NONE = 0,
+	BUG_TRAP_TYPE_WARN = 1,
+	BUG_TRAP_TYPE_BUG = 2,
+};
+
+#ifdef CONFIG_GENERIC_BUG
+#include <asm-generic/bug.h>
+
+static inline int is_warning_bug(const struct bug_entry *bug)
+{
+	return bug->flags & BUGFLAG_WARNING;
+}
+
+const struct bug_entry *find_bug(unsigned long bugaddr);
+
+enum bug_trap_type report_bug(unsigned long bug_addr);
+
+int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
+			 struct module *);
+void module_bug_cleanup(struct module *);
+
+/* These are defined by the architecture */
+int is_valid_bugaddr(unsigned long addr);
+
+#else	/* !CONFIG_GENERIC_BUG */
+
+static inline enum bug_trap_type report_bug(unsigned long bug_addr)
+{
+	return BUG_TRAP_TYPE_BUG;
+}
+static inline int  module_bug_finalize(const Elf_Ehdr *hdr,
+					const Elf_Shdr *sechdrs,
+					struct module *mod)
+{
+	return 0;
+}
+static inline void module_bug_cleanup(struct module *mod) {}
+
+#endif	/* CONFIG_GENERIC_BUG */
+#endif	/* _LINUX_BUG_H */
diff -puN include/linux/module.h~generic-bug-implementation include/linux/module.h
--- a/include/linux/module.h~generic-bug-implementation
+++ a/include/linux/module.h
@@ -319,6 +319,13 @@ struct module
 
 	unsigned int taints;	/* same bits as kernel:tainted */
 
+#ifdef CONFIG_GENERIC_BUG
+	/* Support for BUG */
+	struct list_head bug_list;
+	struct bug_entry *bug_table;
+	unsigned num_bugs;
+#endif
+
 #ifdef CONFIG_MODULE_UNLOAD
 	/* Reference counts */
 	struct module_ref ref[NR_CPUS];
diff -puN lib/Kconfig.debug~generic-bug-implementation lib/Kconfig.debug
--- a/lib/Kconfig.debug~generic-bug-implementation
+++ a/lib/Kconfig.debug
@@ -285,7 +285,7 @@ config DEBUG_HIGHMEM
 config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
 	depends on BUG
-	depends on ARM || ARM26 || AVR32 || M32R || M68K || SPARC32 || SPARC64 || X86_32 || FRV || SUPERH
+	depends on ARM || ARM26 || AVR32 || M32R || M68K || SPARC32 || SPARC64 || X86_32 || FRV || SUPERH || GENERIC_BUG
 	default !EMBEDDED
 	help
 	  Say Y here to make BUG() panics output the file name and line number
diff -puN lib/Makefile~generic-bug-implementation lib/Makefile
--- a/lib/Makefile~generic-bug-implementation
+++ a/lib/Makefile
@@ -55,6 +55,8 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 
+lib-$(CONFIG_GENERIC_BUG) += bug.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/bug.c
--- /dev/null
+++ a/lib/bug.c
@@ -0,0 +1,163 @@
+/*
+  Generic support for BUG()
+
+  This respects the following config options:
+
+  CONFIG_BUG - emit BUG traps.  Nothing happens without this.
+  CONFIG_GENERIC_BUG - enable this code.
+  CONFIG_DEBUG_BUGVERBOSE - emit full file+line information for each BUG
+
+  CONFIG_BUG and CONFIG_DEBUG_BUGVERBOSE are potentially user-settable
+  (though they're generally always on).
+
+  CONFIG_GENERIC_BUG is set by each architecture using this code.
+
+  To use this, your architecture must:
+
+  1. Set up the config options:
+     - Enable CONFIG_GENERIC_BUG if CONFIG_BUG
+
+  2. Implement BUG (and optionally BUG_ON, WARN, WARN_ON)
+     - Define HAVE_ARCH_BUG
+     - Implement BUG() to generate a faulting instruction
+     - NOTE: struct bug_entry does not have "file" or "line" entries
+       when CONFIG_DEBUG_BUGVERBOSE is not enabled, so you must generate
+       the values accordingly.
+
+  3. Implement the trap
+     - In the illegal instruction trap handler (typically), verify
+       that the fault was in kernel mode, and call report_bug()
+     - report_bug() will return whether it was a false alarm, a warning,
+       or an actual bug.
+     - You must implement the is_valid_bugaddr(bugaddr) callback which
+       returns true if the eip is a real kernel address, and it points
+       to the expected BUG trap instruction.
+
+    Jeremy Fitzhardinge <jeremy@goop.org> 2006
+ */
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/bug.h>
+
+extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
+
+#ifdef CONFIG_MODULES
+static LIST_HEAD(module_bug_list);
+
+static const struct bug_entry *module_find_bug(unsigned long bugaddr)
+{
+	struct module *mod;
+
+	list_for_each_entry(mod, &module_bug_list, bug_list) {
+		const struct bug_entry *bug = mod->bug_table;
+		unsigned i;
+
+		for (i = 0; i < mod->num_bugs; ++i, ++bug)
+			if (bugaddr == bug->bug_addr)
+				return bug;
+	}
+	return NULL;
+}
+
+int module_bug_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
+			struct module *mod)
+{
+	char *secstrings;
+	unsigned int i;
+
+	mod->bug_table = NULL;
+	mod->num_bugs = 0;
+
+	/* Find the __bug_table section, if present */
+	secstrings = (char *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+	for (i = 1; i < hdr->e_shnum; i++) {
+		if (strcmp(secstrings+sechdrs[i].sh_name, "__bug_table"))
+			continue;
+		mod->bug_table = (void *) sechdrs[i].sh_addr;
+		mod->num_bugs = sechdrs[i].sh_size / sizeof(struct bug_entry);
+		break;
+	}
+
+	/*
+	 * Strictly speaking this should have a spinlock to protect against
+	 * traversals, but since we only traverse on BUG()s, a spinlock
+	 * could potentially lead to deadlock and thus be counter-productive.
+	 */
+	list_add(&mod->bug_list, &module_bug_list);
+
+	return 0;
+}
+
+void module_bug_cleanup(struct module *mod)
+{
+	list_del(&mod->bug_list);
+}
+
+#else
+
+static inline const struct bug_entry *module_find_bug(unsigned long bugaddr)
+{
+	return NULL;
+}
+#endif
+
+const struct bug_entry *find_bug(unsigned long bugaddr)
+{
+	const struct bug_entry *bug;
+
+	for (bug = __start___bug_table; bug < __stop___bug_table; ++bug)
+		if (bugaddr == bug->bug_addr)
+			return bug;
+
+	return module_find_bug(bugaddr);
+}
+
+enum bug_trap_type report_bug(unsigned long bugaddr)
+{
+	const struct bug_entry *bug;
+	const char *file;
+	unsigned line, warning;
+
+	if (!is_valid_bugaddr(bugaddr))
+		return BUG_TRAP_TYPE_NONE;
+
+	bug = find_bug(bugaddr);
+
+	printk(KERN_EMERG "------------[ cut here ]------------\n");
+
+	file = NULL;
+	line = 0;
+	warning = 0;
+
+	if (bug) {
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+		file = bug->file;
+		line = bug->line;
+#endif
+		warning = (bug->flags & BUGFLAG_WARNING) != 0;
+	}
+
+	if (warning) {
+		/* this is a WARN_ON rather than BUG/BUG_ON */
+		if (file)
+			printk(KERN_ERR "Badness at %s:%u\n",
+			       file, line);
+		else
+			printk(KERN_ERR "Badness at %p "
+			       "[verbose debug info unavailable]\n",
+			       (void *)bugaddr);
+
+		dump_stack();
+		return BUG_TRAP_TYPE_WARN;
+	}
+
+	if (file)
+		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
+		       file, line);
+	else
+		printk(KERN_CRIT "Kernel BUG at %p "
+		       "[verbose debug info unavailable]\n",
+		       (void *)bugaddr);
+
+	return BUG_TRAP_TYPE_BUG;
+}
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
generic-bug-implementation.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
uml-add-generic-bug-support.patch
use-generic-bug-for-ppc.patch
fix-generic-warn_on-message.patch
convert-i386-pda-code-to-use-%fs.patch
time-uninline-jiffiesh-fix.patch

