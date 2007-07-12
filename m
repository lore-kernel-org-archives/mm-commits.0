From: akpm@linux-foundation.org
Subject: + kallsyms-make-ksym_name_len-include-space-for-trailing-0.patch added to -mm tree
Date: Thu, 12 Jul 2007 13:55:39 -0700
Message-ID: <200707122055.l6CKtek9002029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757564AbXGLU4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 16:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, benh@kernel.crashing.org, paulus@samba.org, pmarques@grupopie.com


The patch titled
     kallsyms: make KSYM_NAME_LEN include space for trailing '\0'
has been added to the -mm tree.  Its filename is
     kallsyms-make-ksym_name_len-include-space-for-trailing-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kallsyms: make KSYM_NAME_LEN include space for trailing '\0'
From: Tejun Heo <htejun@gmail.com>

KSYM_NAME_LEN is peculiar in that it does not include the space for the
trailing '\0', forcing all users to use KSYM_NAME_LEN + 1 when allocating
buffer.  This is nonsense and error-prone.  Moreover, when the caller
forgets that it's very likely to subtly bite back by corrupting the stack
because the last position of the buffer is always cleared to zero.

This patch increments KSYM_NAME_LEN by one and updates code accordingly.

* off-by-one bug in asm-powerpc/kprobes.h::kprobe_lookup_name() macro
  is fixed.

* Where MODULE_NAME_LEN and KSYM_NAME_LEN were used together,
  MODULE_NAME_LEN was treated as if it didn't include space for the
  trailing '\0'.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Paulo Marques <pmarques@grupopie.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/unwind.c   |    2 +-
 fs/proc/base.c                |    2 +-
 include/asm-powerpc/kprobes.h |    4 ++--
 include/linux/kallsyms.h      |    6 +++---
 kernel/kallsyms.c             |   16 ++++++++--------
 kernel/lockdep.c              |    4 ++--
 kernel/module.c               |   10 +++++-----
 kernel/time/timer_list.c      |    2 +-
 kernel/time/timer_stats.c     |    2 +-
 mm/slab.c                     |    2 +-
 scripts/kallsyms.c            |    4 ++--
 11 files changed, 27 insertions(+), 27 deletions(-)

diff -puN arch/parisc/kernel/unwind.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 arch/parisc/kernel/unwind.c
--- a/arch/parisc/kernel/unwind.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/arch/parisc/kernel/unwind.c
@@ -242,7 +242,7 @@ static void unwind_frame_regs(struct unw
 #ifdef CONFIG_KALLSYMS
 		/* Handle some frequent special cases.... */
 		{
-			char symname[KSYM_NAME_LEN+1];
+			char symname[KSYM_NAME_LEN];
 			char *modname;
 
 			kallsyms_lookup(info->ip, NULL, NULL, &modname,
diff -puN fs/proc/base.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 fs/proc/base.c
--- a/fs/proc/base.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/fs/proc/base.c
@@ -283,7 +283,7 @@ static int proc_pid_auxv(struct task_str
 static int proc_pid_wchan(struct task_struct *task, char *buffer)
 {
 	unsigned long wchan;
-	char symname[KSYM_NAME_LEN+1];
+	char symname[KSYM_NAME_LEN];
 
 	wchan = get_wchan(task);
 
diff -puN include/asm-powerpc/kprobes.h~kallsyms-make-ksym_name_len-include-space-for-trailing-0 include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/include/asm-powerpc/kprobes.h
@@ -65,10 +65,10 @@ typedef unsigned int kprobe_opcode_t;
 		} else if (name[0] != '.')				\
 			addr = *(kprobe_opcode_t **)addr;		\
 	} else {							\
-		char dot_name[KSYM_NAME_LEN+1];				\
+		char dot_name[KSYM_NAME_LEN];				\
 		dot_name[0] = '.';					\
 		dot_name[1] = '\0';					\
-		strncat(dot_name, name, KSYM_NAME_LEN);			\
+		strncat(dot_name, name, KSYM_NAME_LEN - 2);		\
 		addr = (kprobe_opcode_t *)kallsyms_lookup_name(dot_name); \
 	}								\
 }
diff -puN include/linux/kallsyms.h~kallsyms-make-ksym_name_len-include-space-for-trailing-0 include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/include/linux/kallsyms.h
@@ -7,9 +7,9 @@
 
 #include <linux/errno.h>
 
-#define KSYM_NAME_LEN 127
-#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +	\
-			 2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
+#define KSYM_NAME_LEN 128
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
+			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
diff -puN kernel/kallsyms.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 kernel/kallsyms.c
--- a/kernel/kallsyms.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/kernel/kallsyms.c
@@ -152,7 +152,7 @@ static unsigned int get_symbol_offset(un
 /* Lookup the address for this symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name)
 {
-	char namebuf[KSYM_NAME_LEN+1];
+	char namebuf[KSYM_NAME_LEN];
 	unsigned long i;
 	unsigned int off;
 
@@ -248,7 +248,7 @@ const char *kallsyms_lookup(unsigned lon
 {
 	const char *msym;
 
-	namebuf[KSYM_NAME_LEN] = 0;
+	namebuf[KSYM_NAME_LEN - 1] = 0;
 	namebuf[0] = 0;
 
 	if (is_ksym_addr(addr)) {
@@ -265,7 +265,7 @@ const char *kallsyms_lookup(unsigned lon
 	/* see if it's in a module */
 	msym = module_address_lookup(addr, symbolsize, offset, modname);
 	if (msym)
-		return strncpy(namebuf, msym, KSYM_NAME_LEN);
+		return strncpy(namebuf, msym, KSYM_NAME_LEN - 1);
 
 	return NULL;
 }
@@ -273,7 +273,7 @@ const char *kallsyms_lookup(unsigned lon
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
 	symname[0] = '\0';
-	symname[KSYM_NAME_LEN] = '\0';
+	symname[KSYM_NAME_LEN - 1] = '\0';
 
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
@@ -291,7 +291,7 @@ int lookup_symbol_attrs(unsigned long ad
 			unsigned long *offset, char *modname, char *name)
 {
 	name[0] = '\0';
-	name[KSYM_NAME_LEN] = '\0';
+	name[KSYM_NAME_LEN - 1] = '\0';
 
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
@@ -312,7 +312,7 @@ int sprint_symbol(char *buffer, unsigned
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
-	char namebuf[KSYM_NAME_LEN+1];
+	char namebuf[KSYM_NAME_LEN];
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 	if (!name)
@@ -342,8 +342,8 @@ struct kallsym_iter
 	unsigned long value;
 	unsigned int nameoff; /* If iterating in core kernel symbols */
 	char type;
-	char name[KSYM_NAME_LEN+1];
-	char module_name[MODULE_NAME_LEN + 1];
+	char name[KSYM_NAME_LEN];
+	char module_name[MODULE_NAME_LEN];
 	int exported;
 };
 
diff -puN kernel/lockdep.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 kernel/lockdep.c
--- a/kernel/lockdep.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/kernel/lockdep.c
@@ -379,7 +379,7 @@ get_usage_chars(struct lock_class *class
 
 static void print_lock_name(struct lock_class *class)
 {
-	char str[KSYM_NAME_LEN + 1], c1, c2, c3, c4;
+	char str[KSYM_NAME_LEN], c1, c2, c3, c4;
 	const char *name;
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
@@ -401,7 +401,7 @@ static void print_lock_name(struct lock_
 static void print_lockdep_cache(struct lockdep_map *lock)
 {
 	const char *name;
-	char str[KSYM_NAME_LEN + 1];
+	char str[KSYM_NAME_LEN];
 
 	name = lock->name;
 	if (!name)
diff -puN kernel/module.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 kernel/module.c
--- a/kernel/module.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/kernel/module.c
@@ -2195,7 +2195,7 @@ int lookup_module_symbol_name(unsigned l
 			sym = get_ksymbol(mod, addr, NULL, NULL);
 			if (!sym)
 				goto out;
-			strlcpy(symname, sym, KSYM_NAME_LEN + 1);
+			strlcpy(symname, sym, KSYM_NAME_LEN);
 			mutex_unlock(&module_mutex);
 			return 0;
 		}
@@ -2220,9 +2220,9 @@ int lookup_module_symbol_attrs(unsigned 
 			if (!sym)
 				goto out;
 			if (modname)
-				strlcpy(modname, mod->name, MODULE_NAME_LEN + 1);
+				strlcpy(modname, mod->name, MODULE_NAME_LEN);
 			if (name)
-				strlcpy(name, sym, KSYM_NAME_LEN + 1);
+				strlcpy(name, sym, KSYM_NAME_LEN);
 			mutex_unlock(&module_mutex);
 			return 0;
 		}
@@ -2243,8 +2243,8 @@ int module_get_kallsym(unsigned int symn
 			*value = mod->symtab[symnum].st_value;
 			*type = mod->symtab[symnum].st_info;
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
-				KSYM_NAME_LEN + 1);
-			strlcpy(module_name, mod->name, MODULE_NAME_LEN + 1);
+				KSYM_NAME_LEN);
+			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
 			*exported = is_exported(name, mod);
 			mutex_unlock(&module_mutex);
 			return 0;
diff -puN kernel/time/timer_list.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/kernel/time/timer_list.c
@@ -38,7 +38,7 @@ DECLARE_PER_CPU(struct hrtimer_cpu_base,
 
 static void print_name_offset(struct seq_file *m, void *sym)
 {
-	char symname[KSYM_NAME_LEN+1];
+	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
 		SEQ_printf(m, "<%p>", sym);
diff -puN kernel/time/timer_stats.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/kernel/time/timer_stats.c
@@ -269,7 +269,7 @@ void timer_stats_update_stats(void *time
 
 static void print_name_offset(struct seq_file *m, unsigned long addr)
 {
-	char symname[KSYM_NAME_LEN+1];
+	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name(addr, symname) < 0)
 		seq_printf(m, "<%p>", (void *)addr);
diff -puN mm/slab.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 mm/slab.c
--- a/mm/slab.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/mm/slab.c
@@ -4346,7 +4346,7 @@ static void show_symbol(struct seq_file 
 {
 #ifdef CONFIG_KALLSYMS
 	unsigned long offset, size;
-	char modname[MODULE_NAME_LEN + 1], name[KSYM_NAME_LEN + 1];
+	char modname[MODULE_NAME_LEN], name[KSYM_NAME_LEN];
 
 	if (lookup_symbol_attrs(address, &size, &offset, modname, name) == 0) {
 		seq_printf(m, "%s+%#lx/%#lx", name, offset, size);
diff -puN scripts/kallsyms.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0 scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-make-ksym_name_len-include-space-for-trailing-0
+++ a/scripts/kallsyms.c
@@ -31,7 +31,7 @@
 #include <string.h>
 #include <ctype.h>
 
-#define KSYM_NAME_LEN		127
+#define KSYM_NAME_LEN		128
 
 
 struct sym_entry {
@@ -254,7 +254,7 @@ static void write_src(void)
 	unsigned int i, k, off;
 	unsigned int best_idx[256];
 	unsigned int *markers;
-	char buf[KSYM_NAME_LEN+1];
+	char buf[KSYM_NAME_LEN];
 
 	printf("#include <asm/types.h>\n");
 	printf("#if BITS_PER_LONG == 64\n");
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
pata_acpi-restore-driver.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
libata-implement-ata_wait_after_reset.patch
sata_promise-sata-hotplug-support.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
libata-check-for-an-support.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
ata-ahci-alpm-store-interrupt-value.patch
ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
git-scsi-misc.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
git-block.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lib-add-idr_for_each.patch
lib-add-idr_remove_all.patch
kallsyms-make-ksym_name_len-include-space-for-trailing-0.patch
