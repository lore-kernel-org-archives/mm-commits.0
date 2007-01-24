From: akpm@osdl.org
Subject: + consolidate-bust_spinlocks.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:28:58 -0800
Message-ID: <200701240728.l0O7SwxE011622@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128AbXAXH3s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:29:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dev@sw.ru, adobriyan@openvz.org, ak@muc.de, schwidefsky@de.ibm.com, takata@linux-m32r.org, tony.luck@intel.com


The patch titled
     Consolidate bust_spinlocks()
has been added to the -mm tree.  Its filename is
     consolidate-bust_spinlocks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Consolidate bust_spinlocks()
From: Kirill Korotaev <dev@sw.ru>

Part of long forgotten patch
http://groups.google.com/group/fa.linux.kernel/msg/e98e941ce1cf29f6?dmode=source
Since then, m32r grabbed two copies.

Leave s390 copy because of important absence of CONFIG_VT, but remove
references to non-existent timerlist_lock.  ia64 also loses timerlist_lock.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andi Kleen <ak@muc.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/fault.c       |   26 --------------------------
 arch/ia64/kernel/traps.c   |   30 ------------------------------
 arch/m32r/mm/fault-nommu.c |   26 --------------------------
 arch/m32r/mm/fault.c       |   26 --------------------------
 arch/s390/mm/fault.c       |    4 +---
 arch/x86_64/mm/fault.c     |   21 ---------------------
 lib/Makefile               |    4 ++--
 lib/bust_spinlocks.c       |    2 +-
 8 files changed, 4 insertions(+), 135 deletions(-)

diff -puN arch/i386/mm/fault.c~consolidate-bust_spinlocks arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~consolidate-bust_spinlocks
+++ a/arch/i386/mm/fault.c
@@ -60,32 +60,6 @@ static inline int notify_page_fault(stru
 }
 
 /*
- * Unlock any spinlocks which will prevent us from getting the
- * message out 
- */
-void bust_spinlocks(int yes)
-{
-	int loglevel_save = console_loglevel;
-
-	if (yes) {
-		oops_in_progress = 1;
-		return;
-	}
-#ifdef CONFIG_VT
-	unblank_screen();
-#endif
-	oops_in_progress = 0;
-	/*
-	 * OK, the message is on the console.  Now we call printk()
-	 * without oops_in_progress set so that printk will give klogd
-	 * a poke.  Hold onto your hats...
-	 */
-	console_loglevel = 15;		/* NMI oopser may have shut the console up */
-	printk(" ");
-	console_loglevel = loglevel_save;
-}
-
-/*
  * Return EIP plus the CS segment base.  The segment limit is also
  * adjusted, clamped to the kernel/user address space (whichever is
  * appropriate), and returned in *eip_limit.
diff -puN arch/ia64/kernel/traps.c~consolidate-bust_spinlocks arch/ia64/kernel/traps.c
--- a/arch/ia64/kernel/traps.c~consolidate-bust_spinlocks
+++ a/arch/ia64/kernel/traps.c
@@ -24,8 +24,6 @@
 #include <asm/uaccess.h>
 #include <asm/kdebug.h>
 
-extern spinlock_t timerlist_lock;
-
 fpswa_interface_t *fpswa_interface;
 EXPORT_SYMBOL(fpswa_interface);
 
@@ -53,34 +51,6 @@ trap_init (void)
 		fpswa_interface = __va(ia64_boot_param->fpswa);
 }
 
-/*
- * Unlock any spinlocks which will prevent us from getting the message out (timerlist_lock
- * is acquired through the console unblank code)
- */
-void
-bust_spinlocks (int yes)
-{
-	int loglevel_save = console_loglevel;
-
-	if (yes) {
-		oops_in_progress = 1;
-		return;
-	}
-
-#ifdef CONFIG_VT
-	unblank_screen();
-#endif
-	oops_in_progress = 0;
-	/*
-	 * OK, the message is on the console.  Now we call printk() without
-	 * oops_in_progress set so that printk will give klogd a poke.  Hold onto
-	 * your hats...
-	 */
-	console_loglevel = 15;		/* NMI oopser may have shut the console up */
-	printk(" ");
-	console_loglevel = loglevel_save;
-}
-
 void
 die (const char *str, struct pt_regs *regs, long err)
 {
diff -puN arch/m32r/mm/fault.c~consolidate-bust_spinlocks arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~consolidate-bust_spinlocks
+++ a/arch/m32r/mm/fault.c
@@ -49,32 +49,6 @@ unsigned int tlb_entry_d_dat[NR_CPUS];
 
 extern void init_tlb(void);
 
-/*
- * Unlock any spinlocks which will prevent us from getting the
- * message out
- */
-void bust_spinlocks(int yes)
-{
-	int loglevel_save = console_loglevel;
-
-	if (yes) {
-		oops_in_progress = 1;
-		return;
-	}
-#ifdef CONFIG_VT
-	unblank_screen();
-#endif
-	oops_in_progress = 0;
-	/*
-	 * OK, the message is on the console.  Now we call printk()
-	 * without oops_in_progress set so that printk will give klogd
-	 * a poke.  Hold onto your hats...
-	 */
-	console_loglevel = 15;		/* NMI oopser may have shut the console up */
-	printk(" ");
-	console_loglevel = loglevel_save;
-}
-
 /*======================================================================*
  * do_page_fault()
  *======================================================================*
diff -puN arch/m32r/mm/fault-nommu.c~consolidate-bust_spinlocks arch/m32r/mm/fault-nommu.c
--- a/arch/m32r/mm/fault-nommu.c~consolidate-bust_spinlocks
+++ a/arch/m32r/mm/fault-nommu.c
@@ -44,32 +44,6 @@ unsigned int tlb_entry_d_dat[NR_CPUS];
 #define tlb_entry_d tlb_entry_d_dat[smp_processor_id()]
 #endif
 
-/*
- * Unlock any spinlocks which will prevent us from getting the
- * message out
- */
-void bust_spinlocks(int yes)
-{
-	int loglevel_save = console_loglevel;
-
-	if (yes) {
-		oops_in_progress = 1;
-		return;
-	}
-#ifdef CONFIG_VT
-	unblank_screen();
-#endif
-	oops_in_progress = 0;
-	/*
-	 * OK, the message is on the console.  Now we call printk()
-	 * without oops_in_progress set so that printk will give klogd
-	 * a poke.  Hold onto your hats...
-	 */
-	console_loglevel = 15;	/* NMI oopser may have shut the console up */
-	printk(" ");
-	console_loglevel = loglevel_save;
-}
-
 void do_BUG(const char *file, int line)
 {
 	bust_spinlocks(1);
diff -puN arch/s390/mm/fault.c~consolidate-bust_spinlocks arch/s390/mm/fault.c
--- a/arch/s390/mm/fault.c~consolidate-bust_spinlocks
+++ a/arch/s390/mm/fault.c
@@ -83,12 +83,10 @@ static inline int notify_page_fault(enum
 }
 #endif
 
-extern spinlock_t timerlist_lock;
 
 /*
  * Unlock any spinlocks which will prevent us from getting the
- * message out (timerlist_lock is acquired through the
- * console unblank code)
+ * message out.
  */
 void bust_spinlocks(int yes)
 {
diff -puN arch/x86_64/mm/fault.c~consolidate-bust_spinlocks arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~consolidate-bust_spinlocks
+++ a/arch/x86_64/mm/fault.c
@@ -69,27 +69,6 @@ static inline int notify_page_fault(stru
 	                                  DIE_PAGE_FAULT, &args);
 }
 
-void bust_spinlocks(int yes)
-{
-	int loglevel_save = console_loglevel;
-	if (yes) {
-		oops_in_progress = 1;
-	} else {
-#ifdef CONFIG_VT
-		unblank_screen();
-#endif
-		oops_in_progress = 0;
-		/*
-		 * OK, the message is on the console.  Now we call printk()
-		 * without oops_in_progress set so that printk will give klogd
-		 * a poke.  Hold onto your hats...
-		 */
-		console_loglevel = 15;		/* NMI oopser may have shut the console up */
-		printk(" ");
-		console_loglevel = loglevel_save;
-	}
-}
-
 /* Sometimes the CPU reports invalid exceptions on prefetch.
    Check that here and ignore.
    Opcode checker based on code by Richard Brunner */
diff -puN lib/bust_spinlocks.c~consolidate-bust_spinlocks lib/bust_spinlocks.c
--- a/lib/bust_spinlocks.c~consolidate-bust_spinlocks
+++ a/lib/bust_spinlocks.c
@@ -14,7 +14,7 @@
 #include <linux/vt_kern.h>
 
 
-void bust_spinlocks(int yes)
+void __attribute__((weak)) bust_spinlocks(int yes)
 {
 	if (yes) {
 		oops_in_progress = 1;
diff -puN lib/Makefile~consolidate-bust_spinlocks lib/Makefile
--- a/lib/Makefile~consolidate-bust_spinlocks
+++ a/lib/Makefile
@@ -3,7 +3,7 @@
 #
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
-	 bust_spinlocks.o rbtree.o radix-tree.o dump_stack.o \
+	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o div64.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o
 
@@ -12,7 +12,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
-obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o
+obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o bust_spinlocks.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
_

Patches currently in -mm which might be from dev@sw.ru are

consolidate-bust_spinlocks.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
