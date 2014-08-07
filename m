From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:03:25 -0700
Message-ID: <53e3db8d.TJ5SN/dvEc/DSF59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:48063 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUD0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:26 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1173346pde.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move slab related stuff from util.c to slab_common.c
has been removed from the -mm tree.  Its filename was
     mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: move slab related stuff from util.c to slab_common.c

Functions krealloc(), __krealloc(), kzfree() belongs to slab API, so
should be placed in slab_common.c

Also move slab allocator's tracepoints defenitions to slab_common.c No
functional changes here.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |  101 ++++++++++++++++++++++++++++++++++++++++++++
 mm/util.c        |  102 ---------------------------------------------
 2 files changed, 101 insertions(+), 102 deletions(-)

diff -puN mm/slab_common.c~mm-move-slab-related-stuff-from-utilc-to-slab_commonc mm/slab_common.c
--- a/mm/slab_common.c~mm-move-slab-related-stuff-from-utilc-to-slab_commonc
+++ a/mm/slab_common.c
@@ -19,6 +19,8 @@
 #include <asm/tlbflush.h>
 #include <asm/page.h>
 #include <linux/memcontrol.h>
+
+#define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
 #include "slab.h"
@@ -787,3 +789,102 @@ static int __init slab_proc_init(void)
 }
 module_init(slab_proc_init);
 #endif /* CONFIG_SLABINFO */
+
+static __always_inline void *__do_krealloc(const void *p, size_t new_size,
+					   gfp_t flags)
+{
+	void *ret;
+	size_t ks = 0;
+
+	if (p)
+		ks = ksize(p);
+
+	if (ks >= new_size)
+		return (void *)p;
+
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret && p)
+		memcpy(ret, p, ks);
+
+	return ret;
+}
+
+/**
+ * __krealloc - like krealloc() but don't free @p.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * This function is like krealloc() except it never frees the originally
+ * allocated buffer. Use this if you don't want to free the buffer immediately
+ * like, for example, with RCU.
+ */
+void *__krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	if (unlikely(!new_size))
+		return ZERO_SIZE_PTR;
+
+	return __do_krealloc(p, new_size, flags);
+
+}
+EXPORT_SYMBOL(__krealloc);
+
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @new_size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return ZERO_SIZE_PTR;
+	}
+
+	ret = __do_krealloc(p, new_size, flags);
+	if (ret && p != ret)
+		kfree(p);
+
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
+/**
+ * kzfree - like kfree but zero memory
+ * @p: object to free memory of
+ *
+ * The memory of the object @p points to is zeroed before freed.
+ * If @p is %NULL, kzfree() does nothing.
+ *
+ * Note: this function zeroes the whole allocated buffer which can be a good
+ * deal bigger than the requested buffer size passed to kmalloc(). So be
+ * careful when using this function in performance sensitive code.
+ */
+void kzfree(const void *p)
+{
+	size_t ks;
+	void *mem = (void *)p;
+
+	if (unlikely(ZERO_OR_NULL_PTR(mem)))
+		return;
+	ks = ksize(mem);
+	memset(mem, 0, ks);
+	kfree(mem);
+}
+EXPORT_SYMBOL(kzfree);
+
+/* Tracepoints definitions. */
+EXPORT_TRACEPOINT_SYMBOL(kmalloc);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
+EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kfree);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
diff -puN mm/util.c~mm-move-slab-related-stuff-from-utilc-to-slab_commonc mm/util.c
--- a/mm/util.c~mm-move-slab-related-stuff-from-utilc-to-slab_commonc
+++ a/mm/util.c
@@ -16,9 +16,6 @@
 
 #include "internal.h"
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/kmem.h>
-
 /**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
@@ -112,97 +109,6 @@ void *memdup_user(const void __user *src
 }
 EXPORT_SYMBOL(memdup_user);
 
-static __always_inline void *__do_krealloc(const void *p, size_t new_size,
-					   gfp_t flags)
-{
-	void *ret;
-	size_t ks = 0;
-
-	if (p)
-		ks = ksize(p);
-
-	if (ks >= new_size)
-		return (void *)p;
-
-	ret = kmalloc_track_caller(new_size, flags);
-	if (ret && p)
-		memcpy(ret, p, ks);
-
-	return ret;
-}
-
-/**
- * __krealloc - like krealloc() but don't free @p.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * This function is like krealloc() except it never frees the originally
- * allocated buffer. Use this if you don't want to free the buffer immediately
- * like, for example, with RCU.
- */
-void *__krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	if (unlikely(!new_size))
-		return ZERO_SIZE_PTR;
-
-	return __do_krealloc(p, new_size, flags);
-
-}
-EXPORT_SYMBOL(__krealloc);
-
-/**
- * krealloc - reallocate memory. The contents will remain unchanged.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @new_size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
- */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	void *ret;
-
-	if (unlikely(!new_size)) {
-		kfree(p);
-		return ZERO_SIZE_PTR;
-	}
-
-	ret = __do_krealloc(p, new_size, flags);
-	if (ret && p != ret)
-		kfree(p);
-
-	return ret;
-}
-EXPORT_SYMBOL(krealloc);
-
-/**
- * kzfree - like kfree but zero memory
- * @p: object to free memory of
- *
- * The memory of the object @p points to is zeroed before freed.
- * If @p is %NULL, kzfree() does nothing.
- *
- * Note: this function zeroes the whole allocated buffer which can be a good
- * deal bigger than the requested buffer size passed to kmalloc(). So be
- * careful when using this function in performance sensitive code.
- */
-void kzfree(const void *p)
-{
-	size_t ks;
-	void *mem = (void *)p;
-
-	if (unlikely(ZERO_OR_NULL_PTR(mem)))
-		return;
-	ks = ksize(mem);
-	memset(mem, 0, ks);
-	kfree(mem);
-}
-EXPORT_SYMBOL(kzfree);
-
 /*
  * strndup_user - duplicate an existing string from user space
  * @s: The string to duplicate
@@ -504,11 +410,3 @@ out_mm:
 out:
 	return res;
 }
