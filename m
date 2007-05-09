From: akpm@linux-foundation.org
Subject: - fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:49 -0700
Message-ID: <200705090248.l492mnvL009155@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967154AbXEICta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix race between cat /proc/*/wchan and rmmod et al
has been removed from the -mm tree.  Its filename was
     fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix race between cat /proc/*/wchan and rmmod et al
From: Alexey Dobriyan <adobriyan@sw.ru>

kallsyms_lookup() can go iterating over modules list unprotected which is OK
for emergency situations (oops), but not OK for regular stuff like
/proc/*/wchan.

Introduce lookup_symbol_name()/lookup_module_symbol_name() which copy symbol
name into caller-supplied buffer or return -ERANGE.  All copying is done with
module_mutex held, so...

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c            |   11 +++++------
 include/linux/kallsyms.h  |    7 +++++++
 include/linux/module.h    |    6 ++++++
 kernel/kallsyms.c         |   17 +++++++++++++++++
 kernel/module.c           |   23 +++++++++++++++++++++++
 kernel/time/timer_list.c  |   13 +++++--------
 kernel/time/timer_stats.c |   10 ++++------
 7 files changed, 67 insertions(+), 20 deletions(-)

diff -puN fs/proc/base.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al fs/proc/base.c
--- a/fs/proc/base.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al
+++ a/fs/proc/base.c
@@ -278,16 +278,15 @@ static int proc_pid_auxv(struct task_str
  */
 static int proc_pid_wchan(struct task_struct *task, char *buffer)
 {
-	const char *sym_name;
 	unsigned long wchan;
-	char namebuf[KSYM_NAME_LEN+1];
+	char symname[KSYM_NAME_LEN+1];
 
 	wchan = get_wchan(task);
 
-	sym_name = kallsyms_lookup(wchan, NULL, NULL, NULL, namebuf);
-	if (sym_name)
-		return sprintf(buffer, "%s", sym_name);
-	return sprintf(buffer, "%lu", wchan);
+	if (lookup_symbol_name(wchan, symname) < 0)
+		return sprintf(buffer, "%lu", wchan);
+	else
+		return sprintf(buffer, "%s", symname);
 }
 #endif /* CONFIG_KALLSYMS */
 
diff -puN include/linux/kallsyms.h~fix-race-between-cat-proc-wchan-and-rmmod-et-al include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~fix-race-between-cat-proc-wchan-and-rmmod-et-al
+++ a/include/linux/kallsyms.h
@@ -30,6 +30,8 @@ extern int sprint_symbol(char *buffer, u
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
 
+int lookup_symbol_name(unsigned long addr, char *symname);
+
 #else /* !CONFIG_KALLSYMS */
 
 static inline unsigned long kallsyms_lookup_name(const char *name)
@@ -58,6 +60,11 @@ static inline int sprint_symbol(char *bu
 	return 0;
 }
 
+static inline int lookup_symbol_name(unsigned long addr, char *symname)
+{
+	return -ERANGE;
+}
+
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
diff -puN include/linux/module.h~fix-race-between-cat-proc-wchan-and-rmmod-et-al include/linux/module.h
--- a/include/linux/module.h~fix-race-between-cat-proc-wchan-and-rmmod-et-al
+++ a/include/linux/module.h
@@ -454,6 +454,7 @@ const char *module_address_lookup(unsign
 				  unsigned long *symbolsize,
 				  unsigned long *offset,
 				  char **modname);
+int lookup_module_symbol_name(unsigned long addr, char *symname);
 
 /* For extable.c to search modules' exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr);
@@ -525,6 +526,11 @@ static inline const char *module_address
 	return NULL;
 }
 
+static inline int lookup_module_symbol_name(unsigned long addr, char *symname)
+{
+	return -ERANGE;
+}
+
 static inline int module_get_kallsym(unsigned int symnum, unsigned long *value,
 					char *type, char *name,
 					char *module_name, int *exported)
diff -puN kernel/kallsyms.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al kernel/kallsyms.c
--- a/kernel/kallsyms.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al
+++ a/kernel/kallsyms.c
@@ -269,6 +269,23 @@ const char *kallsyms_lookup(unsigned lon
 	return NULL;
 }
 
+int lookup_symbol_name(unsigned long addr, char *symname)
+{
+	symname[0] = '\0';
+	symname[KSYM_NAME_LEN] = '\0';
+
+	if (is_ksym_addr(addr)) {
+		unsigned long pos;
+
+		pos = get_symbol_pos(addr, NULL, NULL);
+		/* Grab name */
+		kallsyms_expand_symbol(get_symbol_offset(pos), symname);
+		return 0;
+	}
+	/* see if it's in a module */
+	return lookup_module_symbol_name(addr, symname);
+}
+
 /* Look up a kernel symbol and return it in a text buffer. */
 int sprint_symbol(char *buffer, unsigned long address)
 {
diff -puN kernel/module.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al kernel/module.c
--- a/kernel/module.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al
+++ a/kernel/module.c
@@ -2126,6 +2126,29 @@ const char *module_address_lookup(unsign
 	return NULL;
 }
 
+int lookup_module_symbol_name(unsigned long addr, char *symname)
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (within(addr, mod->module_init, mod->init_size) ||
+		    within(addr, mod->module_core, mod->core_size)) {
+			const char *sym;
+
+			sym = get_ksymbol(mod, addr, NULL, NULL);
+			if (!sym)
+				goto out;
+			strlcpy(symname, sym, KSYM_NAME_LEN + 1);
+			mutex_unlock(&module_mutex);
+			return 0;
+		}
+	}
+out:
+	mutex_unlock(&module_mutex);
+	return -ERANGE;
+}
+
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 			char *name, char *module_name, int *exported)
 {
diff -puN kernel/time/timer_list.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al
+++ a/kernel/time/timer_list.c
@@ -38,15 +38,12 @@ DECLARE_PER_CPU(struct hrtimer_cpu_base,
 
 static void print_name_offset(struct seq_file *m, void *sym)
 {
-	unsigned long addr = (unsigned long)sym;
-	char namebuf[KSYM_NAME_LEN+1];
-	const char *sym_name;
-
-	sym_name = kallsyms_lookup(addr, NULL, NULL, NULL, namebuf);
-	if (sym_name)
-		SEQ_printf(m, "%s", sym_name);
-	else
+	char symname[KSYM_NAME_LEN+1];
+
+	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
 		SEQ_printf(m, "<%p>", sym);
+	else
+		SEQ_printf(m, "%s", symname);
 }
 
 static void
diff -puN kernel/time/timer_stats.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~fix-race-between-cat-proc-wchan-and-rmmod-et-al
+++ a/kernel/time/timer_stats.c
@@ -257,14 +257,12 @@ void timer_stats_update_stats(void *time
 
 static void print_name_offset(struct seq_file *m, unsigned long addr)
 {
-	char namebuf[KSYM_NAME_LEN+1];
-	const char *sym_name;
+	char symname[KSYM_NAME_LEN+1];
 
-	sym_name = kallsyms_lookup(addr, NULL, NULL, NULL, namebuf);
-	if (sym_name)
-		seq_printf(m, "%s", sym_name);
-	else
+	if (lookup_symbol_name(addr, symname) < 0)
 		seq_printf(m, "<%p>", (void *)addr);
+	else
+		seq_printf(m, "%s", symname);
 }
 
 static int tstats_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
