From: akpm@linux-foundation.org
Subject: + module-add-within_module_core-and-within_module_init.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:28:42 -0800
Message-ID: <200811140028.mAE0ShUj021404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538AbYKNA3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, rusty@rustcorp.com.au


The patch titled
     module: add within_module_core() and within_module_init()
has been added to the -mm tree.  Its filename is
     module-add-within_module_core-and-within_module_init.patch

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
Subject: module: add within_module_core() and within_module_init()
From: Masami Hiramatsu <mhiramat@redhat.com>

This series of patches allows kprobes to probe module's __init and __exit
functions.  This means, you can probe driver initialization and
terminating.

Currently, kprobes can't probe __init function because these functions are
freed after module initialization.  And it also can't probe module __exit
functions because kprobe increments reference count of target module and
user can't unload it.  this means __exit functions never be called unless
removing probes from the module.

To solve both cases, this series of patches introduces GONE flag and sets
it when the target code is freed(for this purpose, kprobes hooks
MODULE_STATE_* events).  This also removes refcount incrementing for
allowing user to unload target module.  Users can check which probes are
GONE by debugfs interface.  For taking timing of freeing module's .init
text, these also include a patch which adds module's notifier of
MODULE_STATE_LIVE event.


This patch:

Add within_module_core() and within_module_init() for checking whether an
address is in the module .init.text section or .text section, and replace
within() local inline functions in kernel/module.c with them.

kprobes uses these functions to check where the kprobe is inserted.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   12 ++++++++++++
 kernel/module.c        |   16 ++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff -puN include/linux/module.h~module-add-within_module_core-and-within_module_init include/linux/module.h
--- a/include/linux/module.h~module-add-within_module_core-and-within_module_init
+++ a/include/linux/module.h
@@ -366,6 +366,18 @@ struct module *module_text_address(unsig
 struct module *__module_text_address(unsigned long addr);
 int is_module_address(unsigned long addr);
 
+static inline int within_module_core(unsigned long addr, struct module *mod)
+{
+	return (unsigned long)mod->module_core <= addr &&
+	       addr < (unsigned long)mod->module_core + mod->core_size;
+}
+
+static inline int within_module_init(unsigned long addr, struct module *mod)
+{
+	return (unsigned long)mod->module_init <= addr &&
+	       addr < (unsigned long)mod->module_init + mod->init_size;
+}
+
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
diff -puN kernel/module.c~module-add-within_module_core-and-within_module_init kernel/module.c
--- a/kernel/module.c~module-add-within_module_core-and-within_module_init
+++ a/kernel/module.c
@@ -2220,7 +2220,7 @@ static const char *get_ksymbol(struct mo
 	unsigned long nextval;
 
 	/* At worse, next value is at end of module */
-	if (within(addr, mod->module_init, mod->init_size))
+	if (within_module_init(addr, mod))
 		nextval = (unsigned long)mod->module_init+mod->init_text_size;
 	else
 		nextval = (unsigned long)mod->module_core+mod->core_text_size;
@@ -2268,8 +2268,8 @@ const char *module_address_lookup(unsign
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size)
-		    || within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod)) {
 			if (modname)
 				*modname = mod->name;
 			ret = get_ksymbol(mod, addr, size, offset);
@@ -2291,8 +2291,8 @@ int lookup_module_symbol_name(unsigned l
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, NULL, NULL);
@@ -2315,8 +2315,8 @@ int lookup_module_symbol_attrs(unsigned 
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, size, offset);
@@ -2535,7 +2535,7 @@ int is_module_address(unsigned long addr
 	preempt_disable();
 
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_core(addr, mod)) {
 			preempt_enable();
 			return 1;
 		}
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
module-add-within_module_core-and-within_module_init.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
kprobes-add-__kprobes-to-kprobe-internal-functions.patch
kprobes-support-probing-module-__exit-function.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-remove-called_from-argument.patch
kprobes-remove-called_from-argument-fix.patch
module-add-module_state_live-notify.patch
kprobes-support-probing-module-__init-function.patch

