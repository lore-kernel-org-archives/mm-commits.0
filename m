From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:24 -0700
Message-ID: <5591acfc.pNKYwEI6tw0WGJzq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbF2Uj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: optimise kmemleak_lock acquiring during kmemleak_scan
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: optimise kmemleak_lock acquiring during kmemleak_scan

The kmemleak memory scanning uses finer grained object->lock spinlocks
primarily to avoid races with the memory block freeing.  However, the
pointer lookup in the rb tree requires the kmemleak_lock to be held.  This
is currently done in the find_and_get_object() function for each
pointer-like location read during scanning.  While this allows a low
latency on kmemleak_*() callbacks on other CPUs, the memory scanning is
slower.

This patch moves the kmemleak_lock outside the scan_block() loop,
acquiring/releasing it only once per scanned memory block.  The
allow_resched logic is moved outside scan_block() and a new
scan_large_block() function is implemented which splits large blocks in
MAX_SCAN_SIZE chunks with cond_resched() calls in-between.  A redundant
(object->flags & OBJECT_NO_SCAN) check is also removed from scan_object().

With this patch, the kmemleak scanning performance is significantly
improved: at least 50% with lock debugging disabled and over an order of
magnitude with lock proving enabled (on an arm64 system).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   90 +++++++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 34 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan
+++ a/mm/kmemleak.c
@@ -53,10 +53,12 @@
  *   modifications to the memory scanning parameters including the scan_thread
  *   pointer
  *
- * Locks and mutexes should only be acquired/nested in the following order:
+ * Locks and mutexes are acquired/nested in the following order:
  *
- *   scan_mutex -> object->lock -> other_object->lock (SINGLE_DEPTH_NESTING)
- *				-> kmemleak_lock
+ *   scan_mutex [-> object->lock] -> kmemleak_lock -> other_object->lock (SINGLE_DEPTH_NESTING)
+ *
+ * No kmemleak_lock and object->lock nesting is allowed outside scan_mutex
+ * regions.
  *
  * The kmemleak_object structures have a use_count incremented or decremented
  * using the get_object()/put_object() functions. When the use_count becomes
@@ -490,8 +492,7 @@ static struct kmemleak_object *find_and_
 
 	rcu_read_lock();
 	read_lock_irqsave(&kmemleak_lock, flags);
-	if (ptr >= min_addr && ptr < max_addr)
-		object = lookup_object(ptr, alias);
+	object = lookup_object(ptr, alias);
 	read_unlock_irqrestore(&kmemleak_lock, flags);
 
 	/* check whether the object is still available */
@@ -1170,19 +1171,18 @@ static int scan_should_stop(void)
  * found to the gray list.
  */
 static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned, int allow_resched)
+		       struct kmemleak_object *scanned)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
+	unsigned long flags;
 
+	read_lock_irqsave(&kmemleak_lock, flags);
 	for (ptr = start; ptr < end; ptr++) {
 		struct kmemleak_object *object;
-		unsigned long flags;
 		unsigned long pointer;
 
-		if (allow_resched)
-			cond_resched();
 		if (scan_should_stop())
 			break;
 
@@ -1195,26 +1195,31 @@ static void scan_block(void *_start, voi
 		pointer = *ptr;
 		kasan_enable_current();
 
-		object = find_and_get_object(pointer, 1);
+		if (pointer < min_addr || pointer >= max_addr)
+			continue;
+
+		/*
+		 * No need for get_object() here since we hold kmemleak_lock.
+		 * object->use_count cannot be dropped to 0 while the object
+		 * is still present in object_tree_root and object_list
+		 * (with updates protected by kmemleak_lock).
+		 */
+		object = lookup_object(pointer, 1);
 		if (!object)
 			continue;
-		if (object == scanned) {
+		if (object == scanned)
 			/* self referenced, ignore */
-			put_object(object);
 			continue;
-		}
 
 		/*
 		 * Avoid the lockdep recursive warning on object->lock being
 		 * previously acquired in scan_object(). These locks are
 		 * enclosed by scan_mutex.
 		 */
-		spin_lock_irqsave_nested(&object->lock, flags,
-					 SINGLE_DEPTH_NESTING);
+		spin_lock_nested(&object->lock, SINGLE_DEPTH_NESTING);
 		if (!color_white(object)) {
 			/* non-orphan, ignored or new */
-			spin_unlock_irqrestore(&object->lock, flags);
-			put_object(object);
+			spin_unlock(&object->lock);
 			continue;
 		}
 
@@ -1226,13 +1231,27 @@ static void scan_block(void *_start, voi
 		 */
 		object->count++;
 		if (color_gray(object)) {
+			/* put_object() called when removing from gray_list */
+			WARN_ON(!get_object(object));
 			list_add_tail(&object->gray_list, &gray_list);
-			spin_unlock_irqrestore(&object->lock, flags);
-			continue;
 		}
+		spin_unlock(&object->lock);
+	}
+	read_unlock_irqrestore(&kmemleak_lock, flags);
+}
 
-		spin_unlock_irqrestore(&object->lock, flags);
-		put_object(object);
+/*
+ * Scan a large memory block in MAX_SCAN_SIZE chunks to reduce the latency.
+ */
+static void scan_large_block(void *start, void *end)
+{
+	void *next;
+
+	while (start < end) {
+		next = min(start + MAX_SCAN_SIZE, end);
+		scan_block(start, next, NULL);
+		start = next;
+		cond_resched();
 	}
 }
 
@@ -1258,22 +1277,25 @@ static void scan_object(struct kmemleak_
 	if (hlist_empty(&object->area_list)) {
 		void *start = (void *)object->pointer;
 		void *end = (void *)(object->pointer + object->size);
+		void *next;
 
-		while (start < end && (object->flags & OBJECT_ALLOCATED) &&
-		       !(object->flags & OBJECT_NO_SCAN)) {
-			scan_block(start, min(start + MAX_SCAN_SIZE, end),
-				   object, 0);
-			start += MAX_SCAN_SIZE;
+		do {
+			next = min(start + MAX_SCAN_SIZE, end);
+			scan_block(start, next, object);
+
+			start = next;
+			if (start >= end)
+				break;
 
 			spin_unlock_irqrestore(&object->lock, flags);
 			cond_resched();
 			spin_lock_irqsave(&object->lock, flags);
-		}
+		} while (object->flags & OBJECT_ALLOCATED);
 	} else
 		hlist_for_each_entry(area, &object->area_list, node)
 			scan_block((void *)area->start,
 				   (void *)(area->start + area->size),
-				   object, 0);
+				   object);
 out:
 	spin_unlock_irqrestore(&object->lock, flags);
 }
@@ -1350,14 +1372,14 @@ static void kmemleak_scan(void)
 	rcu_read_unlock();
 
 	/* data/bss scanning */
-	scan_block(_sdata, _edata, NULL, 1);
-	scan_block(__bss_start, __bss_stop, NULL, 1);
+	scan_large_block(_sdata, _edata);
+	scan_large_block(__bss_start, __bss_stop);
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
 	for_each_possible_cpu(i)
-		scan_block(__per_cpu_start + per_cpu_offset(i),
-			   __per_cpu_end + per_cpu_offset(i), NULL, 1);
+		scan_large_block(__per_cpu_start + per_cpu_offset(i),
+				 __per_cpu_end + per_cpu_offset(i));
 #endif
 
 	/*
@@ -1378,7 +1400,7 @@ static void kmemleak_scan(void)
 			/* only scan if page is in use */
 			if (page_count(page) == 0)
 				continue;
-			scan_block(page, page + 1, NULL, 1);
+			scan_block(page, page + 1, NULL);
 		}
 	}
 	put_online_mems();
@@ -1392,7 +1414,7 @@ static void kmemleak_scan(void)
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			scan_block(task_stack_page(p), task_stack_page(p) +
-				   THREAD_SIZE, NULL, 0);
+				   THREAD_SIZE, NULL);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	}
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

