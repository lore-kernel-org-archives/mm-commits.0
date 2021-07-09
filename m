Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03946C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9B3613E1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhGIVgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGIVgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE61613D3;
        Fri,  9 Jul 2021 21:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866401;
        bh=Cp70fVXnbfMcF+yocLFOjrvmdPvF4n626oeNGITnmM4=;
        h=Date:From:To:Subject:From;
        b=lZwML83tsIRen8guFR0dfvl0LYFcsUJfRDD1ZdlTIl3IttWRLGLOYjL1JUP/sy5Zh
         Xb5Yg/w7wUi9Vo0S7VTZm7HGqvZZtaQ0E+hs5bd8g0ou4aQ8Y9xJbW4LP+Io1yxPpU
         y7oza1u63Vny5uKcxPsuUJ67L0IsvsVc2E24pmOY=
Date:   Fri, 09 Jul 2021 14:33:20 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ast@kernel.org, bhe@redhat.com,
        bp@alien8.de, catalin.marinas@arm.com, cuibixuan@huawei.com,
        dyoung@redhat.com, evgreen@chromium.org, hsinyi@chromium.org,
        jeyu@kernel.org, jolsa@kernel.org, khlebnikov@yandex-team.ru,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com,
        rdunlap@infradead.org, rostedt@goodmis.org, sashal@kernel.org,
        sergey.senozhatsky@gmail.com, swboyd@chromium.org,
        tglx@linutronix.de, vgoyal@redhat.com, will@kernel.org,
        willy@infradead.org
Subject:  [merged]
 module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
 removed from -mm tree
Message-ID: <20210709213320.mvtmACg-N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module: add printk formats to add module build ID to stacktraces
has been removed from the -mm tree.  Its filename was
     module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: module: add printk formats to add module build ID to stacktraces

Let's make kernel stacktraces easier to identify by including the build
ID[1] of a module if the stacktrace is printing a symbol from a module. 
This makes it simpler for developers to locate a kernel module's full
debuginfo for a particular stacktrace.  Combined with
scripts/decode_stracktrace.sh, a developer can download the matching
debuginfo from a debuginfod[2] server and find the exact file and line
number for the functions plus offsets in a stacktrace that match the
module.  This is especially useful for pstore crash debugging where the
kernel crashes are recorded in something like console-ramoops and the
recovery kernel/modules are different or the debuginfo doesn't exist on
the device due to space concerns (the debuginfo can be too large for space
limited devices).

Originally, I put this on the %pS format, but that was quickly rejected
given that %pS is used in other places such as ftrace where build IDs
aren't meaningful.  There was some discussions on the list to put every
module build ID into the "Modules linked in:" section of the stacktrace
message but that quickly becomes very hard to read once you have more than
three or four modules linked in.  It also provides too much information
when we don't expect each module to be traversed in a stacktrace.  Having
the build ID for modules that aren't important just makes things messy. 
Splitting it to multiple lines for each module quickly explodes the number
of lines printed in an oops too, possibly wrapping the warning off the
console.  And finally, trying to stash away each module used in a
callstack to provide the ID of each symbol printed is cumbersome and would
require changes to each architecture to stash away modules and return
their build IDs once unwinding has completed.

Instead, we opt for the simpler approach of introducing new printk formats
'%pS[R]b' for "pointer symbolic backtrace with module build ID" and '%pBb'
for "pointer backtrace with module build ID" and then updating the few
places in the architecture layer where the stacktrace is printed to use
this new format.

Before:

 Call trace:
  lkdtm_WARNING+0x28/0x30 [lkdtm]
  direct_entry+0x16c/0x1b4 [lkdtm]
  full_proxy_write+0x74/0xa4
  vfs_write+0xec/0x2e8

After:

 Call trace:
  lkdtm_WARNING+0x28/0x30 [lkdtm 6c2215028606bda50de823490723dc4bc5bf46f9]
  direct_entry+0x16c/0x1b4 [lkdtm 6c2215028606bda50de823490723dc4bc5bf46f9]
  full_proxy_write+0x74/0xa4
  vfs_write+0xec/0x2e8

[akpm@linux-foundation.org: fix build with CONFIG_MODULES=n, tweak code layout]
[rdunlap@infradead.org: fix build when CONFIG_MODULES is not set]
  Link: https://lkml.kernel.org/r/20210513171510.20328-1-rdunlap@infradead.org
[akpm@linux-foundation.org: make kallsyms_lookup_buildid() static]
[cuibixuan@huawei.com: fix build error when CONFIG_SYSFS is disabled]
  Link: https://lkml.kernel.org/r/20210525105049.34804-1-cuibixuan@huawei.com
Link: https://lkml.kernel.org/r/20210511003845.2429846-6-swboyd@chromium.org
Link: https://fedoraproject.org/wiki/Releases/FeatureBuildId [1]
Link: https://sourceware.org/elfutils/Debuginfod.html [2]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/printk-formats.rst |   11 ++
 include/linux/kallsyms.h                  |   21 +++-
 include/linux/module.h                    |    9 +
 kernel/kallsyms.c                         |  104 ++++++++++++++++----
 kernel/module.c                           |   42 +++++++-
 lib/vsprintf.c                            |    8 +
 6 files changed, 166 insertions(+), 29 deletions(-)

--- a/Documentation/core-api/printk-formats.rst~module-add-printk-formats-to-add-module-build-id-to-stacktraces
+++ a/Documentation/core-api/printk-formats.rst
@@ -125,6 +125,17 @@ used when printing stack backtraces. The
 consideration the effect of compiler optimisations which may occur
 when tail-calls are used and marked with the noreturn GCC attribute.
 
+If the pointer is within a module, the module name and optionally build ID is
+printed after the symbol name with an extra ``b`` appended to the end of the
+specifier.
+
+::
+	%pS	versatile_init+0x0/0x110 [module_name]
+	%pSb	versatile_init+0x0/0x110 [module_name ed5019fdf5e53be37cb1ba7899292d7e143b259e]
+	%pSRb	versatile_init+0x9/0x110 [module_name ed5019fdf5e53be37cb1ba7899292d7e143b259e]
+		(with __builtin_extract_return_addr() translation)
+	%pBb	prev_fn_of_versatile_init+0x88/0x88 [module_name ed5019fdf5e53be37cb1ba7899292d7e143b259e]
+
 Probed Pointers from BPF / tracing
 ----------------------------------
 
--- a/include/linux/kallsyms.h~module-add-printk-formats-to-add-module-build-id-to-stacktraces
+++ a/include/linux/kallsyms.h
@@ -7,6 +7,7 @@
 #define _LINUX_KALLSYMS_H
 
 #include <linux/errno.h>
+#include <linux/buildid.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/mm.h>
@@ -15,8 +16,10 @@
 #include <asm/sections.h>
 
 #define KSYM_NAME_LEN 128
-#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
-			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s %s]") + \
+			(KSYM_NAME_LEN - 1) + \
+			2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + \
+			(BUILD_ID_SIZE_MAX * 2) + 1)
 
 struct cred;
 struct module;
@@ -91,8 +94,10 @@ const char *kallsyms_lookup(unsigned lon
 
 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_symbol_build_id(char *buffer, unsigned long address);
 extern int sprint_symbol_no_offset(char *buffer, unsigned long address);
 extern int sprint_backtrace(char *buffer, unsigned long address);
+extern int sprint_backtrace_build_id(char *buffer, unsigned long address);
 
 int lookup_symbol_name(unsigned long addr, char *symname);
 int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
@@ -128,6 +133,12 @@ static inline int sprint_symbol(char *bu
 	return 0;
 }
 
+static inline int sprint_symbol_build_id(char *buffer, unsigned long address)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 static inline int sprint_symbol_no_offset(char *buffer, unsigned long addr)
 {
 	*buffer = '\0';
@@ -138,6 +149,12 @@ static inline int sprint_backtrace(char
 {
 	*buffer = '\0';
 	return 0;
+}
+
+static inline int sprint_backtrace_build_id(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
 }
 
 static inline int lookup_symbol_name(unsigned long addr, char *symname)
--- a/include/linux/module.h~module-add-printk-formats-to-add-module-build-id-to-stacktraces
+++ a/include/linux/module.h
@@ -11,6 +11,7 @@
 
 #include <linux/list.h>
 #include <linux/stat.h>
+#include <linux/buildid.h>
 #include <linux/compiler.h>
 #include <linux/cache.h>
 #include <linux/kmod.h>
@@ -369,6 +370,11 @@ struct module {
 	/* Unique handle for this module */
 	char name[MODULE_NAME_LEN];
 
+#ifdef CONFIG_STACKTRACE_BUILD_ID
+	/* Module build ID */
+	unsigned char build_id[BUILD_ID_SIZE_MAX];
+#endif
+
 	/* Sysfs stuff. */
 	struct module_kobject mkobj;
 	struct module_attribute *modinfo_attrs;
@@ -636,7 +642,7 @@ void *dereference_module_function_descri
 const char *module_address_lookup(unsigned long addr,
 			    unsigned long *symbolsize,
 			    unsigned long *offset,
-			    char **modname,
+			    char **modname, const unsigned char **modbuildid,
 			    char *namebuf);
 int lookup_module_symbol_name(unsigned long addr, char *symname);
 int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
@@ -740,6 +746,7 @@ static inline const char *module_address
 					  unsigned long *symbolsize,
 					  unsigned long *offset,
 					  char **modname,
+					  const unsigned char **modbuildid,
 					  char *namebuf)
 {
 	return NULL;
--- a/kernel/kallsyms.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces
+++ a/kernel/kallsyms.c
@@ -25,7 +25,10 @@
 #include <linux/filter.h>
 #include <linux/ftrace.h>
 #include <linux/kprobes.h>
+#include <linux/build_bug.h>
 #include <linux/compiler.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
 
 /*
  * These will be re-linked against their real values
@@ -297,21 +300,14 @@ int kallsyms_lookup_size_offset(unsigned
 		get_symbol_pos(addr, symbolsize, offset);
 		return 1;
 	}
-	return !!module_address_lookup(addr, symbolsize, offset, NULL, namebuf) ||
+	return !!module_address_lookup(addr, symbolsize, offset, NULL, NULL, namebuf) ||
 	       !!__bpf_address_lookup(addr, symbolsize, offset, namebuf);
 }
 
-/*
- * Lookup an address
- * - modname is set to NULL if it's in the kernel.
- * - We guarantee that the returned name is valid until we reschedule even if.
- *   It resides in a module.
- * - We also guarantee that modname will be valid until rescheduled.
- */
-const char *kallsyms_lookup(unsigned long addr,
-			    unsigned long *symbolsize,
-			    unsigned long *offset,
-			    char **modname, char *namebuf)
+static const char *kallsyms_lookup_buildid(unsigned long addr,
+			unsigned long *symbolsize,
+			unsigned long *offset, char **modname,
+			const unsigned char **modbuildid, char *namebuf)
 {
 	const char *ret;
 
@@ -327,6 +323,8 @@ const char *kallsyms_lookup(unsigned lon
 				       namebuf, KSYM_NAME_LEN);
 		if (modname)
 			*modname = NULL;
+		if (modbuildid)
+			*modbuildid = NULL;
 
 		ret = namebuf;
 		goto found;
@@ -334,7 +332,7 @@ const char *kallsyms_lookup(unsigned lon
 
 	/* See if it's in a module or a BPF JITed image. */
 	ret = module_address_lookup(addr, symbolsize, offset,
-				    modname, namebuf);
+				    modname, modbuildid, namebuf);
 	if (!ret)
 		ret = bpf_address_lookup(addr, symbolsize,
 					 offset, modname, namebuf);
@@ -348,6 +346,22 @@ found:
 	return ret;
 }
 
+/*
+ * Lookup an address
+ * - modname is set to NULL if it's in the kernel.
+ * - We guarantee that the returned name is valid until we reschedule even if.
+ *   It resides in a module.
+ * - We also guarantee that modname will be valid until rescheduled.
+ */
+const char *kallsyms_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname, char *namebuf)
+{
+	return kallsyms_lookup_buildid(addr, symbolsize, offset, modname,
+				       NULL, namebuf);
+}
+
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
 	int res;
@@ -404,15 +418,17 @@ found:
 
 /* Look up a kernel symbol and return it in a text buffer. */
 static int __sprint_symbol(char *buffer, unsigned long address,
-			   int symbol_offset, int add_offset)
+			   int symbol_offset, int add_offset, int add_buildid)
 {
 	char *modname;
+	const unsigned char *buildid;
 	const char *name;
 	unsigned long offset, size;
 	int len;
 
 	address += symbol_offset;
-	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
+	name = kallsyms_lookup_buildid(address, &size, &offset, &modname, &buildid,
+				       buffer);
 	if (!name)
 		return sprintf(buffer, "0x%lx", address - symbol_offset);
 
@@ -424,8 +440,19 @@ static int __sprint_symbol(char *buffer,
 	if (add_offset)
 		len += sprintf(buffer + len, "+%#lx/%#lx", offset, size);
 
-	if (modname)
-		len += sprintf(buffer + len, " [%s]", modname);
+	if (modname) {
+		len += sprintf(buffer + len, " [%s", modname);
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+		if (add_buildid && buildid) {
+			/* build ID should match length of sprintf */
+#if IS_ENABLED(CONFIG_MODULES)
+			static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
+#endif
+			len += sprintf(buffer + len, " %20phN", buildid);
+		}
+#endif
+		len += sprintf(buffer + len, "]");
+	}
 
 	return len;
 }
@@ -443,11 +470,28 @@ static int __sprint_symbol(char *buffer,
  */
 int sprint_symbol(char *buffer, unsigned long address)
 {
-	return __sprint_symbol(buffer, address, 0, 1);
+	return __sprint_symbol(buffer, address, 0, 1, 0);
 }
 EXPORT_SYMBOL_GPL(sprint_symbol);
 
 /**
+ * sprint_symbol_build_id - Look up a kernel symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function looks up a kernel symbol with @address and stores its name,
+ * offset, size, module name and module build ID to @buffer if possible. If no
+ * symbol was found, just saves its @address as is.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_symbol_build_id(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, 0, 1, 1);
+}
+EXPORT_SYMBOL_GPL(sprint_symbol_build_id);
+
+/**
  * sprint_symbol_no_offset - Look up a kernel symbol and return it in a text buffer
  * @buffer: buffer to be stored
  * @address: address to lookup
@@ -460,7 +504,7 @@ EXPORT_SYMBOL_GPL(sprint_symbol);
  */
 int sprint_symbol_no_offset(char *buffer, unsigned long address)
 {
-	return __sprint_symbol(buffer, address, 0, 0);
+	return __sprint_symbol(buffer, address, 0, 0, 0);
 }
 EXPORT_SYMBOL_GPL(sprint_symbol_no_offset);
 
@@ -480,7 +524,27 @@ EXPORT_SYMBOL_GPL(sprint_symbol_no_offse
  */
 int sprint_backtrace(char *buffer, unsigned long address)
 {
-	return __sprint_symbol(buffer, address, -1, 1);
+	return __sprint_symbol(buffer, address, -1, 1, 0);
+}
+
+/**
+ * sprint_backtrace_build_id - Look up a backtrace symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function is for stack backtrace and does the same thing as
+ * sprint_symbol() but with modified/decreased @address. If there is a
+ * tail-call to the function marked "noreturn", gcc optimized out code after
+ * the call so that the stack-saved return address could point outside of the
+ * caller. This function ensures that kallsyms will find the original caller
+ * by decreasing @address. This function also appends the module build ID to
+ * the @buffer if @address is within a kernel module.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_backtrace_build_id(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, -1, 1, 1);
 }
 
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
--- a/kernel/module.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces
+++ a/kernel/module.c
@@ -13,6 +13,7 @@
 #include <linux/trace_events.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
+#include <linux/buildid.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/sysfs.h>
@@ -1465,6 +1466,13 @@ resolve_symbol_wait(struct module *mod,
 	return ksym;
 }
 
+#ifdef CONFIG_KALLSYMS
+static inline bool sect_empty(const Elf_Shdr *sect)
+{
+	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
+}
+#endif
+
 /*
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
@@ -1472,11 +1480,6 @@ resolve_symbol_wait(struct module *mod,
 #ifdef CONFIG_SYSFS
 
 #ifdef CONFIG_KALLSYMS
-static inline bool sect_empty(const Elf_Shdr *sect)
-{
-	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
-}
-
 struct module_sect_attr {
 	struct bin_attribute battr;
 	unsigned long address;
@@ -2797,6 +2800,26 @@ static void add_kallsyms(struct module *
 }
 #endif /* CONFIG_KALLSYMS */
 
+#if IS_ENABLED(CONFIG_KALLSYMS) && IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+static void init_build_id(struct module *mod, const struct load_info *info)
+{
+	const Elf_Shdr *sechdr;
+	unsigned int i;
+
+	for (i = 0; i < info->hdr->e_shnum; i++) {
+		sechdr = &info->sechdrs[i];
+		if (!sect_empty(sechdr) && sechdr->sh_type == SHT_NOTE &&
+		    !build_id_parse_buf((void *)sechdr->sh_addr, mod->build_id,
+					sechdr->sh_size))
+			break;
+	}
+}
+#else
+static void init_build_id(struct module *mod, const struct load_info *info)
+{
+}
+#endif
+
 static void dynamic_debug_setup(struct module *mod, struct _ddebug *debug, unsigned int num)
 {
 	if (!debug)
@@ -4021,6 +4044,7 @@ static int load_module(struct load_info
 		goto free_arch_cleanup;
 	}
 
+	init_build_id(mod, info);
 	dynamic_debug_setup(mod, info->debug, info->num_debug);
 
 	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
@@ -4254,6 +4278,7 @@ const char *module_address_lookup(unsign
 			    unsigned long *size,
 			    unsigned long *offset,
 			    char **modname,
+			    const unsigned char **modbuildid,
 			    char *namebuf)
 {
 	const char *ret = NULL;
@@ -4264,6 +4289,13 @@ const char *module_address_lookup(unsign
 	if (mod) {
 		if (modname)
 			*modname = mod->name;
+		if (modbuildid) {
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+			*modbuildid = mod->build_id;
+#else
+			*modbuildid = NULL;
+#endif
+		}
 
 		ret = find_kallsyms_symbol(mod, addr, size, offset);
 	}
--- a/lib/vsprintf.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces
+++ a/lib/vsprintf.c
@@ -993,8 +993,12 @@ char *symbol_string(char *buf, char *end
 	value = (unsigned long)ptr;
 
 #ifdef CONFIG_KALLSYMS
-	if (*fmt == 'B')
+	if (*fmt == 'B' && fmt[1] == 'b')
+		sprint_backtrace_build_id(sym, value);
+	else if (*fmt == 'B')
 		sprint_backtrace(sym, value);
+	else if (*fmt == 'S' && (fmt[1] == 'b' || (fmt[1] == 'R' && fmt[2] == 'b')))
+		sprint_symbol_build_id(sym, value);
 	else if (*fmt != 's')
 		sprint_symbol(sym, value);
 	else
@@ -2263,9 +2267,11 @@ early_param("no_hash_pointers", no_hash_
  * - 'S' For symbolic direct pointers (or function descriptors) with offset
  * - 's' For symbolic direct pointers (or function descriptors) without offset
  * - '[Ss]R' as above with __builtin_extract_return_addr() translation
+ * - 'S[R]b' as above with module build ID (for use in backtraces)
  * - '[Ff]' %pf and %pF were obsoleted and later removed in favor of
  *	    %ps and %pS. Be careful when re-using these specifiers.
  * - 'B' For backtraced symbolic direct pointers with offset
+ * - 'Bb' as above with module build ID (for use in backtraces)
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'b[l]' For a bitmap, the number of bits is determined by the field
_

Patches currently in -mm which might be from swboyd@chromium.org are


