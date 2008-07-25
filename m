From: akpm@linux-foundation.org
Subject: - locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:03 -0700
Message-ID: <200807252254.m6PMs3hi002779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbYGYWym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     locking: add typecheck on irqsave and friends for correct flags
has been removed from the -mm tree.  Its filename was
     locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: locking: add typecheck on irqsave and friends for correct flags
From: Steven Rostedt <rostedt@goodmis.org>

There haave been several areas in the kernel where an int has been used for
flags in local_irq_save() and friends instead of a long.  This can cause some
hard to debug problems on some architectures.

This patch adds a typecheck inside the irqsave and restore functions to flag
these cases.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: build fix]
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irqflags.h |   54 ++++++++++++++++++++-------
 include/linux/spinlock.h |   72 ++++++++++++++++++++++++++++---------
 2 files changed, 95 insertions(+), 31 deletions(-)

diff -puN include/linux/irqflags.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags include/linux/irqflags.h
--- a/include/linux/irqflags.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags
+++ a/include/linux/irqflags.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_TRACE_IRQFLAGS_H
 #define _LINUX_TRACE_IRQFLAGS_H
 
+#include <linux/typecheck.h>
+
 #ifdef CONFIG_TRACE_IRQFLAGS
   extern void trace_softirqs_on(unsigned long ip);
   extern void trace_softirqs_off(unsigned long ip);
@@ -58,18 +60,24 @@
 	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
 	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
-#define local_irq_save(flags) \
-	do { raw_local_irq_save(flags); trace_hardirqs_off(); } while (0)
+#define local_irq_save(flags)				\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		raw_local_irq_save(flags);		\
+		trace_hardirqs_off();			\
+	} while (0)
 
-#define local_irq_restore(flags)				\
-	do {							\
-		if (raw_irqs_disabled_flags(flags)) {		\
-			raw_local_irq_restore(flags);		\
-			trace_hardirqs_off();			\
-		} else {					\
-			trace_hardirqs_on();			\
-			raw_local_irq_restore(flags);		\
-		}						\
+
+#define local_irq_restore(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		if (raw_irqs_disabled_flags(flags)) {	\
+			raw_local_irq_restore(flags);	\
+			trace_hardirqs_off();		\
+		} else {				\
+			trace_hardirqs_on();		\
+			raw_local_irq_restore(flags);	\
+		}					\
 	} while (0)
 #else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
 /*
@@ -78,8 +86,16 @@
  */
 # define raw_local_irq_disable()	local_irq_disable()
 # define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)	local_irq_save(flags)
-# define raw_local_irq_restore(flags)	local_irq_restore(flags)
+# define raw_local_irq_save(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		local_irq_save(flags);			\
+	} while (0)
+# define raw_local_irq_restore(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		local_irq_restore(flags);		\
+	} while (0)
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
@@ -89,7 +105,11 @@
 		raw_safe_halt();				\
 	} while (0)
 
-#define local_save_flags(flags)		raw_local_save_flags(flags)
+#define local_save_flags(flags)				\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		raw_local_save_flags(flags);		\
+	} while (0)
 
 #define irqs_disabled()						\
 ({								\
@@ -99,7 +119,11 @@
 	raw_irqs_disabled_flags(_flags);			\
 })
 
-#define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
+#define irqs_disabled_flags(flags)		\
+({						\
+	typecheck(unsigned long, flags);	\
+	raw_irqs_disabled_flags(flags);		\
+})
 #endif		/* CONFIG_X86 */
 
 #endif
diff -puN include/linux/spinlock.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags include/linux/spinlock.h
--- a/include/linux/spinlock.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags
+++ a/include/linux/spinlock.h
@@ -46,6 +46,7 @@
  *  linux/spinlock.h:     builds the final spin_*() APIs.
  */
 
+#include <linux/typecheck.h>
 #include <linux/preempt.h>
 #include <linux/linkage.h>
 #include <linux/compiler.h>
@@ -191,23 +192,53 @@ do {								\
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 
-#define spin_lock_irqsave(lock, flags)	flags = _spin_lock_irqsave(lock)
-#define read_lock_irqsave(lock, flags)	flags = _read_lock_irqsave(lock)
-#define write_lock_irqsave(lock, flags)	flags = _write_lock_irqsave(lock)
+#define spin_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _spin_lock_irqsave(lock);	\
+	} while (0)
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _read_lock_irqsave(lock);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _write_lock_irqsave(lock);	\
+	} while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define spin_lock_irqsave_nested(lock, flags, subclass) \
-	flags = _spin_lock_irqsave_nested(lock, subclass)
+#define spin_lock_irqsave_nested(lock, flags, subclass)			\
+	do {								\
+		typecheck(unsigned long, flags);			\
+		flags = _spin_lock_irqsave_nested(lock, subclass);	\
+	} while (0)
 #else
-#define spin_lock_irqsave_nested(lock, flags, subclass) \
-	flags = _spin_lock_irqsave(lock)
+#define spin_lock_irqsave_nested(lock, flags, subclass)			\
+	do {								\
+		typecheck(unsigned long, flags);			\
+		flags = _spin_lock_irqsave(lock);			\
+	} while (0)
 #endif
 
 #else
 
-#define spin_lock_irqsave(lock, flags)	_spin_lock_irqsave(lock, flags)
-#define read_lock_irqsave(lock, flags)	_read_lock_irqsave(lock, flags)
-#define write_lock_irqsave(lock, flags)	_write_lock_irqsave(lock, flags)
+#define spin_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_spin_lock_irqsave(lock, flags);	\
+	} while (0)
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_read_lock_irqsave(lock, flags);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_write_lock_irqsave(lock, flags);	\
+	} while (0)
 #define spin_lock_irqsave_nested(lock, flags, subclass)	\
 	spin_lock_irqsave(lock, flags)
 
@@ -260,16 +291,25 @@ do {						\
 } while (0)
 #endif
 
-#define spin_unlock_irqrestore(lock, flags) \
-					_spin_unlock_irqrestore(lock, flags)
+#define spin_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_spin_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define spin_unlock_bh(lock)		_spin_unlock_bh(lock)
 
-#define read_unlock_irqrestore(lock, flags) \
-					_read_unlock_irqrestore(lock, flags)
+#define read_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_read_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define read_unlock_bh(lock)		_read_unlock_bh(lock)
 
-#define write_unlock_irqrestore(lock, flags) \
-					_write_unlock_irqrestore(lock, flags)
+#define write_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_write_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define write_unlock_bh(lock)		_write_unlock_bh(lock)
 
 #define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch

