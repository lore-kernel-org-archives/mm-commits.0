From: akpm@linux-foundation.org
Subject: + modules-remove-stop_machine-during-module-load.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:32:14 -0700
Message-ID: <200809022332.m82NWF8L018492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbYIBXcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au


The patch titled
     modules: remove stop_machine during module load
has been added to the -mm tree.  Its filename is
     modules-remove-stop_machine-during-module-load.patch

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
Subject: modules: remove stop_machine during module load
From: Andi Kleen <andi@firstfloor.org>

Nodule loading currently does a stop_machine on each module load to insert
the module into the global module lists.  Especially on larger systems
this can be quite expensive.

It does that to handle concurrent lock lessmodule list readers
like kallsyms.

I don't think stop_machine() is actually needed to insert something into a
list though.  There are no concurrent writers because the module mutex is
taken.  And the RCU list functions know how to insert a node into a list
with the right memory ordering so that concurrent readers don't go off
into the wood.

So remove the stop_machine for the module list insert and just
do a list_add_rcu() instead.

Module removal will still do a stop_machine of course, it needs
that for other reasons.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff -puN kernel/module.c~modules-remove-stop_machine-during-module-load kernel/module.c
--- a/kernel/module.c~modules-remove-stop_machine-during-module-load
+++ a/kernel/module.c
@@ -42,6 +42,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/unwind.h>
+#include <linux/rculist.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -64,7 +65,7 @@
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
 /* List of modules, protected by module_mutex or preempt_disable
- * (add/delete uses stop_machine). */
+ * (delete uses stop_machine/add uses RCU list operations). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
 
@@ -219,7 +220,7 @@ static bool each_symbol(bool (*fn)(const
 	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
 		return true;
 
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		struct symsearch arr[] = {
 			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
 			  NOT_GPL_ONLY, false },
@@ -1395,17 +1396,6 @@ static void mod_kobject_remove(struct mo
 }
 
 /*
- * link the module with the whole machine is stopped with interrupts off
- * - this defends against kallsyms not taking locks
- */
-static int __link_module(void *_mod)
-{
-	struct module *mod = _mod;
-	list_add(&mod->list, &modules);
-	return 0;
-}
-
-/*
  * unlink the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
@@ -2265,8 +2255,12 @@ static noinline struct module *load_modu
 
 	/* Now sew it into the lists so we can get lockdep and oops
          * info during argument parsing.  Noone should access us, since
-         * strong_try_module_get() will fail. */
-	stop_machine(__link_module, mod, NULL);
+         * strong_try_module_get() will fail.
+	 * lockdep/oops can run asynchronous, so use the RCU list insertion
+	 * function to insert in a way safe to concurrent readers.
+	 * The mutex protects against concurrent writers.
+	 */
+	list_add_rcu(&mod->list, &modules);
 
 	/* Size of section 0 is 0, so this works well if no params */
 	err = parse_args(mod->name, mod->args,
@@ -2471,7 +2465,7 @@ const char *module_address_lookup(unsign
 	const char *ret = NULL;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size)
 		    || within(addr, mod->module_core, mod->core_size)) {
 			if (modname)
@@ -2494,7 +2488,7 @@ int lookup_module_symbol_name(unsigned l
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
 			const char *sym;
@@ -2518,7 +2512,7 @@ int lookup_module_symbol_attrs(unsigned 
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
 			const char *sym;
@@ -2545,7 +2539,7 @@ int module_get_kallsym(unsigned int symn
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
 			*type = mod->symtab[symnum].st_info;
@@ -2588,7 +2582,7 @@ unsigned long module_kallsyms_lookup_nam
 			ret = mod_find_symname(mod, colon+1);
 		*colon = ':';
 	} else {
-		list_for_each_entry(mod, &modules, list)
+		list_for_each_entry_rcu(mod, &modules, list)
 			if ((ret = mod_find_symname(mod, name)) != 0)
 				break;
 	}
@@ -2689,7 +2683,7 @@ const struct exception_table_entry *sear
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->num_exentries == 0)
 			continue;
 
@@ -2715,7 +2709,7 @@ int is_module_address(unsigned long addr
 
 	preempt_disable();
 
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_core, mod->core_size)) {
 			preempt_enable();
 			return 1;
@@ -2736,7 +2730,7 @@ struct module *__module_text_address(uns
 	if (addr < module_addr_min || addr > module_addr_max)
 		return NULL;
 
-	list_for_each_entry(mod, &modules, list)
+	list_for_each_entry_rcu(mod, &modules, list)
 		if (within(addr, mod->module_init, mod->init_text_size)
 		    || within(addr, mod->module_core, mod->core_text_size))
 			return mod;
@@ -2761,8 +2755,11 @@ void print_modules(void)
 	char buf[8];
 
 	printk("Modules linked in:");
-	list_for_each_entry(mod, &modules, list)
+	/* Most callers should already have preempt disabled, but make sure */
+	preempt_disable();
+	list_for_each_entry_rcu(mod, &modules, list)
 		printk(" %s%s", mod->name, module_flags(mod, buf));
+	preempt_enable();
 	if (last_unloaded_module[0])
 		printk(" [last unloaded: %s]", last_unloaded_module);
 	printk("\n");
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
misdn-misc-timerdev-fixes.patch
modules-remove-stop_machine-during-module-load.patch
acpi_pmc-use-proper-read-function-also-in-errata-mode.patch
acpi_pmc-check-for-monotonicity.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
acpi-use-bcd2bin-bin2bcd.patch
profile-likely-unlikely-macros.patch

