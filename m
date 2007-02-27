From: akpm@linux-foundation.org
Subject: + kconfig-centralize-the-selection-of-semaphore-debugging.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:56 -0800
Message-ID: <200702272059.l1RKx0pr028412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52000 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXB0U7Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, dhowells@redhat.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     kconfig: centralize the selection of semaphore debugging in lib/Kconfig.debug
has been added to the -mm tree.  Its filename is
     kconfig-centralize-the-selection-of-semaphore-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kconfig: centralize the selection of semaphore debugging in lib/Kconfig.debug
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the Kconfig selection of semaphore debugging from the ALPHA and FRV
Kconfig files, and centralize it in lib/Kconfig.debug.

There doesn't seem to be much point in letting individual architectures
independently define the same Kconfig option when it can just as easily be
put in a single Kconfig file and made dependent on a subset of
architectures.  that way, at least the option shows up in the same relative
location in the menu each time.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig.debug    |    8 --------
 arch/frv/kernel/semaphore.c |    2 +-
 include/asm-frv/semaphore.h |   14 ++++++--------
 lib/Kconfig.debug           |   10 ++++++++++
 4 files changed, 17 insertions(+), 17 deletions(-)

diff -puN arch/alpha/Kconfig.debug~kconfig-centralize-the-selection-of-semaphore-debugging arch/alpha/Kconfig.debug
--- a/arch/alpha/Kconfig.debug~kconfig-centralize-the-selection-of-semaphore-debugging
+++ a/arch/alpha/Kconfig.debug
@@ -16,14 +16,6 @@ config DEBUG_RWLOCK
 	  too many attempts.  If you suspect a rwlock problem or a kernel
 	  hacker asks for this option then say Y.  Otherwise say N.
 
-config DEBUG_SEMAPHORE
-	bool "Semaphore debugging"
-	depends on DEBUG_KERNEL
-	help
-	  If you say Y here then semaphore processing will issue lots of
-	  verbose debugging messages.  If you suspect a semaphore problem or a
-	  kernel hacker asks for this option then say Y.  Otherwise say N.
-
 config ALPHA_LEGACY_START_ADDRESS
 	bool "Legacy kernel start address"
 	depends on ALPHA_GENERIC
diff -puN arch/frv/kernel/semaphore.c~kconfig-centralize-the-selection-of-semaphore-debugging arch/frv/kernel/semaphore.c
--- a/arch/frv/kernel/semaphore.c~kconfig-centralize-the-selection-of-semaphore-debugging
+++ a/arch/frv/kernel/semaphore.c
@@ -19,7 +19,7 @@ struct sem_waiter {
 	struct task_struct	*task;
 };
 
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 void semtrace(struct semaphore *sem, const char *str)
 {
 	if (sem->debug)
diff -puN include/asm-frv/semaphore.h~kconfig-centralize-the-selection-of-semaphore-debugging include/asm-frv/semaphore.h
--- a/include/asm-frv/semaphore.h~kconfig-centralize-the-selection-of-semaphore-debugging
+++ a/include/asm-frv/semaphore.h
@@ -20,8 +20,6 @@
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
 
-#define SEMAPHORE_DEBUG		0
-
 /*
  * the semaphore definition
  * - if counter is >0 then there are tokens available on the semaphore for down to collect
@@ -32,12 +30,12 @@ struct semaphore {
 	unsigned		counter;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	unsigned		__magic;
 #endif
 };
 
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 # define __SEM_DEBUG_INIT(name) , (long)&(name).__magic
 #else
 # define __SEM_DEBUG_INIT(name)
@@ -76,7 +74,7 @@ static inline void down(struct semaphore
 {
 	unsigned long flags;
 
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif
 
@@ -95,7 +93,7 @@ static inline int down_interruptible(str
 	unsigned long flags;
 	int ret = 0;
 
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif
 
@@ -119,7 +117,7 @@ static inline int down_trylock(struct se
 	unsigned long flags;
 	int success = 0;
 
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif
 
@@ -136,7 +134,7 @@ static inline void up(struct semaphore *
 {
 	unsigned long flags;
 
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif
 
diff -puN lib/Kconfig.debug~kconfig-centralize-the-selection-of-semaphore-debugging lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-centralize-the-selection-of-semaphore-debugging
+++ a/lib/Kconfig.debug
@@ -201,6 +201,16 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config DEBUG_SEMAPHORE
+	bool "Semaphore debugging"
+	depends on DEBUG_KERNEL
+	depends on ALPHA || FRV
+	default n
+	help
+	  If you say Y here then semaphore processing will issue lots of
+	  verbose debugging messages.  If you suspect a semaphore problem or a
+	  kernel hacker asks for this option then say Y.  Otherwise say N.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
git-dvb.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
git-mips.patch
mips-remove-unreferenced-_ioc_slmask-macro-in-ioctlh.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
