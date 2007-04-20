From: akpm@linux-foundation.org
Subject: + report-that-kernel-is-tainted-if-there-were-an-oops-before.patch added to -mm tree
Date: Fri, 20 Apr 2007 13:30:05 -0700
Message-ID: <200704202030.l3KKU6cO023193@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767237AbXDTUbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 16:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, dev@openvz.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, lethal@linux-sh.org, paulus@samba.org, ralf@linux-mips.org, randy.dunlap@oracle.com, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, xemul@openvz.org


The patch titled
     Report that kernel is tainted if there were an OOPS before
has been added to the -mm tree.  Its filename is
     report-that-kernel-is-tainted-if-there-were-an-oops-before.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Report that kernel is tainted if there were an OOPS before
From: Pavel Emelianov <xemul@sw.ru>

If the kernel OOPS-ed or BUG-ed then it probably should considered as
tainted.  Use die_counter introduced by many architectures to determine
whether or not the kernel died.

This saves a lot of time explaining oddities in the calltrace seen via
SysRq-P.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    4 ++++
 arch/arm/kernel/traps.c        |    1 -
 arch/avr32/kernel/traps.c      |    2 --
 arch/i386/kernel/traps.c       |    1 -
 arch/ia64/kernel/traps.c       |    1 -
 arch/mips/kernel/traps.c       |    1 -
 arch/powerpc/kernel/traps.c    |    1 -
 arch/ppc/kernel/traps.c        |    1 -
 arch/s390/kernel/traps.c       |    2 --
 arch/sh/kernel/traps.c         |    2 --
 arch/sparc/kernel/traps.c      |    1 -
 arch/sparc64/kernel/traps.c    |    1 -
 arch/x86_64/kernel/traps.c     |    1 -
 arch/xtensa/kernel/traps.c     |    1 -
 include/linux/kernel.h         |    1 +
 kernel/panic.c                 |   10 +++++++---
 16 files changed, 12 insertions(+), 19 deletions(-)

diff -puN Documentation/oops-tracing.txt~report-that-kernel-is-tainted-if-there-were-an-oops-before Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/Documentation/oops-tracing.txt
@@ -240,6 +240,10 @@ characters, each representing a particul
   7: 'U' if a user or user application specifically requested that the
      Tainted flag be set, ' ' otherwise.
 
+  8: 'D' if a kernel has died recently, i.e. there was an OOPS or BUG
+      before, ' ' otherwise. This is useful when seeing the calltrace
+      from SysRq-P output.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff -puN arch/arm/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/arm/kernel/traps.c
@@ -207,7 +207,6 @@ void show_stack(struct task_struct *tsk,
 static void __die(const char *str, int err, struct thread_info *thread, struct pt_regs *regs)
 {
 	struct task_struct *tsk = thread->task;
-	static int die_counter;
 
 	printk("Internal error: %s: %x [#%d]\n", str, err, ++die_counter);
 	print_modules();
diff -puN arch/avr32/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/avr32/kernel/traps.c
@@ -24,8 +24,6 @@ static DEFINE_SPINLOCK(die_lock);
 
 void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
 {
-	static int die_counter;
-
 	console_verbose();
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
diff -puN arch/i386/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/i386/kernel/traps.c
@@ -438,7 +438,6 @@ void die(const char * str, struct pt_reg
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
-	static int die_counter;
 	unsigned long flags;
 
 	oops_enter();
diff -puN arch/ia64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/ia64/kernel/traps.c
--- a/arch/ia64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/ia64/kernel/traps.c
@@ -47,7 +47,6 @@ die (const char *str, struct pt_regs *re
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
-	static int die_counter;
 	int cpu = get_cpu();
 
 	if (die.lock_owner != cpu) {
diff -puN arch/mips/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/mips/kernel/traps.c
@@ -312,7 +312,6 @@ static DEFINE_SPINLOCK(die_lock);
 
 NORET_TYPE void ATTRIB_NORET die(const char * str, struct pt_regs * regs)
 {
-	static int die_counter;
 #ifdef CONFIG_MIPS_MT_SMTC
 	unsigned long dvpret = dvpe();
 #endif /* CONFIG_MIPS_MT_SMTC */
diff -puN arch/powerpc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/powerpc/kernel/traps.c
@@ -105,7 +105,6 @@ int die(const char *str, struct pt_regs 
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
-	static int die_counter;
 	unsigned long flags;
 
 	if (debugger(regs))
diff -puN arch/ppc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/ppc/kernel/traps.c
--- a/arch/ppc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/ppc/kernel/traps.c
@@ -76,7 +76,6 @@ DEFINE_SPINLOCK(die_lock);
 
 int die(const char * str, struct pt_regs * fp, long err)
 {
-	static int die_counter;
 	int nl = 0;
 	console_verbose();
 	spin_lock_irq(&die_lock);
diff -puN arch/s390/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/s390/kernel/traps.c
@@ -251,8 +251,6 @@ static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
-
 	debug_stop_all();
 	console_verbose();
 	spin_lock_irq(&die_lock);
diff -puN arch/sh/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/sh/kernel/traps.c
--- a/arch/sh/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/sh/kernel/traps.c
@@ -78,8 +78,6 @@ DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
-
 	console_verbose();
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
diff -puN arch/sparc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/sparc/kernel/traps.c
--- a/arch/sparc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/sparc/kernel/traps.c
@@ -89,7 +89,6 @@ void instruction_dump (unsigned long *pc
 
 void die_if_kernel(char *str, struct pt_regs *regs)
 {
-	static int die_counter;
 	int count = 0;
 
 	/* Amuse the user. */
diff -puN arch/sparc64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/sparc64/kernel/traps.c
--- a/arch/sparc64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/sparc64/kernel/traps.c
@@ -2209,7 +2209,6 @@ static inline struct reg_window *kernel_
 
 void die_if_kernel(char *str, struct pt_regs *regs)
 {
-	static int die_counter;
 	extern void smp_report_regs(void);
 	int count = 0;
 	
diff -puN arch/x86_64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/x86_64/kernel/traps.c
@@ -570,7 +570,6 @@ void __kprobes oops_end(unsigned long fl
 
 void __kprobes __die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
 	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff,++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
diff -puN arch/xtensa/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/xtensa/kernel/traps.c
@@ -465,7 +465,6 @@ DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
 	int nl = 0;
 
 	console_verbose();
diff -puN include/linux/kernel.h~report-that-kernel-is-tainted-if-there-were-an-oops-before include/linux/kernel.h
--- a/include/linux/kernel.h~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/include/linux/kernel.h
@@ -213,6 +213,7 @@ extern enum system_states {
 #define TAINT_USER			(1<<6)
 
 extern void dump_stack(void);
+extern int die_counter;
 
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
diff -puN kernel/panic.c~report-that-kernel-is-tainted-if-there-were-an-oops-before kernel/panic.c
--- a/kernel/panic.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/kernel/panic.c
@@ -150,23 +150,27 @@ EXPORT_SYMBOL(panic);
  *  'R' - User forced a module unload.
  *  'M' - Machine had a machine check experience.
  *  'B' - System has hit bad_page.
+ *  'D' - An OOPS or BUG has happened.
  *  'U' - Userspace-defined naughtiness.
  *
  *	The string is overwritten by the next call to print_taint().
  */
+
+int die_counter;
  
 const char *print_tainted(void)
 {
 	static char buf[20];
-	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c",
+	if (tainted || die_counter) {
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
 			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
  			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
 			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
-			tainted & TAINT_USER ? 'U' : ' ');
+			tainted & TAINT_USER ? 'U' : ' ',
+			die_counter ? 'D' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
introduce-a-handy-list_first_entry-macro-v2.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
