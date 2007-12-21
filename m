From: akpm@linux-foundation.org
Subject: + remove-fastcall-from-linux-include.patch added to -mm tree
Date: Thu, 20 Dec 2007 16:53:53 -0800
Message-ID: <200712210053.lBL0rrZe021998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbXLUAyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 19:54:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     Remove fastcall from linux/include
has been added to the -mm tree.  Its filename is
     remove-fastcall-from-linux-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove fastcall from linux/include
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h      |   16 ++++++++--------
 include/linux/kernel.h   |    2 +-
 include/linux/mutex.h    |   12 ++++++------
 include/linux/preempt.h  |    4 ++--
 include/linux/spinlock.h |    2 +-
 include/linux/timer.h    |    4 ++--
 6 files changed, 20 insertions(+), 20 deletions(-)

diff -puN include/linux/irq.h~remove-fastcall-from-linux-include include/linux/irq.h
--- a/include/linux/irq.h~remove-fastcall-from-linux-include
+++ a/include/linux/irq.h
@@ -25,7 +25,7 @@
 #include <asm/irq_regs.h>
 
 struct irq_desc;
-typedef	void fastcall (*irq_flow_handler_t)(unsigned int irq,
+typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
 
 
@@ -276,19 +276,19 @@ extern int handle_IRQ_event(unsigned int
  * Built-in IRQ handlers for various IRQ types,
  * callable via desc->chip->handle_irq()
  */
-extern void fastcall handle_level_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_edge_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_simple_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_bad_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 
 /*
  * Monolithic do_IRQ implementation.
  * (is an explicit fastcall, because i386 4KSTACKS calls it from assembly)
  */
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
-extern fastcall unsigned int __do_IRQ(unsigned int irq);
+extern unsigned int __do_IRQ(unsigned int irq);
 #endif
 
 /*
diff -puN include/linux/kernel.h~remove-fastcall-from-linux-include include/linux/kernel.h
--- a/include/linux/kernel.h~remove-fastcall-from-linux-include
+++ a/include/linux/kernel.h
@@ -133,7 +133,7 @@ NORET_TYPE void panic(const char * fmt, 
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-fastcall NORET_TYPE void do_exit(long error_code)
+NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
diff -puN include/linux/mutex.h~remove-fastcall-from-linux-include include/linux/mutex.h
--- a/include/linux/mutex.h~remove-fastcall-from-linux-include
+++ a/include/linux/mutex.h
@@ -112,7 +112,7 @@ extern void __mutex_init(struct mutex *l
  *
  * Returns 1 if the mutex is locked, 0 if unlocked.
  */
-static inline int fastcall mutex_is_locked(struct mutex *lock)
+static inline int mutex_is_locked(struct mutex *lock)
 {
 	return atomic_read(&lock->count) != 1;
 }
@@ -132,9 +132,9 @@ extern int __must_check mutex_lock_killa
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
 #else
-extern void fastcall mutex_lock(struct mutex *lock);
-extern int __must_check fastcall mutex_lock_interruptible(struct mutex *lock);
-extern int __must_check fastcall mutex_lock_killable(struct mutex *lock);
+extern void mutex_lock(struct mutex *lock);
+extern int __must_check mutex_lock_interruptible(struct mutex *lock);
+extern int __must_check mutex_lock_killable(struct mutex *lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
@@ -145,7 +145,7 @@ extern int __must_check fastcall mutex_l
  * NOTE: mutex_trylock() follows the spin_trylock() convention,
  *       not the down_trylock() convention!
  */
-extern int fastcall mutex_trylock(struct mutex *lock);
-extern void fastcall mutex_unlock(struct mutex *lock);
+extern int mutex_trylock(struct mutex *lock);
+extern void mutex_unlock(struct mutex *lock);
 
 #endif
diff -puN include/linux/preempt.h~remove-fastcall-from-linux-include include/linux/preempt.h
--- a/include/linux/preempt.h~remove-fastcall-from-linux-include
+++ a/include/linux/preempt.h
@@ -11,8 +11,8 @@
 #include <linux/list.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
-  extern void fastcall add_preempt_count(int val);
-  extern void fastcall sub_preempt_count(int val);
+  extern void add_preempt_count(int val);
+  extern void sub_preempt_count(int val);
 #else
 # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
 # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
diff -puN include/linux/spinlock.h~remove-fastcall-from-linux-include include/linux/spinlock.h
--- a/include/linux/spinlock.h~remove-fastcall-from-linux-include
+++ a/include/linux/spinlock.h
@@ -71,7 +71,7 @@
 #define LOCK_SECTION_END                        \
         ".previous\n\t"
 
-#define __lockfunc fastcall __attribute__((section(".spinlock.text")))
+#define __lockfunc __attribute__((section(".spinlock.text")))
 
 /*
  * Pull the raw_spinlock_t and raw_rwlock_t definitions:
diff -puN include/linux/timer.h~remove-fastcall-from-linux-include include/linux/timer.h
--- a/include/linux/timer.h~remove-fastcall-from-linux-include
+++ a/include/linux/timer.h
@@ -35,8 +35,8 @@ extern struct tvec_base boot_tvec_bases;
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
 
-void fastcall init_timer(struct timer_list * timer);
-void fastcall init_timer_deferrable(struct timer_list *timer);
+void init_timer(struct timer_list * timer);
+void init_timer_deferrable(struct timer_list *timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-net.patch
git-sh.patch
git-x86.patch
mm-remove-fastcall-from-mm.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
fs-remove-fastcall-it-is-always-empty.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include.patch
