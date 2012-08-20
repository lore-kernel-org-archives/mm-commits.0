From: akpm@linux-foundation.org
Subject: [merged] mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:35 -0700
Message-ID: <20120820195635.C7FF91E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34156 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HTT4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:37 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4032395obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.khan@hp.com, cl@linux.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: restructure kmem_cache_create() to move debug cache integrity checks into a new function
has been removed from the -mm tree.  Its filename was
     mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.khan@hp.com>
Subject: mm/slab_common.c: restructure kmem_cache_create() to move debug cache integrity checks into a new function

kmem_cache_create() does cache integrity checks when CONFIG_DEBUG_VM is
defined.  These checks interspersed with the regular code path has lead to
compile time warnings when compiled without CONFIG_DEBUG_VM defined. 
Restructuring the code to move the integrity checks in to a new function
would eliminate the current compile warning problem and also will allow
for future changes to the debug only code to evolve without introducing
new warnings in the regular path.  This restructuring work is based on the
discussion in the following thread:

https://lkml.org/lkml/2012/7/13/424

[akpm@linux-foundation.org: fix build, cleanup]
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   97 ++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 49 deletions(-)

diff -puN mm/slab_common.c~mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function
+++ a/mm/slab_common.c
@@ -23,49 +23,17 @@ enum slab_state slab_state;
 LIST_HEAD(slab_caches);
 DEFINE_MUTEX(slab_mutex);
 
-/*
- * kmem_cache_create - Create a cache.
- * @name: A string which is used in /proc/slabinfo to identify this cache.
- * @size: The size of objects to be created in this cache.
- * @align: The required alignment for the objects.
- * @flags: SLAB flags
- * @ctor: A constructor for the objects.
- *
- * Returns a ptr to the cache on success, NULL on failure.
- * Cannot be called within a interrupt, but can be interrupted.
- * The @ctor is run when new pages are allocated by the cache.
- *
- * The flags are
- *
- * %SLAB_POISON - Poison the slab with a known test pattern (a5a5a5a5)
- * to catch references to uninitialised memory.
- *
- * %SLAB_RED_ZONE - Insert `Red' zones around the allocated memory to check
- * for buffer overruns.
- *
- * %SLAB_HWCACHE_ALIGN - Align the objects in this cache to a hardware
- * cacheline.  This can be beneficial if you're counting cycles as closely
- * as davem.
- */
-
-struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align,
-		unsigned long flags, void (*ctor)(void *))
+#ifdef CONFIG_DEBUG_VM
+static int kmem_cache_sanity_check(const char *name, size_t size)
 {
 	struct kmem_cache *s = NULL;
 
-#ifdef CONFIG_DEBUG_VM
 	if (!name || in_interrupt() || size < sizeof(void *) ||
 		size > KMALLOC_MAX_SIZE) {
-		printk(KERN_ERR "kmem_cache_create(%s) integrity check"
-			" failed\n", name);
-		goto out;
+		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
+		return -EINVAL;
 	}
-#endif
 
-	get_online_cpus();
-	mutex_lock(&slab_mutex);
-
-#ifdef CONFIG_DEBUG_VM
 	list_for_each_entry(s, &slab_caches, list) {
 		char tmp;
 		int res;
@@ -77,36 +45,67 @@ struct kmem_cache *kmem_cache_create(con
 		 */
 		res = probe_kernel_address(s->name, tmp);
 		if (res) {
-			printk(KERN_ERR
-			       "Slab cache with size %d has lost its name\n",
+			pr_err("Slab cache with size %d has lost its name\n",
 			       s->object_size);
 			continue;
 		}
 
 		if (!strcmp(s->name, name)) {
-			printk(KERN_ERR "kmem_cache_create(%s): Cache name"
-				" already exists.\n",
-				name);
+			pr_err("%s (%s): Cache name already exists.\n",
+			       __func__, name);
 			dump_stack();
 			s = NULL;
-			goto oops;
+			return -EINVAL;
 		}
 	}
 
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
+	return 0;
+}
+#else
+static inline int kmem_cache_sanity_check(const char *name, size_t size)
+{
+	return 0;
+}
 #endif
 
-	s = __kmem_cache_create(name, size, align, flags, ctor);
+/*
+ * kmem_cache_create - Create a cache.
+ * @name: A string which is used in /proc/slabinfo to identify this cache.
+ * @size: The size of objects to be created in this cache.
+ * @align: The required alignment for the objects.
+ * @flags: SLAB flags
+ * @ctor: A constructor for the objects.
+ *
+ * Returns a ptr to the cache on success, NULL on failure.
+ * Cannot be called within a interrupt, but can be interrupted.
+ * The @ctor is run when new pages are allocated by the cache.
+ *
+ * The flags are
+ *
+ * %SLAB_POISON - Poison the slab with a known test pattern (a5a5a5a5)
+ * to catch references to uninitialised memory.
+ *
+ * %SLAB_RED_ZONE - Insert `Red' zones around the allocated memory to check
+ * for buffer overruns.
+ *
+ * %SLAB_HWCACHE_ALIGN - Align the objects in this cache to a hardware
+ * cacheline.  This can be beneficial if you're counting cycles as closely
+ * as davem.
+ */
+
+struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align,
+		unsigned long flags, void (*ctor)(void *))
+{
+	struct kmem_cache *s = NULL;
 
-#ifdef CONFIG_DEBUG_VM
-oops:
-#endif
+	get_online_cpus();
+	mutex_lock(&slab_mutex);
+	if (kmem_cache_sanity_check(name, size) == 0)
+		s = __kmem_cache_create(name, size, align, flags, ctor);
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-#ifdef CONFIG_DEBUG_VM
-out:
-#endif
 	if (!s && (flags & SLAB_PANIC))
 		panic("kmem_cache_create: Failed to create slab '%s'\n", name);
 
_

Patches currently in -mm which might be from shuah.khan@hp.com are

linux-next.patch

