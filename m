From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch
 added to -mm tree
Date: Mon, 08 Jun 2015 14:53:35 -0700
Message-ID: <55760edf.85LCJIEDz05/Vzr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbbFHVxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 17:53:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: optimise kmemleak_lock acquiring during kmemleak_scan
has been added to the -mm tree.  Its filename is
     mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: optimise kmemleak_lock acquiring during kmemleak_scan

The kmemleak memory scanning uses finer grained object->lock spinlocks
primarily to avoid races with the memory block freeing. However, the
pointer lookup in the rb tree requires the kmemleak_lock to be held.
This is currently done in the find_and_get_object() function for each
pointer-like location read during scanning. While this allows a low
latency on kmemleak_*() callbacks on other CPUs, the memory scanning is
slower.

This patch moves the kmemleak_lock outside the core scan_block() function
allowing the spinlock to be acquired/released only once per scanned memory
block rather than individual pointer-like values.  The memory scanning
performance is significantly improved (3x on an arm64 system).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

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
@@ -1175,14 +1176,19 @@ static void scan_block(void *_start, voi
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
+	unsigned long klflags;
 
+	read_lock_irqsave(&kmemleak_lock, klflags);
 	for (ptr = start; ptr < end; ptr++) {
 		struct kmemleak_object *object;
 		unsigned long flags;
 		unsigned long pointer;
 
-		if (allow_resched)
+		if (allow_resched && need_resched()) {
+			read_unlock_irqrestore(&kmemleak_lock, klflags);
 			cond_resched();
+			read_lock_irqsave(&kmemleak_lock, klflags);
+		}
 		if (scan_should_stop())
 			break;
 
@@ -1195,14 +1201,21 @@ static void scan_block(void *_start, voi
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
@@ -1214,7 +1227,6 @@ static void scan_block(void *_start, voi
 		if (!color_white(object)) {
 			/* non-orphan, ignored or new */
 			spin_unlock_irqrestore(&object->lock, flags);
-			put_object(object);
 			continue;
 		}
 
@@ -1226,14 +1238,16 @@ static void scan_block(void *_start, voi
 		 */
 		object->count++;
 		if (color_gray(object)) {
+			/* put_object() called when removing from gray_list */
+			WARN_ON(!get_object(object));
 			list_add_tail(&object->gray_list, &gray_list);
 			spin_unlock_irqrestore(&object->lock, flags);
 			continue;
 		}
 
 		spin_unlock_irqrestore(&object->lock, flags);
-		put_object(object);
 	}
+	read_unlock_irqrestore(&kmemleak_lock, klflags);
 }
 
 /*
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch
mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block.patch
mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch
mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch
mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch
linux-next.patch

