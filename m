From: akpm@linux-foundation.org
Subject: [merged] lglock-map-to-spinlock-when-config_smp.patch removed
 from -mm tree
Date: Mon, 11 Nov 2013 10:44:08 -0800
Message-ID: <52812578.cIW3AT1ZxyxHKahM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 13:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, npiggin@kernel.dk, mmarek@suse.cz, hpa@zytor.com, dhowells@redhat.com, josh@joshtriplett.org

Subject: [merged] lglock-map-to-spinlock-when-config_smp.patch removed from -mm tree
To: josh@joshtriplett.org,dhowells@redhat.com,hpa@zytor.com,mmarek@suse.cz,npiggin@kernel.dk,rusty@rustcorp.com.au,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 10:44:08 -0800


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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lglock.h |   16 ++++++++++++++++
 kernel/Makefile        |    4 ++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff -puN include/linux/lglock.h~lglock-map-to-spinlock-when-config_smp include/linux/lglock.h
--- a/include/linux/lglock.h~lglock-map-to-spinlock-when-config_smp
+++ a/include/linux/lglock.h
@@ -35,6 +35,8 @@
 #define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
 #define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
 
+#ifdef CONFIG_SMP
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
 #else
@@ -67,4 +69,18 @@ void lg_local_unlock_cpu(struct lglock *
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
--- a/kernel/Makefile~lglock-map-to-spinlock-when-config_smp
+++ a/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o
 	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o groups.o lglock.o smpboot.o
+	    async.o range.o groups.o smpboot.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
@@ -50,7 +50,7 @@ obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
-obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_SMP) += lglock.o spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch
linux-next.patch

