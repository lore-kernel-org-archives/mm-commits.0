From: akpm@linux-foundation.org
Subject: - make-taint-bit-reliable-v3.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:44 -0700
Message-ID: <200810182311.m9INBiop027784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYJRXMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Make the taint flags reliable
has been removed from the -mm tree.  Its filename was
     make-taint-bit-reliable-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make the taint flags reliable
From: Andi Kleen <andi@firstfloor.org>

It's somewhat unlikely that it happens, but right now a race window
between interrupts or machine checks or oopses could corrupt the tainted
bitmap because it is modified in a non atomic fashion.

Convert the taint variable to an unsigned long and use only atomic bit
operations on it.

Unfortunately this means the intvec sysctl functions cannot be used on it
anymore.

It turned out the taint sysctl handler could actually be simplified a bit
(since it only increases capabilities) so this patch actually removes
code.

[akpm@linux-foundation.org: remove unneeded include]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot.c |   14 +++----
 include/linux/kernel.h    |   25 ++++++-------
 kernel/module.c           |   12 +++---
 kernel/panic.c            |   63 ++++++++++++++++++++++++---------
 kernel/softlockup.c       |    2 -
 kernel/sysctl.c           |   67 +++++++++++++++---------------------
 6 files changed, 101 insertions(+), 82 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~make-taint-bit-reliable-v3 arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~make-taint-bit-reliable-v3
+++ a/arch/x86/kernel/smpboot.c
@@ -282,6 +282,8 @@ static void __cpuinit smp_callin(void)
 	cpu_set(cpuid, cpu_callin_map);
 }
 
+static int __cpuinitdata unsafe_smp;
+
 /*
  * Activate a secondary processor.
  */
@@ -397,7 +399,7 @@ static void __cpuinit smp_apply_quirks(s
 				goto valid_k7;
 
 		/* If we get here, not a certified SMP capable AMD system. */
-		add_taint(TAINT_UNSAFE_SMP);
+		unsafe_smp = 1;
 	}
 
 valid_k7:
@@ -414,12 +416,10 @@ static void __cpuinit smp_checks(void)
 	 * Don't taint if we are running SMP kernel on a single non-MP
 	 * approved Athlon
 	 */
-	if (tainted & TAINT_UNSAFE_SMP) {
-		if (num_online_cpus())
-			printk(KERN_INFO "WARNING: This combination of AMD"
-				"processors is not suitable for SMP.\n");
-		else
-			tainted &= ~TAINT_UNSAFE_SMP;
+	if (unsafe_smp && num_online_cpus() > 1) {
+		printk(KERN_INFO "WARNING: This combination of AMD"
+			"processors is not suitable for SMP.\n");
+		add_taint(TAINT_UNSAFE_SMP);
 	}
 }
 
diff -puN include/linux/kernel.h~make-taint-bit-reliable-v3 include/linux/kernel.h
--- a/include/linux/kernel.h~make-taint-bit-reliable-v3
+++ a/include/linux/kernel.h
@@ -235,9 +235,10 @@ extern int oops_in_progress;		/* If set,
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
-extern int tainted;
 extern const char *print_tainted(void);
-extern void add_taint(unsigned);
+extern void add_taint(unsigned flag);
+extern int test_taint(unsigned flag);
+extern unsigned long get_taint(void);
 extern int root_mountflags;
 
 /* Values used for system_state */
@@ -250,16 +251,16 @@ extern enum system_states {
 	SYSTEM_SUSPEND_DISK,
 } system_state;
 
-#define TAINT_PROPRIETARY_MODULE	(1<<0)
-#define TAINT_FORCED_MODULE		(1<<1)
-#define TAINT_UNSAFE_SMP		(1<<2)
-#define TAINT_FORCED_RMMOD		(1<<3)
-#define TAINT_MACHINE_CHECK		(1<<4)
-#define TAINT_BAD_PAGE			(1<<5)
-#define TAINT_USER			(1<<6)
-#define TAINT_DIE			(1<<7)
-#define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
-#define TAINT_WARN			(1<<9)
+#define TAINT_PROPRIETARY_MODULE	0
+#define TAINT_FORCED_MODULE		1
+#define TAINT_UNSAFE_SMP		2
+#define TAINT_FORCED_RMMOD		3
+#define TAINT_MACHINE_CHECK		4
+#define TAINT_BAD_PAGE			5
+#define TAINT_USER			6
+#define TAINT_DIE			7
+#define TAINT_OVERRIDDEN_ACPI_TABLE	8
+#define TAINT_WARN			9
 
 extern void dump_stack(void) __cold;
 
diff -puN kernel/module.c~make-taint-bit-reliable-v3 kernel/module.c
--- a/kernel/module.c~make-taint-bit-reliable-v3
+++ a/kernel/module.c
@@ -100,7 +100,7 @@ static inline int strong_try_module_get(
 static inline void add_taint_module(struct module *mod, unsigned flag)
 {
 	add_taint(flag);
-	mod->taints |= flag;
+	mod->taints |= (1U << flag);
 }
 
 /*
@@ -923,7 +923,7 @@ static const char vermagic[] = VERMAGIC_
 static int try_to_force_load(struct module *mod, const char *symname)
 {
 #ifdef CONFIG_MODULE_FORCE_LOAD
-	if (!(tainted & TAINT_FORCED_MODULE))
+	if (!test_taint(TAINT_FORCED_MODULE))
 		printk("%s: no version for \"%s\" found: kernel tainted.\n",
 		       mod->name, symname);
 	add_taint_module(mod, TAINT_FORCED_MODULE);
@@ -1033,7 +1033,7 @@ static unsigned long resolve_symbol(Elf_
 	const unsigned long *crc;
 
 	ret = find_symbol(name, &owner, &crc,
-			  !(mod->taints & TAINT_PROPRIETARY_MODULE), true);
+			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
@@ -1634,7 +1634,7 @@ static void set_license(struct module *m
 		license = "unspecified";
 
 	if (!license_is_gpl_compatible(license)) {
-		if (!(tainted & TAINT_PROPRIETARY_MODULE))
+		if (!test_taint(TAINT_PROPRIETARY_MODULE))
 			printk(KERN_WARNING "%s: module license '%s' taints "
 				"kernel.\n", mod->name, license);
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
@@ -2552,9 +2552,9 @@ static char *module_flags(struct module 
 	    mod->state == MODULE_STATE_GOING ||
 	    mod->state == MODULE_STATE_COMING) {
 		buf[bx++] = '(';
-		if (mod->taints & TAINT_PROPRIETARY_MODULE)
+		if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
 			buf[bx++] = 'P';
-		if (mod->taints & TAINT_FORCED_MODULE)
+		if (mod->taints & (1 << TAINT_FORCED_MODULE))
 			buf[bx++] = 'F';
 		/*
 		 * TAINT_FORCED_RMMOD: could be added.
diff -puN kernel/panic.c~make-taint-bit-reliable-v3 kernel/panic.c
--- a/kernel/panic.c~make-taint-bit-reliable-v3
+++ a/kernel/panic.c
@@ -23,7 +23,7 @@
 #include <linux/kallsyms.h>
 
 int panic_on_oops;
-int tainted;
+static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -159,31 +159,60 @@ EXPORT_SYMBOL(panic);
  *	The string is overwritten by the next call to print_taint().
  */
 
+struct tnt {
+	u8 bit;
+	char true;
+	char false;
+};
+
+static const struct tnt tnts[] = {
+	{ TAINT_PROPRIETARY_MODULE, 'P', 'G' },
+	{ TAINT_FORCED_MODULE, 'F', ' ' },
+	{ TAINT_UNSAFE_SMP, 'S', ' ' },
+	{ TAINT_FORCED_RMMOD, 'R', ' ' },
+	{ TAINT_MACHINE_CHECK, 'M', ' ' },
+	{ TAINT_BAD_PAGE, 'B', ' ' },
+	{ TAINT_USER, 'U', ' ' },
+	{ TAINT_DIE, 'D', ' ' },
+	{ TAINT_OVERRIDDEN_ACPI_TABLE, 'A', ' ' },
+	{ TAINT_WARN, 'W', ' ' },
+};
+
 const char *print_tainted(void)
 {
-	static char buf[20];
-	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
-			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
-			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
-			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
-			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
-			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
-			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
-			tainted & TAINT_USER ? 'U' : ' ',
-			tainted & TAINT_DIE ? 'D' : ' ',
-			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
-			tainted & TAINT_WARN ? 'W' : ' ');
-	}
-	else
+	static char buf[ARRAY_SIZE(tnts) + sizeof("Tainted: ") + 1];
+
+	if (tainted_mask) {
+		char *s;
+		int i;
+
+		s = buf + sprintf(buf, "Tainted: ");
+		for (i = 0; i < ARRAY_SIZE(tnts); i++) {
+			const struct tnt *t = &tnts[i];
+			*s++ = test_bit(t->bit, &tainted_mask) ?
+					t->true : t->false;
+		}
+		*s = 0;
+	} else
 		snprintf(buf, sizeof(buf), "Not tainted");
 	return(buf);
 }
 
+int test_taint(unsigned flag)
+{
+	return test_bit(flag, &tainted_mask);
+}
+EXPORT_SYMBOL(test_taint);
+
+unsigned long get_taint(void)
+{
+	return tainted_mask;
+}
+
 void add_taint(unsigned flag)
 {
 	debug_locks = 0; /* can't trust the integrity of the kernel anymore */
-	tainted |= flag;
+	set_bit(flag, &tainted_mask);
 }
 EXPORT_SYMBOL(add_taint);
 
diff -puN kernel/softlockup.c~make-taint-bit-reliable-v3 kernel/softlockup.c
--- a/kernel/softlockup.c~make-taint-bit-reliable-v3
+++ a/kernel/softlockup.c
@@ -226,7 +226,7 @@ static void check_hung_uninterruptible_t
 	 * If the system crashed already then all bets are off,
 	 * do not report extra hung tasks:
 	 */
-	if ((tainted & TAINT_DIE) || did_panic)
+	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
 	read_lock(&tasklist_lock);
diff -puN kernel/sysctl.c~make-taint-bit-reliable-v3 kernel/sysctl.c
--- a/kernel/sysctl.c~make-taint-bit-reliable-v3
+++ a/kernel/sysctl.c
@@ -149,7 +149,7 @@ extern int max_lock_depth;
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+static int proc_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
@@ -379,10 +379,9 @@ static struct ctl_table kern_table[] = {
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
-		.data		= &tainted,
-		.maxlen		= sizeof(int),
+		.maxlen 	= sizeof(long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_taint,
+		.proc_handler	= &proc_taint,
 	},
 #endif
 #ifdef CONFIG_LATENCYTOP
@@ -2228,49 +2227,39 @@ int proc_dointvec(struct ctl_table *tabl
 		    	    NULL,NULL);
 }
 
-#define OP_SET	0
-#define OP_AND	1
-#define OP_OR	2
-
-static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
-				      int *valp,
-				      int write, void *data)
-{
-	int op = *(int *)data;
-	if (write) {
-		int val = *negp ? -*lvalp : *lvalp;
-		switch(op) {
-		case OP_SET:	*valp = val; break;
-		case OP_AND:	*valp &= val; break;
-		case OP_OR:	*valp |= val; break;
-		}
-	} else {
-		int val = *valp;
-		if (val < 0) {
-			*negp = -1;
-			*lvalp = (unsigned long)-val;
-		} else {
-			*negp = 0;
-			*lvalp = (unsigned long)val;
-		}
-	}
-	return 0;
-}
-
 /*
- *	Taint values can only be increased
+ * Taint values can only be increased
+ * This means we can safely use a temporary.
  */
-static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+static int proc_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int op;
+	struct ctl_table t;
+	unsigned long tmptaint = get_taint();
+	int err;
 
 	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	op = OP_OR;
-	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
-				do_proc_dointvec_bset_conv,&op);
+	t = *table;
+	t.data = &tmptaint;
+	err = proc_doulongvec_minmax(&t, write, filp, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	if (write) {
+		/*
+		 * Poor man's atomic or. Not worth adding a primitive
+		 * to everyone's atomic.h for this
+		 */
+		int i;
+		for (i = 0; i < BITS_PER_LONG && tmptaint >> i; i++) {
+			if ((tmptaint >> i) & 1)
+				add_taint(i);
+		}
+	}
+
+	return err;
 }
 
 struct do_proc_dointvec_minmax_conv_param {
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
fix-documentation-of-sysrq-q.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
acpi-use-bcd2bin-bin2bcd.patch

