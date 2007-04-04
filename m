From: akpm@linux-foundation.org
Subject: + simplify-kallsyms_lookup.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:10:26 -0700
Message-ID: <200704040010.l340AQt1007291@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49707 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946043AbXDDALJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, rusty@rustcorp.com.au


The patch titled
     Simplify kallsyms_lookup()
has been added to the -mm tree.  Its filename is
     simplify-kallsyms_lookup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Simplify kallsyms_lookup()
From: Alexey Dobriyan <adobriyan@sw.ru>

Several kallsyms_lookup() pass dummy arguments but only need, say, module's
name.  Make kallsyms_lookup() accept NULLs where possible.

Also, makes picture clearer about what interfaces are needed for all symbol
resolving business.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/unwind.c |    5 +----
 arch/powerpc/xmon/xmon.c    |    3 +--
 arch/sh64/kernel/unwind.c   |    6 +++---
 fs/proc/base.c              |    5 ++---
 kernel/kallsyms.c           |    6 ++++--
 kernel/kprobes.c            |    4 ++--
 kernel/lockdep.c            |    5 +----
 kernel/module.c             |    6 ++++--
 kernel/time/timer_list.c    |    4 +---
 kernel/time/timer_stats.c   |    4 +---
 10 files changed, 20 insertions(+), 28 deletions(-)

diff -puN arch/parisc/kernel/unwind.c~simplify-kallsyms_lookup arch/parisc/kernel/unwind.c
--- a/arch/parisc/kernel/unwind.c~simplify-kallsyms_lookup
+++ a/arch/parisc/kernel/unwind.c
@@ -216,11 +216,8 @@ static void unwind_frame_regs(struct unw
 		/* Handle some frequent special cases.... */
 		{
 			char symname[KSYM_NAME_LEN+1];
-			char *modname;
-			unsigned long symsize, offset;
 
-			kallsyms_lookup(info->ip, &symsize, &offset,
-					&modname, symname);
+			kallsyms_lookup(info->ip, NULL, NULL, NULL, symname);
 
 			dbg("info->ip = 0x%lx, name = %s\n", info->ip, symname);
 
diff -puN arch/powerpc/xmon/xmon.c~simplify-kallsyms_lookup arch/powerpc/xmon/xmon.c
--- a/arch/powerpc/xmon/xmon.c~simplify-kallsyms_lookup
+++ a/arch/powerpc/xmon/xmon.c
@@ -1218,7 +1218,6 @@ static void get_function_bounds(unsigned
 {
 	unsigned long size, offset;
 	const char *name;
-	char *modname;
 
 	*startp = *endp = 0;
 	if (pc == 0)
@@ -1226,7 +1225,7 @@ static void get_function_bounds(unsigned
 	if (setjmp(bus_error_jmp) == 0) {
 		catch_memory_errors = 1;
 		sync();
-		name = kallsyms_lookup(pc, &size, &offset, &modname, tmpstr);
+		name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
 		if (name != NULL) {
 			*startp = pc - offset;
 			*endp = pc - offset + size;
diff -puN arch/sh64/kernel/unwind.c~simplify-kallsyms_lookup arch/sh64/kernel/unwind.c
--- a/arch/sh64/kernel/unwind.c~simplify-kallsyms_lookup
+++ a/arch/sh64/kernel/unwind.c
@@ -46,15 +46,15 @@ static int lookup_prev_stack_frame(unsig
 		      struct pt_regs *regs)
 {
 	const char *sym;
-	char *modname, namebuf[128];
-	unsigned long offset, size;
+	char namebuf[128];
+	unsigned long offset;
 	unsigned long prologue = 0;
 	unsigned long fp_displacement = 0;
 	unsigned long fp_prev = 0;
 	unsigned long offset_r14 = 0, offset_r18 = 0;
 	int i, found_prologue_end = 0;
 
-	sym = kallsyms_lookup(pc, &size, &offset, &modname, namebuf);
+	sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
 	if (!sym)
 		return -EINVAL;
 
diff -puN fs/proc/base.c~simplify-kallsyms_lookup fs/proc/base.c
--- a/fs/proc/base.c~simplify-kallsyms_lookup
+++ a/fs/proc/base.c
@@ -278,14 +278,13 @@ static int proc_pid_auxv(struct task_str
  */
 static int proc_pid_wchan(struct task_struct *task, char *buffer)
 {
-	char *modname;
 	const char *sym_name;
-	unsigned long wchan, size, offset;
+	unsigned long wchan;
 	char namebuf[KSYM_NAME_LEN+1];
 
 	wchan = get_wchan(task);
 
-	sym_name = kallsyms_lookup(wchan, &size, &offset, &modname, namebuf);
+	sym_name = kallsyms_lookup(wchan, NULL, NULL, NULL, namebuf);
 	if (sym_name)
 		return sprintf(buffer, "%s", sym_name);
 	return sprintf(buffer, "%lu", wchan);
diff -puN kernel/kallsyms.c~simplify-kallsyms_lookup kernel/kallsyms.c
--- a/kernel/kallsyms.c~simplify-kallsyms_lookup
+++ a/kernel/kallsyms.c
@@ -214,8 +214,10 @@ static unsigned long get_symbol_pos(unsi
 			symbol_end = (unsigned long)_etext;
 	}
 
-	*symbolsize = symbol_end - symbol_start;
-	*offset = addr - symbol_start;
+	if (symbolsize)
+		*symbolsize = symbol_end - symbol_start;
+	if (offset)
+		*offset = addr - symbol_start;
 
 	return low;
 }
diff -puN kernel/kprobes.c~simplify-kallsyms_lookup kernel/kprobes.c
--- a/kernel/kprobes.c~simplify-kallsyms_lookup
+++ a/kernel/kprobes.c
@@ -868,13 +868,13 @@ static int __kprobes show_kprobe_addr(st
 	struct kprobe *p, *kp;
 	const char *sym = NULL;
 	unsigned int i = *(loff_t *) v;
-	unsigned long size, offset = 0;
+	unsigned long offset = 0;
 	char *modname, namebuf[128];
 
 	head = &kprobe_table[i];
 	preempt_disable();
 	hlist_for_each_entry_rcu(p, node, head, hlist) {
-		sym = kallsyms_lookup((unsigned long)p->addr, &size,
+		sym = kallsyms_lookup((unsigned long)p->addr, NULL,
 					&offset, &modname, namebuf);
 		if (p->pre_handler == aggr_pre_handler) {
 			list_for_each_entry_rcu(kp, &p->list, list)
diff -puN kernel/lockdep.c~simplify-kallsyms_lookup kernel/lockdep.c
--- a/kernel/lockdep.c~simplify-kallsyms_lookup
+++ a/kernel/lockdep.c
@@ -340,10 +340,7 @@ static const char *usage_str[] =
 
 const char * __get_key_name(struct lockdep_subclass_key *key, char *str)
 {
-	unsigned long offs, size;
-	char *modname;
-
-	return kallsyms_lookup((unsigned long)key, &size, &offs, &modname, str);
+	return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
 }
 
 void
diff -puN kernel/module.c~simplify-kallsyms_lookup kernel/module.c
--- a/kernel/module.c~simplify-kallsyms_lookup
+++ a/kernel/module.c
@@ -2174,8 +2174,10 @@ static const char *get_ksymbol(struct mo
 	if (!best)
 		return NULL;
 
-	*size = nextval - mod->symtab[best].st_value;
-	*offset = addr - mod->symtab[best].st_value;
+	if (size)
+		*size = nextval - mod->symtab[best].st_value;
+	if (offset)
+		*offset = addr - mod->symtab[best].st_value;
 	return mod->strtab + mod->symtab[best].st_name;
 }
 
diff -puN kernel/time/timer_list.c~simplify-kallsyms_lookup kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~simplify-kallsyms_lookup
+++ a/kernel/time/timer_list.c
@@ -40,11 +40,9 @@ static void print_name_offset(struct seq
 {
 	unsigned long addr = (unsigned long)sym;
 	char namebuf[KSYM_NAME_LEN+1];
-	unsigned long size, offset;
 	const char *sym_name;
-	char *modname;
 
-	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
+	sym_name = kallsyms_lookup(addr, NULL, NULL, NULL, namebuf);
 	if (sym_name)
 		SEQ_printf(m, "%s", sym_name);
 	else
diff -puN kernel/time/timer_stats.c~simplify-kallsyms_lookup kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~simplify-kallsyms_lookup
+++ a/kernel/time/timer_stats.c
@@ -258,11 +258,9 @@ void timer_stats_update_stats(void *time
 static void print_name_offset(struct seq_file *m, unsigned long addr)
 {
 	char namebuf[KSYM_NAME_LEN+1];
-	unsigned long size, offset;
 	const char *sym_name;
-	char *modname;
 
-	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
+	sym_name = kallsyms_lookup(addr, NULL, NULL, NULL, namebuf);
 	if (sym_name)
 		seq_printf(m, "%s", sym_name);
 	else
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
git-cpufreq.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
add-file-position-info-to-proc.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
protect-tty-drivers-list-with-tty_mutex.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
