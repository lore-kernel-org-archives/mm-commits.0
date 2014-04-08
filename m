From: akpm@linux-foundation.org
Subject: [merged] lglock-map-to-spinlock-when-config_smp.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:49:21 -0700
Message-ID: <53446ee1.OyV/zDtyKXMY8KBC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDHVtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, npiggin@kernel.dk, mmarek@suse.cz, hpa@zytor.com, dhowells@redhat.com, a.p.zijlstra@chello.nl, josh@joshtriplett.org

Subject: [merged] lglock-map-to-spinlock-when-config_smp.patch removed from -mm tree
To: josh@joshtriplett.org,a.p.zijlstra@chello.nl,dhowells@redhat.com,hpa@zytor.com,mmarek@suse.cz,npiggin@kernel.dk,rusty@rustcorp.com.au,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:49:21 -0700


The patch titled
     Subject: lglock: map to spinlock when !CONFIG_SMP
has been removed from the -mm tree.  Its filename was
     lglock-map-to-spinlock-when-config_smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: lglock: map to spinlock when !CONFIG_SMP

When the system has only one CPU, lglock is effectively a spinlock; map it
directly to spinlock to eliminate the indirection and duplicate code.

In addition to removing overhead, this drops 1.6k of code with a defconfig
modified to have !CONFIG_SMP, and 1.1k with a minimal config.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lglock.h  |   16 ++++++++++++++++
 kernel/locking/Makefile |    3 ++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/lglock.h~lglock-map-to-spinlock-when-config_smp include/linux/lglock.h
--- a/include/linux/lglock.h~lglock-map-to-spinlock-when-config_smp
+++ a/include/linux/lglock.h
@@ -25,6 +25,8 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 
+#ifdef CONFIG_SMP
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
 #else
@@ -57,4 +59,18 @@ void lg_local_unlock_cpu(struct lglock *
 void lg_global_lock(struct lglock *lg);
 void lg_global_unlock(struct lglock *lg);
 
+#else
+/* When !CONFIG_SMP, map lglock to spinlock */
+#define lglock spinlock
+#define DEFINE_LGLOCK(name) DEFINE_SPINLOCK(name)
+#define DEFINE_STATIC_LGLOCK(name) static DEFINE_SPINLOCK(name)
+#define lg_lock_init(lg, name) spin_lock_init(lg)
+#define lg_local_lock spin_lock
+#define lg_local_unlock spin_unlock
+#define lg_local_lock_cpu(lg, cpu) spin_lock(lg)
+#define lg_local_unlock_cpu(lg, cpu) spin_unlock(lg)
+#define lg_global_lock spin_lock
+#define lg_global_unlock spin_unlock
+#endif
+
 #endif
diff -puN kernel/locking/Makefile~lglock-map-to-spinlock-when-config_smp kernel/locking/Makefile
--- a/kernel/locking/Makefile~lglock-map-to-spinlock-when-config_smp
+++ a/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o lglock.o mcs_spinlock.o
+obj-y += mutex.o semaphore.o rwsem.o mcs_spinlock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -14,6 +14,7 @@ ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_SMP) += lglock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch

