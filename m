Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEC817E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118456; cv=none; b=tdnizP5krHaAWSTA+iOt3pmexQXX5hu3yluc801tNjBTMgyl4VD3Sa3EaEeBW1yLEpRCH0bmZ5iBw1yWz6VuQ4/fy3jgISuRcdU7hNIn47gGoVimBmLdNUqzjFqrlii3REEkPom9467OKlKiMdlhiKHcJFDSeT7joCW1AsoUwR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118456; c=relaxed/simple;
	bh=ndttpHEMQ0BM+a0nQj4Zua8XCeLyDP4188Qnhs5l4O4=;
	h=Date:To:From:Subject:Message-Id; b=QojQIZ+Bb1Wjac3rO6RNJRjdyjNumSTvIlMfxA4Wa9Yf0kLzymJHzZrwCv1gPh1TXBcG8SpsO5h4jiAoG43eSLfBrFhhvQEhdsydEJgScyHZFOsBKskMxUGHHwhdatYrqiohiCa7XVdYtprYXa3hv9MFYcVMO43pwFCzh3WYq30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U297zfwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U297zfwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6BBC4CEF1;
	Sat,  6 Sep 2025 00:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118455;
	bh=ndttpHEMQ0BM+a0nQj4Zua8XCeLyDP4188Qnhs5l4O4=;
	h=Date:To:From:Subject:From;
	b=U297zfwHTSXZoUaMsrcxVl+ZD9Ham3AZ0c4OEy0D0AhFH32znWT0n2/jg6OHGA9Hg
	 iJ1pVqHAdby8JY2bplArQxEz3qRbUIED+TQjxJsl7fUk3IsbSQyRd9YlM1ePSl3lGs
	 dqsF5BlBo/XgJIlnJf2YKc6GkK8Ue2tGoUfCHDfo=
Date: Fri, 05 Sep 2025 17:27:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-implement-dynamic-allocation-of-swap-table.patch added to mm-new branch
Message-Id: <20250906002735.AF6BBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: implement dynamic allocation of swap table
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-implement-dynamic-allocation-of-swap-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-implement-dynamic-allocation-of-swap-table.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: implement dynamic allocation of swap table
Date: Sat, 6 Sep 2025 03:13:56 +0800

Now swap table is cluster based, which means free clusters can free its
table since no one should modify it.

There could be speculative readers, like swap cache look up, protect them
by making them RCU protected.  All swap table should be filled with null
entries before free, so such readers will either see a NULL pointer or a
null filled table being lazy freed.

On allocation, allocate the table when a cluster is used by any order.

This way, we can reduce the memory usage of large swap device
significantly.

This idea to dynamically release unused swap cluster data was initially
suggested by Chris Li while proposing the cluster swap allocator and it
suits the swap table idea very well.

Link: https://lkml.kernel.org/r/20250905191357.78298-15-ryncsn@gmail.com
Co-developed-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    2 
 mm/swap_state.c |    9 --
 mm/swap_table.h |   37 +++++++-
 mm/swapfile.c   |  202 ++++++++++++++++++++++++++++++++++++----------
 4 files changed, 199 insertions(+), 51 deletions(-)

--- a/mm/swapfile.c~mm-swap-implement-dynamic-allocation-of-swap-table
+++ a/mm/swapfile.c
@@ -105,6 +105,8 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static struct kmem_cache *swap_table_cachep;
+
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
@@ -400,10 +402,17 @@ static inline bool cluster_is_discard(st
 	return info->flags == CLUSTER_FLAG_DISCARD;
 }
 
+static inline bool cluster_table_is_alloced(struct swap_cluster_info *ci)
+{
+	return rcu_dereference_protected(ci->table, lockdep_is_held(&ci->lock));
+}
+
 static inline bool cluster_is_usable(struct swap_cluster_info *ci, int order)
 {
 	if (unlikely(ci->flags > CLUSTER_FLAG_USABLE))
 		return false;
+	if (!cluster_table_is_alloced(ci))
+		return false;
 	if (!order)
 		return true;
 	return cluster_is_empty(ci) || order == ci->order;
@@ -421,32 +430,98 @@ static inline unsigned int cluster_offse
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
-static int swap_table_alloc_table(struct swap_cluster_info *ci)
+static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
-	WARN_ON(ci->table);
-	ci->table = kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, GFP_KERNEL);
-	if (!ci->table)
-		return -ENOMEM;
-	return 0;
+	unsigned int ci_off;
+	struct swap_table *table;
+
+	/* Only empty cluster's table is allow to be freed  */
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
+	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
+		VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_off)));
+	table = (void *)rcu_dereference_protected(ci->table, true);
+	rcu_assign_pointer(ci->table, NULL);
+
+	kmem_cache_free(swap_table_cachep, table);
 }
 
-static void swap_cluster_free_table(struct swap_cluster_info *ci)
+/*
+ * Allocate a swap table may need to sleep, which leads to migration,
+ * so attempt an atomic allocation first then fallback and handle
+ * potential race.
+ */
+static struct swap_cluster_info *
+swap_cluster_alloc_table(struct swap_info_struct *si,
+			 struct swap_cluster_info *ci,
+			 int order)
 {
-	unsigned int ci_off;
-	unsigned long swp_tb;
+	struct swap_cluster_info *pcp_ci;
+	struct swap_table *table;
+	unsigned long offset;
 
-	if (!ci->table)
-		return;
+	/*
+	 * Only cluster isolation from the allocator does table allocation.
+	 * Swap allocator uses a percpu cluster and holds the local lock.
+	 */
+	lockdep_assert_held(&ci->lock);
+	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 
-	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
-		swp_tb = __swap_table_get(ci, ci_off);
-		if (!swp_tb_is_null(swp_tb))
-			pr_err_once("swap: unclean swap space on swapoff: 0x%lx",
-				    swp_tb);
+	table = kmem_cache_zalloc(swap_table_cachep,
+				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (table) {
+		rcu_assign_pointer(ci->table, table);
+		return ci;
+	}
+
+	/*
+	 * Try a sleep allocation. Each isolated free cluster may cause
+	 * a sleep allocation, but there is a limited number of them, so
+	 * the potential recursive allocation should be limited.
+	 */
+	spin_unlock(&ci->lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_unlock(&si->global_cluster_lock);
+	local_unlock(&percpu_swap_cluster.lock);
+	table = kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_KERNEL);
+
+	local_lock(&percpu_swap_cluster.lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_lock(&si->global_cluster_lock);
+	/*
+	 * Back to atomic context. First, check if we migrated to a new
+	 * CPU with a usable percpu cluster. If so, try using that instead.
+	 * No need to check it for the spinning device, as swap is
+	 * serialized by the global lock on them.
+	 *
+	 * The is_usable check is a bit rough, but ensures order 0 success.
+	 */
+	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
+	if ((si->flags & SWP_SOLIDSTATE) && offset) {
+		pcp_ci = swap_cluster_lock(si, offset);
+		if (cluster_is_usable(pcp_ci, order) &&
+		    pcp_ci->count < SWAPFILE_CLUSTER) {
+			ci = pcp_ci;
+			goto free_table;
+		}
+		swap_cluster_unlock(pcp_ci);
 	}
 
-	kfree(ci->table);
-	ci->table = NULL;
+	if (!table)
+		return NULL;
+
+	spin_lock(&ci->lock);
+	/* Nothing should have touched the dangling empty cluster. */
+	if (WARN_ON_ONCE(cluster_table_is_alloced(ci)))
+		goto free_table;
+
+	rcu_assign_pointer(ci->table, table);
+	return ci;
+
+free_table:
+	if (table)
+		kmem_cache_free(swap_table_cachep, table);
+	return ci;
 }
 
 static void move_cluster(struct swap_info_struct *si,
@@ -478,7 +553,7 @@ static void swap_cluster_schedule_discar
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	lockdep_assert_held(&ci->lock);
+	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 }
@@ -493,15 +568,11 @@ static void __free_cluster(struct swap_i
  * this returns NULL for an non-empty list.
  */
 static struct swap_cluster_info *isolate_lock_cluster(
-		struct swap_info_struct *si, struct list_head *list)
+		struct swap_info_struct *si, struct list_head *list, int order)
 {
-	struct swap_cluster_info *ci, *ret = NULL;
+	struct swap_cluster_info *ci, *found = NULL;
 
 	spin_lock(&si->lock);
-
-	if (unlikely(!(si->flags & SWP_WRITEOK)))
-		goto out;
-
 	list_for_each_entry(ci, list, list) {
 		if (!spin_trylock(&ci->lock))
 			continue;
@@ -513,13 +584,19 @@ static struct swap_cluster_info *isolate
 
 		list_del(&ci->list);
 		ci->flags = CLUSTER_FLAG_NONE;
-		ret = ci;
+		found = ci;
 		break;
 	}
-out:
 	spin_unlock(&si->lock);
 
-	return ret;
+	if (found && !cluster_table_is_alloced(found)) {
+		/* Only an empty free cluster's swap table can be freed. */
+		VM_WARN_ON_ONCE(list != &si->free_clusters);
+		VM_WARN_ON_ONCE(!cluster_is_empty(found));
+		return swap_cluster_alloc_table(si, found, order);
+	}
+
+	return found;
 }
 
 /*
@@ -652,17 +729,27 @@ static void relocate_cluster(struct swap
  * added to free cluster list and its usage counter will be increased by 1.
  * Only used for initialization.
  */
-static void inc_cluster_info_page(struct swap_info_struct *si,
+static int inc_cluster_info_page(struct swap_info_struct *si,
 	struct swap_cluster_info *cluster_info, unsigned long page_nr)
 {
 	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
+	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
 	ci = cluster_info + idx;
+	if (!ci->table) {
+		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		if (!table)
+			return -ENOMEM;
+		rcu_assign_pointer(ci->table, table);
+	}
+
 	ci->count++;
 
 	VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
 	VM_BUG_ON(ci->flags);
+
+	return 0;
 }
 
 static bool cluster_reclaim_range(struct swap_info_struct *si,
@@ -844,7 +931,7 @@ static unsigned int alloc_swap_scan_list
 	unsigned int found = SWAP_ENTRY_INVALID;
 
 	do {
-		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list, order);
 		unsigned long offset;
 
 		if (!ci)
@@ -869,7 +956,7 @@ static void swap_reclaim_full_clusters(s
 	if (force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
-	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
+	while ((ci = isolate_lock_cluster(si, &si->full_clusters, 0))) {
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
@@ -1017,6 +1104,7 @@ new_cluster:
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
+
 	return found;
 }
 
@@ -1884,7 +1972,13 @@ swp_entry_t get_swap_page_of_type(int ty
 	/* This is called for allocating swap entry, not cache */
 	if (get_swap_device_info(si)) {
 		if (si->flags & SWP_WRITEOK) {
+			/*
+			 * Grab the local lock to be complaint
+			 * with swap table allocation.
+			 */
+			local_lock(&percpu_swap_cluster.lock);
 			offset = cluster_alloc_swap_entry(si, 0, 1);
+			local_unlock(&percpu_swap_cluster.lock);
 			if (offset) {
 				entry = swp_entry(si->type, offset);
 				atomic_long_dec(&nr_swap_pages);
@@ -2677,12 +2771,21 @@ static void wait_for_allocation(struct s
 static void free_cluster_info(struct swap_cluster_info *cluster_info,
 			      unsigned long maxpages)
 {
+	struct swap_cluster_info *ci;
 	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
 	if (!cluster_info)
 		return;
-	for (i = 0; i < nr_clusters; i++)
-		swap_cluster_free_table(&cluster_info[i]);
+	for (i = 0; i < nr_clusters; i++) {
+		ci = cluster_info + i;
+		/* Cluster with bad marks count will have a remaining table */
+		spin_lock(&ci->lock);
+		if (rcu_dereference_protected(ci->table, true)) {
+			ci->count = 0;
+			swap_cluster_free_table(ci);
+		}
+		spin_unlock(&ci->lock);
+	}
 	kvfree(cluster_info);
 }
 
@@ -2718,6 +2821,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct address_space *mapping;
 	struct inode *inode;
 	struct filename *pathname;
+	unsigned int maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2824,8 +2928,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->swap_map = NULL;
 	zeromap = p->zeromap;
 	p->zeromap = NULL;
+	maxpages = p->max;
 	cluster_info = p->cluster_info;
-	free_cluster_info(cluster_info, p->max);
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
@@ -2837,6 +2941,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
+	free_cluster_info(cluster_info, maxpages);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 
@@ -3215,11 +3320,8 @@ static struct swap_cluster_info *setup_c
 	if (!cluster_info)
 		goto err;
 
-	for (i = 0; i < nr_clusters; i++) {
+	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
-		if (swap_table_alloc_table(&cluster_info[i]))
-			goto err_free;
-	}
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
@@ -3238,16 +3340,23 @@ static struct swap_cluster_info *setup_c
 	 * See setup_swap_map(): header page, bad pages,
 	 * and the EOF part of the last cluster.
 	 */
-	inc_cluster_info_page(si, cluster_info, 0);
+	err = inc_cluster_info_page(si, cluster_info, 0);
+	if (err)
+		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
 		if (page_nr >= maxpages)
 			continue;
-		inc_cluster_info_page(si, cluster_info, page_nr);
+		err = inc_cluster_info_page(si, cluster_info, page_nr);
+		if (err)
+			goto err;
+	}
+	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
+		err = inc_cluster_info_page(si, cluster_info, i);
+		if (err)
+			goto err;
 	}
-	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++)
-		inc_cluster_info_page(si, cluster_info, i);
 
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
@@ -3961,6 +4070,15 @@ static int __init swapfile_init(void)
 
 	swapfile_maximum_size = arch_max_swapfile_size();
 
+	/*
+	 * Once a cluster is freed, it's swap table content is read
+	 * only, and all swap cache readers (swap_cache_*) verifies
+	 * the content before use. So it's safe to use RCU slab here.
+	 */
+	swap_table_cachep = kmem_cache_create("swap_table",
+			    sizeof(struct swap_table),
+			    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
+
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
 		swap_migration_ad_supported = true;
--- a/mm/swap.h~mm-swap-implement-dynamic-allocation-of-swap-table
+++ a/mm/swap.h
@@ -36,7 +36,7 @@ struct swap_cluster_info {
 	u16 count;
 	u8 flags;
 	u8 order;
-	atomic_long_t *table;	/* Swap table entries, see mm/swap_table.h */
+	atomic_long_t __rcu *table;	/* Swap table entries, see mm/swap_table.h */
 	struct list_head list;
 };
 
--- a/mm/swap_state.c~mm-swap-implement-dynamic-allocation-of-swap-table
+++ a/mm/swap_state.c
@@ -92,8 +92,8 @@ struct folio *swap_cache_get_folio(swp_e
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = __swap_table_get(__swap_entry_to_cluster(entry),
-					  swp_cluster_offset(entry));
+		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+					swp_cluster_offset(entry));
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
@@ -116,11 +116,10 @@ void *swap_cache_get_shadow(swp_entry_t
 {
 	unsigned long swp_tb;
 
-	swp_tb = __swap_table_get(__swap_entry_to_cluster(entry),
-				  swp_cluster_offset(entry));
+	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+				swp_cluster_offset(entry));
 	if (swp_tb_is_shadow(swp_tb))
 		return swp_tb_to_shadow(swp_tb);
-
 	return NULL;
 }
 
--- a/mm/swap_table.h~mm-swap-implement-dynamic-allocation-of-swap-table
+++ a/mm/swap_table.h
@@ -2,8 +2,15 @@
 #ifndef _MM_SWAP_TABLE_H
 #define _MM_SWAP_TABLE_H
 
+#include <linux/rcupdate.h>
+#include <linux/atomic.h>
 #include "swap.h"
 
+/* A typical flat array in each cluster as swap table */
+struct swap_table {
+	atomic_long_t entries[SWAPFILE_CLUSTER];
+};
+
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
@@ -76,22 +83,46 @@ static inline void *swp_tb_to_shadow(uns
 static inline void __swap_table_set(struct swap_cluster_info *ci,
 				    unsigned int off, unsigned long swp_tb)
 {
+	atomic_long_t *table = rcu_dereference_protected(ci->table, true);
+
+	lockdep_assert_held(&ci->lock);
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
-	atomic_long_set(&ci->table[off], swp_tb);
+	atomic_long_set(&table[off], swp_tb);
 }
 
 static inline unsigned long __swap_table_xchg(struct swap_cluster_info *ci,
 					      unsigned int off, unsigned long swp_tb)
 {
+	atomic_long_t *table = rcu_dereference_protected(ci->table, true);
+
+	lockdep_assert_held(&ci->lock);
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
 	/* Ordering is guaranteed by cluster lock, relax */
-	return atomic_long_xchg_relaxed(&ci->table[off], swp_tb);
+	return atomic_long_xchg_relaxed(&table[off], swp_tb);
 }
 
 static inline unsigned long __swap_table_get(struct swap_cluster_info *ci,
 					     unsigned int off)
 {
+	atomic_long_t *table;
+
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
-	return atomic_long_read(&ci->table[off]);
+	table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
+
+	return atomic_long_read(&table[off]);
+}
+
+static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
+					unsigned int off)
+{
+	atomic_long_t *table;
+	unsigned long swp_tb;
+
+	rcu_read_lock();
+	table = rcu_dereference(ci->table);
+	swp_tb = table ? atomic_long_read(&table[off]) : null_to_swp_tb();
+	rcu_read_unlock();
+
+	return swp_tb;
 }
 #endif
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch
mm-page-writeback-drop-usage-of-folio_index.patch
mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cahe-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

