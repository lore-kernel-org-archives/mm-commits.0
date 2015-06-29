From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:18 -0700
Message-ID: <5591acf6.nDozr20QJurwhUTN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbbF2UjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: fix delete_object_*() race when called on the same memory block
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: fix delete_object_*() race when called on the same memory block

Calling delete_object_*() on the same pointer is not a standard use case
(unless there is a bug in the code calling kmemleak_free()).  However,
during kmemleak disabling (error or user triggered via /sys), there is a
potential race between kmemleak_free() calls on a CPU and
__kmemleak_do_cleanup() on a different CPU.  The current delete_object_*()
implementation first performs a look-up holding kmemleak_lock, increments
the object->use_count and then re-acquires kmemleak_lock to remove the
object from object_tree_root and object_list.

This patch simplifies the delete_object_*() mechanism to both look up and
remove an object from the object_tree_root and object_list atomically
(guarded by kmemleak_lock).  This allows safe concurrent calls to
delete_object_*() on the same pointer without additional locking for
synchronising the kmemleak_free_enabled flag.

A side effect is a slight improvement in the delete_object_*() performance
by avoiding acquiring kmemleak_lock twice and incrementing/decrementing
object->use_count.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block
+++ a/mm/kmemleak.c
@@ -498,6 +498,27 @@ static struct kmemleak_object *find_and_
 }
 
 /*
+ * Look up an object in the object search tree and remove it from both
+ * object_tree_root and object_list. The returned object's use_count should be
+ * at least 1, as initially set by create_object().
+ */
+static struct kmemleak_object *find_and_remove_object(unsigned long ptr, int alias)
+{
+	unsigned long flags;
+	struct kmemleak_object *object;
+
+	write_lock_irqsave(&kmemleak_lock, flags);
+	object = lookup_object(ptr, alias);
+	if (object) {
+		rb_erase(&object->rb_node, &object_tree_root);
+		list_del_rcu(&object->object_list);
+	}
+	write_unlock_irqrestore(&kmemleak_lock, flags);
+
+	return object;
+}
+
+/*
  * Save stack trace to the given array of MAX_TRACE size.
  */
 static int __save_stack_trace(unsigned long *trace)
@@ -600,20 +621,14 @@ out:
 }
 
 /*
- * Remove the metadata (struct kmemleak_object) for a memory block from the
- * object_list and object_tree_root and decrement its use_count.
+ * Mark the object as not allocated and schedule RCU freeing via put_object().
  */
 static void __delete_object(struct kmemleak_object *object)
 {
 	unsigned long flags;
 
-	write_lock_irqsave(&kmemleak_lock, flags);
-	rb_erase(&object->rb_node, &object_tree_root);
-	list_del_rcu(&object->object_list);
-	write_unlock_irqrestore(&kmemleak_lock, flags);
-
 	WARN_ON(!(object->flags & OBJECT_ALLOCATED));
-	WARN_ON(atomic_read(&object->use_count) < 2);
+	WARN_ON(atomic_read(&object->use_count) < 1);
 
 	/*
 	 * Locking here also ensures that the corresponding memory block
@@ -633,7 +648,7 @@ static void delete_object_full(unsigned
 {
 	struct kmemleak_object *object;
 
-	object = find_and_get_object(ptr, 0);
+	object = find_and_remove_object(ptr, 0);
 	if (!object) {
 #ifdef DEBUG
 		kmemleak_warn("Freeing unknown object at 0x%08lx\n",
@@ -642,7 +657,6 @@ static void delete_object_full(unsigned
 		return;
 	}
 	__delete_object(object);
-	put_object(object);
 }
 
 /*
@@ -655,7 +669,7 @@ static void delete_object_part(unsigned
 	struct kmemleak_object *object;
 	unsigned long start, end;
 
-	object = find_and_get_object(ptr, 1);
+	object = find_and_remove_object(ptr, 1);
 	if (!object) {
 #ifdef DEBUG
 		kmemleak_warn("Partially freeing unknown object at 0x%08lx "
@@ -663,7 +677,6 @@ static void delete_object_part(unsigned
 #endif
 		return;
 	}
-	__delete_object(object);
 
 	/*
 	 * Create one or two objects that may result from the memory block
@@ -681,7 +694,7 @@ static void delete_object_part(unsigned
 		create_object(ptr + size, end - ptr - size, object->min_count,
 			      GFP_KERNEL);
 
-	put_object(object);
+	__delete_object(object);
 }
 
 static void __paint_it(struct kmemleak_object *object, int color)
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

