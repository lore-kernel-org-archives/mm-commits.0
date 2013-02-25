From: akpm@linux-foundation.org
Subject: [merged] swap-add-per-partition-lock-for-swapfile.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:58 -0800
Message-ID: <20130225205259.133D431C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:53877 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759714Ab3BYUxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:01 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347348ghb.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, arnd@arndb.de, dan.magenheimer@oracle.com, gregkh@linuxfoundation.org, hughd@google.com, konrad.wilk@oracle.com, minchan.kim@gmail.com, minchan@kernel.org, riel@redhat.com, sfr@canb.auug.org.au, shli@fusionio.com, sjenning@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: add per-partition lock for swapfile
has been removed from the -mm tree.  Its filename was
     swap-add-per-partition-lock-for-swapfile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap: add per-partition lock for swapfile

swap_lock is heavily contended when I test swap to 3 fast SSD (even
slightly slower than swap to 2 such SSD).  The main contention comes from
swap_info_get().  This patch tries to fix the gap with adding a new
per-partition lock.

Global data like nr_swapfiles, total_swap_pages, least_priority and
swap_list are still protected by swap_lock.

nr_swap_pages is an atomic now, it can be changed without swap_lock.  In
theory, it's possible get_swap_page() finds no swap pages but actually
there are free swap pages.  But sounds not a big problem.

Accessing partition specific data (like scan_swap_map and so on) is only
protected by swap_info_struct.lock.

Changing swap_info_struct.flags need hold swap_lock and
swap_info_struct.lock, because scan_scan_map() will check it.  read the
flags is ok with either the locks hold.

If both swap_lock and swap_info_struct.lock must be hold, we always hold
the former first to avoid deadlock.

swap_entry_free() can change swap_list.  To delete that code, we add a new
highest_priority_index.  Whenever get_swap_page() is called, we check it. 
If it's valid, we use it.

It's a pity get_swap_page() still holds swap_lock().  But in practice,
swap_lock() isn't heavily contended in my test with this patch (or I can
say there are other much more heavier bottlenecks like TLB flush).  And
BTW, looks get_swap_page() doesn't really need the lock.  We never free
swap_info[] and we check SWAP_WRITEOK flag.  The only risk without the
lock is we could swapout to some low priority swap, but we can quickly
recover after several rounds of swap, so sounds not a big deal to me.  But
I'd prefer to fix this if it's a real problem.

"swap: make each swap partition have one address_space" improved the
swapout speed from 1.7G/s to 2G/s.  This patch further improves the speed
to 2.3G/s, so around 15% improvement.  It's a multi-process test, so TLB
flush isn't the biggest bottleneck before the patches.

[arnd@arndb.de: fix it for nommu]
[hughd@google.com: add missing unlock]
[minchan@kernel.org: get rid of lockdep whinge on sys_swapon]
Signed-off-by: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_32.c |    2 
 arch/tile/mm/pgtable.c  |    2 
 include/linux/swap.h    |   32 ++++++-
 mm/mmap.c               |    2 
 mm/nommu.c              |    2 
 mm/swap_state.c         |    3 
 mm/swapfile.c           |  154 ++++++++++++++++++++++++++------------
 mm/vmscan.c             |    8 -
 8 files changed, 145 insertions(+), 60 deletions(-)

diff -puN arch/sparc/mm/init_32.c~swap-add-per-partition-lock-for-swapfile arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~swap-add-per-partition-lock-for-swapfile
+++ a/arch/sparc/mm/init_32.c
@@ -57,7 +57,7 @@ void show_mem(unsigned int filter)
 	printk("Mem-info:\n");
 	show_free_areas(filter);
 	printk("Free swap:       %6ldkB\n",
-	       nr_swap_pages << (PAGE_SHIFT-10));
+	       get_nr_swap_pages() << (PAGE_SHIFT-10));
 	printk("%ld pages of RAM\n", totalram_pages);
 	printk("%ld free pages\n", nr_free_pages());
 }
diff -puN arch/tile/mm/pgtable.c~swap-add-per-partition-lock-for-swapfile arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~swap-add-per-partition-lock-for-swapfile
+++ a/arch/tile/mm/pgtable.c
@@ -61,7 +61,7 @@ void show_mem(unsigned int filter)
 	       global_page_state(NR_PAGETABLE),
 	       global_page_state(NR_BOUNCE),
 	       global_page_state(NR_FILE_PAGES),
-	       nr_swap_pages);
+	       get_nr_swap_pages());
 
 	for_each_zone(zone) {
 		unsigned long flags, order, total = 0, largest_order = -1;
diff -puN include/linux/swap.h~swap-add-per-partition-lock-for-swapfile include/linux/swap.h
--- a/include/linux/swap.h~swap-add-per-partition-lock-for-swapfile
+++ a/include/linux/swap.h
@@ -202,6 +202,18 @@ struct swap_info_struct {
 	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
 	atomic_t frontswap_pages;	/* frontswap pages in-use counter */
 #endif
+	spinlock_t lock;		/*
+					 * protect map scan related fields like
+					 * swap_map, lowest_bit, highest_bit,
+					 * inuse_pages, cluster_next,
+					 * cluster_nr, lowest_alloc and
+					 * highest_alloc. other fields are only
+					 * changed at swapon/swapoff, so are
+					 * protected by swap_lock. changing
+					 * flags need hold this lock and
+					 * swap_lock. If both locks need hold,
+					 * hold swap_lock first.
+					 */
 };
 
 struct swap_list_t {
@@ -209,9 +221,6 @@ struct swap_list_t {
 	int next;	/* swapfile to be used next */
 };
 
-/* Swap 50% full? Release swapcache more aggressively.. */
-#define vm_swap_full() (nr_swap_pages*2 < total_swap_pages)
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
@@ -347,8 +356,20 @@ extern struct page *swapin_readahead(swp
 			struct vm_area_struct *vma, unsigned long addr);
 
 /* linux/mm/swapfile.c */
-extern long nr_swap_pages;
+extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
+
+/* Swap 50% full? Release swapcache more aggressively.. */
+static inline bool vm_swap_full(void)
+{
+	return atomic_long_read(&nr_swap_pages) * 2 < total_swap_pages;
+}
+
+static inline long get_nr_swap_pages(void)
+{
+	return atomic_long_read(&nr_swap_pages);
+}
+
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -381,9 +402,10 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 #else /* CONFIG_SWAP */
 
-#define nr_swap_pages				0L
+#define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
+#define vm_swap_full()				0
 
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
diff -puN mm/mmap.c~swap-add-per-partition-lock-for-swapfile mm/mmap.c
--- a/mm/mmap.c~swap-add-per-partition-lock-for-swapfile
+++ a/mm/mmap.c
@@ -144,7 +144,7 @@ int __vm_enough_memory(struct mm_struct 
 		 */
 		free -= global_page_state(NR_SHMEM);
 
-		free += nr_swap_pages;
+		free += get_nr_swap_pages();
 
 		/*
 		 * Any slabs which are created with the
diff -puN mm/nommu.c~swap-add-per-partition-lock-for-swapfile mm/nommu.c
--- a/mm/nommu.c~swap-add-per-partition-lock-for-swapfile
+++ a/mm/nommu.c
@@ -1907,7 +1907,7 @@ int __vm_enough_memory(struct mm_struct 
 		 */
 		free -= global_page_state(NR_SHMEM);
 
-		free += nr_swap_pages;
+		free += get_nr_swap_pages();
 
 		/*
 		 * Any slabs which are created with the
diff -puN mm/swap_state.c~swap-add-per-partition-lock-for-swapfile mm/swap_state.c
--- a/mm/swap_state.c~swap-add-per-partition-lock-for-swapfile
+++ a/mm/swap_state.c
@@ -69,7 +69,8 @@ void show_swap_cache_info(void)
 	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
 		swap_cache_info.find_success, swap_cache_info.find_total);
-	printk("Free swap  = %ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
+	printk("Free swap  = %ldkB\n",
+		get_nr_swap_pages() << (PAGE_SHIFT - 10));
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
 }
 
diff -puN mm/swapfile.c~swap-add-per-partition-lock-for-swapfile mm/swapfile.c
--- a/mm/swapfile.c~swap-add-per-partition-lock-for-swapfile
+++ a/mm/swapfile.c
@@ -47,9 +47,11 @@ static sector_t map_swap_entry(swp_entry
 
 DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
-long nr_swap_pages;
+atomic_long_t nr_swap_pages;
+/* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
 static int least_priority;
+static atomic_t highest_priority_index = ATOMIC_INIT(-1);
 
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Unused_file[] = "Unused swap file entry ";
@@ -223,7 +225,7 @@ static unsigned long scan_swap_map(struc
 			si->lowest_alloc = si->max;
 			si->highest_alloc = 0;
 		}
-		spin_unlock(&swap_lock);
+		spin_unlock(&si->lock);
 
 		/*
 		 * If seek is expensive, start searching for new cluster from
@@ -242,7 +244,7 @@ static unsigned long scan_swap_map(struc
 			if (si->swap_map[offset])
 				last_in_cluster = offset + SWAPFILE_CLUSTER;
 			else if (offset == last_in_cluster) {
-				spin_lock(&swap_lock);
+				spin_lock(&si->lock);
 				offset -= SWAPFILE_CLUSTER - 1;
 				si->cluster_next = offset;
 				si->cluster_nr = SWAPFILE_CLUSTER - 1;
@@ -263,7 +265,7 @@ static unsigned long scan_swap_map(struc
 			if (si->swap_map[offset])
 				last_in_cluster = offset + SWAPFILE_CLUSTER;
 			else if (offset == last_in_cluster) {
-				spin_lock(&swap_lock);
+				spin_lock(&si->lock);
 				offset -= SWAPFILE_CLUSTER - 1;
 				si->cluster_next = offset;
 				si->cluster_nr = SWAPFILE_CLUSTER - 1;
@@ -277,7 +279,7 @@ static unsigned long scan_swap_map(struc
 		}
 
 		offset = scan_base;
-		spin_lock(&swap_lock);
+		spin_lock(&si->lock);
 		si->cluster_nr = SWAPFILE_CLUSTER - 1;
 		si->lowest_alloc = 0;
 	}
@@ -293,9 +295,9 @@ checks:
 	/* reuse swap entry of cache-only swap if not busy. */
 	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
-		spin_unlock(&swap_lock);
+		spin_unlock(&si->lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);
-		spin_lock(&swap_lock);
+		spin_lock(&si->lock);
 		/* entry was freed successfully, try to use this again */
 		if (swap_was_freed)
 			goto checks;
@@ -335,13 +337,13 @@ checks:
 			    si->lowest_alloc <= last_in_cluster)
 				last_in_cluster = si->lowest_alloc - 1;
 			si->flags |= SWP_DISCARDING;
-			spin_unlock(&swap_lock);
+			spin_unlock(&si->lock);
 
 			if (offset < last_in_cluster)
 				discard_swap_cluster(si, offset,
 					last_in_cluster - offset + 1);
 
-			spin_lock(&swap_lock);
+			spin_lock(&si->lock);
 			si->lowest_alloc = 0;
 			si->flags &= ~SWP_DISCARDING;
 
@@ -355,10 +357,10 @@ checks:
 			 * could defer that delay until swap_writepage,
 			 * but it's easier to keep this self-contained.
 			 */
-			spin_unlock(&swap_lock);
+			spin_unlock(&si->lock);
 			wait_on_bit(&si->flags, ilog2(SWP_DISCARDING),
 				wait_for_discard, TASK_UNINTERRUPTIBLE);
-			spin_lock(&swap_lock);
+			spin_lock(&si->lock);
 		} else {
 			/*
 			 * Note pages allocated by racing tasks while
@@ -374,14 +376,14 @@ checks:
 	return offset;
 
 scan:
-	spin_unlock(&swap_lock);
+	spin_unlock(&si->lock);
 	while (++offset <= si->highest_bit) {
 		if (!si->swap_map[offset]) {
-			spin_lock(&swap_lock);
+			spin_lock(&si->lock);
 			goto checks;
 		}
 		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
-			spin_lock(&swap_lock);
+			spin_lock(&si->lock);
 			goto checks;
 		}
 		if (unlikely(--latency_ration < 0)) {
@@ -392,11 +394,11 @@ scan:
 	offset = si->lowest_bit;
 	while (++offset < scan_base) {
 		if (!si->swap_map[offset]) {
-			spin_lock(&swap_lock);
+			spin_lock(&si->lock);
 			goto checks;
 		}
 		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
-			spin_lock(&swap_lock);
+			spin_lock(&si->lock);
 			goto checks;
 		}
 		if (unlikely(--latency_ration < 0)) {
@@ -404,7 +406,7 @@ scan:
 			latency_ration = LATENCY_LIMIT;
 		}
 	}
-	spin_lock(&swap_lock);
+	spin_lock(&si->lock);
 
 no_page:
 	si->flags -= SWP_SCANNING;
@@ -417,13 +419,34 @@ swp_entry_t get_swap_page(void)
 	pgoff_t offset;
 	int type, next;
 	int wrapped = 0;
+	int hp_index;
 
 	spin_lock(&swap_lock);
-	if (nr_swap_pages <= 0)
+	if (atomic_long_read(&nr_swap_pages) <= 0)
 		goto noswap;
-	nr_swap_pages--;
+	atomic_long_dec(&nr_swap_pages);
 
 	for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
+		hp_index = atomic_xchg(&highest_priority_index, -1);
+		/*
+		 * highest_priority_index records current highest priority swap
+		 * type which just frees swap entries. If its priority is
+		 * higher than that of swap_list.next swap type, we use it.  It
+		 * isn't protected by swap_lock, so it can be an invalid value
+		 * if the corresponding swap type is swapoff. We double check
+		 * the flags here. It's even possible the swap type is swapoff
+		 * and swapon again and its priority is changed. In such rare
+		 * case, low prority swap type might be used, but eventually
+		 * high priority swap will be used after several rounds of
+		 * swap.
+		 */
+		if (hp_index != -1 && hp_index != type &&
+		    swap_info[type]->prio < swap_info[hp_index]->prio &&
+		    (swap_info[hp_index]->flags & SWP_WRITEOK)) {
+			type = hp_index;
+			swap_list.next = type;
+		}
+
 		si = swap_info[type];
 		next = si->next;
 		if (next < 0 ||
@@ -432,22 +455,29 @@ swp_entry_t get_swap_page(void)
 			wrapped++;
 		}
 
-		if (!si->highest_bit)
+		spin_lock(&si->lock);
+		if (!si->highest_bit) {
+			spin_unlock(&si->lock);
 			continue;
-		if (!(si->flags & SWP_WRITEOK))
+		}
+		if (!(si->flags & SWP_WRITEOK)) {
+			spin_unlock(&si->lock);
 			continue;
+		}
 
 		swap_list.next = next;
+
+		spin_unlock(&swap_lock);
 		/* This is called for allocating swap entry for cache */
 		offset = scan_swap_map(si, SWAP_HAS_CACHE);
-		if (offset) {
-			spin_unlock(&swap_lock);
+		spin_unlock(&si->lock);
+		if (offset)
 			return swp_entry(type, offset);
-		}
+		spin_lock(&swap_lock);
 		next = swap_list.next;
 	}
 
-	nr_swap_pages++;
+	atomic_long_inc(&nr_swap_pages);
 noswap:
 	spin_unlock(&swap_lock);
 	return (swp_entry_t) {0};
@@ -459,19 +489,19 @@ swp_entry_t get_swap_page_of_type(int ty
 	struct swap_info_struct *si;
 	pgoff_t offset;
 
-	spin_lock(&swap_lock);
 	si = swap_info[type];
+	spin_lock(&si->lock);
 	if (si && (si->flags & SWP_WRITEOK)) {
-		nr_swap_pages--;
+		atomic_long_dec(&nr_swap_pages);
 		/* This is called for allocating swap entry, not cache */
 		offset = scan_swap_map(si, 1);
 		if (offset) {
-			spin_unlock(&swap_lock);
+			spin_unlock(&si->lock);
 			return swp_entry(type, offset);
 		}
-		nr_swap_pages++;
+		atomic_long_inc(&nr_swap_pages);
 	}
-	spin_unlock(&swap_lock);
+	spin_unlock(&si->lock);
 	return (swp_entry_t) {0};
 }
 
@@ -493,7 +523,7 @@ static struct swap_info_struct *swap_inf
 		goto bad_offset;
 	if (!p->swap_map[offset])
 		goto bad_free;
-	spin_lock(&swap_lock);
+	spin_lock(&p->lock);
 	return p;
 
 bad_free:
@@ -511,6 +541,27 @@ out:
 	return NULL;
 }
 
+/*
+ * This swap type frees swap entry, check if it is the highest priority swap
+ * type which just frees swap entry. get_swap_page() uses
+ * highest_priority_index to search highest priority swap type. The
+ * swap_info_struct.lock can't protect us if there are multiple swap types
+ * active, so we use atomic_cmpxchg.
+ */
+static void set_highest_priority_index(int type)
+{
+	int old_hp_index, new_hp_index;
+
+	do {
+		old_hp_index = atomic_read(&highest_priority_index);
+		if (old_hp_index != -1 &&
+			swap_info[old_hp_index]->prio >= swap_info[type]->prio)
+			break;
+		new_hp_index = type;
+	} while (atomic_cmpxchg(&highest_priority_index,
+		old_hp_index, new_hp_index) != old_hp_index);
+}
+
 static unsigned char swap_entry_free(struct swap_info_struct *p,
 				     swp_entry_t entry, unsigned char usage)
 {
@@ -553,10 +604,8 @@ static unsigned char swap_entry_free(str
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit)
 			p->highest_bit = offset;
-		if (swap_list.next >= 0 &&
-		    p->prio > swap_info[swap_list.next]->prio)
-			swap_list.next = p->type;
-		nr_swap_pages++;
+		set_highest_priority_index(p->type);
+		atomic_long_inc(&nr_swap_pages);
 		p->inuse_pages--;
 		frontswap_invalidate_page(p->type, offset);
 		if (p->flags & SWP_BLKDEV) {
@@ -581,7 +630,7 @@ void swap_free(swp_entry_t entry)
 	p = swap_info_get(entry);
 	if (p) {
 		swap_entry_free(p, entry, 1);
-		spin_unlock(&swap_lock);
+		spin_unlock(&p->lock);
 	}
 }
 
@@ -598,7 +647,7 @@ void swapcache_free(swp_entry_t entry, s
 		count = swap_entry_free(p, entry, SWAP_HAS_CACHE);
 		if (page)
 			mem_cgroup_uncharge_swapcache(page, entry, count != 0);
-		spin_unlock(&swap_lock);
+		spin_unlock(&p->lock);
 	}
 }
 
@@ -617,7 +666,7 @@ int page_swapcount(struct page *page)
 	p = swap_info_get(entry);
 	if (p) {
 		count = swap_count(p->swap_map[swp_offset(entry)]);
-		spin_unlock(&swap_lock);
+		spin_unlock(&p->lock);
 	}
 	return count;
 }
@@ -706,7 +755,7 @@ int free_swap_and_cache(swp_entry_t entr
 				page = NULL;
 			}
 		}
-		spin_unlock(&swap_lock);
+		spin_unlock(&p->lock);
 	}
 	if (page) {
 		/*
@@ -804,11 +853,13 @@ unsigned int count_swap_pages(int type, 
 	if ((unsigned int)type < nr_swapfiles) {
 		struct swap_info_struct *sis = swap_info[type];
 
+		spin_lock(&sis->lock);
 		if (sis->flags & SWP_WRITEOK) {
 			n = sis->pages;
 			if (free)
 				n -= sis->inuse_pages;
 		}
+		spin_unlock(&sis->lock);
 	}
 	spin_unlock(&swap_lock);
 	return n;
@@ -1457,7 +1508,7 @@ static void _enable_swap_info(struct swa
 	p->swap_map = swap_map;
 	frontswap_map_set(p, frontswap_map);
 	p->flags |= SWP_WRITEOK;
-	nr_swap_pages += p->pages;
+	atomic_long_add(p->pages, &nr_swap_pages);
 	total_swap_pages += p->pages;
 
 	/* insert swap space into swap_list: */
@@ -1479,15 +1530,19 @@ static void enable_swap_info(struct swap
 				unsigned long *frontswap_map)
 {
 	spin_lock(&swap_lock);
+	spin_lock(&p->lock);
 	_enable_swap_info(p, prio, swap_map, frontswap_map);
 	frontswap_init(p->type);
+	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 }
 
 static void reinsert_swap_info(struct swap_info_struct *p)
 {
 	spin_lock(&swap_lock);
+	spin_lock(&p->lock);
 	_enable_swap_info(p, p->prio, p->swap_map, frontswap_map_get(p));
+	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 }
 
@@ -1547,14 +1602,16 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		/* just pick something that's safe... */
 		swap_list.next = swap_list.head;
 	}
+	spin_lock(&p->lock);
 	if (p->prio < 0) {
 		for (i = p->next; i >= 0; i = swap_info[i]->next)
 			swap_info[i]->prio = p->prio--;
 		least_priority++;
 	}
-	nr_swap_pages -= p->pages;
+	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
 	p->flags &= ~SWP_WRITEOK;
+	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 
 	set_current_oom_origin();
@@ -1573,14 +1630,17 @@ SYSCALL_DEFINE1(swapoff, const char __us
 
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
+	spin_lock(&p->lock);
 	drain_mmlist();
 
 	/* wait for anyone still in scan_swap_map */
 	p->highest_bit = 0;		/* cuts scans short */
 	while (p->flags >= SWP_SCANNING) {
+		spin_unlock(&p->lock);
 		spin_unlock(&swap_lock);
 		schedule_timeout_uninterruptible(1);
 		spin_lock(&swap_lock);
+		spin_lock(&p->lock);
 	}
 
 	swap_file = p->swap_file;
@@ -1590,6 +1650,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->swap_map = NULL;
 	p->flags = 0;
 	frontswap_invalidate_area(type);
+	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
@@ -1795,6 +1856,7 @@ static struct swap_info_struct *alloc_sw
 	p->flags = SWP_USED;
 	p->next = -1;
 	spin_unlock(&swap_lock);
+	spin_lock_init(&p->lock);
 
 	return p;
 }
@@ -2117,7 +2179,7 @@ void si_swapinfo(struct sysinfo *val)
 		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
 			nr_to_be_unused += si->inuse_pages;
 	}
-	val->freeswap = nr_swap_pages + nr_to_be_unused;
+	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;
 	val->totalswap = total_swap_pages + nr_to_be_unused;
 	spin_unlock(&swap_lock);
 }
@@ -2150,7 +2212,7 @@ static int __swap_duplicate(swp_entry_t 
 	p = swap_info[type];
 	offset = swp_offset(entry);
 
-	spin_lock(&swap_lock);
+	spin_lock(&p->lock);
 	if (unlikely(offset >= p->max))
 		goto unlock_out;
 
@@ -2185,7 +2247,7 @@ static int __swap_duplicate(swp_entry_t 
 	p->swap_map[offset] = count | has_cache;
 
 unlock_out:
-	spin_unlock(&swap_lock);
+	spin_unlock(&p->lock);
 out:
 	return err;
 
@@ -2310,7 +2372,7 @@ int add_swap_count_continuation(swp_entr
 	}
 
 	if (!page) {
-		spin_unlock(&swap_lock);
+		spin_unlock(&si->lock);
 		return -ENOMEM;
 	}
 
@@ -2358,7 +2420,7 @@ int add_swap_count_continuation(swp_entr
 	list_add_tail(&page->lru, &head->lru);
 	page = NULL;			/* now it's attached, don't free it */
 out:
-	spin_unlock(&swap_lock);
+	spin_unlock(&si->lock);
 outer:
 	if (page)
 		__free_page(page);
diff -puN mm/vmscan.c~swap-add-per-partition-lock-for-swapfile mm/vmscan.c
--- a/mm/vmscan.c~swap-add-per-partition-lock-for-swapfile
+++ a/mm/vmscan.c
@@ -1684,7 +1684,7 @@ static void get_scan_count(struct lruvec
 		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+	if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -1933,7 +1933,7 @@ static inline bool should_continue_recla
 	 */
 	pages_for_compaction = (2UL << sc->order);
 	inactive_lru_pages = zone_page_state(zone, NR_INACTIVE_FILE);
-	if (nr_swap_pages > 0)
+	if (get_nr_swap_pages() > 0)
 		inactive_lru_pages += zone_page_state(zone, NR_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
@@ -3085,7 +3085,7 @@ unsigned long global_reclaimable_pages(v
 	nr = global_page_state(NR_ACTIVE_FILE) +
 	     global_page_state(NR_INACTIVE_FILE);
 
-	if (nr_swap_pages > 0)
+	if (get_nr_swap_pages() > 0)
 		nr += global_page_state(NR_ACTIVE_ANON) +
 		      global_page_state(NR_INACTIVE_ANON);
 
@@ -3099,7 +3099,7 @@ unsigned long zone_reclaimable_pages(str
 	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
 	     zone_page_state(zone, NR_INACTIVE_FILE);
 
-	if (nr_swap_pages > 0)
+	if (get_nr_swap_pages() > 0)
 		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
 		      zone_page_state(zone, NR_INACTIVE_ANON);
 
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
linux-next.patch
kernel-smpc-cleanups.patch

