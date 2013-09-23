From: akpm@linux-foundation.org
Subject: + kernel-modulec-use-pr_foo.patch added to -mm tree
Date: Mon, 23 Sep 2013 14:27:15 -0700
Message-ID: <5240b233.dty8UAcwiIb0b6pb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3IWV1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 17:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, joe@perches.com, fhrbata@redhat.com, akpm@linux-foundation.org

Subject: + kernel-modulec-use-pr_foo.patch added to -mm tree
To: akpm@linux-foundation.org,fhrbata@redhat.com,joe@perches.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 14:27:15 -0700


The patch titled
     Subject: kernel/module.c: use pr_foo()
has been added to the -mm tree.  Its filename is
     kernel-modulec-use-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-modulec-use-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-modulec-use-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/module.c: use pr_foo()

kernel/module.c uses a mix of printk(KERN_foo and pr_foo().  Convert it
all to pr_foo and make the offered cleanups.

Not sure what to do about the printk(KERN_DEFAULT).  We don't have a
pr_default().

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Joe Perches <joe@perches.com>
Cc: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |  106 +++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 61 deletions(-)

diff -puN kernel/module.c~kernel-modulec-use-pr_foo kernel/module.c
--- a/kernel/module.c~kernel-modulec-use-pr_foo
+++ a/kernel/module.c
@@ -378,23 +378,21 @@ static bool check_symbol(const struct sy
 		if (syms->licence == GPL_ONLY)
 			return false;
 		if (syms->licence == WILL_BE_GPL_ONLY && fsa->warn) {
-			printk(KERN_WARNING "Symbol %s is being used "
-			       "by a non-GPL module, which will not "
-			       "be allowed in the future\n", fsa->name);
+			pr_warn("Symbol %s is being used by a non-GPL module, "
+				"which will not be allowed in the future\n",
+				fsa->name);
 		}
 	}
 
 #ifdef CONFIG_UNUSED_SYMBOLS
 	if (syms->unused && fsa->warn) {
-		printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
-		       "however this module is using it.\n", fsa->name);
-		printk(KERN_WARNING
-		       "This symbol will go away in the future.\n");
-		printk(KERN_WARNING
-		       "Please evalute if this is the right api to use and if "
-		       "it really is, submit a report the linux kernel "
-		       "mailinglist together with submitting your code for "
-		       "inclusion.\n");
+		pr_warn("Symbol %s is marked as UNUSED, however this module is "
+			"using it.\n", fsa->name);
+		pr_warn("This symbol will go away in the future.\n");
+		pr_warn("Please evalute if this is the right api to use and if "
+			"it really is, submit a report the linux kernel "
+			"mailinglist together with submitting your code for "
+			"inclusion.\n");
 	}
 #endif
 
@@ -492,16 +490,15 @@ static int percpu_modalloc(struct module
 		return 0;
 
 	if (align > PAGE_SIZE) {
-		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
-		       mod->name, align, PAGE_SIZE);
+		pr_warn("%s: per-cpu alignment %li > %li\n",
+			mod->name, align, PAGE_SIZE);
 		align = PAGE_SIZE;
 	}
 
 	mod->percpu = __alloc_reserved_percpu(pcpusec->sh_size, align);
 	if (!mod->percpu) {
-		printk(KERN_WARNING
-		       "%s: Could not allocate %lu bytes percpu data\n",
-		       mod->name, (unsigned long)pcpusec->sh_size);
+		pr_warn("%s: Could not allocate %lu bytes percpu data\n",
+			mod->name, (unsigned long)pcpusec->sh_size);
 		return -ENOMEM;
 	}
 	mod->percpu_size = pcpusec->sh_size;
@@ -679,7 +676,7 @@ static int add_module_usage(struct modul
 	pr_debug("Allocating new usage for %s.\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
-		printk(KERN_WARNING "%s: out of memory loading\n", a->name);
+		pr_warn("%s: out of memory loading\n", a->name);
 		return -ENOMEM;
 	}
 
@@ -1145,8 +1142,7 @@ static int try_to_force_load(struct modu
 {
 #ifdef CONFIG_MODULE_FORCE_LOAD
 	if (!test_taint(TAINT_FORCED_MODULE))
-		printk(KERN_WARNING "%s: %s: kernel tainted.\n",
-		       mod->name, reason);
+		pr_warn("%s: %s: kernel tainted.\n", mod->name, reason);
 	add_taint_module(mod, TAINT_FORCED_MODULE, LOCKDEP_NOW_UNRELIABLE);
 	return 0;
 #else
@@ -1199,8 +1195,7 @@ static int check_version(Elf_Shdr *sechd
 		goto bad_version;
 	}
 
-	printk(KERN_WARNING "%s: no symbol version for %s\n",
-	       mod->name, symname);
+	pr_warn("%s: no symbol version for %s\n", mod->name, symname);
 	return 0;
 
 bad_version:
@@ -1309,8 +1304,8 @@ resolve_symbol_wait(struct module *mod,
 			!IS_ERR(ksym = resolve_symbol(mod, info, name, owner))
 			|| PTR_ERR(ksym) != -EBUSY,
 					     30 * HZ) <= 0) {
-		printk(KERN_WARNING "%s: gave up waiting for init of module %s.\n",
-		       mod->name, owner);
+		pr_warn("%s: gave up waiting for init of module %s.\n",
+			mod->name, owner);
 	}
 	return ksym;
 }
@@ -1626,15 +1621,14 @@ static int mod_sysfs_init(struct module
 	struct kobject *kobj;
 
 	if (!module_sysfs_initialized) {
-		printk(KERN_ERR "%s: module sysfs not initialized\n",
-		       mod->name);
+		pr_err("%s: module sysfs not initialized\n", mod->name);
 		err = -EINVAL;
 		goto out;
 	}
 
 	kobj = kset_find_obj(module_kset, mod->name);
 	if (kobj) {
-		printk(KERN_ERR "%s: module is already loaded\n", mod->name);
+		pr_err("%s: module is already loaded\n", mod->name);
 		kobject_put(kobj);
 		err = -EINVAL;
 		goto out;
@@ -1961,8 +1955,7 @@ static int verify_export_symbols(struct
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
 			if (find_symbol(s->name, &owner, NULL, true, false)) {
-				printk(KERN_ERR
-				       "%s: exports duplicate symbol %s"
+				pr_err("%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
 				       mod->name, s->name, module_name(owner));
 				return -ENOEXEC;
@@ -2013,8 +2006,8 @@ static int simplify_symbols(struct modul
 			if (!ksym && ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;
 
-			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
-			       mod->name, name, PTR_ERR(ksym));
+			pr_warn("%s: Unknown symbol %s (err %li)\n",
+				mod->name, name, PTR_ERR(ksym));
 			ret = PTR_ERR(ksym) ?: -ENOENT;
 			break;
 
@@ -2168,8 +2161,8 @@ static void set_license(struct module *m
 
 	if (!license_is_gpl_compatible(license)) {
 		if (!test_taint(TAINT_PROPRIETARY_MODULE))
-			printk(KERN_WARNING "%s: module license '%s' taints "
-				"kernel.\n", mod->name, license);
+			pr_warn("%s: module license '%s' taints kernel.\n",
+				mod->name, license);
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE,
 				 LOCKDEP_NOW_UNRELIABLE);
 	}
@@ -2405,8 +2398,8 @@ static void dynamic_debug_setup(struct _
 		return;
 #ifdef CONFIG_DYNAMIC_DEBUG
 	if (ddebug_add_module(debug, num, debug->modname))
-		printk(KERN_ERR "dynamic debug error adding module: %s\n",
-					debug->modname);
+		pr_err("dynamic debug error adding module: %s\n",
+			debug->modname);
 #endif
 }
 
@@ -2619,8 +2612,7 @@ static int rewrite_section_headers(struc
 		Elf_Shdr *shdr = &info->sechdrs[i];
 		if (shdr->sh_type != SHT_NOBITS
 		    && info->len < shdr->sh_offset + shdr->sh_size) {
-			printk(KERN_ERR "Module len %lu truncated\n",
-			       info->len);
+			pr_err("Module len %lu truncated\n", info->len);
 			return -ENOEXEC;
 		}
 
@@ -2682,15 +2674,14 @@ static struct module *setup_load_info(st
 
 	info->index.mod = find_sec(info, ".gnu.linkonce.this_module");
 	if (!info->index.mod) {
-		printk(KERN_WARNING "No module found in object\n");
+		pr_warn("No module found in object\n");
 		return ERR_PTR(-ENOEXEC);
 	}
 	/* This is temporary: point mod into copy of data. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
 
 	if (info->index.sym == 0) {
-		printk(KERN_WARNING "%s: module has no symbols (stripped?)\n",
-		       mod->name);
+		pr_warn("%s: module has no symbols (stripped?)\n", mod->name);
 		return ERR_PTR(-ENOEXEC);
 	}
 
@@ -2717,7 +2708,7 @@ static int check_modinfo(struct module *
 		if (err)
 			return err;
 	} else if (!same_magic(modmagic, vermagic, info->index.vers)) {
-		printk(KERN_ERR "%s: version magic '%s' should be '%s'\n",
+		pr_err("%s: version magic '%s' should be '%s'\n",
 		       mod->name, modmagic, vermagic);
 		return -ENOEXEC;
 	}
@@ -2727,9 +2718,8 @@ static int check_modinfo(struct module *
 
 	if (get_modinfo(info, "staging")) {
 		add_taint_module(mod, TAINT_CRAP, LOCKDEP_STILL_OK);
-		printk(KERN_WARNING "%s: module is from the staging directory,"
-		       " the quality is unknown, you have been warned.\n",
-		       mod->name);
+		pr_warn("%s: module is from the staging directory, the quality "
+			"is unknown, you have been warned.\n", mod->name);
 	}
 
 	/* Set up license info based on the info section */
@@ -2776,8 +2766,7 @@ static int find_module_sections(struct m
 		 * This shouldn't happen with same compiler and binutils
 		 * building all parts of the module.
 		 */
-		printk(KERN_WARNING "%s: has both .ctors and .init_array.\n",
-		       mod->name);
+		pr_warn("%s: has both .ctors and .init_array.\n", mod->name);
 		return -EINVAL;
 	}
 #endif
@@ -2813,8 +2802,7 @@ static int find_module_sections(struct m
 				    sizeof(*mod->extable), &mod->num_exentries);
 
 	if (section_addr(info, "__obsparm"))
-		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
-		       mod->name);
+		pr_warn("%s: Ignoring obsolete parameters\n", mod->name);
 
 	info->debug = section_objs(info, "__verbose",
 				   sizeof(*info->debug), &info->num_debug);
@@ -3092,11 +3080,10 @@ static int do_init_module(struct module
 		return ret;
 	}
 	if (ret > 0) {
-		printk(KERN_WARNING
-"%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n"
-"%s: loading module anyway...\n",
-		       __func__, mod->name, ret,
-		       __func__);
+		pr_warn("%s: '%s'->init suspiciously returned %d, it should "
+			"follow 0/-E convention\n"
+			"%s: loading module anyway...\n",
+			__func__, mod->name, ret, __func__);
 		dump_stack();
 	}
 
@@ -3219,10 +3206,8 @@ static int unknown_module_param_cb(char
 {
 	/* Check for magic 'dyndbg' arg */ 
 	int ret = ddebug_dyndbg_module_param_cb(param, val, modname);
-	if (ret != 0) {
-		printk(KERN_WARNING "%s: unknown parameter '%s' ignored\n",
-		       modname, param);
-	}
+	if (ret != 0)
+		pr_warn("%s: unknown parameter '%s' ignored\n", modname, param);
 	return 0;
 }
 
@@ -3257,10 +3242,9 @@ static int load_module(struct load_info
 #ifdef CONFIG_MODULE_SIG
 	mod->sig_ok = info->sig_ok;
 	if (!mod->sig_ok) {
-		printk_once(KERN_NOTICE
-			    "%s: module verification failed: signature and/or"
-			    " required key missing - tainting kernel\n",
-			    mod->name);
+		pr_notice_once("%s: module verification failed: signature "
+			       "and/or  required key missing - tainting "
+			       "kernel\n", mod->name);
 		add_taint_module(mod, TAINT_FORCED_MODULE, LOCKDEP_STILL_OK);
 	}
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

