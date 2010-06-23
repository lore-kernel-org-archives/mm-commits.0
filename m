From: akpm@linux-foundation.org
Subject: + revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch added to -mm tree
Date: Wed, 23 Jun 2010 15:26:20 -0700
Message-ID: <201006232255.o5NMt6Ym004240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FWWzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 18:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au


The patch titled
     revert d04ab5241f301bdcad2f6beb0ecd326bd82100a7
has been added to the -mm tree.  Its filename is
     revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch

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
Subject: revert d04ab5241f301bdcad2f6beb0ecd326bd82100a7
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   77 +++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 34 deletions(-)

diff -puN kernel/module.c~revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7 kernel/module.c
--- a/kernel/module.c~revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7
+++ a/kernel/module.c
@@ -1127,9 +1127,8 @@ static const struct kernel_symbol *resol
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
  */
-#ifdef CONFIG_SYSFS
+#if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
 
-#ifdef CONFIG_KALLSYMS
 static inline bool sect_empty(const Elf_Shdr *sect)
 {
 	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
@@ -1166,7 +1165,8 @@ static void free_sect_attrs(struct modul
 	kfree(sect_attrs);
 }
 
-static void add_sect_attrs(struct module *mod, const struct load_info *info)
+static void add_sect_attrs(struct module *mod, unsigned int nsect,
+		char *secstrings, Elf_Shdr *sechdrs)
 {
 	unsigned int nloaded = 0, i, size[2];
 	struct module_sect_attrs *sect_attrs;
@@ -1174,8 +1174,8 @@ static void add_sect_attrs(struct module
 	struct attribute **gattr;
 
 	/* Count loaded sections and allocate structures */
-	for (i = 0; i < info->hdr->e_shnum; i++)
-		if (!sect_empty(&info->sechdrs[i]))
+	for (i = 0; i < nsect; i++)
+		if (!sect_empty(&sechdrs[i]))
 			nloaded++;
 	size[0] = ALIGN(sizeof(*sect_attrs)
 			+ nloaded * sizeof(sect_attrs->attrs[0]),
@@ -1192,12 +1192,11 @@ static void add_sect_attrs(struct module
 	sect_attrs->nsections = 0;
 	sattr = &sect_attrs->attrs[0];
 	gattr = &sect_attrs->grp.attrs[0];
-	for (i = 0; i < info->hdr->e_shnum; i++) {
-		Elf_Shdr *sec = &info->sechdrs[i];
-		if (sect_empty(sec))
+	for (i = 0; i < nsect; i++) {
+		if (sect_empty(&sechdrs[i]))
 			continue;
-		sattr->address = sec->sh_addr;
-		sattr->name = kstrdup(info->secstrings + sec->sh_name,
+		sattr->address = sechdrs[i].sh_addr;
+		sattr->name = kstrdup(secstrings + sechdrs[i].sh_name,
 					GFP_KERNEL);
 		if (sattr->name == NULL)
 			goto out;
@@ -1265,7 +1264,8 @@ static void free_notes_attrs(struct modu
 	kfree(notes_attrs);
 }
 
-static void add_notes_attrs(struct module *mod, const struct load_info *info)
+static void add_notes_attrs(struct module *mod, unsigned int nsect,
+			    char *secstrings, Elf_Shdr *sechdrs)
 {
 	unsigned int notes, loaded, i;
 	struct module_notes_attrs *notes_attrs;
@@ -1277,9 +1277,9 @@ static void add_notes_attrs(struct modul
 
 	/* Count notes sections and allocate structures.  */
 	notes = 0;
-	for (i = 0; i < info->hdr->e_shnum; i++)
-		if (!sect_empty(&info->sechdrs[i]) &&
-		    (info->sechdrs[i].sh_type == SHT_NOTE))
+	for (i = 0; i < nsect; i++)
+		if (!sect_empty(&sechdrs[i]) &&
+		    (sechdrs[i].sh_type == SHT_NOTE))
 			++notes;
 
 	if (notes == 0)
@@ -1293,15 +1293,15 @@ static void add_notes_attrs(struct modul
 
 	notes_attrs->notes = notes;
 	nattr = &notes_attrs->attrs[0];
-	for (loaded = i = 0; i < info->hdr->e_shnum; ++i) {
-		if (sect_empty(&info->sechdrs[i]))
+	for (loaded = i = 0; i < nsect; ++i) {
+		if (sect_empty(&sechdrs[i]))
 			continue;
-		if (info->sechdrs[i].sh_type == SHT_NOTE) {
+		if (sechdrs[i].sh_type == SHT_NOTE) {
 			sysfs_bin_attr_init(nattr);
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
 			nattr->attr.mode = S_IRUGO;
-			nattr->size = info->sechdrs[i].sh_size;
-			nattr->private = (void *) info->sechdrs[i].sh_addr;
+			nattr->size = sechdrs[i].sh_size;
+			nattr->private = (void *) sechdrs[i].sh_addr;
 			nattr->read = module_notes_read;
 			++nattr;
 		}
@@ -1332,8 +1332,8 @@ static void remove_notes_attrs(struct mo
 
 #else
 
-static inline void add_sect_attrs(struct module *mod,
-				  const struct load_info *info)
+static inline void add_sect_attrs(struct module *mod, unsigned int nsect,
+		char *sectstrings, Elf_Shdr *sechdrs)
 {
 }
 
@@ -1341,16 +1341,17 @@ static inline void remove_sect_attrs(str
 {
 }
 
-static inline void add_notes_attrs(struct module *mod,
-				   const struct load_info *info)
+static inline void add_notes_attrs(struct module *mod, unsigned int nsect,
+				   char *sectstrings, Elf_Shdr *sechdrs)
 {
 }
 
 static inline void remove_notes_attrs(struct module *mod)
 {
 }
-#endif /* CONFIG_KALLSYMS */
+#endif
 
+#ifdef CONFIG_SYSFS
 static void add_usage_links(struct module *mod)
 {
 #ifdef CONFIG_MODULE_UNLOAD
@@ -1455,7 +1456,6 @@ out:
 }
 
 static int mod_sysfs_setup(struct module *mod,
-			   const struct load_info *info,
 			   struct kernel_param *kparam,
 			   unsigned int num_params)
 {
@@ -1480,8 +1480,6 @@ static int mod_sysfs_setup(struct module
 		goto out_unreg_param;
 
 	add_usage_links(mod);
-	add_sect_attrs(mod, info);
-	add_notes_attrs(mod, info);
 
 	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
 	return 0;
@@ -1498,26 +1496,32 @@ out:
 
 static void mod_sysfs_fini(struct module *mod)
 {
-	remove_notes_attrs(mod);
-	remove_sect_attrs(mod);
 	kobject_put(&mod->mkobj.kobj);
 }
 
-#else /* !CONFIG_SYSFS */
+#else /* CONFIG_SYSFS */
 
-static int mod_sysfs_init(struct module *mod)
+static inline int mod_sysfs_init(struct module *mod)
 {
 	return 0;
 }
 
-static int mod_sysfs_setup(struct module *mod,
-			   const struct load_info *info,
+static inline int mod_sysfs_setup(struct module *mod,
 			   struct kernel_param *kparam,
 			   unsigned int num_params)
 {
 	return 0;
 }
 
+static inline int module_add_modinfo_attrs(struct module *mod)
+{
+	return 0;
+}
+
+static inline void module_remove_modinfo_attrs(struct module *mod)
+{
+}
+
 static void mod_sysfs_fini(struct module *mod)
 {
 }
@@ -1558,6 +1562,8 @@ static void free_module(struct module *m
 	mutex_lock(&module_mutex);
 	stop_machine(__unlink_module, mod, NULL);
 	mutex_unlock(&module_mutex);
+	remove_notes_attrs(mod);
+	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
 	/* Arch-specific cleanup. */
@@ -2682,10 +2688,13 @@ static noinline struct module *load_modu
 	if (err < 0)
 		goto unlink;
 
-	err = mod_sysfs_setup(mod, &info, mod->kp, mod->num_kp);
+	err = mod_sysfs_setup(mod, mod->kp, mod->num_kp);
 	if (err < 0)
 		goto unlink;
 
+	add_sect_attrs(mod, info.hdr->e_shnum, info.secstrings, info.sechdrs);
+	add_notes_attrs(mod, info.hdr->e_shnum, info.secstrings, info.sechdrs);
+
 	/* Get rid of temporary copy and strmap. */
 	kfree(info.strmap);
 	free_copy(&info);
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

