From: akpm@linux-foundation.org
Subject: + modules-remove-modlist_lock.patch added to -mm tree
Date: Thu, 05 Jul 2007 11:21:14 -0700
Message-ID: <200707051821.l65ILEvj011287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387AbXGESWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 14:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, mingo@elte.hu, tobiasoed@hotmail.com


The patch titled
     modules: remove modlist_lock
has been added to the -mm tree.  Its filename is
     modules-remove-modlist_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: modules: remove modlist_lock
From: Rusty Russell <rusty@rustcorp.com.au>

Now we always use stop_machine for module insertion or deletion, we no
longer need the modlist_lock: merely disabling preemption is sufficient to
block against list manipulation.  This avoids deadlock on OOPSen where we
can potentially grab the lock twice.

Bug: 8695
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tobias Oed <tobiasoed@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff -puN kernel/module.c~modules-remove-modlist_lock kernel/module.c
--- a/kernel/module.c~modules-remove-modlist_lock
+++ a/kernel/module.c
@@ -61,10 +61,8 @@ extern int module_sysfs_initialized;
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
-/* Protects module list */
-static DEFINE_SPINLOCK(modlist_lock);
-
-/* List of modules, protected by module_mutex AND modlist_lock */
+/* List of modules, protected by module_mutex or preempt_disable
+ * (add/delete uses stop_machine). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
 static DECLARE_MUTEX(notify_mutex);
@@ -772,14 +770,13 @@ static void print_unload_info(struct seq
 void __symbol_put(const char *symbol)
 {
 	struct module *owner;
-	unsigned long flags;
 	const unsigned long *crc;
 
-	spin_lock_irqsave(&modlist_lock, flags);
+	preempt_disable();
 	if (!__find_symbol(symbol, &owner, &crc, 1))
 		BUG();
 	module_put(owner);
-	spin_unlock_irqrestore(&modlist_lock, flags);
+	preempt_enable();
 }
 EXPORT_SYMBOL(__symbol_put);
 
@@ -1248,14 +1245,14 @@ static void free_module(struct module *m
 void *__symbol_get(const char *symbol)
 {
 	struct module *owner;
-	unsigned long value, flags;
+	unsigned long value;
 	const unsigned long *crc;
 
-	spin_lock_irqsave(&modlist_lock, flags);
+	preempt_disable();
 	value = __find_symbol(symbol, &owner, &crc, 1);
 	if (value && !strong_try_module_get(owner))
 		value = 0;
-	spin_unlock_irqrestore(&modlist_lock, flags);
+	preempt_enable();
 
 	return (void *)value;
 }
@@ -2368,11 +2365,10 @@ const struct seq_operations modules_op =
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
 {
-	unsigned long flags;
 	const struct exception_table_entry *e = NULL;
 	struct module *mod;
 
-	spin_lock_irqsave(&modlist_lock, flags);
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (mod->num_exentries == 0)
 			continue;
@@ -2383,7 +2379,7 @@ const struct exception_table_entry *sear
 		if (e)
 			break;
 	}
-	spin_unlock_irqrestore(&modlist_lock, flags);
+	preempt_enable();
 
 	/* Now, if we found one, we are running inside it now, hence
            we cannot unload the module, hence no refcnt needed. */
@@ -2395,25 +2391,24 @@ const struct exception_table_entry *sear
  */
 int is_module_address(unsigned long addr)
 {
-	unsigned long flags;
 	struct module *mod;
 
-	spin_lock_irqsave(&modlist_lock, flags);
+	preempt_disable();
 
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_core, mod->core_size)) {
-			spin_unlock_irqrestore(&modlist_lock, flags);
+			preempt_enable();
 			return 1;
 		}
 	}
 
-	spin_unlock_irqrestore(&modlist_lock, flags);
+	preempt_enable();
 
 	return 0;
 }
 
 
-/* Is this a valid kernel address?  We don't grab the lock: we are oopsing. */
+/* Is this a valid kernel address? */
 struct module *__module_text_address(unsigned long addr)
 {
 	struct module *mod;
@@ -2428,11 +2423,10 @@ struct module *__module_text_address(uns
 struct module *module_text_address(unsigned long addr)
 {
 	struct module *mod;
-	unsigned long flags;
 
-	spin_lock_irqsave(&modlist_lock, flags);
+	preempt_disable();
 	mod = __module_text_address(addr);
-	spin_unlock_irqrestore(&modlist_lock, flags);
+	preempt_enable();
 
 	return mod;
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
modules-remove-modlist_lock.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
fix-lguest-w-lockdep.patch
lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
readahead-split-ondemand-readahead-interface-into-two-functions.patch
readahead-sanify-file_ra_state-names.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
