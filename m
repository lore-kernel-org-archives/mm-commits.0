From: akpm@linux-foundation.org
Subject: [patch 114/142] mm/swap: split swap cache into 64MB trunks
Date: Wed, 22 Feb 2017 15:45:26 -0800
Message-ID: <58ae2296.P4MryHXSCjRHa4U0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49334 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934315AbdBVXp2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ying.huang@intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, vdavydov.dev@gmail.com

From: "Huang, Ying" <ying.huang@intel.com>
Subject: mm/swap: split swap cache into 64MB trunks

The patch is to improve the scalability of the swap out/in via using fine
grained locks for the swap cache.  In current kernel, one address space
will be used for each swap device.  And in the common configuration, the
number of the swap device is very small (one is typical).  This causes the
heavy lock contention on the radix tree of the address space if multiple
tasks swap out/in concurrently.  But in fact, there is no dependency
between pages in the swap cache.  So that, we can split the one shared
address space for each swap device into several address spaces to reduce
the lock contention.  In the patch, the shared address space is split into
64MB trunks.  64MB is chosen to balance the memory space usage and effect
of lock contention reduction.

The size of struct address_space on x86_64 architecture is 408B, so with
the patch, 6528B more memory will be used for every 1GB swap space on
x86_64 architecture.

One address space is still shared for the swap entries in the same 64M
trunks.  To avoid lock contention for the first round of swap space
allocation, the order of the swap clusters in the initial free clusters
list is changed.  The swap space distance between the consecutive swap
clusters in the free cluster list is at least 64M.  After the first round
of allocation, the swap clusters are expected to be freed randomly, so the
lock contention should be reduced effectively.

Link: http://lkml.kernel.org/r/735bab895e64c930581ffb0a05b661e01da82bc5.1484082593.git.tim.c.chen@linux.intel.com
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

 include/linux/swap.h |   11 +++++-
 mm/swap.c            |    6 ---
 mm/swap_state.c      |   68 +++++++++++++++++++++++++++++++++--------
 mm/swapfile.c        |   16 ++++++++-
 4 files changed, 79 insertions(+), 22 deletions(-)

diff -puN include/linux/swap.h~mm-swap-split-swap-cache-into-64mb-trunks include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-split-swap-cache-into-64mb-trunks
+++ a/include/linux/swap.h
@@ -343,8 +343,13 @@ int generic_swapfile_activate(struct swa
 		sector_t *);
 
 /* linux/mm/swap_state.c */
-extern struct address_space swapper_spaces[];
-#define swap_address_space(entry) (&swapper_spaces[swp_type(entry)])
+/* One swap address space for each 64M swap space */
+#define SWAP_ADDRESS_SPACE_SHIFT	14
+#define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
+extern struct address_space *swapper_spaces[];
+#define swap_address_space(entry)			    \
+	(&swapper_spaces[swp_type(entry)][swp_offset(entry) \
+		>> SWAP_ADDRESS_SPACE_SHIFT])
 extern unsigned long total_swapcache_pages(void);
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *, struct list_head *list);
@@ -398,6 +403,8 @@ extern struct swap_info_struct *page_swa
 extern bool reuse_swap_page(struct page *, int *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
+extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
+extern void exit_swap_address_space(unsigned int type);
 
 #else /* CONFIG_SWAP */
 
diff -puN mm/swap.c~mm-swap-split-swap-cache-into-64mb-trunks mm/swap.c
--- a/mm/swap.c~mm-swap-split-swap-cache-into-64mb-trunks
+++ a/mm/swap.c
@@ -971,12 +971,6 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
 void __init swap_setup(void)
 {
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
-#ifdef CONFIG_SWAP
-	int i;
-
-	for (i = 0; i < MAX_SWAPFILES; i++)
-		spin_lock_init(&swapper_spaces[i].tree_lock);
-#endif
 
 	/* Use a smaller cluster for small-memory machines */
 	if (megs < 16)
diff -puN mm/swap_state.c~mm-swap-split-swap-cache-into-64mb-trunks mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-split-swap-cache-into-64mb-trunks
+++ a/mm/swap_state.c
@@ -17,6 +17,7 @@
 #include <linux/blkdev.h>
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
+#include <linux/vmalloc.h>
 
 #include <asm/pgtable.h>
 
@@ -32,15 +33,8 @@ static const struct address_space_operat
 #endif
 };
 
-struct address_space swapper_spaces[MAX_SWAPFILES] = {
-	[0 ... MAX_SWAPFILES - 1] = {
-		.page_tree	= RADIX_TREE_INIT(GFP_ATOMIC|__GFP_NOWARN),
-		.i_mmap_writable = ATOMIC_INIT(0),
-		.a_ops		= &swap_aops,
-		/* swap cache doesn't use writeback related tags */
-		.flags		= 1 << AS_NO_WRITEBACK_TAGS,
-	}
-};
+struct address_space *swapper_spaces[MAX_SWAPFILES];
+static unsigned int nr_swapper_spaces[MAX_SWAPFILES];
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
 
@@ -53,11 +47,26 @@ static struct {
 
 unsigned long total_swapcache_pages(void)
 {
-	int i;
+	unsigned int i, j, nr;
 	unsigned long ret = 0;
+	struct address_space *spaces;
 
-	for (i = 0; i < MAX_SWAPFILES; i++)
-		ret += swapper_spaces[i].nrpages;
+	rcu_read_lock();
+	for (i = 0; i < MAX_SWAPFILES; i++) {
+		/*
+		 * The corresponding entries in nr_swapper_spaces and
+		 * swapper_spaces will be reused only after at least
+		 * one grace period.  So it is impossible for them
+		 * belongs to different usage.
+		 */
+		nr = nr_swapper_spaces[i];
+		spaces = rcu_dereference(swapper_spaces[i]);
+		if (!nr || !spaces)
+			continue;
+		for (j = 0; j < nr; j++)
+			ret += spaces[j].nrpages;
+	}
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -505,3 +514,38 @@ struct page *swapin_readahead(swp_entry_
 skip:
 	return read_swap_cache_async(entry, gfp_mask, vma, addr);
 }
+
+int init_swap_address_space(unsigned int type, unsigned long nr_pages)
+{
+	struct address_space *spaces, *space;
+	unsigned int i, nr;
+
+	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
+	spaces = vzalloc(sizeof(struct address_space) * nr);
+	if (!spaces)
+		return -ENOMEM;
+	for (i = 0; i < nr; i++) {
+		space = spaces + i;
+		INIT_RADIX_TREE(&space->page_tree, GFP_ATOMIC|__GFP_NOWARN);
+		atomic_set(&space->i_mmap_writable, 0);
+		space->a_ops = &swap_aops;
+		/* swap cache doesn't use writeback related tags */
+		mapping_set_no_writeback_tags(space);
+		spin_lock_init(&space->tree_lock);
+	}
+	nr_swapper_spaces[type] = nr;
+	rcu_assign_pointer(swapper_spaces[type], spaces);
+
+	return 0;
+}
+
+void exit_swap_address_space(unsigned int type)
+{
+	struct address_space *spaces;
+
+	spaces = swapper_spaces[type];
+	nr_swapper_spaces[type] = 0;
+	rcu_assign_pointer(swapper_spaces[type], NULL);
+	synchronize_rcu();
+	kvfree(spaces);
+}
diff -puN mm/swapfile.c~mm-swap-split-swap-cache-into-64mb-trunks mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-split-swap-cache-into-64mb-trunks
+++ a/mm/swapfile.c
@@ -2084,6 +2084,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	vfree(frontswap_map);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
+	exit_swap_address_space(p->type);
 
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
@@ -2407,8 +2408,12 @@ static unsigned long read_swap_header(st
 	return maxpages;
 }
 
-#define SWAP_CLUSTER_COLS						\
+#define SWAP_CLUSTER_INFO_COLS						\
 	DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
+#define SWAP_CLUSTER_SPACE_COLS						\
+	DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
+#define SWAP_CLUSTER_COLS						\
+	max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_COLS)
 
 static int setup_swap_map_and_extents(struct swap_info_struct *p,
 					union swap_header *swap_header,
@@ -2471,7 +2476,10 @@ static int setup_swap_map_and_extents(st
 		return nr_extents;
 
 
-	/* Reduce false cache line sharing between cluster_info */
+	/*
+	 * Reduce false cache line sharing between cluster_info and
+	 * sharing same address space.
+	 */
 	for (k = 0; k < SWAP_CLUSTER_COLS; k++) {
 		j = (k + col) % SWAP_CLUSTER_COLS;
 		for (i = 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTER_COLS); i++) {
@@ -2661,6 +2669,10 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 	}
 
+	error = init_swap_address_space(p->type, maxpages);
+	if (error)
+		goto bad_swap;
+
 	mutex_lock(&swapon_mutex);
 	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
_
