From: akpm@linux-foundation.org
Subject: + mm-introduce-kmemleak_update_trace.patch added to -mm tree
Date: Fri, 02 May 2014 15:49:14 -0700
Message-ID: <536420ea.zUBjylJ4RCNwVVu2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaEBWtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, catalin.marinas@arm.com

Subject: + mm-introduce-kmemleak_update_trace.patch added to -mm tree
To: catalin.marinas@arm.com,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:49:14 -0700


The patch titled
     Subject: mm: introduce kmemleak_update_trace()
has been added to the -mm tree.  Its filename is
     mm-introduce-kmemleak_update_trace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-kmemleak_update_trace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-kmemleak_update_trace.patch

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
mm-kmemleakc-use-%u-to-print-checksum.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch
mm-call-kmemleak-directly-from-memblock_allocfree.patch
mm-postpone-the-disabling-of-kmemleak-early-logging.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

