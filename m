From: akpm@linux-foundation.org
Subject: - fix-raw_spinlock_t-vs-lockdep.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:32 -0700
Message-ID: <200707192003.l6JK3WwM019872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760327AbXGSUSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fix raw_spinlock_t vs lockdep
has been removed from the -mm tree.  Its filename was
     fix-raw_spinlock_t-vs-lockdep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix raw_spinlock_t vs lockdep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Use the lockdep infrastructure to track lock contention and other lock
statistics.

It tracks lock contention events, and the first four unique call-sites that
encountered contention.

It also measures lock wait-time and hold-time in nanoseconds. The minimum and
maximum times are tracked, as well as a total (which together with the number
of event can give the avg).

All statistics are done per lock class, per write (exclusive state) and per read
(shared state). 

The statistics are collected per-cpu, so that the collection overhead is
minimized via having no global cachemisses.

This new lock statistics feature is independent of the lock dependency checking
traditionally done by lockdep; it just shares the lock tracking code. It is
also possible to enable both and runtime disabled either component - thereby
avoiding the O(n^2) lock chain walks for instance.


This patch:

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

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
