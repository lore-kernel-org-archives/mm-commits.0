From: akpm@linux-foundation.org
Subject: + locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch added to -mm tree
Date: Thu, 01 May 2008 17:28:14 -0700
Message-ID: <200805020028.m420SElK000900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932237AbYEBA3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 20:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, srostedt@redhat.com


The patch titled
     locking: add typecheck on irqsave and friends for correct flags
has been added to the -mm tree.  Its filename is
     locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch

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
Subject: locking: add typecheck on irqsave and friends for correct flags
From: Steven Rostedt <rostedt@goodmis.org>

There haave been several areas in the kernel where an int has been used for
flags in local_irq_save() and friends instead of a long.  This can cause some
hard to debug problems on some architectures.

This patch adds a typecheck inside the irqsave and restore functions to flag
these cases.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irqflags.h |   52 +++++++++++++++++++--------
 include/linux/spinlock.h |   71 ++++++++++++++++++++++++++++---------
 2 files changed, 92 insertions(+), 31 deletions(-)

diff -puN include/linux/irqflags.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags include/linux/irqflags.h
--- a/include/linux/irqflags.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags
+++ a/include/linux/irqflags.h
@@ -58,18 +58,24 @@
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
@@ -78,8 +84,16 @@
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
@@ -89,7 +103,11 @@
 		raw_safe_halt();				\
 	} while (0)
 
-#define local_save_flags(flags)		raw_local_save_flags(flags)
+#define local_save_flags(flags)				\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		raw_local_save_flags(flags);		\
+	} while(0)
 
 #define irqs_disabled()						\
 ({								\
@@ -99,7 +117,11 @@
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
@@ -191,23 +191,53 @@ do {								\
 
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
 
@@ -260,16 +290,25 @@ do {						\
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
9p-use-correct-type-for-processor-flags.patch
fix-irq-flags-in-mac80211-code.patch
fix-irq-flags-in-saa7134.patch
fix-irq-flags-in-rtc-ds1511.patch
fix-irq-flags-for-iuu_phoenixc.patch
git-sched.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch

