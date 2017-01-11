From: akpm@linux-foundation.org
Subject: + mm-swap-add-cluster-lock.patch added to -mm tree
Date: Wed, 11 Jan 2017 15:42:37 -0800
Message-ID: <5876c2ed.ieZmieSK/J0mOrC+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755054AbdAKXnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 18:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: add cluster lock
has been added to the -mm tree.  Its filename is
     mm-swap-add-cluster-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-add-cluster-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-add-cluster-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Huang, Ying" <ying.huang@intel.com>
Subject: mm/swap: add cluster lock

This patch is to reduce the lock contention of swap_info_struct->lock via
using a more fine grained lock in swap_cluster_info for some swap
operations.  swap_info_struct->lock is heavily contended if multiple
processes reclaim pages simultaneously.  Because there is only one lock
for each swap device.  While in common configuration, there is only one or
several swap devices in the system.  The lock protects almost all swap
related operations.

In fact, many swap operations only access one element of
swap_info_struct->swap_map array.  And there is no dependency between
different elements of swap_info_struct->swap_map.  So a fine grained lock
can be used to allow parallel access to the different elements of
swap_info_struct->swap_map.

In this patch, one bit of swap_cluster_info is used as the bin spinlock to
protect the elements of swap_info_struct->swap_map in the swap cluster and
the fields of swap_cluster_info.  This reduced locking contention for
swap_info_struct->swap_map access greatly.

To use the bin spinlock, the size of swap_cluster_info needs to increase
from 4 bytes to 8 bytes on the 64bit system.  This will use 4k more memory
for every 1G swap space.

Because the size of swap_cluster_info is much smaller than the size of the
cache line (8 vs 64 on x86_64 architecture), there may be false cache line
sharing between swap_cluster_info bit spinlocks.  To avoid the false
sharing in the first round of the swap cluster allocation, the order of
the swap clusters in the free clusters list is changed.  So that, the
swap_cluster_info sharing the same cache line will be placed as far as
possible.  After the first round of allocation, the order of the clusters
in free clusters list is expected to be random.  So the false sharing
should be not noticeable.

Link: http://lkml.kernel.org/r/dbb860bbd825b1aaba18988015e8963f263c3f0d.1484082593.git.tim.c.chen@linux.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net> escreveu:
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   13 +-
 mm/swapfile.c        |  239 +++++++++++++++++++++++++++++++----------
 2 files changed, 194 insertions(+), 58 deletions(-)

diff -puN include/linux/swap.h~mm-swap-add-cluster-lock include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-add-cluster-lock
+++ a/include/linux/swap.h
@@ -176,11 +176,16 @@ enum {
  * protected by swap_info_struct.lock.
  */
 struct swap_cluster_info {
-	unsigned int data:24;
-	unsigned int flags:8;
+	unsigned long data;
 };
-#define CLUSTER_FLAG_FREE 1 /* This cluster is free */
-#define CLUSTER_FLAG_NEXT_NULL 2 /* This cluster has no next cluster */
+#define CLUSTER_COUNT_SHIFT		8
+#define CLUSTER_FLAG_MASK		((1UL << CLUSTER_COUNT_SHIFT) - 1)
+#define CLUSTER_COUNT_MASK		(~CLUSTER_FLAG_MASK)
+#define CLUSTER_FLAG_FREE		1 /* This cluster is free */
+#define CLUSTER_FLAG_NEXT_NULL		2 /* This cluster has no next cluster */
+/* cluster lock, protect cluster_info contents and sis->swap_map */
+#define CLUSTER_FLAG_LOCK_BIT		2
+#define CLUSTER_FLAG_LOCK		(1 << CLUSTER_FLAG_LOCK_BIT)
 
 /*
  * We assign a cluster to each CPU, so each CPU can allocate swap entry from
diff -puN mm/swapfile.c~mm-swap-add-cluster-lock mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-add-cluster-lock
+++ a/mm/swapfile.c
@@ -200,61 +200,107 @@ static void discard_swap_cluster(struct
 #define LATENCY_LIMIT		256
 
 static inline void cluster_set_flag(struct swap_cluster_info *info,
-	unsigned int flag)
+				    unsigned int flag)
 {
-	info->flags = flag;
+	info->data = (info->data & (CLUSTER_COUNT_MASK | CLUSTER_FLAG_LOCK)) |
+		(flag & ~CLUSTER_FLAG_LOCK);
 }
 
 static inline unsigned int cluster_count(struct swap_cluster_info *info)
 {
-	return info->data;
+	return info->data >> CLUSTER_COUNT_SHIFT;
 }
 
 static inline void cluster_set_count(struct swap_cluster_info *info,
 				     unsigned int c)
 {
-	info->data = c;
+	info->data = (c << CLUSTER_COUNT_SHIFT) | (info->data & CLUSTER_FLAG_MASK);
 }
 
 static inline void cluster_set_count_flag(struct swap_cluster_info *info,
 					 unsigned int c, unsigned int f)
 {
-	info->flags = f;
-	info->data = c;
+	info->data = (info->data & CLUSTER_FLAG_LOCK) |
+		(c << CLUSTER_COUNT_SHIFT) | (f & ~CLUSTER_FLAG_LOCK);
 }
 
 static inline unsigned int cluster_next(struct swap_cluster_info *info)
 {
-	return info->data;
+	return cluster_count(info);
 }
 
 static inline void cluster_set_next(struct swap_cluster_info *info,
 				    unsigned int n)
 {
-	info->data = n;
+	cluster_set_count(info, n);
 }
 
 static inline void cluster_set_next_flag(struct swap_cluster_info *info,
 					 unsigned int n, unsigned int f)
 {
-	info->flags = f;
-	info->data = n;
+	cluster_set_count_flag(info, n, f);
 }
 
 static inline bool cluster_is_free(struct swap_cluster_info *info)
 {
-	return info->flags & CLUSTER_FLAG_FREE;
+	return info->data & CLUSTER_FLAG_FREE;
 }
 
 static inline bool cluster_is_null(struct swap_cluster_info *info)
 {
-	return info->flags & CLUSTER_FLAG_NEXT_NULL;
+	return info->data & CLUSTER_FLAG_NEXT_NULL;
 }
 
 static inline void cluster_set_null(struct swap_cluster_info *info)
 {
-	info->flags = CLUSTER_FLAG_NEXT_NULL;
-	info->data = 0;
+	cluster_set_next_flag(info, 0, CLUSTER_FLAG_NEXT_NULL);
+}
+
+/* Protect swap_cluster_info fields and si->swap_map */
+static inline void __lock_cluster(struct swap_cluster_info *ci)
+{
+	bit_spin_lock(CLUSTER_FLAG_LOCK_BIT, &ci->data);
+}
+
+static inline struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
+						     unsigned long offset)
+{
+	struct swap_cluster_info *ci;
+
+	ci = si->cluster_info;
+	if (ci) {
+		ci += offset / SWAPFILE_CLUSTER;
+		__lock_cluster(ci);
+	}
+	return ci;
+}
+
+static inline void unlock_cluster(struct swap_cluster_info *ci)
+{
+	if (ci)
+		bit_spin_unlock(CLUSTER_FLAG_LOCK_BIT, &ci->data);
+}
+
+static inline struct swap_cluster_info *lock_cluster_or_swap_info(
+	struct swap_info_struct *si,
+	unsigned long offset)
+{
+	struct swap_cluster_info *ci;
+
+	ci = lock_cluster(si, offset);
+	if (!ci)
+		spin_lock(&si->lock);
+
+	return ci;
+}
+
+static inline void unlock_cluster_or_swap_info(struct swap_info_struct *si,
+					       struct swap_cluster_info *ci)
+{
+	if (ci)
+		unlock_cluster(ci);
+	else
+		spin_unlock(&si->lock);
 }
 
 static inline bool cluster_list_empty(struct swap_cluster_list *list)
@@ -281,9 +327,17 @@ static void cluster_list_add_tail(struct
 		cluster_set_next_flag(&list->head, idx, 0);
 		cluster_set_next_flag(&list->tail, idx, 0);
 	} else {
+		struct swap_cluster_info *ci_tail;
 		unsigned int tail = cluster_next(&list->tail);
 
-		cluster_set_next(&ci[tail], idx);
+		/*
+		 * Nested cluster lock, but both cluster locks are
+		 * only acquired when we held swap_info_struct->lock
+		 */
+		ci_tail = ci + tail;
+		__lock_cluster(ci_tail);
+		cluster_set_next(ci_tail, idx);
+		unlock_cluster(ci_tail);
 		cluster_set_next_flag(&list->tail, idx, 0);
 	}
 }
@@ -328,7 +382,7 @@ static void swap_cluster_schedule_discar
 */
 static void swap_do_scheduled_discard(struct swap_info_struct *si)
 {
-	struct swap_cluster_info *info;
+	struct swap_cluster_info *info, *ci;
 	unsigned int idx;
 
 	info = si->cluster_info;
@@ -341,10 +395,14 @@ static void swap_do_scheduled_discard(st
 				SWAPFILE_CLUSTER);
 
 		spin_lock(&si->lock);
-		cluster_set_flag(&info[idx], CLUSTER_FLAG_FREE);
+		ci = lock_cluster(si, idx * SWAPFILE_CLUSTER);
+		cluster_set_flag(ci, CLUSTER_FLAG_FREE);
+		unlock_cluster(ci);
 		cluster_list_add_tail(&si->free_clusters, info, idx);
+		ci = lock_cluster(si, idx * SWAPFILE_CLUSTER);
 		memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 				0, SWAPFILE_CLUSTER);
+		unlock_cluster(ci);
 	}
 }
 
@@ -447,8 +505,9 @@ static void scan_swap_map_try_ssd_cluste
 	unsigned long *offset, unsigned long *scan_base)
 {
 	struct percpu_cluster *cluster;
+	struct swap_cluster_info *ci;
 	bool found_free;
-	unsigned long tmp;
+	unsigned long tmp, max;
 
 new_cluster:
 	cluster = this_cpu_ptr(si->percpu_cluster);
@@ -476,14 +535,21 @@ new_cluster:
 	 * check if there is still free entry in the cluster
 	 */
 	tmp = cluster->next;
-	while (tmp < si->max && tmp < (cluster_next(&cluster->index) + 1) *
-	       SWAPFILE_CLUSTER) {
+	max = min_t(unsigned long, si->max,
+		    (cluster_next(&cluster->index) + 1) * SWAPFILE_CLUSTER);
+	if (tmp >= max) {
+		cluster_set_null(&cluster->index);
+		goto new_cluster;
+	}
+	ci = lock_cluster(si, tmp);
+	while (tmp < max) {
 		if (!si->swap_map[tmp]) {
 			found_free = true;
 			break;
 		}
 		tmp++;
 	}
+	unlock_cluster(ci);
 	if (!found_free) {
 		cluster_set_null(&cluster->index);
 		goto new_cluster;
@@ -496,6 +562,7 @@ new_cluster:
 static unsigned long scan_swap_map(struct swap_info_struct *si,
 				   unsigned char usage)
 {
+	struct swap_cluster_info *ci;
 	unsigned long offset;
 	unsigned long scan_base;
 	unsigned long last_in_cluster = 0;
@@ -572,9 +639,11 @@ checks:
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
 
+	ci = lock_cluster(si, offset);
 	/* reuse swap entry of cache-only swap if not busy. */
 	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
+		unlock_cluster(ci);
 		spin_unlock(&si->lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);
 		spin_lock(&si->lock);
@@ -584,8 +653,10 @@ checks:
 		goto scan; /* check next one */
 	}
 
-	if (si->swap_map[offset])
+	if (si->swap_map[offset]) {
+		unlock_cluster(ci);
 		goto scan;
+	}
 
 	if (offset == si->lowest_bit)
 		si->lowest_bit++;
@@ -601,6 +672,7 @@ checks:
 	}
 	si->swap_map[offset] = usage;
 	inc_cluster_info_page(si, si->cluster_info, offset);
+	unlock_cluster(ci);
 	si->cluster_next = offset + 1;
 	si->flags -= SWP_SCANNING;
 
@@ -731,7 +803,7 @@ swp_entry_t get_swap_page_of_type(int ty
 	return (swp_entry_t) {0};
 }
 
-static struct swap_info_struct *swap_info_get(swp_entry_t entry)
+static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
 	unsigned long offset, type;
@@ -749,7 +821,6 @@ static struct swap_info_struct *swap_inf
 		goto bad_offset;
 	if (!p->swap_map[offset])
 		goto bad_free;
-	spin_lock(&p->lock);
 	return p;
 
 bad_free:
@@ -767,14 +838,45 @@ out:
 	return NULL;
 }
 
+static struct swap_info_struct *swap_info_get(swp_entry_t entry)
+{
+	struct swap_info_struct *p;
+
+	p = _swap_info_get(entry);
+	if (p)
+		spin_lock(&p->lock);
+	return p;
+}
+
 static unsigned char swap_entry_free(struct swap_info_struct *p,
-				     swp_entry_t entry, unsigned char usage)
+				     swp_entry_t entry, unsigned char usage,
+				     bool swap_info_locked)
 {
+	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
 	unsigned char count;
 	unsigned char has_cache;
+	bool lock_swap_info = false;
+
+	if (!swap_info_locked) {
+		count = p->swap_map[offset];
+		if (!p->cluster_info || count == usage || count == SWAP_MAP_SHMEM) {
+lock_swap_info:
+			swap_info_locked = true;
+			lock_swap_info = true;
+			spin_lock(&p->lock);
+		}
+	}
+
+	ci = lock_cluster(p, offset);
 
 	count = p->swap_map[offset];
+
+	if (!swap_info_locked && (count == usage || count == SWAP_MAP_SHMEM)) {
+		unlock_cluster(ci);
+		goto lock_swap_info;
+	}
+
 	has_cache = count & SWAP_HAS_CACHE;
 	count &= ~SWAP_HAS_CACHE;
 
@@ -800,10 +902,15 @@ static unsigned char swap_entry_free(str
 	usage = count | has_cache;
 	p->swap_map[offset] = usage;
 
+	unlock_cluster(ci);
+
 	/* free if no reference */
 	if (!usage) {
+		VM_BUG_ON(!swap_info_locked);
 		mem_cgroup_uncharge_swap(entry);
+		ci = lock_cluster(p, offset);
 		dec_cluster_info_page(p, p->cluster_info, offset);
+		unlock_cluster(ci);
 		if (offset < p->lowest_bit)
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit) {
@@ -829,6 +936,9 @@ static unsigned char swap_entry_free(str
 		}
 	}
 
+	if (lock_swap_info)
+		spin_unlock(&p->lock);
+
 	return usage;
 }
 
@@ -840,11 +950,9 @@ void swap_free(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
 
-	p = swap_info_get(entry);
-	if (p) {
-		swap_entry_free(p, entry, 1);
-		spin_unlock(&p->lock);
-	}
+	p = _swap_info_get(entry);
+	if (p)
+		swap_entry_free(p, entry, 1, false);
 }
 
 /*
@@ -854,11 +962,9 @@ void swapcache_free(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
 
-	p = swap_info_get(entry);
-	if (p) {
-		swap_entry_free(p, entry, SWAP_HAS_CACHE);
-		spin_unlock(&p->lock);
-	}
+	p = _swap_info_get(entry);
+	if (p)
+		swap_entry_free(p, entry, SWAP_HAS_CACHE, false);
 }
 
 /*
@@ -870,13 +976,17 @@ int page_swapcount(struct page *page)
 {
 	int count = 0;
 	struct swap_info_struct *p;
+	struct swap_cluster_info *ci;
 	swp_entry_t entry;
+	unsigned long offset;
 
 	entry.val = page_private(page);
-	p = swap_info_get(entry);
+	p = _swap_info_get(entry);
 	if (p) {
-		count = swap_count(p->swap_map[swp_offset(entry)]);
-		spin_unlock(&p->lock);
+		offset = swp_offset(entry);
+		ci = lock_cluster_or_swap_info(p, offset);
+		count = swap_count(p->swap_map[offset]);
+		unlock_cluster_or_swap_info(p, ci);
 	}
 	return count;
 }
@@ -889,22 +999,26 @@ int swp_swapcount(swp_entry_t entry)
 {
 	int count, tmp_count, n;
 	struct swap_info_struct *p;
+	struct swap_cluster_info *ci;
 	struct page *page;
 	pgoff_t offset;
 	unsigned char *map;
 
-	p = swap_info_get(entry);
+	p = _swap_info_get(entry);
 	if (!p)
 		return 0;
 
-	count = swap_count(p->swap_map[swp_offset(entry)]);
+	offset = swp_offset(entry);
+
+	ci = lock_cluster_or_swap_info(p, offset);
+
+	count = swap_count(p->swap_map[offset]);
 	if (!(count & COUNT_CONTINUED))
 		goto out;
 
 	count &= ~COUNT_CONTINUED;
 	n = SWAP_MAP_MAX + 1;
 
-	offset = swp_offset(entry);
 	page = vmalloc_to_page(p->swap_map + offset);
 	offset &= ~PAGE_MASK;
 	VM_BUG_ON(page_private(page) != SWP_CONTINUED);
@@ -919,7 +1033,7 @@ int swp_swapcount(swp_entry_t entry)
 		n *= (SWAP_CONT_MAX + 1);
 	} while (tmp_count & COUNT_CONTINUED);
 out:
-	spin_unlock(&p->lock);
+	unlock_cluster_or_swap_info(p, ci);
 	return count;
 }
 
@@ -1017,7 +1131,7 @@ int free_swap_and_cache(swp_entry_t entr
 
 	p = swap_info_get(entry);
 	if (p) {
-		if (swap_entry_free(p, entry, 1) == SWAP_HAS_CACHE) {
+		if (swap_entry_free(p, entry, 1, true) == SWAP_HAS_CACHE) {
 			page = find_get_page(swap_address_space(entry),
 					     swp_offset(entry));
 			if (page && !trylock_page(page)) {
@@ -2298,6 +2412,9 @@ static unsigned long read_swap_header(st
 	return maxpages;
 }
 
+#define SWAP_CLUSTER_COLS						\
+	DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
+
 static int setup_swap_map_and_extents(struct swap_info_struct *p,
 					union swap_header *swap_header,
 					unsigned char *swap_map,
@@ -2305,11 +2422,12 @@ static int setup_swap_map_and_extents(st
 					unsigned long maxpages,
 					sector_t *span)
 {
-	int i;
+	unsigned int j, k;
 	unsigned int nr_good_pages;
 	int nr_extents;
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
-	unsigned long idx = p->cluster_next / SWAPFILE_CLUSTER;
+	unsigned long col = p->cluster_next / SWAPFILE_CLUSTER % SWAP_CLUSTER_COLS;
+	unsigned long i, idx;
 
 	nr_good_pages = maxpages - 1;	/* omit header page */
 
@@ -2357,15 +2475,20 @@ static int setup_swap_map_and_extents(st
 	if (!cluster_info)
 		return nr_extents;
 
-	for (i = 0; i < nr_clusters; i++) {
-		if (!cluster_count(&cluster_info[idx])) {
+
+	/* Reduce false cache line sharing between cluster_info */
+	for (k = 0; k < SWAP_CLUSTER_COLS; k++) {
+		j = (k + col) % SWAP_CLUSTER_COLS;
+		for (i = 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTER_COLS); i++) {
+			idx = i * SWAP_CLUSTER_COLS + j;
+			if (idx >= nr_clusters)
+				continue;
+			if (cluster_count(&cluster_info[idx]))
+				continue;
 			cluster_set_flag(&cluster_info[idx], CLUSTER_FLAG_FREE);
 			cluster_list_add_tail(&p->free_clusters, cluster_info,
 					      idx);
 		}
-		idx++;
-		if (idx == nr_clusters)
-			idx = 0;
 	}
 	return nr_extents;
 }
@@ -2627,6 +2750,7 @@ void si_swapinfo(struct sysinfo *val)
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage)
 {
 	struct swap_info_struct *p;
+	struct swap_cluster_info *ci;
 	unsigned long offset, type;
 	unsigned char count;
 	unsigned char has_cache;
@@ -2640,10 +2764,10 @@ static int __swap_duplicate(swp_entry_t
 		goto bad_file;
 	p = swap_info[type];
 	offset = swp_offset(entry);
-
-	spin_lock(&p->lock);
 	if (unlikely(offset >= p->max))
-		goto unlock_out;
+		goto out;
+
+	ci = lock_cluster_or_swap_info(p, offset);
 
 	count = p->swap_map[offset];
 
@@ -2686,7 +2810,7 @@ static int __swap_duplicate(swp_entry_t
 	p->swap_map[offset] = count | has_cache;
 
 unlock_out:
-	spin_unlock(&p->lock);
+	unlock_cluster_or_swap_info(p, ci);
 out:
 	return err;
 
@@ -2775,6 +2899,7 @@ EXPORT_SYMBOL_GPL(__page_file_index);
 int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 {
 	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
 	struct page *head;
 	struct page *page;
 	struct page *list_page;
@@ -2798,6 +2923,9 @@ int add_swap_count_continuation(swp_entr
 	}
 
 	offset = swp_offset(entry);
+
+	ci = lock_cluster(si, offset);
+
 	count = si->swap_map[offset] & ~SWAP_HAS_CACHE;
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
@@ -2810,6 +2938,7 @@ int add_swap_count_continuation(swp_entr
 	}
 
 	if (!page) {
+		unlock_cluster(ci);
 		spin_unlock(&si->lock);
 		return -ENOMEM;
 	}
@@ -2858,6 +2987,7 @@ int add_swap_count_continuation(swp_entr
 	list_add_tail(&page->lru, &head->lru);
 	page = NULL;			/* now it's attached, don't free it */
 out:
+	unlock_cluster(ci);
 	spin_unlock(&si->lock);
 outer:
 	if (page)
@@ -2871,7 +3001,8 @@ outer:
  * into, carry if so, or else fail until a new continuation page is allocated;
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
- * Called while __swap_duplicate() or swap_entry_free() holds swap_lock.
+ * Called while __swap_duplicate() or swap_entry_free() holds swap or cluster
+ * lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,
 				 pgoff_t offset, unsigned char count)
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-kernel-message-in-swap_info_get.patch
mm-swap-add-cluster-lock.patch
mm-swap-split-swap-cache-into-64mb-trunks.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch

