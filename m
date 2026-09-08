Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440C15A5133
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 22:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908267; cv=none; b=L1M/3fuO2Zq4fJH5VuZLC2fmKn5r46lPQ7SZR6KUnvm+xvNwaaNBFqDao1BRvcX7zqmou8KHLh9Gg03ouejNxEWdhqnjgTK6Eta6dROe7FAnuWzaXpBTzl15luJuktjP9zxB6ZS/fzzsrvEUF4l9wMn8U66ZH4StLqjXCnEdS0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908267; c=relaxed/simple;
	bh=Q74WLPoac8pWM8P/KuOI6GOdVlAgD0nq4d+470XRtpE=;
	h=Date:To:From:Subject:Message-Id; b=QiPwx+1pM3ARr3VgfwrTgPNRsGmRjhNubdJRKvsPHlenc6sIk7O23c/CemS0R2k1aP013u7kpWwPo1zBHQeVq6e1B1KH5kpqTsaioZxIVXtUjatV96s+q8rOGjQYOH2mEYqnWhP1WfLAvqxi1q0OhsR+yBSzKx9Asbh34B+EuXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jeTSOEXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jeTSOEXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC991F00A3D;
	Tue,  8 Sep 2026 22:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788908264;
	bh=IQy7vAXXAJpBl57RVhxmLNj+vX6dVIqs711eTnWa3Z0=;
	h=Date:To:From:Subject;
	b=jeTSOEXVcDt1JzTBLgOY1x5O5oM+U2ZUMaqzuQKi4GgPfsDVDpZN0YMyw7Brvk5cY
	 a4gto40sLXVVaD4kpGid8p+3ZzQhFqjcxlCDfds2890veGy4PZhUmLEnZGwJWUWmLD
	 iB+CdKo4fVQQyx0mKIhGWvGwvlIgbCOSEp3rMutU=
Date: Tue, 08 Sep 2026 15:57:43 -0700
To: mm-commits@vger.kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,peterz@infradead.org,ojeda@kernel.org,mhiramat@kernel.org,mcgrof@kernel.org,gregkh@linuxfoundation.org,arnd@arndb.de,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-extend-module_blacklist-parameter-to-built-in-modules.patch added to mm-nonmm-unstable branch
Message-Id: <20260908225743.ECC991F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: extend module_blacklist parameter to built-in modules
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     module-extend-module_blacklist-parameter-to-built-in-modules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-extend-module_blacklist-parameter-to-built-in-modules.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: module: extend module_blacklist parameter to built-in modules
Date: Tue, 8 Sep 2026 16:32:29 -0400

Currently, the "module_blacklist=" command-line parameter only applies to
loadable modules.  If a module is built-in, the parameter is silently
ignored.  This patch extends the blacklisting functionality to built-in
modules by intercepting their initialisation routines during early boot.

To achieve this, we introduce a new ".initcall.modnames" memory section. 
For each built-in module, we use a standard C structure (i.e., struct
initcall_modname) to map its initcall function pointer to its associated
KBUILD_MODNAME string.  This mapping is restricted only to files
implementing built-in modules via module_init() to avoid mapping core
kernel subsystems and save memory.

During boot, built-in initcalls are executed sequentially via
do_initcall_level() and do_pre_smp_initcalls().  We introduce a new
wrapper function, do_one_initcall_builtin(), to cross-reference the
initcall function pointer against the ".initcall.modnames" table.  If a
match is found and the module is present in the blacklist, the initcall is
skipped.

To make the blacklist functional on monolithic kernels, the command-line
parameter parsing and the module_is_blacklisted() lookup function are
decoupled from the loadable module subsystem and moved to init/main.c. 
This enables "module_blacklist=" to intercept built-in modules even on
kernels built with CONFIG_MODULES=n.

Link: https://lore.kernel.org/20260908203230.401020-3-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    4 +-
 include/linux/init.h              |   25 ++++++++++++
 include/linux/module.h            |    4 +-
 init/main.c                       |   54 ++++++++++++++++++++++++++--
 kernel/module/main.c              |   22 -----------
 rust/bindings/bindings_helper.h   |    1 
 rust/macros/module.rs             |   19 +++++++++
 7 files changed, 103 insertions(+), 26 deletions(-)

--- a/include/asm-generic/vmlinux.lds.h~module-extend-module_blacklist-parameter-to-built-in-modules
+++ a/include/asm-generic/vmlinux.lds.h
@@ -734,7 +734,9 @@
 	EARLYCON_TABLE()						\
 	LSM_TABLE()							\
 	EARLY_LSM_TABLE()						\
-	KUNIT_INIT_TABLE()
+	KUNIT_INIT_TABLE()						\
+	. = ALIGN(8);							\
+	BOUNDED_SECTION_BY(.initcall.modnames, _initcall_modnames)
 
 #define INIT_TEXT							\
 	*(.init.text .init.text.*)					\
--- a/include/linux/init.h~module-extend-module_blacklist-parameter-to-built-in-modules
+++ a/include/linux/init.h
@@ -252,6 +252,7 @@ extern struct module __this_module;
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
+#define __initcall_fn_ptr(fn, __iid, id)	__initcall_stub(fn, __iid, id)
 #define ____define_initcall(fn, __stub, __name, __sec)		\
 	__define_initcall_stub(__stub, fn)			\
 	asm(".section	\"" __sec "\", \"a\"		\n"	\
@@ -260,6 +261,7 @@ extern struct module __this_module;
 	    ".previous					\n");	\
 	static_assert(__same_type(initcall_t, &fn));
 #else
+#define __initcall_fn_ptr(fn, __iid, id)	fn
 #define ____define_initcall(fn, __unused, __name, __sec)	\
 	static initcall_t __name __used 			\
 		__attribute__((__section__(__sec))) = fn;
@@ -271,7 +273,28 @@ extern struct module __this_module;
 		__initcall_name(initcall, __iid, id),		\
 		__initcall_section(__sec, __iid))
 
-#define ___define_initcall(fn, id, __sec)			\
+struct initcall_modname {
+	initcall_t initcall_fn;
+	const char *modname;
+};
+
+#define ____define_initcall_modname(fn, id, __sec, __iid)		\
+	__unique_initcall(fn, id, __sec, __iid)				\
+	static const char __initstr_##fn[] __used __aligned(1)		\
+		__section(".init.rodata") = KBUILD_MODNAME;		\
+	static const struct initcall_modname __modname_##fn __used	\
+		__section(".initcall.modnames")				\
+		__aligned(__alignof__(struct initcall_modname)) = {	\
+			.initcall_fn = __initcall_fn_ptr(fn, __iid, id),\
+			.modname = __initstr_##fn			\
+		};
+
+#define __define_initcall_modname(fn, id)				\
+	____define_initcall_modname(fn, id, .initcall##id, __initcall_id(fn))
+
+#define __builtin_module_initcall(fn)	__define_initcall_modname(fn, 6)
+
+#define ___define_initcall(fn, id, __sec)				\
 	__unique_initcall(fn, id, __sec, __initcall_id(fn))
 
 #define __define_initcall(fn, id) ___define_initcall(fn, id, .initcall##id)
--- a/include/linux/module.h~module-extend-module_blacklist-parameter-to-built-in-modules
+++ a/include/linux/module.h
@@ -86,7 +86,7 @@ extern void cleanup_module(void);
  * builtin) or at module insertion time (if a module).  There can only
  * be one per module.
  */
-#define module_init(x)	__initcall(x);
+#define module_init(x)	__builtin_module_initcall(x);
 
 /**
  * module_exit() - driver exit entry point
@@ -879,6 +879,8 @@ static inline void module_for_each_mod(i
 }
 #endif /* CONFIG_MODULES */
 
+bool module_is_blacklisted(const char *module_name);
+
 #ifdef CONFIG_SYSFS
 extern struct kset *module_kset;
 extern const struct kobj_type module_ktype;
--- a/init/main.c~module-extend-module_blacklist-parameter-to-built-in-modules
+++ a/init/main.c
@@ -1344,6 +1344,56 @@ static inline void do_trace_initcall_lev
 }
 #endif /* !TRACEPOINTS_ENABLED */
 
+extern struct initcall_modname __start_initcall_modnames[];
+extern struct initcall_modname __stop_initcall_modnames[];
+
+/* module_blacklist is a comma-separated list of module names */
+static char *module_blacklist;
+bool __init_or_module module_is_blacklisted(const char *module_name)
+{
+	const char *p;
+	size_t len;
+
+	if (!module_blacklist)
+		return false;
+
+	for (p = module_blacklist; *p; p += len) {
+		len = strcspn(p, ",");
+		if (strlen(module_name) == len && parameqn(module_name, p, len))
+			return true;
+		if (p[len] == ',')
+			len++;
+	}
+	return false;
+}
+core_param(module_blacklist, module_blacklist, charp, 0400);
+
+static const char *__init get_builtin_modname(initcall_t fn)
+{
+	struct initcall_modname *p;
+
+	for (p = __start_initcall_modnames; p < __stop_initcall_modnames; p++) {
+		if (p->initcall_fn == fn)
+			return p->modname;
+	}
+	return NULL;
+}
+
+static void __init do_one_initcall_builtin(initcall_t fn)
+{
+	const char *modname;
+
+	if (module_blacklist) {
+		modname = get_builtin_modname(fn);
+		if (modname && module_is_blacklisted(modname)) {
+			pr_info("Skipping initcall for blacklisted built-in module %s\n",
+				modname);
+			return;
+		}
+	}
+	do_one_initcall(fn);
+}
+
 int __init_or_module do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
@@ -1416,7 +1466,7 @@ static void __init do_initcall_level(int
 
 	do_trace_initcall_level(initcall_level_names[level]);
 	for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
-		do_one_initcall(initcall_from_entry(fn));
+		do_one_initcall_builtin(initcall_from_entry(fn));
 }
 
 static void __init do_initcalls(void)
@@ -1461,7 +1511,7 @@ static void __init do_pre_smp_initcalls(
 
 	do_trace_initcall_level("early");
 	for (fn = __initcall_start; fn < __initcall0_start; fn++)
-		do_one_initcall(initcall_from_entry(fn));
+		do_one_initcall_builtin(initcall_from_entry(fn));
 }
 
 static int run_init_process(const char *init_filename)
--- a/kernel/module/main.c~module-extend-module_blacklist-parameter-to-built-in-modules
+++ a/kernel/module/main.c
@@ -2930,26 +2930,6 @@ int __weak module_frob_arch_sections(Elf
 	return 0;
 }
 
-/* module_blacklist is a comma-separated list of module names */
-static char *module_blacklist;
-static bool blacklisted(const char *module_name)
-{
-	const char *p;
-	size_t len;
-
-	if (!module_blacklist)
-		return false;
-
-	for (p = module_blacklist; *p; p += len) {
-		len = strcspn(p, ",");
-		if (strlen(module_name) == len && parameqn(module_name, p, len))
-			return true;
-		if (p[len] == ',')
-			len++;
-	}
-	return false;
-}
-core_param(module_blacklist, module_blacklist, charp, 0400);
 
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
@@ -3402,7 +3382,7 @@ static int early_mod_check(struct load_i
 	 * Now that we know we have the correct module name, check
 	 * if it's blacklisted.
 	 */
-	if (blacklisted(info->name)) {
+	if (module_is_blacklisted(info->name)) {
 		pr_err("Module %s is blacklisted\n", info->name);
 		return -EPERM;
 	}
--- a/rust/bindings/bindings_helper.h~module-extend-module_blacklist-parameter-to-built-in-modules
+++ a/rust/bindings/bindings_helper.h
@@ -63,6 +63,7 @@
 #include <linux/fwctl.h>
 #include <linux/fs.h>
 #include <linux/i2c.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io-pgtable.h>
 #include <linux/ioport.h>
--- a/rust/macros/module.rs~module-extend-module_blacklist-parameter-to-built-in-modules
+++ a/rust/macros/module.rs
@@ -480,6 +480,8 @@ pub(crate) fn module(info: ModuleInfo) -
     let ident_init = format_ident!("__{ident}_init");
     let ident_exit = format_ident!("__{ident}_exit");
     let ident_initcall = format_ident!("__{ident}_initcall");
+    let ident_modname = format_ident!("__{ident}_modname");
+    let ident_modname_str = format_ident!("__{ident}_modname_str");
     let initcall_section = ".initcall6.init";
 
     let global_asm = format!(
@@ -491,6 +493,9 @@ pub(crate) fn module(info: ModuleInfo) -
     );
 
     let name_cstr = CString::new(name.value()).expect("name contains NUL-terminator");
+    let name_bytes = name_cstr.to_bytes_with_nul();
+    let name_len = name_bytes.len();
+    let name_byte_literal = Literal::byte_string(name_bytes);
 
     Ok(quote! {
         /// The module name.
@@ -592,6 +597,20 @@ pub(crate) fn module(info: ModuleInfo) -
                 ::core::arch::global_asm!(#global_asm);
 
                 #[cfg(not(MODULE))]
+                #[used(compiler)]
+                #[link_section = ".init.rodata"]
+                static #ident_modname_str: [u8; #name_len] = *#name_byte_literal;
+
+                #[cfg(not(MODULE))]
+                #[used(compiler)]
+                #[link_section = ".initcall.modnames"]
+                static #ident_modname: ::kernel::bindings::initcall_modname =
+                    ::kernel::bindings::initcall_modname {
+                        initcall_fn: Some(#ident_init),
+                        modname: #ident_modname_str.as_ptr().cast(),
+                    };
+
+                #[cfg(not(MODULE))]
                 #[no_mangle]
                 pub extern "C" fn #ident_init() -> ::kernel::ffi::c_int {
                     // SAFETY: This function is inaccessible to the outside due to the double
_

Patches currently in -mm which might be from atomlin@atomlin.com are

hung_task-reset-warning-budget-when-problem-gets-resolved.patch
hung_task-log-summary-line-when-warning-budget-is-exhausted.patch
module-treat-dashes-and-underscores-interchangeably-in-module_blacklist.patch
module-extend-module_blacklist-parameter-to-built-in-modules.patch
module-rename-module_blacklist-to-module_denylist.patch

