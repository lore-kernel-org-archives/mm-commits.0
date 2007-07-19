From: akpm@linux-foundation.org
Subject: - lockdep-various-fixes.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:48 -0700
Message-ID: <200707192003.l6JK3mxU019890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbXGSUWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: various fixes
has been removed from the -mm tree.  Its filename was
     lockdep-various-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: various fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

 - update the copyright notices
 - use the default hash function
 - fix a thinko in a BUILD_BUG_ON
 - add a WARN_ON to spot inconsitent naming
 - fix a termination issue in /proc/lock_stat

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    3 ++-
 kernel/lockdep.c        |   21 ++++++++++++---------
 kernel/lockdep_proc.c   |    6 +++++-
 3 files changed, 19 insertions(+), 11 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-various-fixes include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-various-fixes
+++ a/include/linux/lockdep.h
@@ -1,7 +1,8 @@
 /*
  * Runtime locking correctness validator
  *
- *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
  * see Documentation/lockdep-design.txt for more details.
  */
diff -puN kernel/lockdep.c~lockdep-various-fixes kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-various-fixes
+++ a/kernel/lockdep.c
@@ -5,7 +5,8 @@
  *
  * Started by Ingo Molnar:
  *
- *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
  * this code maps all the lock dependencies as they occur in a live kernel
  * and will warn about the following classes of locking bugs:
@@ -37,6 +38,7 @@
 #include <linux/debug_locks.h>
 #include <linux/irqflags.h>
 #include <linux/utsname.h>
+#include <linux/hash.h>
 
 #include <asm/sections.h>
 
@@ -238,8 +240,7 @@ LIST_HEAD(all_lock_classes);
  */
 #define CLASSHASH_BITS		(MAX_LOCKDEP_KEYS_BITS - 1)
 #define CLASSHASH_SIZE		(1UL << CLASSHASH_BITS)
-#define CLASSHASH_MASK		(CLASSHASH_SIZE - 1)
-#define __classhashfn(key)	((((unsigned long)key >> CLASSHASH_BITS) + (unsigned long)key) & CLASSHASH_MASK)
+#define __classhashfn(key)	hash_long((unsigned long)key, CLASSHASH_BITS)
 #define classhashentry(key)	(classhash_table + __classhashfn((key)))
 
 static struct list_head classhash_table[CLASSHASH_SIZE];
@@ -250,9 +251,7 @@ static struct list_head classhash_table[
  */
 #define CHAINHASH_BITS		(MAX_LOCKDEP_CHAINS_BITS-1)
 #define CHAINHASH_SIZE		(1UL << CHAINHASH_BITS)
-#define CHAINHASH_MASK		(CHAINHASH_SIZE - 1)
-#define __chainhashfn(chain) \
-		(((chain >> CHAINHASH_BITS) + chain) & CHAINHASH_MASK)
+#define __chainhashfn(chain)	hash_long(chain, CHAINHASH_BITS)
 #define chainhashentry(chain)	(chainhash_table + __chainhashfn((chain)))
 
 static struct list_head chainhash_table[CHAINHASH_SIZE];
@@ -676,7 +675,8 @@ look_up_lock_class(struct lockdep_map *l
 	 * (or spin_lock_init()) call - which acts as the key. For static
 	 * locks we use the lock object itself as the key.
 	 */
-	BUILD_BUG_ON(sizeof(struct lock_class_key) > sizeof(struct lock_class));
+	BUILD_BUG_ON(sizeof(struct lock_class_key) >
+			sizeof(struct lockdep_map));
 
 	key = lock->key->subkeys + subclass;
 
@@ -686,9 +686,12 @@ look_up_lock_class(struct lockdep_map *l
 	 * We can walk the hash lockfree, because the hash only
 	 * grows, and we are careful when adding entries to the end:
 	 */
-	list_for_each_entry(class, hash_head, hash_entry)
-		if (class->key == key)
+	list_for_each_entry(class, hash_head, hash_entry) {
+		if (class->key == key) {
+			WARN_ON_ONCE(class->name != lock->name);
 			return class;
+		}
+	}
 
 	return NULL;
 }
diff -puN kernel/lockdep_proc.c~lockdep-various-fixes kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockdep-various-fixes
+++ a/kernel/lockdep_proc.c
@@ -5,7 +5,8 @@
  *
  * Started by Ingo Molnar:
  *
- *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
  * Code for /proc/lockdep and /proc/lockdep_stats:
  *
@@ -498,6 +499,9 @@ static void *ls_start(struct seq_file *m
 	if (data->iter == data->stats)
 		seq_header(m);
 
+	if (data->iter == data->iter_end)
+		data->iter = NULL;
+
 	return data->iter;
 }
 
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
