From: akpm@linux-foundation.org
Subject: + slab-slub-slob-add-slab_flags_t.patch added to -mm tree
Date: Thu, 02 Nov 2017 14:42:48 -0700
Message-ID: <59fb9158.8BerTulJXleXwcgm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934115AbdKBVmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 17:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab, slub, slob: add slab_flags_t
has been added to the -mm tree.  Its filename is
     slab-slub-slob-add-slab_flags_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-slub-slob-add-slab_flags_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-slub-slob-add-slab_flags_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: slab, slub, slob: add slab_flags_t

Add sparse-checked slab_flags_t for struct kmem_cache::flags (SLAB_POISON,
etc).

SLAB is bloated temporarily by switching to "unsigned long", but only
temporarily.

Link: http://lkml.kernel.org/r/20171021100225.GA22428@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c       |    2 -
 fs/xfs/kmem.h            |    2 -
 include/linux/kasan.h    |    4 +-
 include/linux/kmemleak.h |    8 ++--
 include/linux/slab.h     |   60 ++++++++++++++++++++++---------------
 include/linux/slab_def.h |    2 -
 include/linux/slub_def.h |    2 -
 include/linux/types.h    |    1 
 include/net/sock.h       |    2 -
 mm/kasan/kasan.c         |    2 -
 mm/slab.c                |   23 ++++++--------
 mm/slab.h                |   26 ++++++++--------
 mm/slab_common.c         |   16 ++++-----
 mm/slob.c                |    2 -
 mm/slub.c                |   26 ++++++++--------
 15 files changed, 97 insertions(+), 81 deletions(-)

diff -puN fs/ecryptfs/main.c~slab-slub-slob-add-slab_flags_t fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~slab-slub-slob-add-slab_flags_t
+++ a/fs/ecryptfs/main.c
@@ -660,7 +660,7 @@ static struct ecryptfs_cache_info {
 	struct kmem_cache **cache;
 	const char *name;
 	size_t size;
-	unsigned long flags;
+	slab_flags_t flags;
 	void (*ctor)(void *obj);
 } ecryptfs_cache_infos[] = {
 	{
diff -puN fs/xfs/kmem.h~slab-slub-slob-add-slab_flags_t fs/xfs/kmem.h
--- a/fs/xfs/kmem.h~slab-slub-slob-add-slab_flags_t
+++ a/fs/xfs/kmem.h
@@ -104,7 +104,7 @@ kmem_zone_init(int size, char *zone_name
 }
 
 static inline kmem_zone_t *
-kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
+kmem_zone_init_flags(int size, char *zone_name, slab_flags_t flags,
 		     void (*construct)(void *))
 {
 	return kmem_cache_create(zone_name, size, 0, flags, construct);
diff -puN include/linux/kasan.h~slab-slub-slob-add-slab_flags_t include/linux/kasan.h
--- a/include/linux/kasan.h~slab-slub-slob-add-slab_flags_t
+++ a/include/linux/kasan.h
@@ -46,7 +46,7 @@ void kasan_alloc_pages(struct page *page
 void kasan_free_pages(struct page *page, unsigned int order);
 
 void kasan_cache_create(struct kmem_cache *cache, size_t *size,
-			unsigned long *flags);
+			slab_flags_t *flags);
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
 
@@ -95,7 +95,7 @@ static inline void kasan_free_pages(stru
 
 static inline void kasan_cache_create(struct kmem_cache *cache,
 				      size_t *size,
-				      unsigned long *flags) {}
+				      slab_flags_t *flags) {}
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
 
diff -puN include/linux/kmemleak.h~slab-slub-slob-add-slab_flags_t include/linux/kmemleak.h
--- a/include/linux/kmemleak.h~slab-slub-slob-add-slab_flags_t
+++ a/include/linux/kmemleak.h
@@ -48,14 +48,14 @@ extern void kmemleak_not_leak_phys(phys_
 extern void kmemleak_ignore_phys(phys_addr_t phys) __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
-					    int min_count, unsigned long flags,
+					    int min_count, slab_flags_t flags,
 					    gfp_t gfp)
 {
 	if (!(flags & SLAB_NOLEAKTRACE))
 		kmemleak_alloc(ptr, size, min_count, gfp);
 }
 
-static inline void kmemleak_free_recursive(const void *ptr, unsigned long flags)
+static inline void kmemleak_free_recursive(const void *ptr, slab_flags_t flags)
 {
 	if (!(flags & SLAB_NOLEAKTRACE))
 		kmemleak_free(ptr);
@@ -76,7 +76,7 @@ static inline void kmemleak_alloc(const
 {
 }
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
-					    int min_count, unsigned long flags,
+					    int min_count, slab_flags_t flags,
 					    gfp_t gfp)
 {
 }
@@ -94,7 +94,7 @@ static inline void kmemleak_free(const v
 static inline void kmemleak_free_part(const void *ptr, size_t size)
 {
 }
-static inline void kmemleak_free_recursive(const void *ptr, unsigned long flags)
+static inline void kmemleak_free_recursive(const void *ptr, slab_flags_t flags)
 {
 }
 static inline void kmemleak_free_percpu(const void __percpu *ptr)
diff -puN include/linux/slab_def.h~slab-slub-slob-add-slab_flags_t include/linux/slab_def.h
--- a/include/linux/slab_def.h~slab-slub-slob-add-slab_flags_t
+++ a/include/linux/slab_def.h
@@ -20,7 +20,7 @@ struct kmem_cache {
 	struct reciprocal_value reciprocal_buffer_size;
 /* 2) touched by every alloc & free from the backend */
 
-	unsigned int flags;		/* constant flags */
+	slab_flags_t flags;		/* constant flags */
 	unsigned int num;		/* # of objs per slab */
 
 /* 3) cache_grow/shrink */
diff -puN include/linux/slab.h~slab-slub-slob-add-slab_flags_t include/linux/slab.h
--- a/include/linux/slab.h~slab-slub-slob-add-slab_flags_t
+++ a/include/linux/slab.h
@@ -21,13 +21,20 @@
  * Flags to pass to kmem_cache_create().
  * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.
  */
-#define SLAB_CONSISTENCY_CHECKS	0x00000100UL	/* DEBUG: Perform (expensive) checks on alloc/free */
-#define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
-#define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
-#define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
-#define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
-#define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
-#define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
+/* DEBUG: Perform (expensive) checks on alloc/free */
+#define SLAB_CONSISTENCY_CHECKS	((slab_flags_t __force)0x00000100UL)
+/* DEBUG: Red zone objs in a cache */
+#define SLAB_RED_ZONE		((slab_flags_t __force)0x00000400UL)
+/* DEBUG: Poison objects */
+#define SLAB_POISON		((slab_flags_t __force)0x00000800UL)
+/* Align objs on cache lines */
+#define SLAB_HWCACHE_ALIGN	((slab_flags_t __force)0x00002000UL)
+/* Use GFP_DMA memory */
+#define SLAB_CACHE_DMA		((slab_flags_t __force)0x00004000UL)
+/* DEBUG: Store the last owner for bug hunting */
+#define SLAB_STORE_USER		((slab_flags_t __force)0x00010000UL)
+/* Panic if kmem_cache_create() fails */
+#define SLAB_PANIC		((slab_flags_t __force)0x00040000UL)
 /*
  * SLAB_TYPESAFE_BY_RCU - **WARNING** READ THIS!
  *
@@ -65,44 +72,51 @@
  *
  * Note that SLAB_TYPESAFE_BY_RCU was originally named SLAB_DESTROY_BY_RCU.
  */
-#define SLAB_TYPESAFE_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
-#define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
-#define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
+/* Defer freeing slabs to RCU */
+#define SLAB_TYPESAFE_BY_RCU	((slab_flags_t __force)0x00080000UL)
+/* Spread some memory over cpuset */
+#define SLAB_MEM_SPREAD		((slab_flags_t __force)0x00100000UL)
+/* Trace allocations and frees */
+#define SLAB_TRACE		((slab_flags_t __force)0x00200000UL)
 
 /* Flag to prevent checks on free */
 #ifdef CONFIG_DEBUG_OBJECTS
-# define SLAB_DEBUG_OBJECTS	0x00400000UL
+# define SLAB_DEBUG_OBJECTS	((slab_flags_t __force)0x00400000UL)
 #else
-# define SLAB_DEBUG_OBJECTS	0x00000000UL
+# define SLAB_DEBUG_OBJECTS	((slab_flags_t __force)0x00000000UL)
 #endif
 
-#define SLAB_NOLEAKTRACE	0x00800000UL	/* Avoid kmemleak tracing */
+/* Avoid kmemleak tracing */
+#define SLAB_NOLEAKTRACE	((slab_flags_t __force)0x00800000UL)
 
 /* Don't track use of uninitialized memory */
 #ifdef CONFIG_KMEMCHECK
-# define SLAB_NOTRACK		0x01000000UL
+# define SLAB_NOTRACK		((slab_flags_t __force)0x01000000UL)
 #else
-# define SLAB_NOTRACK		0x00000000UL
+# define SLAB_NOTRACK		((slab_flags_t __force)0x00000000UL)
 #endif
+/* Fault injection mark */
 #ifdef CONFIG_FAILSLAB
-# define SLAB_FAILSLAB		0x02000000UL	/* Fault injection mark */
+# define SLAB_FAILSLAB		((slab_flags_t __force)0x02000000UL)
 #else
-# define SLAB_FAILSLAB		0x00000000UL
+# define SLAB_FAILSLAB		((slab_flags_t __force)0x00000000UL)
 #endif
+/* Account to memcg */
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
-# define SLAB_ACCOUNT		0x04000000UL	/* Account to memcg */
+# define SLAB_ACCOUNT		((slab_flags_t __force)0x04000000UL)
 #else
-# define SLAB_ACCOUNT		0x00000000UL
+# define SLAB_ACCOUNT		((slab_flags_t __force)0x00000000UL)
 #endif
 
 #ifdef CONFIG_KASAN
-#define SLAB_KASAN		0x08000000UL
+#define SLAB_KASAN		((slab_flags_t __force)0x08000000UL)
 #else
-#define SLAB_KASAN		0x00000000UL
+#define SLAB_KASAN		((slab_flags_t __force)0x00000000UL)
 #endif
 
 /* The following flags affect the page allocator grouping pages by mobility */
-#define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
+/* Objects are reclaimable */
+#define SLAB_RECLAIM_ACCOUNT	((slab_flags_t __force)0x00020000UL)
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
@@ -128,7 +142,7 @@ void __init kmem_cache_init(void);
 bool slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
-			unsigned long,
+			slab_flags_t,
 			void (*)(void *));
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
diff -puN include/linux/slub_def.h~slab-slub-slob-add-slab_flags_t include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-slub-slob-add-slab_flags_t
+++ a/include/linux/slub_def.h
@@ -82,7 +82,7 @@ struct kmem_cache_order_objects {
 struct kmem_cache {
 	struct kmem_cache_cpu __percpu *cpu_slab;
 	/* Used for retriving partial slabs etc */
-	unsigned long flags;
+	slab_flags_t flags;
 	unsigned long min_partial;
 	int size;		/* The size of an object including meta data */
 	int object_size;	/* The size of an object without meta data */
diff -puN include/linux/types.h~slab-slub-slob-add-slab_flags_t include/linux/types.h
--- a/include/linux/types.h~slab-slub-slob-add-slab_flags_t
+++ a/include/linux/types.h
@@ -156,6 +156,7 @@ typedef u32 dma_addr_t;
 #endif
 
 typedef unsigned __bitwise gfp_t;
+typedef unsigned long __bitwise slab_flags_t;
 typedef unsigned __bitwise fmode_t;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
diff -puN include/net/sock.h~slab-slub-slob-add-slab_flags_t include/net/sock.h
--- a/include/net/sock.h~slab-slub-slob-add-slab_flags_t
+++ a/include/net/sock.h
@@ -1105,7 +1105,7 @@ struct proto {
 
 	struct kmem_cache	*slab;
 	unsigned int		obj_size;
-	int			slab_flags;
+	slab_flags_t		slab_flags;
 
 	struct percpu_counter	*orphan_count;
 
diff -puN mm/kasan/kasan.c~slab-slub-slob-add-slab_flags_t mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~slab-slub-slob-add-slab_flags_t
+++ a/mm/kasan/kasan.c
@@ -337,7 +337,7 @@ static size_t optimal_redzone(size_t obj
 }
 
 void kasan_cache_create(struct kmem_cache *cache, size_t *size,
-			unsigned long *flags)
+			slab_flags_t *flags)
 {
 	int redzone_adjust;
 	int orig_size = *size;
diff -puN mm/slab.c~slab-slub-slob-add-slab_flags_t mm/slab.c
--- a/mm/slab.c~slab-slub-slob-add-slab_flags_t
+++ a/mm/slab.c
@@ -252,8 +252,8 @@ static void kmem_cache_node_init(struct
 	MAKE_LIST((cachep), (&(ptr)->slabs_free), slabs_free, nodeid);	\
 	} while (0)
 
-#define CFLGS_OBJFREELIST_SLAB	(0x40000000UL)
-#define CFLGS_OFF_SLAB		(0x80000000UL)
+#define CFLGS_OBJFREELIST_SLAB	((slab_flags_t __force)0x40000000UL)
+#define CFLGS_OFF_SLAB		((slab_flags_t __force)0x80000000UL)
 #define	OBJFREELIST_SLAB(x)	((x)->flags & CFLGS_OBJFREELIST_SLAB)
 #define	OFF_SLAB(x)	((x)->flags & CFLGS_OFF_SLAB)
 
@@ -441,7 +441,7 @@ static inline struct array_cache *cpu_ca
  * Calculate the number of objects and left-over bytes for a given buffer size.
  */
 static unsigned int cache_estimate(unsigned long gfporder, size_t buffer_size,
-		unsigned long flags, size_t *left_over)
+		slab_flags_t flags, size_t *left_over)
 {
 	unsigned int num;
 	size_t slab_size = PAGE_SIZE << gfporder;
@@ -1759,7 +1759,7 @@ static void slabs_destroy(struct kmem_ca
  * towards high-order requests, this should be changed.
  */
 static size_t calculate_slab_order(struct kmem_cache *cachep,
-				size_t size, unsigned long flags)
+				size_t size, slab_flags_t flags)
 {
 	size_t left_over = 0;
 	int gfporder;
@@ -1886,8 +1886,8 @@ static int __ref setup_cpu_cache(struct
 	return 0;
 }
 
-unsigned long kmem_cache_flags(unsigned long object_size,
-	unsigned long flags, const char *name,
+slab_flags_t kmem_cache_flags(unsigned long object_size,
+	slab_flags_t flags, const char *name,
 	void (*ctor)(void *))
 {
 	return flags;
@@ -1895,7 +1895,7 @@ unsigned long kmem_cache_flags(unsigned
 
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
-		   unsigned long flags, void (*ctor)(void *))
+		   slab_flags_t flags, void (*ctor)(void *))
 {
 	struct kmem_cache *cachep;
 
@@ -1913,7 +1913,7 @@ __kmem_cache_alias(const char *name, siz
 }
 
 static bool set_objfreelist_slab_cache(struct kmem_cache *cachep,
-			size_t size, unsigned long flags)
+			size_t size, slab_flags_t flags)
 {
 	size_t left;
 
@@ -1936,7 +1936,7 @@ static bool set_objfreelist_slab_cache(s
 }
 
 static bool set_off_slab_cache(struct kmem_cache *cachep,
-			size_t size, unsigned long flags)
+			size_t size, slab_flags_t flags)
 {
 	size_t left;
 
@@ -1970,7 +1970,7 @@ static bool set_off_slab_cache(struct km
 }
 
 static bool set_on_slab_cache(struct kmem_cache *cachep,
-			size_t size, unsigned long flags)
+			size_t size, slab_flags_t flags)
 {
 	size_t left;
 
@@ -2006,8 +2006,7 @@ static bool set_on_slab_cache(struct kme
  * cacheline.  This can be beneficial if you're counting cycles as closely
  * as davem.
  */
-int
-__kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
+int __kmem_cache_create(struct kmem_cache *cachep, slab_flags_t flags)
 {
 	size_t ralign = BYTES_PER_WORD;
 	gfp_t gfp;
diff -puN mm/slab_common.c~slab-slub-slob-add-slab_flags_t mm/slab_common.c
--- a/mm/slab_common.c~slab-slub-slob-add-slab_flags_t
+++ a/mm/slab_common.c
@@ -291,7 +291,7 @@ int slab_unmergeable(struct kmem_cache *
 }
 
 struct kmem_cache *find_mergeable(size_t size, size_t align,
-		unsigned long flags, const char *name, void (*ctor)(void *))
+		slab_flags_t flags, const char *name, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
 
@@ -341,7 +341,7 @@ struct kmem_cache *find_mergeable(size_t
  * Figure out what the alignment of the objects will be given a set of
  * flags, a user specified alignment and the size of the objects.
  */
-unsigned long calculate_alignment(unsigned long flags,
+unsigned long calculate_alignment(slab_flags_t flags,
 		unsigned long align, unsigned long size)
 {
 	/*
@@ -366,7 +366,7 @@ unsigned long calculate_alignment(unsign
 
 static struct kmem_cache *create_cache(const char *name,
 		size_t object_size, size_t size, size_t align,
-		unsigned long flags, void (*ctor)(void *),
+		slab_flags_t flags, void (*ctor)(void *),
 		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
 {
 	struct kmem_cache *s;
@@ -431,7 +431,7 @@ out_free_cache:
  */
 struct kmem_cache *
 kmem_cache_create(const char *name, size_t size, size_t align,
-		  unsigned long flags, void (*ctor)(void *))
+		  slab_flags_t flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s = NULL;
 	const char *cache_name;
@@ -879,7 +879,7 @@ bool slab_is_available(void)
 #ifndef CONFIG_SLOB
 /* Create a cache during boot when no slab services are available yet */
 void __init create_boot_cache(struct kmem_cache *s, const char *name, size_t size,
-		unsigned long flags)
+		slab_flags_t flags)
 {
 	int err;
 
@@ -899,7 +899,7 @@ void __init create_boot_cache(struct kme
 }
 
 struct kmem_cache *__init create_kmalloc_cache(const char *name, size_t size,
-				unsigned long flags)
+				slab_flags_t flags)
 {
 	struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);
 
@@ -1057,7 +1057,7 @@ void __init setup_kmalloc_cache_index_ta
 	}
 }
 
-static void __init new_kmalloc_cache(int idx, unsigned long flags)
+static void __init new_kmalloc_cache(int idx, slab_flags_t flags)
 {
 	kmalloc_caches[idx] = create_kmalloc_cache(kmalloc_info[idx].name,
 					kmalloc_info[idx].size, flags);
@@ -1068,7 +1068,7 @@ static void __init new_kmalloc_cache(int
  * may already have been created because they were needed to
  * enable allocations for slab creation.
  */
-void __init create_kmalloc_caches(unsigned long flags)
+void __init create_kmalloc_caches(slab_flags_t flags)
 {
 	int i;
 
diff -puN mm/slab.h~slab-slub-slob-add-slab_flags_t mm/slab.h
--- a/mm/slab.h~slab-slub-slob-add-slab_flags_t
+++ a/mm/slab.h
@@ -21,7 +21,7 @@ struct kmem_cache {
 	unsigned int object_size;/* The original size of the object */
 	unsigned int size;	/* The aligned/padded/added on size  */
 	unsigned int align;	/* Alignment as calculated */
-	unsigned long flags;	/* Active flags on the slab */
+	slab_flags_t flags;	/* Active flags on the slab */
 	const char *name;	/* Slab name for sysfs */
 	int refcount;		/* Use counter */
 	void (*ctor)(void *);	/* Called on object slot creation */
@@ -79,13 +79,13 @@ extern const struct kmalloc_info_struct
 	unsigned long size;
 } kmalloc_info[];
 
-unsigned long calculate_alignment(unsigned long flags,
+unsigned long calculate_alignment(slab_flags_t flags,
 		unsigned long align, unsigned long size);
 
 #ifndef CONFIG_SLOB
 /* Kmalloc array related functions */
 void setup_kmalloc_cache_index_table(void);
-void create_kmalloc_caches(unsigned long);
+void create_kmalloc_caches(slab_flags_t);
 
 /* Find the kmalloc slab corresponding for a certain size */
 struct kmem_cache *kmalloc_slab(size_t, gfp_t);
@@ -93,32 +93,32 @@ struct kmem_cache *kmalloc_slab(size_t,
 
 
 /* Functions provided by the slab allocators */
-extern int __kmem_cache_create(struct kmem_cache *, unsigned long flags);
+int __kmem_cache_create(struct kmem_cache *, slab_flags_t flags);
 
 extern struct kmem_cache *create_kmalloc_cache(const char *name, size_t size,
-			unsigned long flags);
+			slab_flags_t flags);
 extern void create_boot_cache(struct kmem_cache *, const char *name,
-			size_t size, unsigned long flags);
+			size_t size, slab_flags_t flags);
 
 int slab_unmergeable(struct kmem_cache *s);
 struct kmem_cache *find_mergeable(size_t size, size_t align,
-		unsigned long flags, const char *name, void (*ctor)(void *));
+		slab_flags_t flags, const char *name, void (*ctor)(void *));
 #ifndef CONFIG_SLOB
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
-		   unsigned long flags, void (*ctor)(void *));
+		   slab_flags_t flags, void (*ctor)(void *));
 
-unsigned long kmem_cache_flags(unsigned long object_size,
-	unsigned long flags, const char *name,
+slab_flags_t kmem_cache_flags(unsigned long object_size,
+	slab_flags_t flags, const char *name,
 	void (*ctor)(void *));
 #else
 static inline struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
-		   unsigned long flags, void (*ctor)(void *))
+		   slab_flags_t flags, void (*ctor)(void *))
 { return NULL; }
 
-static inline unsigned long kmem_cache_flags(unsigned long object_size,
-	unsigned long flags, const char *name,
+static inline slab_flags_t kmem_cache_flags(unsigned long object_size,
+	slab_flags_t flags, const char *name,
 	void (*ctor)(void *))
 {
 	return flags;
diff -puN mm/slob.c~slab-slub-slob-add-slab_flags_t mm/slob.c
--- a/mm/slob.c~slab-slub-slob-add-slab_flags_t
+++ a/mm/slob.c
@@ -524,7 +524,7 @@ size_t ksize(const void *block)
 }
 EXPORT_SYMBOL(ksize);
 
-int __kmem_cache_create(struct kmem_cache *c, unsigned long flags)
+int __kmem_cache_create(struct kmem_cache *c, slab_flags_t flags)
 {
 	if (flags & SLAB_TYPESAFE_BY_RCU) {
 		/* leave room for rcu footer at the end of object */
diff -puN mm/slub.c~slab-slub-slob-add-slab_flags_t mm/slub.c
--- a/mm/slub.c~slab-slub-slob-add-slab_flags_t
+++ a/mm/slub.c
@@ -193,8 +193,10 @@ static inline bool kmem_cache_has_cpu_pa
 #define MAX_OBJS_PER_PAGE	32767 /* since page.objects is u15 */
 
 /* Internal SLUB flags */
-#define __OBJECT_POISON		0x80000000UL /* Poison object */
-#define __CMPXCHG_DOUBLE	0x40000000UL /* Use cmpxchg_double */
+/* Poison object */
+#define __OBJECT_POISON		((slab_flags_t __force)0x80000000UL)
+/* Use cmpxchg_double */
+#define __CMPXCHG_DOUBLE	((slab_flags_t __force)0x40000000UL)
 
 /*
  * Tracking user of a slab.
@@ -485,9 +487,9 @@ static inline void *restore_red_left(str
  * Debug settings:
  */
 #if defined(CONFIG_SLUB_DEBUG_ON)
-static int slub_debug = DEBUG_DEFAULT_FLAGS;
+static slab_flags_t slub_debug = DEBUG_DEFAULT_FLAGS;
 #else
-static int slub_debug;
+static slab_flags_t slub_debug;
 #endif
 
 static char *slub_debug_slabs;
@@ -1289,8 +1291,8 @@ out:
 
 __setup("slub_debug", setup_slub_debug);
 
-unsigned long kmem_cache_flags(unsigned long object_size,
-	unsigned long flags, const char *name,
+slab_flags_t kmem_cache_flags(unsigned long object_size,
+	slab_flags_t flags, const char *name,
 	void (*ctor)(void *))
 {
 	/*
@@ -1322,8 +1324,8 @@ static inline void add_full(struct kmem_
 					struct page *page) {}
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct page *page) {}
-unsigned long kmem_cache_flags(unsigned long object_size,
-	unsigned long flags, const char *name,
+slab_flags_t kmem_cache_flags(unsigned long object_size,
+	slab_flags_t flags, const char *name,
 	void (*ctor)(void *))
 {
 	return flags;
@@ -3477,7 +3479,7 @@ static void set_cpu_partial(struct kmem_
  */
 static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
-	unsigned long flags = s->flags;
+	slab_flags_t flags = s->flags;
 	size_t size = s->object_size;
 	int order;
 
@@ -3593,7 +3595,7 @@ static int calculate_sizes(struct kmem_c
 	return !!oo_objects(s->oo);
 }
 
-static int kmem_cache_open(struct kmem_cache *s, unsigned long flags)
+static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 {
 	s->flags = kmem_cache_flags(s->size, flags, s->name, s->ctor);
 	s->reserved = 0;
@@ -4245,7 +4247,7 @@ void __init kmem_cache_init_late(void)
 
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
-		   unsigned long flags, void (*ctor)(void *))
+		   slab_flags_t flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s, *c;
 
@@ -4275,7 +4277,7 @@ __kmem_cache_alias(const char *name, siz
 	return s;
 }
 
-int __kmem_cache_create(struct kmem_cache *s, unsigned long flags)
+int __kmem_cache_create(struct kmem_cache *s, slab_flags_t flags)
 {
 	int err;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

slab-slub-slob-add-slab_flags_t.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit.patch
proc-uninline-name_to_int.patch
proc-use-do-while-in-name_to_int.patch
seq_file-delete-small-value-optimization.patch

