From: akpm@linux-foundation.org
Subject: + lglock-map-to-spinlock-when-config_smp.patch added to -mm tree
Date: Mon, 24 Feb 2014 13:17:59 -0800
Message-ID: <530bb707./nylTqV/8bW7j3Cs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaBXVSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 16:18:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, npiggin@kernel.dk, mmarek@suse.cz, hpa@zytor.com, dhowells@redhat.com, josh@joshtriplett.org

Subject: + lglock-map-to-spinlock-when-config_smp.patch added to -mm tree
To: josh@joshtriplett.org,dhowells@redhat.com,hpa@zytor.com,mmarek@suse.cz,npiggin@kernel.dk,rusty@rustcorp.com.au,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 13:17:59 -0800


The patch titled
     Subject: lglock: map to spinlock when !CONFIG_SMP
has been added to the -mm tree.  Its filename is
     lglock-map-to-spinlock-when-config_smp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lglock-map-to-spinlock-when-config_smp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lglock-map-to-spinlock-when-config_smp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
diff -puN kernel/Makefile~lglock-map-to-spinlock-when-config_smp kernel/Makefile
diff -puN kernel/locking/Makefile~lglock-map-to-spinlock-when-config_smp kernel/locking/Makefile
--- a/kernel/locking/Makefile~lglock-map-to-spinlock-when-config_smp
+++ a/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o lglock.o
+obj-y += mutex.o semaphore.o rwsem.o
 
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

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
lglock-map-to-spinlock-when-config_smp.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

