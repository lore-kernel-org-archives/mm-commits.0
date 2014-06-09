From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-kmemleak_update_trace.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:40:31 -0700
Message-ID: <53960daf.AaDFz2AExbdwx/R8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFITkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, catalin.marinas@arm.com

Subject: [merged] mm-introduce-kmemleak_update_trace.patch removed from -mm tree
To: catalin.marinas@arm.com,hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:31 -0700


The patch titled
     Subject: mm: introduce kmemleak_update_trace()
has been removed from the -mm tree.  Its filename was
     mm-introduce-kmemleak_update_trace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: introduce kmemleak_update_trace()

The memory allocation stack trace is not always useful for debugging a
memory leak (e.g.  radix_tree_preload).  This function, when called,
updates the stack trace for an already allocated object.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kmemleak.txt |    1 +
 include/linux/kmemleak.h   |    4 ++++
 mm/kmemleak.c              |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff -puN Documentation/kmemleak.txt~mm-introduce-kmemleak_update_trace Documentation/kmemleak.txt
--- a/Documentation/kmemleak.txt~mm-introduce-kmemleak_update_trace
+++ a/Documentation/kmemleak.txt
@@ -142,6 +142,7 @@ kmemleak_alloc_percpu	 - notify of a per
 kmemleak_free		 - notify of a memory block freeing
 kmemleak_free_part	 - notify of a partial memory block freeing
 kmemleak_free_percpu	 - notify of a percpu memory block freeing
+kmemleak_update_trace	 - update object allocation stack trace
 kmemleak_not_leak	 - mark an object as not a leak
 kmemleak_ignore		 - do not scan or report an object as leak
 kmemleak_scan_area	 - add scan areas inside a memory block
diff -puN include/linux/kmemleak.h~mm-introduce-kmemleak_update_trace include/linux/kmemleak.h
--- a/include/linux/kmemleak.h~mm-introduce-kmemleak_update_trace
+++ a/include/linux/kmemleak.h
@@ -30,6 +30,7 @@ extern void kmemleak_alloc_percpu(const
 extern void kmemleak_free(const void *ptr) __ref;
 extern void kmemleak_free_part(const void *ptr, size_t size) __ref;
 extern void kmemleak_free_percpu(const void __percpu *ptr) __ref;
+extern void kmemleak_update_trace(const void *ptr) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
@@ -83,6 +84,9 @@ static inline void kmemleak_free_recursi
 static inline void kmemleak_free_percpu(const void __percpu *ptr)
 {
 }
+static inline void kmemleak_update_trace(const void *ptr)
+{
+}
 static inline void kmemleak_not_leak(const void *ptr)
 {
 }
diff -puN mm/kmemleak.c~mm-introduce-kmemleak_update_trace mm/kmemleak.c
--- a/mm/kmemleak.c~mm-introduce-kmemleak_update_trace
+++ a/mm/kmemleak.c
@@ -990,6 +990,40 @@ void __ref kmemleak_free_percpu(const vo
 EXPORT_SYMBOL_GPL(kmemleak_free_percpu);
 
 /**
+ * kmemleak_update_trace - update object allocation stack trace
+ * @ptr:	pointer to beginning of the object
+ *
+ * Override the object allocation stack trace for cases where the actual
+ * allocation place is not always useful.
+ */
+void __ref kmemleak_update_trace(const void *ptr)
+{
+	struct kmemleak_object *object;
+	unsigned long flags;
+
+	pr_debug("%s(0x%p)\n", __func__, ptr);
+
+	if (!kmemleak_enabled || IS_ERR_OR_NULL(ptr))
+		return;
+
+	object = find_and_get_object((unsigned long)ptr, 1);
+	if (!object) {
+#ifdef DEBUG
+		kmemleak_warn("Updating stack trace for unknown object at %p\n",
+			      ptr);
+#endif
+		return;
+	}
+
+	spin_lock_irqsave(&object->lock, flags);
+	object->trace_len = __save_stack_trace(object->trace);
+	spin_unlock_irqrestore(&object->lock, flags);
+
+	put_object(object);
+}
+EXPORT_SYMBOL(kmemleak_update_trace);
+
+/**
  * kmemleak_not_leak - mark an allocated object as false positive
  * @ptr:	pointer to beginning of the object
  *
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

