From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-keep-a-separate-lazy-free-list.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:46:01 -0700
Message-ID: <57435df9.Eek7IYcVRY1N+KmD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, iamjoonsoo.kim@lge.com, joonas.lahtinen@linux.intel.com, mgorman@techsingularity.net, r.peniaev@gmail.com, rientjes@google.com, shawn.lin@rock-chips.com, toshi.kani@hp.com, tvrtko.ursulin@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: keep a separate lazy-free list
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-keep-a-separate-lazy-free-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: mm/vmalloc: keep a separate lazy-free list

When mixing lots of vmallocs and set_memory_*() (which calls
vm_unmap_aliases()) I encountered situations where the performance
degraded severely due to the walking of the entire vmap_area list each
invocation.  One simple improvement is to add the lazily freed vmap_area
to a separate lockless free list, such that we then avoid having to walk
the full list on each purge.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Roman Pen <r.peniaev@gmail.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Pen <r.peniaev@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    3 +-
 mm/vmalloc.c            |   39 ++++++++++++++++++--------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-keep-a-separate-lazy-free-list include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-keep-a-separate-lazy-free-list
+++ a/include/linux/vmalloc.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <asm/page.h>		/* pgprot_t */
 #include <linux/rbtree.h>
 
@@ -44,7 +45,7 @@ struct vmap_area {
 	unsigned long flags;
 	struct rb_node rb_node;         /* address sorted rbtree */
 	struct list_head list;          /* address sorted list */
-	struct list_head purge_list;    /* "lazy purge" list */
+	struct llist_node purge_list;    /* "lazy purge" list */
 	struct vm_struct *vm;
 	struct rcu_head rcu_head;
 };
diff -puN mm/vmalloc.c~mm-vmalloc-keep-a-separate-lazy-free-list mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-keep-a-separate-lazy-free-list
+++ a/mm/vmalloc.c
@@ -274,13 +274,12 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 
 /*** Global kva allocator ***/
 
-#define VM_LAZY_FREE	0x01
-#define VM_LAZY_FREEING	0x02
 #define VM_VM_AREA	0x04
 
 static DEFINE_SPINLOCK(vmap_area_lock);
 /* Export for kexec only */
 LIST_HEAD(vmap_area_list);
+static LLIST_HEAD(vmap_purge_list);
 static struct rb_root vmap_area_root = RB_ROOT;
 
 /* The vmap cache globals are protected by vmap_area_lock */
@@ -601,7 +600,7 @@ static void __purge_vmap_area_lazy(unsig
 					int sync, int force_flush)
 {
 	static DEFINE_SPINLOCK(purge_lock);
-	LIST_HEAD(valist);
+	struct llist_node *valist;
 	struct vmap_area *va;
 	struct vmap_area *n_va;
 	int nr = 0;
@@ -620,20 +619,14 @@ static void __purge_vmap_area_lazy(unsig
 	if (sync)
 		purge_fragmented_blocks_allcpus();
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(va, &vmap_area_list, list) {
-		if (va->flags & VM_LAZY_FREE) {
-			if (va->va_start < *start)
-				*start = va->va_start;
-			if (va->va_end > *end)
-				*end = va->va_end;
-			nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
-			list_add_tail(&va->purge_list, &valist);
-			va->flags |= VM_LAZY_FREEING;
-			va->flags &= ~VM_LAZY_FREE;
-		}
+	valist = llist_del_all(&vmap_purge_list);
+	llist_for_each_entry(va, valist, purge_list) {
+		if (va->va_start < *start)
+			*start = va->va_start;
+		if (va->va_end > *end)
+			*end = va->va_end;
+		nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
 	}
-	rcu_read_unlock();
 
 	if (nr)
 		atomic_sub(nr, &vmap_lazy_nr);
@@ -643,7 +636,7 @@ static void __purge_vmap_area_lazy(unsig
 
 	if (nr) {
 		spin_lock(&vmap_area_lock);
-		list_for_each_entry_safe(va, n_va, &valist, purge_list)
+		llist_for_each_entry_safe(va, n_va, valist, purge_list)
 			__free_vmap_area(va);
 		spin_unlock(&vmap_area_lock);
 	}
@@ -678,9 +671,15 @@ static void purge_vmap_area_lazy(void)
  */
 static void free_vmap_area_noflush(struct vmap_area *va)
 {
-	va->flags |= VM_LAZY_FREE;
-	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
-	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
+	int nr_lazy;
+
+	nr_lazy = atomic_add_return((va->va_end - va->va_start) >> PAGE_SHIFT,
+				    &vmap_lazy_nr);
+
+	/* After this point, we may free va at any time */
+	llist_add(&va->purge_list, &vmap_purge_list);
+
+	if (unlikely(nr_lazy > lazy_max_pages()))
 		try_purge_vmap_area_lazy();
 }
 
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are


