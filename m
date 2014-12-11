From: akpm@linux-foundation.org
Subject: [merged] mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:49 -0800
Message-ID: <5489e92d./kZ/4L5I38wpSKnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbaLKS5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, iamjoonsoo.kim@lge.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_cgroup: rename file to mm/swap_cgroup.c
has been removed from the -mm tree.  Its filename was
     mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_cgroup: rename file to mm/swap_cgroup.c

Now that the external page_cgroup data structure and its lookup is gone,
the only code remaining in there is swap slot accounting.

Rename it and move the conditional compilation into mm/Makefile.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                 |    2 
 include/linux/page_cgroup.h |   40 ------
 include/linux/swap_cgroup.h |   42 ++++++
 mm/Makefile                 |    3 
 mm/memcontrol.c             |    2 
 mm/page_cgroup.c            |  211 ----------------------------------
 mm/swap_cgroup.c            |  208 +++++++++++++++++++++++++++++++++
 mm/swap_state.c             |    1 
 mm/swapfile.c               |    2 
 9 files changed, 255 insertions(+), 256 deletions(-)

diff -puN MAINTAINERS~mm-page_cgroup-rename-file-to-mm-swap_cgroupc MAINTAINERS
--- a/MAINTAINERS~mm-page_cgroup-rename-file-to-mm-swap_cgroupc
+++ a/MAINTAINERS
@@ -2606,7 +2606,7 @@ L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
-F:	mm/page_cgroup.c
+F:	mm/swap_cgroup.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu@intel.com>
diff -puN include/linux/page_cgroup.h~mm-page_cgroup-rename-file-to-mm-swap_cgroupc /dev/null
--- a/include/linux/page_cgroup.h
+++ /dev/null
@@ -1,40 +0,0 @@
-#ifndef __LINUX_PAGE_CGROUP_H
-#define __LINUX_PAGE_CGROUP_H
-
-#include <linux/swap.h>
-
-#ifdef CONFIG_MEMCG_SWAP
-extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new);
-extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
-extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
-extern int swap_cgroup_swapon(int type, unsigned long max_pages);
-extern void swap_cgroup_swapoff(int type);
-#else
-
-static inline
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
-{
-	return 0;
-}
-
-static inline
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	return 0;
-}
-
-static inline int
-swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	return 0;
-}
-
-static inline void swap_cgroup_swapoff(int type)
-{
-	return;
-}
-
-#endif /* CONFIG_MEMCG_SWAP */
-
-#endif /* __LINUX_PAGE_CGROUP_H */
diff -puN /dev/null include/linux/swap_cgroup.h
--- /dev/null
+++ a/include/linux/swap_cgroup.h
@@ -0,0 +1,42 @@
+#ifndef __LINUX_SWAP_CGROUP_H
+#define __LINUX_SWAP_CGROUP_H
+
+#include <linux/swap.h>
+
+#ifdef CONFIG_MEMCG_SWAP
+
+extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
+					unsigned short old, unsigned short new);
+extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
+extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
+extern int swap_cgroup_swapon(int type, unsigned long max_pages);
+extern void swap_cgroup_swapoff(int type);
+
+#else
+
+static inline
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
+{
+	return 0;
+}
+
+static inline
+unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
+{
+	return 0;
+}
+
+static inline int
+swap_cgroup_swapon(int type, unsigned long max_pages)
+{
+	return 0;
+}
+
+static inline void swap_cgroup_swapoff(int type)
+{
+	return;
+}
+
+#endif /* CONFIG_MEMCG_SWAP */
+
+#endif /* __LINUX_SWAP_CGROUP_H */
diff -puN mm/Makefile~mm-page_cgroup-rename-file-to-mm-swap_cgroupc mm/Makefile
--- a/mm/Makefile~mm-page_cgroup-rename-file-to-mm-swap_cgroupc
+++ a/mm/Makefile
@@ -56,7 +56,8 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_MEMCG) += memcontrol.o page_cgroup.o vmpressure.o
+obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
+obj-$(CONFIG_MEMCG_SWAP) += swap_cgroup.o
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
diff -puN mm/memcontrol.c~mm-page_cgroup-rename-file-to-mm-swap_cgroupc mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_cgroup-rename-file-to-mm-swap_cgroupc
+++ a/mm/memcontrol.c
@@ -51,7 +51,7 @@
 #include <linux/seq_file.h>
 #include <linux/vmpressure.h>
 #include <linux/mm_inline.h>
-#include <linux/page_cgroup.h>
+#include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
 #include <linux/lockdep.h>
diff -puN mm/page_cgroup.c~mm-page_cgroup-rename-file-to-mm-swap_cgroupc /dev/null
--- a/mm/page_cgroup.c
+++ /dev/null
@@ -1,211 +0,0 @@
-#include <linux/mm.h>
-#include <linux/page_cgroup.h>
-#include <linux/vmalloc.h>
-#include <linux/swapops.h>
-
-#ifdef CONFIG_MEMCG_SWAP
-
-static DEFINE_MUTEX(swap_cgroup_mutex);
-struct swap_cgroup_ctrl {
-	struct page **map;
-	unsigned long length;
-	spinlock_t	lock;
-};
-
-static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
-
-struct swap_cgroup {
-	unsigned short		id;
-};
-#define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
-
-/*
- * SwapCgroup implements "lookup" and "exchange" operations.
- * In typical usage, this swap_cgroup is accessed via memcg's charge/uncharge
- * against SwapCache. At swap_free(), this is accessed directly from swap.
- *
- * This means,
- *  - we have no race in "exchange" when we're accessed via SwapCache because
- *    SwapCache(and its swp_entry) is under lock.
- *  - When called via swap_free(), there is no user of this entry and no race.
- * Then, we don't need lock around "exchange".
- *
- * TODO: we can push these buffers out to HIGHMEM.
- */
-
-/*
- * allocate buffer for swap_cgroup.
- */
-static int swap_cgroup_prepare(int type)
-{
-	struct page *page;
-	struct swap_cgroup_ctrl *ctrl;
-	unsigned long idx, max;
-
-	ctrl = &swap_cgroup_ctrl[type];
-
-	for (idx = 0; idx < ctrl->length; idx++) {
-		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-		if (!page)
-			goto not_enough_page;
-		ctrl->map[idx] = page;
-	}
-	return 0;
-not_enough_page:
-	max = idx;
-	for (idx = 0; idx < max; idx++)
-		__free_page(ctrl->map[idx]);
-
-	return -ENOMEM;
-}
-
-static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
-					struct swap_cgroup_ctrl **ctrlp)
-{
-	pgoff_t offset = swp_offset(ent);
-	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
-	struct swap_cgroup *sc;
-
-	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
-	if (ctrlp)
-		*ctrlp = ctrl;
-
-	mappage = ctrl->map[offset / SC_PER_PAGE];
-	sc = page_address(mappage);
-	return sc + offset % SC_PER_PAGE;
-}
-
-/**
- * swap_cgroup_cmpxchg - cmpxchg mem_cgroup's id for this swp_entry.
- * @ent: swap entry to be cmpxchged
- * @old: old id
- * @new: new id
- *
- * Returns old id at success, 0 at failure.
- * (There is no mem_cgroup using 0 as its id)
- */
-unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new)
-{
-	struct swap_cgroup_ctrl *ctrl;
-	struct swap_cgroup *sc;
-	unsigned long flags;
-	unsigned short retval;
-
-	sc = lookup_swap_cgroup(ent, &ctrl);
-
-	spin_lock_irqsave(&ctrl->lock, flags);
-	retval = sc->id;
-	if (retval == old)
-		sc->id = new;
-	else
-		retval = 0;
-	spin_unlock_irqrestore(&ctrl->lock, flags);
-	return retval;
-}
-
-/**
- * swap_cgroup_record - record mem_cgroup for this swp_entry.
- * @ent: swap entry to be recorded into
- * @id: mem_cgroup to be recorded
- *
- * Returns old value at success, 0 at failure.
- * (Of course, old value can be 0.)
- */
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
-{
-	struct swap_cgroup_ctrl *ctrl;
-	struct swap_cgroup *sc;
-	unsigned short old;
-	unsigned long flags;
-
-	sc = lookup_swap_cgroup(ent, &ctrl);
-
-	spin_lock_irqsave(&ctrl->lock, flags);
-	old = sc->id;
-	sc->id = id;
-	spin_unlock_irqrestore(&ctrl->lock, flags);
-
-	return old;
-}
-
-/**
- * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
- * @ent: swap entry to be looked up.
- *
- * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
- */
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	return lookup_swap_cgroup(ent, NULL)->id;
-}
-
-int swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	void *array;
-	unsigned long array_size;
-	unsigned long length;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (!do_swap_account)
-		return 0;
-
-	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
-	array_size = length * sizeof(void *);
-
-	array = vzalloc(array_size);
-	if (!array)
-		goto nomem;
-
-	ctrl = &swap_cgroup_ctrl[type];
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl->length = length;
-	ctrl->map = array;
-	spin_lock_init(&ctrl->lock);
-	if (swap_cgroup_prepare(type)) {
-		/* memory shortage */
-		ctrl->map = NULL;
-		ctrl->length = 0;
-		mutex_unlock(&swap_cgroup_mutex);
-		vfree(array);
-		goto nomem;
-	}
-	mutex_unlock(&swap_cgroup_mutex);
-
-	return 0;
-nomem:
-	printk(KERN_INFO "couldn't allocate enough memory for swap_cgroup.\n");
-	printk(KERN_INFO
-		"swap_cgroup can be disabled by swapaccount=0 boot option\n");
-	return -ENOMEM;
-}
-
-void swap_cgroup_swapoff(int type)
-{
-	struct page **map;
-	unsigned long i, length;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (!do_swap_account)
-		return;
-
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl = &swap_cgroup_ctrl[type];
-	map = ctrl->map;
-	length = ctrl->length;
-	ctrl->map = NULL;
-	ctrl->length = 0;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	if (map) {
-		for (i = 0; i < length; i++) {
-			struct page *page = map[i];
-			if (page)
-				__free_page(page);
-		}
-		vfree(map);
-	}
-}
-
-#endif
diff -puN /dev/null mm/swap_cgroup.c
--- /dev/null
+++ a/mm/swap_cgroup.c
@@ -0,0 +1,208 @@
+#include <linux/swap_cgroup.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+
+#include <linux/swapops.h> /* depends on mm.h include */
+
+static DEFINE_MUTEX(swap_cgroup_mutex);
+struct swap_cgroup_ctrl {
+	struct page **map;
+	unsigned long length;
+	spinlock_t	lock;
+};
+
+static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
+
+struct swap_cgroup {
+	unsigned short		id;
+};
+#define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
+
+/*
+ * SwapCgroup implements "lookup" and "exchange" operations.
+ * In typical usage, this swap_cgroup is accessed via memcg's charge/uncharge
+ * against SwapCache. At swap_free(), this is accessed directly from swap.
+ *
+ * This means,
+ *  - we have no race in "exchange" when we're accessed via SwapCache because
+ *    SwapCache(and its swp_entry) is under lock.
+ *  - When called via swap_free(), there is no user of this entry and no race.
+ * Then, we don't need lock around "exchange".
+ *
+ * TODO: we can push these buffers out to HIGHMEM.
+ */
+
+/*
+ * allocate buffer for swap_cgroup.
+ */
+static int swap_cgroup_prepare(int type)
+{
+	struct page *page;
+	struct swap_cgroup_ctrl *ctrl;
+	unsigned long idx, max;
+
+	ctrl = &swap_cgroup_ctrl[type];
+
+	for (idx = 0; idx < ctrl->length; idx++) {
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			goto not_enough_page;
+		ctrl->map[idx] = page;
+	}
+	return 0;
+not_enough_page:
+	max = idx;
+	for (idx = 0; idx < max; idx++)
+		__free_page(ctrl->map[idx]);
+
+	return -ENOMEM;
+}
+
+static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
+					struct swap_cgroup_ctrl **ctrlp)
+{
+	pgoff_t offset = swp_offset(ent);
+	struct swap_cgroup_ctrl *ctrl;
+	struct page *mappage;
+	struct swap_cgroup *sc;
+
+	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (ctrlp)
+		*ctrlp = ctrl;
+
+	mappage = ctrl->map[offset / SC_PER_PAGE];
+	sc = page_address(mappage);
+	return sc + offset % SC_PER_PAGE;
+}
+
+/**
+ * swap_cgroup_cmpxchg - cmpxchg mem_cgroup's id for this swp_entry.
+ * @ent: swap entry to be cmpxchged
+ * @old: old id
+ * @new: new id
+ *
+ * Returns old id at success, 0 at failure.
+ * (There is no mem_cgroup using 0 as its id)
+ */
+unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
+					unsigned short old, unsigned short new)
+{
+	struct swap_cgroup_ctrl *ctrl;
+	struct swap_cgroup *sc;
+	unsigned long flags;
+	unsigned short retval;
+
+	sc = lookup_swap_cgroup(ent, &ctrl);
+
+	spin_lock_irqsave(&ctrl->lock, flags);
+	retval = sc->id;
+	if (retval == old)
+		sc->id = new;
+	else
+		retval = 0;
+	spin_unlock_irqrestore(&ctrl->lock, flags);
+	return retval;
+}
+
+/**
+ * swap_cgroup_record - record mem_cgroup for this swp_entry.
+ * @ent: swap entry to be recorded into
+ * @id: mem_cgroup to be recorded
+ *
+ * Returns old value at success, 0 at failure.
+ * (Of course, old value can be 0.)
+ */
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
+{
+	struct swap_cgroup_ctrl *ctrl;
+	struct swap_cgroup *sc;
+	unsigned short old;
+	unsigned long flags;
+
+	sc = lookup_swap_cgroup(ent, &ctrl);
+
+	spin_lock_irqsave(&ctrl->lock, flags);
+	old = sc->id;
+	sc->id = id;
+	spin_unlock_irqrestore(&ctrl->lock, flags);
+
+	return old;
+}
+
+/**
+ * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
+ * @ent: swap entry to be looked up.
+ *
+ * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
+ */
+unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
+{
+	return lookup_swap_cgroup(ent, NULL)->id;
+}
+
+int swap_cgroup_swapon(int type, unsigned long max_pages)
+{
+	void *array;
+	unsigned long array_size;
+	unsigned long length;
+	struct swap_cgroup_ctrl *ctrl;
+
+	if (!do_swap_account)
+		return 0;
+
+	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
+	array_size = length * sizeof(void *);
+
+	array = vzalloc(array_size);
+	if (!array)
+		goto nomem;
+
+	ctrl = &swap_cgroup_ctrl[type];
+	mutex_lock(&swap_cgroup_mutex);
+	ctrl->length = length;
+	ctrl->map = array;
+	spin_lock_init(&ctrl->lock);
+	if (swap_cgroup_prepare(type)) {
+		/* memory shortage */
+		ctrl->map = NULL;
+		ctrl->length = 0;
+		mutex_unlock(&swap_cgroup_mutex);
+		vfree(array);
+		goto nomem;
+	}
+	mutex_unlock(&swap_cgroup_mutex);
+
+	return 0;
+nomem:
+	printk(KERN_INFO "couldn't allocate enough memory for swap_cgroup.\n");
+	printk(KERN_INFO
+		"swap_cgroup can be disabled by swapaccount=0 boot option\n");
+	return -ENOMEM;
+}
+
+void swap_cgroup_swapoff(int type)
+{
+	struct page **map;
+	unsigned long i, length;
+	struct swap_cgroup_ctrl *ctrl;
+
+	if (!do_swap_account)
+		return;
+
+	mutex_lock(&swap_cgroup_mutex);
+	ctrl = &swap_cgroup_ctrl[type];
+	map = ctrl->map;
+	length = ctrl->length;
+	ctrl->map = NULL;
+	ctrl->length = 0;
+	mutex_unlock(&swap_cgroup_mutex);
+
+	if (map) {
+		for (i = 0; i < length; i++) {
+			struct page *page = map[i];
+			if (page)
+				__free_page(page);
+		}
+		vfree(map);
+	}
+}
diff -puN mm/swap_state.c~mm-page_cgroup-rename-file-to-mm-swap_cgroupc mm/swap_state.c
--- a/mm/swap_state.c~mm-page_cgroup-rename-file-to-mm-swap_cgroupc
+++ a/mm/swap_state.c
@@ -17,7 +17,6 @@
 #include <linux/blkdev.h>
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
-#include <linux/page_cgroup.h>
 
 #include <asm/pgtable.h>
 
diff -puN mm/swapfile.c~mm-page_cgroup-rename-file-to-mm-swap_cgroupc mm/swapfile.c
--- a/mm/swapfile.c~mm-page_cgroup-rename-file-to-mm-swap_cgroupc
+++ a/mm/swapfile.c
@@ -38,7 +38,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
-#include <linux/page_cgroup.h>
+#include <linux/swap_cgroup.h>
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

