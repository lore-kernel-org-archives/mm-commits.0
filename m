From: akpm@linux-foundation.org
Subject: [patch 014/119] mm: add SLUB free list pointer obfuscation
Date: Wed, 06 Sep 2017 16:19:18 -0700
Message-ID: <20170906231918.6qgchuscs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49212 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdIFXTU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.popov@linux.com, cl@linux.com, danielmicay@gmail.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, mm-commits@vger.kernel.org, penberg@kernel.org, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, tycho@docker.com

From: Kees Cook <keescook@chromium.org>
Subject: mm: add SLUB free list pointer obfuscation

This SLUB free list pointer obfuscation code is modified from Brad
Spengler/PaX Team's code in the last public patch of grsecurity/PaX based
on my understanding of the code.  Changes or omissions from the original
code are mine and don't reflect the original grsecurity/PaX code.

This adds a per-cache random value to SLUB caches that is XORed with their
freelist pointer address and value.  This adds nearly zero overhead and
frustrates the very common heap overflow exploitation method of
overwriting freelist pointers.  A recent example of the attack is written
up here: http://cyseclabs.com/blog/cve-2016-6187-heap-off-by-one-exploit
and there is a section dedicated to the technique the book "A Guide to
Kernel Exploitation: Attacking the Core".

This is based on patches by Daniel Micay, and refactored to minimize the
use of #ifdef.

With 200-count cycles of "hackbench -g 20 -l 1000" I saw the following
run times:

before:
	mean 10.11882499999999999995
	variance .03320378329145728642
	stdev .18221905304181911048

after:
	mean 10.12654000000000000014
	variance .04700556623115577889
	stdev .21680767106160192064

The difference gets lost in the noise, but if the above is to be taken
literally, using CONFIG_FREELIST_HARDENED is 0.07% slower.

Link: http://lkml.kernel.org/r/20170802180609.GA66807@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Daniel Micay <danielmicay@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tycho Andersen <tycho@docker.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    4 +++
 init/Kconfig             |    9 +++++++
 mm/slub.c                |   42 ++++++++++++++++++++++++++++++++-----
 3 files changed, 50 insertions(+), 5 deletions(-)

diff -puN include/linux/slub_def.h~mm-add-slub-free-list-pointer-obfuscation include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-add-slub-free-list-pointer-obfuscation
+++ a/include/linux/slub_def.h
@@ -115,6 +115,10 @@ struct kmem_cache {
 #endif
 #endif
 
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	unsigned long random;
+#endif
+
 #ifdef CONFIG_NUMA
 	/*
 	 * Defragmentation by allocating from a remote node.
diff -puN init/Kconfig~mm-add-slub-free-list-pointer-obfuscation init/Kconfig
--- a/init/Kconfig~mm-add-slub-free-list-pointer-obfuscation
+++ a/init/Kconfig
@@ -1576,6 +1576,15 @@ config SLAB_FREELIST_RANDOM
 	  security feature reduces the predictability of the kernel slab
 	  allocator against heap overflows.
 
+config SLAB_FREELIST_HARDENED
+	bool "Harden slab freelist metadata"
+	depends on SLUB
+	help
+	  Many kernel heap attacks try to target slab cache metadata and
+	  other infrastructure. This options makes minor performance
+	  sacrifies to harden the kernel slab allocator against common
+	  freelist exploit methods.
+
 config SLUB_CPU_PARTIAL
 	default y
 	depends on SLUB && SMP
diff -puN mm/slub.c~mm-add-slub-free-list-pointer-obfuscation mm/slub.c
--- a/mm/slub.c~mm-add-slub-free-list-pointer-obfuscation
+++ a/mm/slub.c
@@ -34,6 +34,7 @@
 #include <linux/stacktrace.h>
 #include <linux/prefetch.h>
 #include <linux/memcontrol.h>
+#include <linux/random.h>
 
 #include <trace/events/kmem.h>
 
@@ -238,30 +239,58 @@ static inline void stat(const struct kme
  * 			Core slab cache functions
  *******************************************************************/
 
+/*
+ * Returns freelist pointer (ptr). With hardening, this is obfuscated
+ * with an XOR of the address where the pointer is held and a per-cache
+ * random number.
+ */
+static inline void *freelist_ptr(const struct kmem_cache *s, void *ptr,
+				 unsigned long ptr_addr)
+{
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	return (void *)((unsigned long)ptr ^ s->random ^ ptr_addr);
+#else
+	return ptr;
+#endif
+}
+
+/* Returns the freelist pointer recorded at location ptr_addr. */
+static inline void *freelist_dereference(const struct kmem_cache *s,
+					 void *ptr_addr)
+{
+	return freelist_ptr(s, (void *)*(unsigned long *)(ptr_addr),
+			    (unsigned long)ptr_addr);
+}
+
 static inline void *get_freepointer(struct kmem_cache *s, void *object)
 {
-	return *(void **)(object + s->offset);
+	return freelist_dereference(s, object + s->offset);
 }
 
 static void prefetch_freepointer(const struct kmem_cache *s, void *object)
 {
-	prefetch(object + s->offset);
+	if (object)
+		prefetch(freelist_dereference(s, object + s->offset));
 }
 
 static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
 {
+	unsigned long freepointer_addr;
 	void *p;
 
 	if (!debug_pagealloc_enabled())
 		return get_freepointer(s, object);
 
-	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
-	return p;
+	freepointer_addr = (unsigned long)object + s->offset;
+	probe_kernel_read(&p, (void **)freepointer_addr, sizeof(p));
+	return freelist_ptr(s, p, freepointer_addr);
 }
 
 static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 {
-	*(void **)(object + s->offset) = fp;
+	unsigned long freeptr_addr = (unsigned long)object + s->offset;
+
+	*(void **)freeptr_addr = freelist_ptr(s, fp, freeptr_addr);
 }
 
 /* Loop over all objects in a slab */
@@ -3563,6 +3592,9 @@ static int kmem_cache_open(struct kmem_c
 {
 	s->flags = kmem_cache_flags(s->size, flags, s->name, s->ctor);
 	s->reserved = 0;
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	s->random = get_random_long();
+#endif
 
 	if (need_reserve_slab_rcu && (s->flags & SLAB_TYPESAFE_BY_RCU))
 		s->reserved = sizeof(struct rcu_head);
_
