From: akpm@linux-foundation.org
Subject: + fix-raw_spinlock_t-vs-lockdep.patch added to -mm tree
Date: Wed, 30 May 2007 12:29:44 -0700
Message-ID: <200705301929.l4UJTi3O002878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbXE3TaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 15:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     fix raw_spinlock_t vs lockdep
has been added to the -mm tree.  Its filename is
     fix-raw_spinlock_t-vs-lockdep.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix raw_spinlock_t vs lockdep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

raw_spinlock_t should not use lockdep (and doesn't) since lockdep itself
relies on it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock_types.h    |    4 ++--
 include/linux/spinlock_types_up.h |    9 +--------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN include/linux/spinlock_types.h~fix-raw_spinlock_t-vs-lockdep include/linux/spinlock_types.h
--- a/include/linux/spinlock_types.h~fix-raw_spinlock_t-vs-lockdep
+++ a/include/linux/spinlock_types.h
@@ -9,14 +9,14 @@
  * Released under the General Public License (GPL).
  */
 
-#include <linux/lockdep.h>
-
 #if defined(CONFIG_SMP)
 # include <asm/spinlock_types.h>
 #else
 # include <linux/spinlock_types_up.h>
 #endif
 
+#include <linux/lockdep.h>
+
 typedef struct {
 	raw_spinlock_t raw_lock;
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_SMP)
diff -puN include/linux/spinlock_types_up.h~fix-raw_spinlock_t-vs-lockdep include/linux/spinlock_types_up.h
--- a/include/linux/spinlock_types_up.h~fix-raw_spinlock_t-vs-lockdep
+++ a/include/linux/spinlock_types_up.h
@@ -12,14 +12,10 @@
  * Released under the General Public License (GPL).
  */
 
-#if defined(CONFIG_DEBUG_SPINLOCK) || \
-	defined(CONFIG_DEBUG_LOCK_ALLOC)
+#ifdef CONFIG_DEBUG_SPINLOCK
 
 typedef struct {
 	volatile unsigned int slock;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
 } raw_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED { 1 }
@@ -34,9 +30,6 @@ typedef struct { } raw_spinlock_t;
 
 typedef struct {
 	/* no debug version on UP */
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
 } raw_rwlock_t;
 
 #define __RAW_RW_LOCK_UNLOCKED { }
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
