Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003564C7D
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605746; cv=none; b=HGFnvN8Ta7kG0wkazjHLEb1YGoLVNcSlzuMizYYbtONBxyz1nLYQwiEIP3+JIY/1PZ4RZQQ9e1dDedsmPUnFLu/DvwQ+1xjFlL8INLFTpa33/QfRs9cgEXHFbSuf5JDCBgViydmWMbuDfjtcM1WXYk2oK3dRwNmLqb8Fvcgo4Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605746; c=relaxed/simple;
	bh=bv/tn9KGDEt9gwFMGfvcWejx/9DoUJOXa06VUAYZlb4=;
	h=Date:To:From:Subject:Message-Id; b=UoVEgo7nyn93SxSxVeS7ObFihbrv46eGY8ELaBTKRfmM6hZavJ2tjUsACXlF57mU0t6Ut1pZL6nZUTpnMOq0AlyRkiJod41hOtgSrVNSYqvJUu3/DOAQj1hmCYKyr4VBFVu2dT3A3EB1pqA9Gd0cYjAod9z23f6uUoPmmd660c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8DbUCr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8DbUCr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67D2C4CED0;
	Tue, 31 Dec 2024 00:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605745;
	bh=bv/tn9KGDEt9gwFMGfvcWejx/9DoUJOXa06VUAYZlb4=;
	h=Date:To:From:Subject:From;
	b=N8DbUCr9V8oGGyfB1ZOcWZq8myjB6MOKBHkgNrJ2lLzv39NxnBKzW3BRDkUoWOl/l
	 yUiXot9Kd9gzch7MHdVn9FZSaFM9Wxob4GW1JAv+rboPoeQ4GxbIm/yqttU628yDp5
	 IwS8RV8BKGyuCrmQ71kS+nPGFCg3Fyow8VRFdj/s=
Date: Mon, 30 Dec 2024 16:42:25 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,song@kernel.org,shuah@kernel.org,samitolvanen@google.com,rostedt@goodmis.org,rmoar@google.com,richard@nod.at,pmladek@suse.com,petr.pavlu@suse.com,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mbenes@suse.cz,mark.rutland@arm.com,luto@kernel.org,kirill.shutemov@linux.intel.com,jpoimboe@kernel.org,johannes@sipsolutions.net,joe.lawrence@redhat.com,jikos@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,dianders@chromium.org,davidgow@google.com,dave.hansen@linux.intel.com,danielt@kernel.org,da.gomez@samsung.com,brendan.higgins@linux.dev,bp@alien8.de,anton.ivanov@cambridgegreys.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-introduce-module_state_gone.patch added to mm-unstable branch
Message-Id: <20241231004225.B67D2C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: introduce MODULE_STATE_GONE
has been added to the -mm mm-unstable branch.  Its filename is
     module-introduce-module_state_gone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-introduce-module_state_gone.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: module: introduce MODULE_STATE_GONE
Date: Fri, 27 Dec 2024 09:28:22 +0200

In order to use execmem's API for temporal remapping of the memory
allocated from ROX cache as writable, there is a need to distinguish
between the state when the module is being formed and the state when it is
deconstructed and freed so that when module_memory_free() is called from
error paths during module loading it could restore ROX mappings.

Replace open coded checks for MODULE_STATE_UNFORMED with a helper function
module_is_formed() and add a new MODULE_STATE_GONE that will be set when
the module is deconstructed and freed.

Link: https://lkml.kernel.org/r/20241227072825.1288491-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Daniel Thompson <danielt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h                                                    |    6 +++
 kernel/module/kallsyms.c                                                  |    8 ++--
 kernel/module/kdb.c                                                       |    2 -
 kernel/module/main.c                                                      |   19 ++++------
 kernel/module/procfs.c                                                    |    2 -
 kernel/tracepoint.c                                                       |    2 +
 lib/kunit/test.c                                                          |    2 +
 samples/livepatch/livepatch-callbacks-demo.c                              |    1 
 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c  |    1 
 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c |    1 
 tools/testing/selftests/livepatch/test_modules/test_klp_state.c           |    1 
 tools/testing/selftests/livepatch/test_modules/test_klp_state2.c          |    1 
 12 files changed, 30 insertions(+), 16 deletions(-)

--- a/include/linux/module.h~module-introduce-module_state_gone
+++ a/include/linux/module.h
@@ -320,6 +320,7 @@ enum module_state {
 	MODULE_STATE_COMING,	/* Full formed, running module_init. */
 	MODULE_STATE_GOING,	/* Going away. */
 	MODULE_STATE_UNFORMED,	/* Still setting it up. */
+	MODULE_STATE_GONE,	/* Deconstructing and freeing. */
 };
 
 struct mod_tree_node {
@@ -620,6 +621,11 @@ static inline bool module_is_coming(stru
         return mod->state == MODULE_STATE_COMING;
 }
 
+static inline bool module_is_formed(struct module *mod)
+{
+	return mod->state < MODULE_STATE_UNFORMED;
+}
+
 struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
--- a/kernel/module/kallsyms.c~module-introduce-module_state_gone
+++ a/kernel/module/kallsyms.c
@@ -361,7 +361,7 @@ int lookup_module_symbol_name(unsigned l
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 		if (within_module(addr, mod)) {
 			const char *sym;
@@ -389,7 +389,7 @@ int module_get_kallsym(unsigned int symn
 	list_for_each_entry_rcu(mod, &modules, list) {
 		struct mod_kallsyms *kallsyms;
 
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 		kallsyms = rcu_dereference_sched(mod->kallsyms);
 		if (symnum < kallsyms->num_symtab) {
@@ -441,7 +441,7 @@ static unsigned long __module_kallsyms_l
 	list_for_each_entry_rcu(mod, &modules, list) {
 		unsigned long ret;
 
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 		ret = __find_kallsyms_symbol_value(mod, name);
 		if (ret)
@@ -484,7 +484,7 @@ int module_kallsyms_on_each_symbol(const
 	list_for_each_entry(mod, &modules, list) {
 		struct mod_kallsyms *kallsyms;
 
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 
 		if (modname && strcmp(modname, mod->name))
--- a/kernel/module/kdb.c~module-introduce-module_state_gone
+++ a/kernel/module/kdb.c
@@ -23,7 +23,7 @@ int kdb_lsmod(int argc, const char **arg
 
 	kdb_printf("Module                  Size  modstruct     Used by\n");
 	list_for_each_entry(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 
 		kdb_printf("%-20s%8u", mod->name, mod->mem[MOD_TEXT].size);
--- a/kernel/module/main.c~module-introduce-module_state_gone
+++ a/kernel/module/main.c
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(unregister_module_notifier
  */
 static inline int strong_try_module_get(struct module *mod)
 {
-	BUG_ON(mod && mod->state == MODULE_STATE_UNFORMED);
+	BUG_ON(mod && !module_is_formed(mod));
 	if (mod && mod->state == MODULE_STATE_COMING)
 		return -EBUSY;
 	if (try_module_get(mod))
@@ -361,7 +361,7 @@ bool find_symbol(struct find_symbol_arg
 			  GPL_ONLY },
 		};
 
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 
 		for (i = 0; i < ARRAY_SIZE(arr); i++)
@@ -386,7 +386,7 @@ struct module *find_module_all(const cha
 
 	list_for_each_entry_rcu(mod, &modules, list,
 				lockdep_is_held(&module_mutex)) {
-		if (!even_unformed && mod->state == MODULE_STATE_UNFORMED)
+		if (!even_unformed && !module_is_formed(mod))
 			continue;
 		if (strlen(mod->name) == len && !memcmp(mod->name, name, len))
 			return mod;
@@ -457,7 +457,7 @@ bool __is_module_percpu_address(unsigned
 	preempt_disable();
 
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 		if (!mod->percpu_size)
 			continue;
@@ -1326,7 +1326,7 @@ static void free_module(struct module *m
 	 * that noone uses it while it's being deconstructed.
 	 */
 	mutex_lock(&module_mutex);
-	mod->state = MODULE_STATE_UNFORMED;
+	mod->state = MODULE_STATE_GONE;
 	mutex_unlock(&module_mutex);
 
 	/* Arch-specific cleanup. */
@@ -3048,8 +3048,7 @@ static int module_patient_check_exists(c
 	if (old == NULL)
 		return 0;
 
-	if (old->state == MODULE_STATE_COMING ||
-	    old->state == MODULE_STATE_UNFORMED) {
+	if (old->state == MODULE_STATE_COMING || !module_is_formed(old)) {
 		/* Wait in case it fails to load. */
 		mutex_unlock(&module_mutex);
 		err = wait_event_interruptible(module_wq,
@@ -3608,7 +3607,7 @@ char *module_flags(struct module *mod, c
 {
 	int bx = 0;
 
-	BUG_ON(mod->state == MODULE_STATE_UNFORMED);
+	BUG_ON(!module_is_formed(mod));
 	if (!mod->taints && !show_state)
 		goto out;
 	if (mod->taints ||
@@ -3702,7 +3701,7 @@ lookup:
 	mod = mod_find(addr, &mod_tree);
 	if (mod) {
 		BUG_ON(!within_module(addr, mod));
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			mod = NULL;
 	}
 	return mod;
@@ -3756,7 +3755,7 @@ void print_modules(void)
 	/* Most callers should already have preempt disabled, but make sure */
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (!module_is_formed(mod))
 			continue;
 		pr_cont(" %s%s", mod->name, module_flags(mod, buf, true));
 	}
--- a/kernel/module/procfs.c~module-introduce-module_state_gone
+++ a/kernel/module/procfs.c
@@ -79,7 +79,7 @@ static int m_show(struct seq_file *m, vo
 	unsigned int size;
 
 	/* We always ignore unformed modules. */
-	if (mod->state == MODULE_STATE_UNFORMED)
+	if (!module_is_formed(mod))
 		return 0;
 
 	size = module_total_size(mod);
--- a/kernel/tracepoint.c~module-introduce-module_state_gone
+++ a/kernel/tracepoint.c
@@ -668,6 +668,8 @@ static int tracepoint_module_notify(stru
 		break;
 	case MODULE_STATE_UNFORMED:
 		break;
+	case MODULE_STATE_GONE:
+		break;
 	}
 	return notifier_from_errno(ret);
 }
--- a/lib/kunit/test.c~module-introduce-module_state_gone
+++ a/lib/kunit/test.c
@@ -836,6 +836,8 @@ static int kunit_module_notify(struct no
 		break;
 	case MODULE_STATE_UNFORMED:
 		break;
+	case MODULE_STATE_GONE:
+		break;
 	}
 
 	return 0;
--- a/samples/livepatch/livepatch-callbacks-demo.c~module-introduce-module_state_gone
+++ a/samples/livepatch/livepatch-callbacks-demo.c
@@ -93,6 +93,7 @@ static const char *const module_state[]
 	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
 	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
 	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
+	[MODULE_STATE_GONE]	= "[MODULE_STATE_GONE] Deconstructing and freeing",
 };
 
 static void callback_info(const char *callback, struct klp_object *obj)
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c~module-introduce-module_state_gone
+++ a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
@@ -16,6 +16,7 @@ static const char *const module_state[]
 	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
 	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
 	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
+	[MODULE_STATE_GONE]	= "[MODULE_STATE_GONE] Deconstructing and freeing",
 };
 
 static void callback_info(const char *callback, struct klp_object *obj)
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c~module-introduce-module_state_gone
+++ a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
@@ -16,6 +16,7 @@ static const char *const module_state[]
 	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
 	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
 	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
+	[MODULE_STATE_GONE]	= "[MODULE_STATE_GONE] Deconstructing and freeing",
 };
 
 static void callback_info(const char *callback, struct klp_object *obj)
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c~module-introduce-module_state_gone
+++ a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
@@ -18,6 +18,7 @@ static const char *const module_state[]
 	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
 	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
 	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
+	[MODULE_STATE_GONE]	= "[MODULE_STATE_GONE] Deconstructing and freeing",
 };
 
 static void callback_info(const char *callback, struct klp_object *obj)
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c~module-introduce-module_state_gone
+++ a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
@@ -18,6 +18,7 @@ static const char *const module_state[]
 	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
 	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
 	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
+	[MODULE_STATE_GONE]	= "[MODULE_STATE_GONE] Deconstructing and freeing",
 };
 
 static void callback_info(const char *callback, struct klp_object *obj)
_

Patches currently in -mm which might be from rppt@kernel.org are

x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch
x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch
execmem-add-api-for-temporal-remapping-as-rw-and-restoring-rox-afterwards.patch
module-introduce-module_state_gone.patch
modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch
revert-x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
module-drop-unused-module_writable_address.patch

