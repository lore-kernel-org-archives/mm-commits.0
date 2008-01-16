From: akpm@linux-foundation.org
Subject: - modules-de-mutex-more-symbol-lookup-paths-in-the-module-code.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:37:57 -0800
Message-ID: <200801160137.m0G1bvFb013870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977AbYAPBi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, kyle@mcmartin.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     modules: de-mutex more symbol lookup paths in the module code
has been removed from the -mm tree.  Its filename was
     modules-de-mutex-more-symbol-lookup-paths-in-the-module-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: de-mutex more symbol lookup paths in the module code
From: Rusty Russell <rusty@rustcorp.com.au>

Kyle McMartin reports sysrq_timer_list_show() can hit the module mutex from
hard interrupt context.  These paths don't need to though, since we long ago
changed all the module list manipulation to occur via stop_machine().

Disabling preemption is enough.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN kernel/module.c~modules-de-mutex-more-symbol-lookup-paths-in-the-module-code kernel/module.c
--- a/kernel/module.c~modules-de-mutex-more-symbol-lookup-paths-in-the-module-code
+++ a/kernel/module.c
@@ -2214,29 +2214,34 @@ static const char *get_ksymbol(struct mo
 /* For kallsyms to ask for address resolution.  NULL means not found.
    We don't lock, as this is used for oops resolution and races are a
    lesser concern. */
+/* FIXME: Risky: returns a pointer into a module w/o lock */
 const char *module_address_lookup(unsigned long addr,
 				  unsigned long *size,
 				  unsigned long *offset,
 				  char **modname)
 {
 	struct module *mod;
+	const char *ret = NULL;
 
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size)
 		    || within(addr, mod->module_core, mod->core_size)) {
 			if (modname)
 				*modname = mod->name;
-			return get_ksymbol(mod, addr, size, offset);
+			ret = get_ksymbol(mod, addr, size, offset);
+			break;
 		}
 	}
-	return NULL;
+	preempt_enable();
+	return ret;
 }
 
 int lookup_module_symbol_name(unsigned long addr, char *symname)
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
@@ -2246,12 +2251,12 @@ int lookup_module_symbol_name(unsigned l
 			if (!sym)
 				goto out;
 			strlcpy(symname, sym, KSYM_NAME_LEN);
-			mutex_unlock(&module_mutex);
+			preempt_enable();
 			return 0;
 		}
 	}
 out:
-	mutex_unlock(&module_mutex);
+	preempt_enable();
 	return -ERANGE;
 }
 
@@ -2260,7 +2265,7 @@ int lookup_module_symbol_attrs(unsigned 
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
@@ -2273,12 +2278,12 @@ int lookup_module_symbol_attrs(unsigned 
 				strlcpy(modname, mod->name, MODULE_NAME_LEN);
 			if (name)
 				strlcpy(name, sym, KSYM_NAME_LEN);
-			mutex_unlock(&module_mutex);
+			preempt_enable();
 			return 0;
 		}
 	}
 out:
-	mutex_unlock(&module_mutex);
+	preempt_enable();
 	return -ERANGE;
 }
 
@@ -2287,7 +2292,7 @@ int module_get_kallsym(unsigned int symn
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
@@ -2296,12 +2301,12 @@ int module_get_kallsym(unsigned int symn
 				KSYM_NAME_LEN);
 			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
 			*exported = is_exported(name, mod);
-			mutex_unlock(&module_mutex);
+			preempt_enable();
 			return 0;
 		}
 		symnum -= mod->num_symtab;
 	}
-	mutex_unlock(&module_mutex);
+	preempt_enable();
 	return -ERANGE;
 }
 
@@ -2324,6 +2329,7 @@ unsigned long module_kallsyms_lookup_nam
 	unsigned long ret = 0;
 
 	/* Don't lock: we're in enough trouble already. */
+	preempt_disable();
 	if ((colon = strchr(name, ':')) != NULL) {
 		*colon = '\0';
 		if ((mod = find_module(name)) != NULL)
@@ -2334,6 +2340,7 @@ unsigned long module_kallsyms_lookup_nam
 			if ((ret = mod_find_symname(mod, name)) != 0)
 				break;
 	}
+	preempt_enable();
 	return ret;
 }
 #endif /* CONFIG_KALLSYMS */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-sched.patch
git-scsi-misc.patch
git-x86.patch
kallsyms-should-prefer-non-weak-symbols.patch
virtio_net-remove-double-ether_setup.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-make-module_address_lookup-safe.patch
fixup-container_of-usage.patch
aio-partial-write-should-not-return-error-code.patch
aio-negative-offset-should-return-einval.patch
reiser4.patch
