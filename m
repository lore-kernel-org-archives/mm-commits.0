From: akpm@linux-foundation.org
Subject: + memcg-swap-cgroup-for-remembering-usage.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:18:20 -0800
Message-ID: <200811212318.mALNIK5k019157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361AbYKUXSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:18:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org


The patch titled
     memcg: swap cgroup for remembering usage
has been added to the -mm tree.  Its filename is
     memcg-swap-cgroup-for-remembering-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: swap cgroup for remembering usage
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For accounting swap, we need a record per swap entry, at least.

This patch adds following function.
  - swap_cgroup_swapon() .... called from swapon
  - swap_cgroup_swapoff() ... called at the end of swapoff.

  - swap_cgroup_record() .... record information of swap entry.
  - swap_cgroup_lookup() .... lookup information of swap entry.

This patch just implements "how to record information".  No actual method
for limit the usage of swap.  These routine uses flat table to record and
lookup.  "wise" lookup system like radix-tree requires requires memory
allocation at new records but swap-out is usually called under memory
shortage (or memcg hits limit.) So, I used static allocation.  (maybe
dynamic allocation is not very hard but it adds additional memory
allocation in memory shortage path.)

Note1: In this, we use pointer to record information and this means
      8bytes per swap entry. I think we can reduce this when we
      create "id of cgroup" in the range of 0-65535 or 0-255.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Hugh Dickins <hugh@veritas.com>
Reported-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   35 ++++++
 mm/page_cgroup.c            |  197 ++++++++++++++++++++++++++++++++++
 mm/swapfile.c               |    8 +
 3 files changed, 240 insertions(+)

diff -puN include/linux/page_cgroup.h~memcg-swap-cgroup-for-remembering-usage include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-swap-cgroup-for-remembering-usage
+++ a/include/linux/page_cgroup.h
@@ -105,4 +105,39 @@ static inline void page_cgroup_init(void
 }
 
 #endif
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#include <linux/swap.h>
+extern struct mem_cgroup *
+swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem);
+extern struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent);
+extern int swap_cgroup_swapon(int type, unsigned long max_pages);
+extern void swap_cgroup_swapoff(int type);
+#else
+#include <linux/swap.h>
+
+static inline
+struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
+{
+	return NULL;
+}
+
+static inline
+struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
+{
+	return NULL;
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
+#endif
 #endif
diff -puN mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage
+++ a/mm/page_cgroup.c
@@ -8,6 +8,7 @@
 #include <linux/memory.h>
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
+#include <linux/swapops.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -266,3 +267,199 @@ void __init pgdat_page_cgroup_init(struc
 }
 
 #endif
+
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+
+static DEFINE_MUTEX(swap_cgroup_mutex);
+struct swap_cgroup_ctrl {
+	struct page **map;
+	unsigned long length;
+};
+
+struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
+
+/*
+ * This 8bytes seems big..maybe we can reduce this when we can use "id" for
+ * cgroup rather than pointer.
+ */
+struct swap_cgroup {
+	struct mem_cgroup	*val;
+};
+#define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
+#define SC_POS_MASK	(SC_PER_PAGE - 1)
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
+	if (!do_swap_account)
+		return 0;
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
+/**
+ * swap_cgroup_record - record mem_cgroup for this swp_entry.
+ * @ent: swap entry to be recorded into
+ * @mem: mem_cgroup to be recorded
+ *
+ * Returns old value at success, NULL at failure.
+ * (Of course, old value can be NULL.)
+ */
+struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
+{
+	int type = swp_type(ent);
+	unsigned long offset = swp_offset(ent);
+	unsigned long idx = offset / SC_PER_PAGE;
+	unsigned long pos = offset & SC_POS_MASK;
+	struct swap_cgroup_ctrl *ctrl;
+	struct page *mappage;
+	struct swap_cgroup *sc;
+	struct mem_cgroup *old;
+
+	if (!do_swap_account)
+		return NULL;
+
+	ctrl = &swap_cgroup_ctrl[type];
+
+	mappage = ctrl->map[idx];
+	sc = page_address(mappage);
+	sc += pos;
+	old = sc->val;
+	sc->val = mem;
+
+	return old;
+}
+
+/**
+ * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
+ * @ent: swap entry to be looked up.
+ *
+ * Returns pointer to mem_cgroup at success. NULL at failure.
+ */
+struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
+{
+	int type = swp_type(ent);
+	unsigned long offset = swp_offset(ent);
+	unsigned long idx = offset / SC_PER_PAGE;
+	unsigned long pos = offset & SC_POS_MASK;
+	struct swap_cgroup_ctrl *ctrl;
+	struct page *mappage;
+	struct swap_cgroup *sc;
+	struct mem_cgroup *ret;
+
+	if (!do_swap_account)
+		return NULL;
+
+	ctrl = &swap_cgroup_ctrl[type];
+	mappage = ctrl->map[idx];
+	sc = page_address(mappage);
+	sc += pos;
+	ret = sc->val;
+	return ret;
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
+	length = ((max_pages/SC_PER_PAGE) + 1);
+	array_size = length * sizeof(void *);
+
+	array = vmalloc(array_size);
+	if (!array)
+		goto nomem;
+
+	memset(array, 0, array_size);
+	ctrl = &swap_cgroup_ctrl[type];
+	mutex_lock(&swap_cgroup_mutex);
+	ctrl->length = length;
+	ctrl->map = array;
+	if (swap_cgroup_prepare(type)) {
+		/* memory shortage */
+		ctrl->map = NULL;
+		ctrl->length = 0;
+		vfree(array);
+		mutex_unlock(&swap_cgroup_mutex);
+		goto nomem;
+	}
+	mutex_unlock(&swap_cgroup_mutex);
+
+	printk(KERN_INFO
+		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
+		" and %ld bytes to hold mem_cgroup pointers on swap\n",
+		array_size, length * PAGE_SIZE);
+	printk(KERN_INFO
+	"swap_cgroup can be disabled by noswapaccount boot option.\n");
+
+	return 0;
+nomem:
+	printk(KERN_INFO "couldn't allocate enough memory for swap_cgroup.\n");
+	printk(KERN_INFO
+		"swap_cgroup can be disabled by noswapaccount boot option\n");
+	return -ENOMEM;
+}
+
+void swap_cgroup_swapoff(int type)
+{
+	int i;
+	struct swap_cgroup_ctrl *ctrl;
+
+	if (!do_swap_account)
+		return;
+
+	mutex_lock(&swap_cgroup_mutex);
+	ctrl = &swap_cgroup_ctrl[type];
+	if (ctrl->map) {
+		for (i = 0; i < ctrl->length; i++) {
+			struct page *page = ctrl->map[i];
+			if (page)
+				__free_page(page);
+		}
+		vfree(ctrl->map);
+		ctrl->map = NULL;
+		ctrl->length = 0;
+	}
+	mutex_unlock(&swap_cgroup_mutex);
+}
+
+#endif
diff -puN mm/swapfile.c~memcg-swap-cgroup-for-remembering-usage mm/swapfile.c
--- a/mm/swapfile.c~memcg-swap-cgroup-for-remembering-usage
+++ a/mm/swapfile.c
@@ -32,6 +32,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
+#include <linux/page_cgroup.h>
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -1343,6 +1344,9 @@ asmlinkage long sys_swapoff(const char _
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
+	/* Destroy swap account informatin */
+	swap_cgroup_swapoff(type);
+
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
@@ -1667,6 +1671,10 @@ asmlinkage long sys_swapon(const char __
 		nr_good_pages = swap_header->info.last_page -
 				swap_header->info.nr_badpages -
 				1 /* header page */;
+
+		if (!error)
+			error = swap_cgroup_swapon(type, maxpages);
+
 		if (error)
 			goto bad_swap;
 	}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
vmscan-evict-streaming-io-first.patch
quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

