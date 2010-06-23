From: akpm@linux-foundation.org
Subject: + revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch added to -mm tree
Date: Wed, 23 Jun 2010 15:26:15 -0700
Message-ID: <201006232255.o5NMt3Vf004222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab0FWWzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 18:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au


The patch titled
     revert ed5aa19b93da2c094b6647762774a8022e4e1d6c
has been added to the -mm tree.  Its filename is
     revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch

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
Subject: revert ed5aa19b93da2c094b6647762774a8022e4e1d6c
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN kernel/module.c~revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c kernel/module.c
--- a/kernel/module.c~revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c
+++ a/kernel/module.c
@@ -1,6 +1,6 @@
 /*
    Copyright (C) 2002 Richard Henderson
-   Copyright (C) 2001 Rusty Russell, 2002, 2010 Rusty Russell IBM.
+   Copyright (C) 2001 Rusty Russell, 2002 Rusty Russell IBM.
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -2520,14 +2520,12 @@ static void module_deallocate(struct mod
 
 static int post_relocation(struct module *mod, const struct load_info *info)
 {
-	/* Sort exception table now relocations are done. */
 	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
 	/* Copy relocated percpu area over. */
 	percpu_modcopy(mod, (void *)info->sechdrs[info->index.pcpu].sh_addr,
 		       info->sechdrs[info->index.pcpu].sh_size);
 
-	/* Setup kallsyms-specific fields. */
 	add_kallsyms(mod, info);
 
 	/* Arch-specific module finalizing. */
@@ -2536,7 +2534,7 @@ static int post_relocation(struct module
 
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
-static struct module *load_module(void __user *umod,
+static noinline struct module *load_module(void __user *umod,
 				  unsigned long len,
 				  const char __user *uargs)
 {
@@ -2597,7 +2595,6 @@ static struct module *load_module(void _
 		goto free_arch_cleanup;
 	}
 
-	/* Mark state as coming so strong_try_module_get() ignores us. */
 	mod->state = MODULE_STATE_COMING;
 
 	/* Now sew it into the lists so we can get lockdep and oops
@@ -2625,12 +2622,10 @@ static struct module *load_module(void _
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
 
-	/* Module is ready to execute: parsing args may do that. */
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
 	if (err < 0)
 		goto unlink;
 
-	/* Link in to syfs. */
 	err = mod_sysfs_setup(mod, &info, mod->kp, mod->num_kp);
 	if (err < 0)
 		goto unlink;
@@ -2639,8 +2634,9 @@ static struct module *load_module(void _
 	kfree(info.strmap);
 	free_copy(&info);
 
-	/* Done! */
 	trace_module_load(mod);
+
+	/* Done! */
 	return mod;
 
  unlink:
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

