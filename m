From: akpm@linux-foundation.org
Subject: + kprobes-introduce-kprobe_handle_fault.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:29 -0800
Message-ID: <200802230735.m1N7ZH07018351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758375AbYBWIGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:06:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, mhiramat@redhat.com, mingo@elte.hu, paulus@samba.org, prasanna@in.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     kprobes: introduce kprobe_handle_fault()
has been added to the -mm tree.  Its filename is
     kprobes-introduce-kprobe_handle_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: introduce kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>

Use a central kprobe_handle_fault() inline in kprobes.h to remove all of the
arch-dependant, practically identical implementations in avr32, ia64, powerpc,
s390, sparc64, and x86.

avr32 was the only arch without the preempt_disable/enable pair in its
notify_page_fault implementation.

This uncovered a possible bug in the s390 version as that purely copied the
x86 version unconditionally passing 14 as the trapnr rather than the
error_code parameter.  s390 is changed to pass error_code in this patch.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c     |   25 +------------------------
 arch/avr32/mm/fault.c   |   21 +--------------------
 arch/ia64/mm/fault.c    |   24 +-----------------------
 arch/powerpc/mm/fault.c |   25 +------------------------
 arch/s390/mm/fault.c    |   25 +------------------------
 arch/sparc64/mm/fault.c |   23 +----------------------
 arch/x86/mm/fault.c     |   26 ++------------------------
 include/linux/kprobes.h |   20 ++++++++++++++++++++
 8 files changed, 28 insertions(+), 161 deletions(-)

diff -puN arch/arm/mm/fault.c~kprobes-introduce-kprobe_handle_fault arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~kprobes-introduce-kprobe_handle_fault
+++ a/arch/arm/mm/fault.c
@@ -21,29 +21,6 @@
 
 #include "fault.h"
 
-
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, unsigned int fsr)
-{
-	int ret = 0;
-
-	if (!user_mode(regs)) {
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, fsr))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, unsigned int fsr)
-{
-	return 0;
-}
-#endif
-
 /*
  * This is useful to dump out the page tables associated with
  * 'addr' in mm 'mm'.
@@ -246,7 +223,7 @@ do_page_fault(unsigned long addr, unsign
 	struct mm_struct *mm;
 	int fault, sig, code;
 
-	if (notify_page_fault(regs, fsr))
+	if (handle_kprobe_fault(regs, fsr))
 		return 0;
 
 	tsk = current;
diff -puN arch/avr32/mm/fault.c~kprobes-introduce-kprobe_handle_fault arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~kprobes-introduce-kprobe_handle_fault
+++ a/arch/avr32/mm/fault.c
@@ -20,25 +20,6 @@
 #include <asm/tlb.h>
 #include <asm/uaccess.h>
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	int ret = 0;
-
-	if (!user_mode(regs)) {
-		if (kprobe_running() && kprobe_fault_handler(regs, trap))
-			ret = 1;
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	return 0;
-}
-#endif
-
 int exception_trace = 1;
 
 /*
@@ -66,7 +47,7 @@ asmlinkage void do_page_fault(unsigned l
 	int code;
 	int fault;
 
-	if (notify_page_fault(regs, ecr))
+	if (kprobe_handle_fault(regs, ecr))
 		return;
 
 	address = sysreg_read(TLBEAR);
diff -puN arch/ia64/mm/fault.c~kprobes-introduce-kprobe_handle_fault arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~kprobes-introduce-kprobe_handle_fault
+++ a/arch/ia64/mm/fault.c
@@ -18,28 +18,6 @@
 
 extern int die(char *, struct pt_regs *, long);
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	int ret = 0;
-
-	if (!user_mode(regs)) {
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() && kprobes_fault_handler(regs, trap))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, int trap)
-{
-	return 0;
-}
-#endif
-
 /*
  * Return TRUE if ADDRESS points at a page in the kernel's mapped segment
  * (inside region 5, on ia64) and that page is present.
@@ -106,7 +84,7 @@ ia64_do_page_fault (unsigned long addres
 	/*
 	 * This is to handle the kprobes on user space access instructions
 	 */
-	if (notify_page_fault(regs, TRAP_BRKPT))
+	if (kprobe_handle_fault(regs, TRAP_BRKPT))
 		return;
 
 	down_read(&mm->mmap_sem);
diff -puN arch/powerpc/mm/fault.c~kprobes-introduce-kprobe_handle_fault arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~kprobes-introduce-kprobe_handle_fault
+++ a/arch/powerpc/mm/fault.c
@@ -39,29 +39,6 @@
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
 
-
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 11))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	return 0;
-}
-#endif
-
 /*
  * Check whether the instruction at regs->nip is a store using
  * an update addressing form which will update r1.
@@ -164,7 +141,7 @@ int __kprobes do_page_fault(struct pt_re
 	is_write = error_code & ESR_DST;
 #endif /* CONFIG_4xx || CONFIG_BOOKE */
 
-	if (notify_page_fault(regs))
+	if (kprobe_handle_fault(regs, 11))
 		return 0;
 
 	if (unlikely(debugger_fault_handler(regs)))
diff -puN arch/s390/mm/fault.c~kprobes-introduce-kprobe_handle_fault arch/s390/mm/fault.c
--- a/arch/s390/mm/fault.c~kprobes-introduce-kprobe_handle_fault
+++ a/arch/s390/mm/fault.c
@@ -52,29 +52,6 @@ extern int sysctl_userprocess_debug;
 
 extern void die(const char *,struct pt_regs *,long);
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs, long err)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs, long err)
-{
-	return 0;
-}
-#endif
-
-
 /*
  * Unlock any spinlocks which will prevent us from getting the
  * message out.
@@ -310,7 +287,7 @@ do_exception(struct pt_regs *regs, unsig
 	int si_code;
 	int fault;
 
-	if (notify_page_fault(regs, error_code))
+	if (kprobe_handle_fault(regs, error_code))
 		return;
 
 	tsk = current;
diff -puN arch/sparc64/mm/fault.c~kprobes-introduce-kprobe_handle_fault arch/sparc64/mm/fault.c
--- a/arch/sparc64/mm/fault.c~kprobes-introduce-kprobe_handle_fault
+++ a/arch/sparc64/mm/fault.c
@@ -31,27 +31,6 @@
 #include <asm/sections.h>
 #include <asm/mmu_context.h>
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 0))
-			ret = 1;
-		preempt_enable();
-	}
-	return ret;
-}
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-	return 0;
-}
-#endif
-
 /*
  * To debug kernel to catch accesses to certain virtual/physical addresses.
  * Mode = 0 selects physical watchpoints, mode = 1 selects virtual watchpoints.
@@ -280,7 +259,7 @@ asmlinkage void __kprobes do_sparc64_fau
 
 	fault_code = get_thread_fault_code();
 
-	if (notify_page_fault(regs))
+	if (kprobe_handle_fault(regs, 0))
 		return;
 
 	si_code = SEGV_MAPERR;
diff -puN arch/x86/mm/fault.c~kprobes-introduce-kprobe_handle_fault arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~kprobes-introduce-kprobe_handle_fault
+++ a/arch/x86/mm/fault.c
@@ -49,29 +49,6 @@
 #define PF_RSVD		(1<<3)
 #define PF_INSTR	(1<<4)
 
-static inline int notify_page_fault(struct pt_regs *regs)
-{
-#ifdef CONFIG_KPROBES
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-#ifdef CONFIG_X86_32
-	if (!user_mode_vm(regs)) {
-#else
-	if (!user_mode(regs)) {
-#endif
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-#else
-	return 0;
-#endif
-}
-
 /*
  * X86_32
  * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
@@ -601,7 +578,8 @@ void __kprobes do_page_fault(struct pt_r
 
 	si_code = SEGV_MAPERR;
 
-	if (notify_page_fault(regs))
+	/* Must not try to handle kprobes in v8086 mode */
+	if (!v8086_mode(regs) && kprobe_handle_fault(regs, 14))
 		return;
 
 	/*
diff -puN include/linux/kprobes.h~kprobes-introduce-kprobe_handle_fault include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-introduce-kprobe_handle_fault
+++ a/include/linux/kprobes.h
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/hardirq.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -215,6 +216,21 @@ static inline struct kprobe *kprobe_runn
 	return (__get_cpu_var(current_kprobe));
 }
 
+static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
+{
+	int ret = 0;
+
+	/* kprobe_running() needs smp_processor_id() */
+	if (!user_mode(regs)) {
+		preempt_disable();
+		if (kprobe_running() && kprobe_fault_handler(regs, trapnr))
+			ret = 1;
+		preempt_enable();
+	}
+
+	return ret;
+}
+
 static inline void reset_current_kprobe(void)
 {
 	__get_cpu_var(current_kprobe) = NULL;
@@ -250,6 +266,10 @@ static inline struct kprobe *kprobe_runn
 {
 	return NULL;
 }
+static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
+{
+	return 0;
+}
 static inline int register_kprobe(struct kprobe *p)
 {
 	return -ENOSYS;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
markers-fix-sparse-warnings-in-markersc.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
