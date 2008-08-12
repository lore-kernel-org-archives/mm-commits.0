From: akpm@linux-foundation.org
Subject: + container-freezer-make-refrigerator-always-available.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:56:35 -0700
Message-ID: <200808122256.m7CMuZe7017882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYHLW5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:57:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com, clg@fr.ibm.com, rjw@sisk.pl, serue@us.ibm.com


The patch titled
     container freezer: make refrigerator always available
has been added to the -mm tree.  Its filename is
     container-freezer-make-refrigerator-always-available.patch

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
Subject: container freezer: make refrigerator always available
From: Matt Helsley <matthltc@us.ibm.com>

Now that the TIF_FREEZE flag is available in all architectures, extract
the refrigerator() and freeze_task() from kernel/power/process.c and make
it available to all.

The refrigerator() can now be used in a control group subsystem
implementing a control group freezer.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |   14 +++-
 kernel/Makefile         |    1 
 kernel/freezer.c        |  122 ++++++++++++++++++++++++++++++++++++++
 kernel/power/Kconfig    |    3 
 kernel/power/process.c  |  116 ------------------------------------
 5 files changed, 137 insertions(+), 119 deletions(-)

diff -puN include/linux/freezer.h~container-freezer-make-refrigerator-always-available include/linux/freezer.h
--- a/include/linux/freezer.h~container-freezer-make-refrigerator-always-available
+++ a/include/linux/freezer.h
@@ -6,7 +6,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_FREEZER
 /*
  * Check if a process has been frozen
  */
@@ -39,6 +39,11 @@ static inline void clear_freeze_flag(str
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
+static inline bool should_send_signal(struct task_struct *p)
+{
+	return !(p->flags & PF_FREEZER_NOSIG);
+}
+
 /*
  * Wake up a frozen process
  *
@@ -75,6 +80,9 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
+extern bool freeze_task(struct task_struct *p, bool sig_only);
+extern void cancel_freezing(struct task_struct *p);
+
 /*
  * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
  * calls wait_for_completion(&vfork) and reset right after it returns from this
@@ -166,7 +174,7 @@ static inline void set_freezable_with_si
 	} while (try_to_freeze());					\
 	__retval;							\
 })
-#else /* !CONFIG_PM_SLEEP */
+#else /* !CONFIG_FREEZER */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
@@ -191,6 +199,6 @@ static inline void set_freezable_with_si
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 		wait_event_interruptible_timeout(wq, condition, timeout)
 
-#endif /* !CONFIG_PM_SLEEP */
+#endif /* !CONFIG_FREEZER */
 
 #endif	/* FREEZER_H_INCLUDED */
diff -puN kernel/Makefile~container-freezer-make-refrigerator-always-available kernel/Makefile
--- a/kernel/Makefile~container-freezer-make-refrigerator-always-available
+++ a/kernel/Makefile
@@ -24,6 +24,7 @@ CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
+obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff -puN /dev/null kernel/freezer.c
--- /dev/null
+++ a/kernel/freezer.c
@@ -0,0 +1,122 @@
+/*
+ * kernel/freezer.c - Function to freeze a process
+ *
+ * Originally from kernel/power/process.c
+ */
+
+#include <linux/interrupt.h>
+#include <linux/suspend.h>
+#include <linux/module.h>
+#include <linux/syscalls.h>
+#include <linux/freezer.h>
+
+/*
+ * freezing is complete, mark current process as frozen
+ */
+static inline void frozen_process(void)
+{
+	if (!unlikely(current->flags & PF_NOFREEZE)) {
+		current->flags |= PF_FROZEN;
+		wmb();
+	}
+	clear_freeze_flag(current);
+}
+
+/* Refrigerator is place where frozen processes are stored :-). */
+void refrigerator(void)
+{
+	/* Hmm, should we be allowed to suspend when there are realtime
+	   processes around? */
+	long save;
+
+	task_lock(current);
+	if (freezing(current)) {
+		frozen_process();
+		task_unlock(current);
+	} else {
+		task_unlock(current);
+		return;
+	}
+	save = current->state;
+	pr_debug("%s entered refrigerator\n", current->comm);
+
+	spin_lock_irq(&current->sighand->siglock);
+	recalc_sigpending(); /* We sent fake signal, clean it up */
+	spin_unlock_irq(&current->sighand->siglock);
+
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!frozen(current))
+			break;
+		schedule();
+	}
+	pr_debug("%s left refrigerator\n", current->comm);
+	__set_current_state(save);
+}
+EXPORT_SYMBOL(refrigerator);
+
+static void fake_signal_wake_up(struct task_struct *p)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->sighand->siglock, flags);
+	signal_wake_up(p, 0);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+}
+
+/**
+ *	freeze_task - send a freeze request to given task
+ *	@p: task to send the request to
+ *	@sig_only: if set, the request will only be sent if the task has the
+ *		PF_FREEZER_NOSIG flag unset
+ *	Return value: 'false', if @sig_only is set and the task has
+ *		PF_FREEZER_NOSIG set or the task is frozen, 'true', otherwise
+ *
+ *	The freeze request is sent by setting the tasks's TIF_FREEZE flag and
+ *	either sending a fake signal to it or waking it up, depending on whether
+ *	or not it has PF_FREEZER_NOSIG set.  If @sig_only is set and the task
+ *	has PF_FREEZER_NOSIG set (ie. it is a typical kernel thread), its
+ *	TIF_FREEZE flag will not be set.
+ */
+bool freeze_task(struct task_struct *p, bool sig_only)
+{
+	/*
+	 * We first check if the task is freezing and next if it has already
+	 * been frozen to avoid the race with frozen_process() which first marks
+	 * the task as frozen and next clears its TIF_FREEZE.
+	 */
+	if (!freezing(p)) {
+		rmb();
+		if (frozen(p))
+			return false;
+
+		if (!sig_only || should_send_signal(p))
+			set_freeze_flag(p);
+		else
+			return false;
+	}
+
+	if (should_send_signal(p)) {
+		if (!signal_pending(p))
+			fake_signal_wake_up(p);
+	} else if (sig_only) {
+		return false;
+	} else {
+		wake_up_state(p, TASK_INTERRUPTIBLE);
+	}
+
+	return true;
+}
+
+void cancel_freezing(struct task_struct *p)
+{
+	unsigned long flags;
+
+	if (freezing(p)) {
+		pr_debug("  clean up: %s\n", p->comm);
+		clear_freeze_flag(p);
+		spin_lock_irqsave(&p->sighand->siglock, flags);
+		recalc_sigpending_and_wake(p);
+		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	}
+}
diff -puN kernel/power/Kconfig~container-freezer-make-refrigerator-always-available kernel/power/Kconfig
--- a/kernel/power/Kconfig~container-freezer-make-refrigerator-always-available
+++ a/kernel/power/Kconfig
@@ -85,6 +85,9 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 	default y
 
+config FREEZER
+	def_bool PM_SLEEP
+
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM && ARCH_SUSPEND_POSSIBLE
diff -puN kernel/power/process.c~container-freezer-make-refrigerator-always-available kernel/power/process.c
--- a/kernel/power/process.c~container-freezer-make-refrigerator-always-available
+++ a/kernel/power/process.c
@@ -28,121 +28,6 @@ static inline int freezeable(struct task
 	return 1;
 }
 
-/*
- * freezing is complete, mark current process as frozen
- */
-static inline void frozen_process(void)
-{
-	if (!unlikely(current->flags & PF_NOFREEZE)) {
-		current->flags |= PF_FROZEN;
-		wmb();
-	}
-	clear_freeze_flag(current);
-}
-
-/* Refrigerator is place where frozen processes are stored :-). */
-void refrigerator(void)
-{
-	/* Hmm, should we be allowed to suspend when there are realtime
-	   processes around? */
-	long save;
-
-	task_lock(current);
-	if (freezing(current)) {
-		frozen_process();
-		task_unlock(current);
-	} else {
-		task_unlock(current);
-		return;
-	}
-	save = current->state;
-	pr_debug("%s entered refrigerator\n", current->comm);
-
-	spin_lock_irq(&current->sighand->siglock);
-	recalc_sigpending(); /* We sent fake signal, clean it up */
-	spin_unlock_irq(&current->sighand->siglock);
-
-	for (;;) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!frozen(current))
-			break;
-		schedule();
-	}
-	pr_debug("%s left refrigerator\n", current->comm);
-	__set_current_state(save);
-}
-
-static void fake_signal_wake_up(struct task_struct *p)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 0);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-}
-
-static inline bool should_send_signal(struct task_struct *p)
-{
-	return !(p->flags & PF_FREEZER_NOSIG);
-}
-
-/**
- *	freeze_task - send a freeze request to given task
- *	@p: task to send the request to
- *	@sig_only: if set, the request will only be sent if the task has the
- *		PF_FREEZER_NOSIG flag unset
- *	Return value: 'false', if @sig_only is set and the task has
- *		PF_FREEZER_NOSIG set or the task is frozen, 'true', otherwise
- *
- *	The freeze request is sent by setting the tasks's TIF_FREEZE flag and
- *	either sending a fake signal to it or waking it up, depending on whether
- *	or not it has PF_FREEZER_NOSIG set.  If @sig_only is set and the task
- *	has PF_FREEZER_NOSIG set (ie. it is a typical kernel thread), its
- *	TIF_FREEZE flag will not be set.
- */
-static bool freeze_task(struct task_struct *p, bool sig_only)
-{
-	/*
-	 * We first check if the task is freezing and next if it has already
-	 * been frozen to avoid the race with frozen_process() which first marks
-	 * the task as frozen and next clears its TIF_FREEZE.
-	 */
-	if (!freezing(p)) {
-		rmb();
-		if (frozen(p))
-			return false;
-
-		if (!sig_only || should_send_signal(p))
-			set_freeze_flag(p);
-		else
-			return false;
-	}
-
-	if (should_send_signal(p)) {
-		if (!signal_pending(p))
-			fake_signal_wake_up(p);
-	} else if (sig_only) {
-		return false;
-	} else {
-		wake_up_state(p, TASK_INTERRUPTIBLE);
-	}
-
-	return true;
-}
-
-static void cancel_freezing(struct task_struct *p)
-{
-	unsigned long flags;
-
-	if (freezing(p)) {
-		pr_debug("  clean up: %s\n", p->comm);
-		clear_freeze_flag(p);
-		spin_lock_irqsave(&p->sighand->siglock, flags);
-		recalc_sigpending_and_wake(p);
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	}
-}
