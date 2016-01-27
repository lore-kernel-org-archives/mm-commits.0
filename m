From: akpm@linux-foundation.org
Subject: + mm-slab-alternative-implementation-for-debug_slab_leak.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 21:30:24 -0800
Message-ID: <56a855f0.RtAJjF3SfotGGeKR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbcA0Fa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: alternative implementation for DEBUG_SLAB_LEAK
has been added to the -mm tree.  Its filename is
     mm-slab-alternative-implementation-for-debug_slab_leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-alternative-implementation-for-debug_slab_leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-alternative-implementation-for-debug_slab_leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slab: alternative implementation for DEBUG_SLAB_LEAK

DEBUG_SLAB_LEAK is a debug option.  It's current implementation requires
status buffer so we need more memory to use it.  And, it cause kmem_cache
initialization step more complex.

To remove this extra memory usage and to simplify initialization step,
this patch implement this feature with another way.

When user requests to get slab object owner information, it marks that
getting information is started.  And then, all free objects in caches are
flushed to corresponding slab page.  Now, we can distinguish all freed
object so we can know all allocated objects, too.  After collecting slab
object owner information on allocated objects, mark is checked that there
is no free during the processing.  If true, we can be sure that our
information is correct so information is returned to user.

Although this way is rather complex, it has two important benefits
mentioned above.  So, I think it is worth changing.

There is one drawback that it takes more time to get slab object owner
information but it is just a debug option so it doesn't matter at all.

To help review, this patch implements new way only.  Following patch will
remove useless code.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab_def.h |    3 +
 mm/slab.c                |   85 +++++++++++++++++++++++++++----------
 2 files changed, 66 insertions(+), 22 deletions(-)

diff -puN include/linux/slab_def.h~mm-slab-alternative-implementation-for-debug_slab_leak include/linux/slab_def.h
--- a/include/linux/slab_def.h~mm-slab-alternative-implementation-for-debug_slab_leak
+++ a/include/linux/slab_def.h
@@ -60,6 +60,9 @@ struct kmem_cache {
 	atomic_t allocmiss;
 	atomic_t freehit;
 	atomic_t freemiss;
+#ifdef CONFIG_DEBUG_SLAB_LEAK
+	atomic_t store_user_clean;
+#endif
 
 	/*
 	 * If debugging is enabled, then the allocator can add additional
diff -puN mm/slab.c~mm-slab-alternative-implementation-for-debug_slab_leak mm/slab.c
--- a/mm/slab.c~mm-slab-alternative-implementation-for-debug_slab_leak
+++ a/mm/slab.c
@@ -396,20 +396,25 @@ static void set_obj_status(struct page *
 	status[idx] = val;
 }
 
-static inline unsigned int get_obj_status(struct page *page, int idx)
+static inline bool is_store_user_clean(struct kmem_cache *cachep)
 {
-	int freelist_size;
-	char *status;
-	struct kmem_cache *cachep = page->slab_cache;
+	return atomic_read(&cachep->store_user_clean) == 1;
+}
 
-	freelist_size = cachep->num * sizeof(freelist_idx_t);
-	status = (char *)page->freelist + freelist_size;
+static inline void set_store_user_clean(struct kmem_cache *cachep)
+{
+	atomic_set(&cachep->store_user_clean, 1);
+}
 
-	return status[idx];
+static inline void set_store_user_dirty(struct kmem_cache *cachep)
+{
+	if (is_store_user_clean(cachep))
+		atomic_set(&cachep->store_user_clean, 0);
 }
 
 #else
 static inline void set_obj_status(struct page *page, int idx, int val) {}
+static inline void set_store_user_dirty(struct kmem_cache *cachep) {}
 
 #endif
 
@@ -2550,6 +2555,11 @@ static void *slab_get_obj(struct kmem_ca
 	objp = index_to_obj(cachep, page, get_free_obj(page, page->active));
 	page->active++;
 
+#if DEBUG
+	if (cachep->flags & SLAB_STORE_USER)
+		set_store_user_dirty(cachep);
+#endif
+
 	return objp;
 }
 
@@ -2725,8 +2735,10 @@ static void *cache_free_debugcheck(struc
 		*dbg_redzone1(cachep, objp) = RED_INACTIVE;
 		*dbg_redzone2(cachep, objp) = RED_INACTIVE;
 	}
-	if (cachep->flags & SLAB_STORE_USER)
+	if (cachep->flags & SLAB_STORE_USER) {
+		set_store_user_dirty(cachep);
 		*dbg_userword(cachep, objp) = (void *)caller;
+	}
 
 	objnr = obj_to_index(cachep, page, objp);
 
@@ -4117,15 +4129,34 @@ static void handle_slab(unsigned long *n
 						struct page *page)
 {
 	void *p;
-	int i;
+	int i, j;
+	unsigned long v;
 
 	if (n[0] == n[1])
 		return;
 	for (i = 0, p = page->s_mem; i < c->num; i++, p += c->size) {
-		if (get_obj_status(page, i) != OBJECT_ACTIVE)
+		bool active = true;
+
+		for (j = page->active; j < c->num; j++) {
+			if (get_free_obj(page, j) == i) {
+				active = false;
+				break;
+			}
+		}
+
+		if (!active)
+			continue;
+
+		/*
+		 * probe_kernel_read() is used for DEBUG_PAGEALLOC. page table
+		 * mapping is established when actual object allocation and
+		 * we could mistakenly access the unmapped object in the cpu
+		 * cache.
+		 */
+		if (probe_kernel_read(&v, dbg_userword(c, p), sizeof(v)))
 			continue;
 
-		if (!add_caller(n, (unsigned long)*dbg_userword(c, p)))
+		if (!add_caller(n, v))
 			return;
 	}
 }
@@ -4161,21 +4192,31 @@ static int leaks_show(struct seq_file *m
 	if (!(cachep->flags & SLAB_RED_ZONE))
 		return 0;
 
-	/* OK, we can do it */
+	/*
+	 * Set store_user_clean and start to grab stored user information
+	 * for all objects on this cache. If some alloc/free requests comes
+	 * during the processing, information would be wrong so restart
+	 * whole processing.
+	 */
+	do {
+		set_store_user_clean(cachep);
+		drain_cpu_caches(cachep);
 
-	x[1] = 0;
+		x[1] = 0;
 
-	for_each_kmem_cache_node(cachep, node, n) {
+		for_each_kmem_cache_node(cachep, node, n) {
 
-		check_irq_on();
-		spin_lock_irq(&n->list_lock);
+			check_irq_on();
+			spin_lock_irq(&n->list_lock);
+
+			list_for_each_entry(page, &n->slabs_full, lru)
+				handle_slab(x, cachep, page);
+			list_for_each_entry(page, &n->slabs_partial, lru)
+				handle_slab(x, cachep, page);
+			spin_unlock_irq(&n->list_lock);
+		}
+	} while (!is_store_user_clean(cachep));
 
-		list_for_each_entry(page, &n->slabs_full, lru)
-			handle_slab(x, cachep, page);
-		list_for_each_entry(page, &n->slabs_partial, lru)
-			handle_slab(x, cachep, page);
-		spin_unlock_irq(&n->list_lock);
-	}
 	name = cachep->name;
 	if (x[0] == x[1]) {
 		/* Increase the buffer size */
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch

