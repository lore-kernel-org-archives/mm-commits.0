From: akpm@linux-foundation.org
Subject: + revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch added to -mm tree
Date: Wed, 23 Jun 2010 15:26:19 -0700
Message-ID: <201006232255.o5NMt5qR004228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727Ab0FWWzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 18:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au


The patch titled
     revert 9652e31db6d841e291531547b3f4f12b5aeb42a9
has been added to the -mm tree.  Its filename is
     revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch

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
Subject: revert 9652e31db6d841e291531547b3f4f12b5aeb42a9
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   56 +++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

diff -puN kernel/module.c~revert-9652e31db6d841e291531547b3f4f12b5aeb42a9 kernel/module.c
--- a/kernel/module.c~revert-9652e31db6d841e291531547b3f4f12b5aeb42a9
+++ a/kernel/module.c
@@ -117,8 +117,6 @@ struct load_info {
 	char *secstrings, *strtab;
 	unsigned long *strmap;
 	unsigned long symoffs, stroffs;
-	struct _ddebug *debug;
-	unsigned int num_debug;
 	struct {
 		unsigned int sym, str, mod, vers, info, pcpu;
 	} index;
@@ -1993,7 +1991,7 @@ static void layout_symtab(struct module 
 	mod->core_size += bitmap_weight(info->strmap, strsect->sh_size);
 }
 
-static void add_kallsyms(struct module *mod, const struct load_info *info)
+static void add_kallsyms(struct module *mod, struct load_info *info)
 {
 	unsigned int i, ndst;
 	const Elf_Sym *src;
@@ -2039,8 +2037,6 @@ static void add_kallsyms(struct module *
 
 static void dynamic_debug_setup(struct _ddebug *debug, unsigned int num)
 {
-	if (!debug)
-		return;
 #ifdef CONFIG_DYNAMIC_DEBUG
 	if (ddebug_add_module(debug, num, debug->modname))
 		printk(KERN_ERR "dynamic debug error adding module: %s\n",
@@ -2268,7 +2264,8 @@ static int check_modinfo(struct module *
 	return 0;
 }
 
-static void find_module_sections(struct module *mod, struct load_info *info)
+static void find_module_sections(struct module *mod,
+				 const struct load_info *info)
 {
 	mod->kp = section_objs(info, "__param",
 			       sizeof(*mod->kp), &mod->num_kp);
@@ -2323,15 +2320,9 @@ static void find_module_sections(struct 
 					     &mod->num_ftrace_callsites);
 #endif
 
-	mod->extable = section_objs(info, "__ex_table",
-				    sizeof(*mod->extable), &mod->num_exentries);
-
 	if (section_addr(info, "__obsparm"))
 		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
 		       mod->name);
-
-	info->debug = section_objs(info, "__verbose",
-				   sizeof(*info->debug), &info->num_debug);
 }
 
 static int move_module(struct module *mod, struct load_info *info)
@@ -2518,20 +2509,6 @@ static void module_deallocate(struct mod
 	module_free(mod, mod->module_core);
 }
 
-static int post_relocation(struct module *mod, const struct load_info *info)
-{
-	sort_extable(mod->extable, mod->extable + mod->num_exentries);
-
-	/* Copy relocated percpu area over. */
-	percpu_modcopy(mod, (void *)info->sechdrs[info->index.pcpu].sh_addr,
-		       info->sechdrs[info->index.pcpu].sh_size);
-
-	add_kallsyms(mod, info);
-
-	/* Arch-specific module finalizing. */
-	return module_finalize(info->hdr, info->sechdrs, mod);
-}
-
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2541,6 +2518,8 @@ static noinline struct module *load_modu
 	struct load_info info = { NULL, };
 	struct module *mod;
 	long err;
+	struct _ddebug *debug = NULL;
+	unsigned int num_debug = 0;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
@@ -2582,7 +2561,22 @@ static noinline struct module *load_modu
 	if (err < 0)
 		goto free_modinfo;
 
-	err = post_relocation(mod, &info);
+  	/* Set up and sort exception table */
+	mod->extable = section_objs(&info, "__ex_table",
+				    sizeof(*mod->extable), &mod->num_exentries);
+	sort_extable(mod->extable, mod->extable + mod->num_exentries);
+
+	/* Finally, copy percpu area over. */
+	percpu_modcopy(mod, (void *)info.sechdrs[info.index.pcpu].sh_addr,
+		       info.sechdrs[info.index.pcpu].sh_size);
+
+	add_kallsyms(mod, &info);
+
+	if (!mod->taints)
+		debug = section_objs(&info, "__verbose",
+				     sizeof(*debug), &num_debug);
+
+	err = module_finalize(info.hdr, info.sechdrs, mod);
 	if (err < 0)
 		goto free_modinfo;
 
@@ -2610,9 +2604,8 @@ static noinline struct module *load_modu
 		goto unlock;
 	}
 
-	/* This has to be done once we're sure module name is unique. */
-	if (!mod->taints)
-		dynamic_debug_setup(info.debug, info.num_debug);
+	if (debug)
+		dynamic_debug_setup(debug, num_debug);
 
 	/* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2644,8 +2637,7 @@ static noinline struct module *load_modu
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
  ddebug:
-	if (!mod->taints)
-		dynamic_debug_remove(info.debug);
+	dynamic_debug_remove(debug);
  unlock:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
drivers-gpio-is-platform-neutral-fix.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation-fix.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
acpi-fix-bogus-preemption-logic-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

