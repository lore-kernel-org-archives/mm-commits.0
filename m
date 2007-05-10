From: akpm@linux-foundation.org
Subject: - slob-implement-rcu-freeing.patch removed from -mm tree
Date: Thu, 10 May 2007 12:27:19 -0700
Message-ID: <200705101927.l4AJRJms028293@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbXEJT2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 15:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, mpm@selenic.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     slob: implement RCU freeing
has been removed from the -mm tree.  Its filename was
     slob-implement-rcu-freeing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: slob: implement RCU freeing
From: Nick Piggin <nickpiggin@yahoo.com.au>

The SLOB allocator should implement SLAB_DESTROY_BY_RCU correctly, because
even on UP, RCU freeing semantics are not equivalent to simply freeing
immediately.  This also allows SLOB to be used on SMP.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    7 +-----
 mm/slob.c    |   52 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 12 deletions(-)

diff -puN init/Kconfig~slob-implement-rcu-freeing init/Kconfig
--- a/init/Kconfig~slob-implement-rcu-freeing
+++ a/init/Kconfig
@@ -537,14 +537,11 @@ config SLUB
 	   and has enhanced diagnostics.
 
 config SLOB
-#
-#	SLOB does not support SMP because SLAB_DESTROY_BY_RCU is unsupported
-#
-	depends on EMBEDDED && !SMP && !SPARSEMEM
+	depends on EMBEDDED && !SPARSEMEM
 	bool "SLOB (Simple Allocator)"
 	help
 	   SLOB replaces the SLAB allocator with a drastically simpler
-	   allocator.  SLOB is more space efficient that SLAB but does not
+	   allocator.  SLOB is more space efficient than SLAB but does not
 	   scale well (single lock for all operations) and is also highly
 	   susceptible to fragmentation. SLUB can accomplish a higher object
 	   density. It is usually better to use SLUB instead of SLOB.
diff -puN mm/slob.c~slob-implement-rcu-freeing mm/slob.c
--- a/mm/slob.c~slob-implement-rcu-freeing
+++ a/mm/slob.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
+#include <linux/rcupdate.h>
 
 struct slob_block {
 	int units;
@@ -53,6 +54,16 @@ struct bigblock {
 };
 typedef struct bigblock bigblock_t;
 
+/*
+ * struct slob_rcu is inserted at the tail of allocated slob blocks, which
+ * were created with a SLAB_DESTROY_BY_RCU slab. slob_rcu is used to free
+ * the block using call_rcu.
+ */
+struct slob_rcu {
+	struct rcu_head head;
+	int size;
+};
+
 static slob_t arena = { .next = &arena, .units = 1 };
 static slob_t *slobfree = &arena;
 static bigblock_t *bigblocks;
@@ -266,6 +277,7 @@ size_t ksize(const void *block)
 
 struct kmem_cache {
 	unsigned int size, align;
+	unsigned long flags;
 	const char *name;
 	void (*ctor)(void *, struct kmem_cache *, unsigned long);
 	void (*dtor)(void *, struct kmem_cache *, unsigned long);
@@ -283,6 +295,12 @@ struct kmem_cache *kmem_cache_create(con
 	if (c) {
 		c->name = name;
 		c->size = size;
+		if (flags & SLAB_DESTROY_BY_RCU) {
+			BUG_ON(c->dtor);
+			/* leave room for rcu footer at the end of object */
+			c->size += sizeof(struct slob_rcu);
+		}
+		c->flags = flags;
 		c->ctor = ctor;
 		c->dtor = dtor;
 		/* ignore alignment unless it's forced */
@@ -328,15 +346,35 @@ void *kmem_cache_zalloc(struct kmem_cach
 }
 EXPORT_SYMBOL(kmem_cache_zalloc);
 
-void kmem_cache_free(struct kmem_cache *c, void *b)
+static void __kmem_cache_free(void *b, int size)
 {
-	if (c->dtor)
-		c->dtor(b, c, 0);
-
-	if (c->size < PAGE_SIZE)
-		slob_free(b, c->size);
+	if (size < PAGE_SIZE)
+		slob_free(b, size);
 	else
-		free_pages((unsigned long)b, get_order(c->size));
+		free_pages((unsigned long)b, get_order(size));
+}
+
+static void kmem_rcu_free(struct rcu_head *head)
+{
+	struct slob_rcu *slob_rcu = (struct slob_rcu *)head;
+	void *b = (void *)slob_rcu - (slob_rcu->size - sizeof(struct slob_rcu));
+
+	__kmem_cache_free(b, slob_rcu->size);
+}
+
+void kmem_cache_free(struct kmem_cache *c, void *b)
+{
+	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
+		struct slob_rcu *slob_rcu;
+		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
+		INIT_RCU_HEAD(&slob_rcu->head);
+		slob_rcu->size = c->size;
+		call_rcu(&slob_rcu->head, kmem_rcu_free);
+	} else {
+		if (c->dtor)
+			c->dtor(b, c, 0);
+		__kmem_cache_free(b, c->size);
+	}
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
ia64-race-flushing-icache-in-do_no_page-path.patch
slob-implement-rcu-freeing.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
sched2-sched-domain-sysctl.patch
