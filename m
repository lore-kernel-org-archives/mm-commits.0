From: akpm@linux-foundation.org
Subject: + core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks.patch added to -mm tree
Date: Tue, 09 Feb 2010 15:04:29 -0800
Message-ID: <201002092304.o19N4TgA007069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab0BIXEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:04:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luca@luca-barbieri.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     core kernel: make sparse work with inline spinlocks and rwlocks
has been added to the -mm tree.  Its filename is
     core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: core kernel: make sparse work with inline spinlocks and rwlocks
From: Luca Barbieri <luca@luca-barbieri.com>

Currently sparse does not work with inline spinlock and rwlock functions. 
The problem is that they do not use the __acquires/__releases out-of-line
functions, but use inline functions with no sparse annotations.

This patch adds the appropriate annotations to make it work properly.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwlock.h   |   20 ++++++++++----------
 include/linux/spinlock.h |   13 ++++++++-----
 2 files changed, 18 insertions(+), 15 deletions(-)

diff -puN include/linux/rwlock.h~core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks include/linux/rwlock.h
--- a/include/linux/rwlock.h~core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks
+++ a/include/linux/rwlock.h
@@ -29,25 +29,25 @@ do {								\
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void do_raw_read_lock(rwlock_t *lock);
+ extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
 #define do_raw_read_lock_flags(lock, flags) do_raw_read_lock(lock)
  extern int do_raw_read_trylock(rwlock_t *lock);
- extern void do_raw_read_unlock(rwlock_t *lock);
- extern void do_raw_write_lock(rwlock_t *lock);
+ extern void do_raw_read_unlock(rwlock_t *lock) __releases(lock);
+ extern void do_raw_write_lock(rwlock_t *lock) __acquires(lock);
 #define do_raw_write_lock_flags(lock, flags) do_raw_write_lock(lock)
  extern int do_raw_write_trylock(rwlock_t *lock);
- extern void do_raw_write_unlock(rwlock_t *lock);
+ extern void do_raw_write_unlock(rwlock_t *lock) __releases(lock);
 #else
-# define do_raw_read_lock(rwlock)	arch_read_lock(&(rwlock)->raw_lock)
+# define do_raw_read_lock(rwlock)	do {__acquire(lock); arch_read_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_read_lock_flags(lock, flags) \
-		arch_read_lock_flags(&(lock)->raw_lock, *(flags))
+		do {__acquire(lock); arch_read_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
-# define do_raw_read_unlock(rwlock)	arch_read_unlock(&(rwlock)->raw_lock)
-# define do_raw_write_lock(rwlock)	arch_write_lock(&(rwlock)->raw_lock)
+# define do_raw_read_unlock(rwlock)	do {arch_read_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
+# define do_raw_write_lock(rwlock)	do {__acquire(lock); arch_write_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_write_lock_flags(lock, flags) \
-		arch_write_lock_flags(&(lock)->raw_lock, *(flags))
+		do {__acquire(lock); arch_write_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
-# define do_raw_write_unlock(rwlock)	arch_write_unlock(&(rwlock)->raw_lock)
+# define do_raw_write_unlock(rwlock)	do {arch_write_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
 #endif
 
 #define read_can_lock(rwlock)		arch_read_can_lock(&(rwlock)->raw_lock)
diff -puN include/linux/spinlock.h~core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks include/linux/spinlock.h
--- a/include/linux/spinlock.h~core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks
+++ a/include/linux/spinlock.h
@@ -128,19 +128,21 @@ static inline void smp_mb__after_lock(vo
 #define raw_spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void do_raw_spin_lock(raw_spinlock_t *lock);
+ extern void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock);
 #define do_raw_spin_lock_flags(lock, flags) do_raw_spin_lock(lock)
  extern int do_raw_spin_trylock(raw_spinlock_t *lock);
- extern void do_raw_spin_unlock(raw_spinlock_t *lock);
+ extern void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock);
 #else
-static inline void do_raw_spin_lock(raw_spinlock_t *lock)
+static inline void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock)
 {
+	__acquire(lock);
 	arch_spin_lock(&lock->raw_lock);
 }
 
 static inline void
-do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags)
+do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags) __acquires(lock)
 {
+	__acquire(lock);
 	arch_spin_lock_flags(&lock->raw_lock, *flags);
 }
 
@@ -149,9 +151,10 @@ static inline int do_raw_spin_trylock(ra
 	return arch_spin_trylock(&(lock)->raw_lock);
 }
 
-static inline void do_raw_spin_unlock(raw_spinlock_t *lock)
+static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 {
 	arch_spin_unlock(&lock->raw_lock);
+	__release(lock);
 }
 #endif
 
_

Patches currently in -mm which might be from luca@luca-barbieri.com are

core-kernel-make-sparse-work-with-inline-spinlocks-and-rwlocks.patch

