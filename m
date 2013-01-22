From: akpm@linux-foundation.org
Subject: + swap-make-each-swap-partition-have-one-address_space.patch added to -mm tree
Date: Tue, 22 Jan 2013 15:00:58 -0800
Message-ID: <20130122230058.A689A5A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41260 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3AVXA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 18:00:59 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so321738ggi.3
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 15:00:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, hughd@google.com, minchan.kim@gmail.com, riel@redhat.com, shli@fusionio.com


The patch titled
     Subject: swap: make each swap partition have one address_space
has been added to the -mm tree.  Its filename is
     swap-make-each-swap-partition-have-one-address_space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap: make each swap partition have one address_space

When I use several fast SSD to do swap, swapper_space.tree_lock is heavily
contended.  This makes each swap partition have one address_space to
reduce the lock contention.  There is an array of address_space for swap. 
The swap entry type is the index to the array.

In my test with 3 SSD, this increases the swapout throughput 20%.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c    |    4 +-
 include/linux/swap.h |    9 +++---
 mm/memcontrol.c      |    4 +-
 mm/mincore.c         |    5 ++-
 mm/swap.c            |    9 +++++-
 mm/swap_state.c      |   57 ++++++++++++++++++++++++++++-------------
 mm/swapfile.c        |    5 ++-
 mm/util.c            |   10 +++++--
 8 files changed, 68 insertions(+), 35 deletions(-)

diff -puN fs/proc/meminfo.c~swap-make-each-swap-partition-have-one-address_space fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~swap-make-each-swap-partition-have-one-address_space
+++ a/fs/proc/meminfo.c
@@ -40,7 +40,7 @@ static int meminfo_proc_show(struct seq_
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
 	cached = global_page_state(NR_FILE_PAGES) -
-			total_swapcache_pages - i.bufferram;
+			total_swapcache_pages() - i.bufferram;
 	if (cached < 0)
 		cached = 0;
 
@@ -109,7 +109,7 @@ static int meminfo_proc_show(struct seq_
 		K(i.freeram),
 		K(i.bufferram),
 		K(cached),
-		K(total_swapcache_pages),
+		K(total_swapcache_pages()),
 		K(pages[LRU_ACTIVE_ANON]   + pages[LRU_ACTIVE_FILE]),
 		K(pages[LRU_INACTIVE_ANON] + pages[LRU_INACTIVE_FILE]),
 		K(pages[LRU_ACTIVE_ANON]),
diff -puN include/linux/swap.h~swap-make-each-swap-partition-have-one-address_space include/linux/swap.h
--- a/include/linux/swap.h~swap-make-each-swap-partition-have-one-address_space
+++ a/include/linux/swap.h
@@ -8,7 +8,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
 #include <linux/node.h>
-
+#include <linux/fs.h>
 #include <linux/atomic.h>
 #include <asm/page.h>
 
@@ -330,8 +330,9 @@ int generic_swapfile_activate(struct swa
 		sector_t *);
 
 /* linux/mm/swap_state.c */
-extern struct address_space swapper_space;
-#define total_swapcache_pages  swapper_space.nrpages
+extern struct address_space swapper_spaces[];
+#define swap_address_space(entry) (&swapper_spaces[swp_type(entry)])
+extern unsigned long total_swapcache_pages(void);
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
@@ -382,7 +383,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 #define nr_swap_pages				0L
 #define total_swap_pages			0L
-#define total_swapcache_pages			0UL
+#define total_swapcache_pages()			0UL
 
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
diff -puN mm/memcontrol.c~swap-make-each-swap-partition-have-one-address_space mm/memcontrol.c
--- a/mm/memcontrol.c~swap-make-each-swap-partition-have-one-address_space
+++ a/mm/memcontrol.c
@@ -6305,7 +6305,7 @@ static struct page *mc_handle_swap_pte(s
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
 	 */
-	page = find_get_page(&swapper_space, ent.val);
+	page = find_get_page(swap_address_space(ent), ent.val);
 	if (do_swap_account)
 		entry->val = ent.val;
 
@@ -6346,7 +6346,7 @@ static struct page *mc_handle_file_pte(s
 		swp_entry_t swap = radix_to_swp_entry(page);
 		if (do_swap_account)
 			*entry = swap;
-		page = find_get_page(&swapper_space, swap.val);
+		page = find_get_page(swap_address_space(swap), swap.val);
 	}
 #endif
 	return page;
diff -puN mm/mincore.c~swap-make-each-swap-partition-have-one-address_space mm/mincore.c
--- a/mm/mincore.c~swap-make-each-swap-partition-have-one-address_space
+++ a/mm/mincore.c
@@ -75,7 +75,7 @@ static unsigned char mincore_page(struct
 	/* shmem/tmpfs may return swap: account for swapcache page too. */
 	if (radix_tree_exceptional_entry(page)) {
 		swp_entry_t swap = radix_to_swp_entry(page);
-		page = find_get_page(&swapper_space, swap.val);
+		page = find_get_page(swap_address_space(swap), swap.val);
 	}
 #endif
 	if (page) {
@@ -135,7 +135,8 @@ static void mincore_pte_range(struct vm_
 			} else {
 #ifdef CONFIG_SWAP
 				pgoff = entry.val;
-				*vec = mincore_page(&swapper_space, pgoff);
+				*vec = mincore_page(swap_address_space(entry),
+					pgoff);
 #else
 				WARN_ON(1);
 				*vec = 1;
diff -puN mm/swap.c~swap-make-each-swap-partition-have-one-address_space mm/swap.c
--- a/mm/swap.c~swap-make-each-swap-partition-have-one-address_space
+++ a/mm/swap.c
@@ -855,9 +855,14 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
 void __init swap_setup(void)
 {
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
-
 #ifdef CONFIG_SWAP
-	bdi_init(swapper_space.backing_dev_info);
+	int i;
+
+	for (i = 0; i < MAX_SWAPFILES; i++) {
+		bdi_init(swapper_spaces[i].backing_dev_info);
+		spin_lock_init(&swapper_spaces[i].tree_lock);
+		INIT_LIST_HEAD(&swapper_spaces[i].i_mmap_nonlinear);
+	}
 #endif
 
 	/* Use a smaller cluster for small-memory machines */
diff -puN mm/swap_state.c~swap-make-each-swap-partition-have-one-address_space mm/swap_state.c
--- a/mm/swap_state.c~swap-make-each-swap-partition-have-one-address_space
+++ a/mm/swap_state.c
@@ -36,12 +36,12 @@ static struct backing_dev_info swap_back
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
 };
 
-struct address_space swapper_space = {
-	.page_tree	= RADIX_TREE_INIT(GFP_ATOMIC|__GFP_NOWARN),
-	.tree_lock	= __SPIN_LOCK_UNLOCKED(swapper_space.tree_lock),
-	.a_ops		= &swap_aops,
-	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
-	.backing_dev_info = &swap_backing_dev_info,
+struct address_space swapper_spaces[MAX_SWAPFILES] = {
+	[0 ... MAX_SWAPFILES - 1] = {
+		.page_tree	= RADIX_TREE_INIT(GFP_ATOMIC|__GFP_NOWARN),
+		.a_ops		= &swap_aops,
+		.backing_dev_info = &swap_backing_dev_info,
+	}
 };
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
@@ -53,9 +53,19 @@ static struct {
 	unsigned long find_total;
 } swap_cache_info;
 
+unsigned long total_swapcache_pages(void)
+{
+	int i;
+	unsigned long ret = 0;
+
+	for (i = 0; i < MAX_SWAPFILES; i++)
+		ret += swapper_spaces[i].nrpages;
+	return ret;
+}
+
 void show_swap_cache_info(void)
 {
-	printk("%lu pages in swap cache\n", total_swapcache_pages);
+	printk("%lu pages in swap cache\n", total_swapcache_pages());
 	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
 		swap_cache_info.find_success, swap_cache_info.find_total);
@@ -70,23 +80,26 @@ void show_swap_cache_info(void)
 static int __add_to_swap_cache(struct page *page, swp_entry_t entry)
 {
 	int error;
+	struct address_space *address_space;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageSwapCache(page));
 	VM_BUG_ON(!PageSwapBacked(page));
 
 	page_cache_get(page);
-	SetPageSwapCache(page);
 	set_page_private(page, entry.val);
+	SetPageSwapCache(page);
 
-	spin_lock_irq(&swapper_space.tree_lock);
-	error = radix_tree_insert(&swapper_space.page_tree, entry.val, page);
+	address_space = swap_address_space(entry);
+	spin_lock_irq(&address_space->tree_lock);
+	error = radix_tree_insert(&address_space->page_tree,
+					entry.val, page);
 	if (likely(!error)) {
-		total_swapcache_pages++;
+		address_space->nrpages++;
 		__inc_zone_page_state(page, NR_FILE_PAGES);
 		INC_CACHE_INFO(add_total);
 	}
-	spin_unlock_irq(&swapper_space.tree_lock);
+	spin_unlock_irq(&address_space->tree_lock);
 
 	if (unlikely(error)) {
 		/*
@@ -122,14 +135,19 @@ int add_to_swap_cache(struct page *page,
  */
 void __delete_from_swap_cache(struct page *page)
 {
+	swp_entry_t entry;
+	struct address_space *address_space;
+
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageSwapCache(page));
 	VM_BUG_ON(PageWriteback(page));
 
-	radix_tree_delete(&swapper_space.page_tree, page_private(page));
+	entry.val = page_private(page);
+	address_space = swap_address_space(entry);
+	radix_tree_delete(&address_space->page_tree, page_private(page));
 	set_page_private(page, 0);
 	ClearPageSwapCache(page);
-	total_swapcache_pages--;
+	address_space->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
 }
@@ -195,12 +213,14 @@ int add_to_swap(struct page *page)
 void delete_from_swap_cache(struct page *page)
 {
 	swp_entry_t entry;
+	struct address_space *address_space;
 
 	entry.val = page_private(page);
 
-	spin_lock_irq(&swapper_space.tree_lock);
+	address_space = swap_address_space(entry);
+	spin_lock_irq(&address_space->tree_lock);
 	__delete_from_swap_cache(page);
-	spin_unlock_irq(&swapper_space.tree_lock);
+	spin_unlock_irq(&address_space->tree_lock);
 
 	swapcache_free(entry, page);
 	page_cache_release(page);
@@ -263,7 +283,7 @@ struct page * lookup_swap_cache(swp_entr
 {
 	struct page *page;
 
-	page = find_get_page(&swapper_space, entry.val);
+	page = find_get_page(swap_address_space(entry), entry.val);
 
 	if (page)
 		INC_CACHE_INFO(find_success);
@@ -290,7 +310,8 @@ struct page *read_swap_cache_async(swp_e
 		 * called after lookup_swap_cache() failed, re-calling
 		 * that would confuse statistics.
 		 */
-		found_page = find_get_page(&swapper_space, entry.val);
+		found_page = find_get_page(swap_address_space(entry),
+					entry.val);
 		if (found_page)
 			break;
 
diff -puN mm/swapfile.c~swap-make-each-swap-partition-have-one-address_space mm/swapfile.c
--- a/mm/swapfile.c~swap-make-each-swap-partition-have-one-address_space
+++ a/mm/swapfile.c
@@ -79,7 +79,7 @@ __try_to_reclaim_swap(struct swap_info_s
 	struct page *page;
 	int ret = 0;
 
-	page = find_get_page(&swapper_space, entry.val);
+	page = find_get_page(swap_address_space(entry), entry.val);
 	if (!page)
 		return 0;
 	/*
@@ -699,7 +699,8 @@ int free_swap_and_cache(swp_entry_t entr
 	p = swap_info_get(entry);
 	if (p) {
 		if (swap_entry_free(p, entry, 1) == SWAP_HAS_CACHE) {
-			page = find_get_page(&swapper_space, entry.val);
+			page = find_get_page(swap_address_space(entry),
+						entry.val);
 			if (page && !trylock_page(page)) {
 				page_cache_release(page);
 				page = NULL;
diff -puN mm/util.c~swap-make-each-swap-partition-have-one-address_space mm/util.c
--- a/mm/util.c~swap-make-each-swap-partition-have-one-address_space
+++ a/mm/util.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/security.h>
 #include <linux/swap.h>
+#include <linux/swapops.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -389,9 +390,12 @@ struct address_space *page_mapping(struc
 
 	VM_BUG_ON(PageSlab(page));
 #ifdef CONFIG_SWAP
-	if (unlikely(PageSwapCache(page)))
-		mapping = &swapper_space;
-	else
+	if (unlikely(PageSwapCache(page))) {
+		swp_entry_t entry;
+
+		entry.val = page_private(page);
+		mapping = swap_address_space(entry);
+	} else
 #endif
 	if ((unsigned long)mapping & PAGE_MAPPING_ANON)
 		mapping = NULL;
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
smp-make-smp_call_function_many-use-logic-similar-to-smp_call_function_single.patch
kernel-smpc-cleanups.patch

