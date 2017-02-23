From: akpm@linux-foundation.org
Subject: [merged] mm-swap-free-swap-slots-in-batch.patch removed from -mm
 tree
Date: Thu, 23 Feb 2017 13:16:34 -0800
Message-ID: <58af5132.E1K+LmbTrHKEvQ7a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdBWVQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, vdavydov.dev@gmail.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: free swap slots in batch
has been removed from the -mm tree.  Its filename was
     mm-swap-free-swap-slots-in-batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap: free swap slots in batch

Add new functions that free unused swap slots in batches without the need
to reacquire swap info lock.  This improves scalability and reduce lock
contention.

Link: http://lkml.kernel.org/r/c25e0fcdfd237ec4ca7db91631d3b9f6ed23824e.1484082593.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
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

 include/linux/swap.h |    1 
 mm/swapfile.c        |  157 ++++++++++++++++++++++++-----------------
 2 files changed, 96 insertions(+), 62 deletions(-)

diff -puN include/linux/swap.h~mm-swap-free-swap-slots-in-batch include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-free-swap-slots-in-batch
+++ a/include/linux/swap.h
@@ -394,6 +394,7 @@ extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free(swp_entry_t);
 extern void swapcache_free(swp_entry_t);
+extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
diff -puN mm/swapfile.c~mm-swap-free-swap-slots-in-batch mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-free-swap-slots-in-batch
+++ a/mm/swapfile.c
@@ -942,35 +942,34 @@ static struct swap_info_struct *swap_inf
 	return p;
 }
 
-static unsigned char swap_entry_free(struct swap_info_struct *p,
-				     swp_entry_t entry, unsigned char usage,
-				     bool swap_info_locked)
+static struct swap_info_struct *swap_info_get_cont(swp_entry_t entry,
+					struct swap_info_struct *q)
+{
+	struct swap_info_struct *p;
+
+	p = _swap_info_get(entry);
+
+	if (p != q) {
+		if (q != NULL)
+			spin_unlock(&q->lock);
+		if (p != NULL)
+			spin_lock(&p->lock);
+	}
+	return p;
+}
+
+static unsigned char __swap_entry_free(struct swap_info_struct *p,
+				       swp_entry_t entry, unsigned char usage)
 {
 	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
 	unsigned char count;
 	unsigned char has_cache;
-	bool lock_swap_info = false;
-
-	if (!swap_info_locked) {
-		count = p->swap_map[offset];
-		if (!p->cluster_info || count == usage || count == SWAP_MAP_SHMEM) {
-lock_swap_info:
-			swap_info_locked = true;
-			lock_swap_info = true;
-			spin_lock(&p->lock);
-		}
-	}
 
-	ci = lock_cluster(p, offset);
+	ci = lock_cluster_or_swap_info(p, offset);
 
 	count = p->swap_map[offset];
 
-	if (!swap_info_locked && (count == usage || count == SWAP_MAP_SHMEM)) {
-		unlock_cluster(ci);
-		goto lock_swap_info;
-	}
-
 	has_cache = count & SWAP_HAS_CACHE;
 	count &= ~SWAP_HAS_CACHE;
 
@@ -994,46 +993,52 @@ lock_swap_info:
 	}
 
 	usage = count | has_cache;
-	p->swap_map[offset] = usage;
+	p->swap_map[offset] = usage ? : SWAP_HAS_CACHE;
 
+	unlock_cluster_or_swap_info(p, ci);
+
+	return usage;
+}
+
+static void swap_entry_free(struct swap_info_struct *p, swp_entry_t entry)
+{
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
+	unsigned char count;
+
+	ci = lock_cluster(p, offset);
+	count = p->swap_map[offset];
+	VM_BUG_ON(count != SWAP_HAS_CACHE);
+	p->swap_map[offset] = 0;
+	dec_cluster_info_page(p, p->cluster_info, offset);
 	unlock_cluster(ci);
 
-	/* free if no reference */
-	if (!usage) {
-		VM_BUG_ON(!swap_info_locked);
-		mem_cgroup_uncharge_swap(entry);
-		ci = lock_cluster(p, offset);
-		dec_cluster_info_page(p, p->cluster_info, offset);
-		unlock_cluster(ci);
-		if (offset < p->lowest_bit)
-			p->lowest_bit = offset;
-		if (offset > p->highest_bit) {
-			bool was_full = !p->highest_bit;
-			p->highest_bit = offset;
-			if (was_full && (p->flags & SWP_WRITEOK)) {
-				spin_lock(&swap_avail_lock);
-				WARN_ON(!plist_node_empty(&p->avail_list));
-				if (plist_node_empty(&p->avail_list))
-					plist_add(&p->avail_list,
-						  &swap_avail_head);
-				spin_unlock(&swap_avail_lock);
-			}
-		}
-		atomic_long_inc(&nr_swap_pages);
-		p->inuse_pages--;
-		frontswap_invalidate_page(p->type, offset);
-		if (p->flags & SWP_BLKDEV) {
-			struct gendisk *disk = p->bdev->bd_disk;
-			if (disk->fops->swap_slot_free_notify)
-				disk->fops->swap_slot_free_notify(p->bdev,
-								  offset);
+	mem_cgroup_uncharge_swap(entry);
+	if (offset < p->lowest_bit)
+		p->lowest_bit = offset;
+	if (offset > p->highest_bit) {
+		bool was_full = !p->highest_bit;
+
+		p->highest_bit = offset;
+		if (was_full && (p->flags & SWP_WRITEOK)) {
+			spin_lock(&swap_avail_lock);
+			WARN_ON(!plist_node_empty(&p->avail_list));
+			if (plist_node_empty(&p->avail_list))
+				plist_add(&p->avail_list,
+					  &swap_avail_head);
+			spin_unlock(&swap_avail_lock);
 		}
 	}
-
-	if (lock_swap_info)
-		spin_unlock(&p->lock);
-
-	return usage;
+	atomic_long_inc(&nr_swap_pages);
+	p->inuse_pages--;
+	frontswap_invalidate_page(p->type, offset);
+	if (p->flags & SWP_BLKDEV) {
+		struct gendisk *disk = p->bdev->bd_disk;
+
+		if (disk->fops->swap_slot_free_notify)
+			disk->fops->swap_slot_free_notify(p->bdev,
+							  offset);
+	}
 }
 
 /*
@@ -1045,8 +1050,10 @@ void swap_free(swp_entry_t entry)
 	struct swap_info_struct *p;
 
 	p = _swap_info_get(entry);
-	if (p)
-		swap_entry_free(p, entry, 1, false);
+	if (p) {
+		if (!__swap_entry_free(p, entry, 1))
+			swapcache_free_entries(&entry, 1);
+	}
 }
 
 /*
@@ -1057,8 +1064,32 @@ void swapcache_free(swp_entry_t entry)
 	struct swap_info_struct *p;
 
 	p = _swap_info_get(entry);
+	if (p) {
+		if (!__swap_entry_free(p, entry, SWAP_HAS_CACHE))
+			swapcache_free_entries(&entry, 1);
+	}
+}
+
+void swapcache_free_entries(swp_entry_t *entries, int n)
+{
+	struct swap_info_struct *p, *prev;
+	int i;
+
+	if (n <= 0)
+		return;
+
+	prev = NULL;
+	p = NULL;
+	for (i = 0; i < n; ++i) {
+		p = swap_info_get_cont(entries[i], prev);
+		if (p)
+			swap_entry_free(p, entries[i]);
+		else
+			break;
+		prev = p;
+	}
 	if (p)
-		swap_entry_free(p, entry, SWAP_HAS_CACHE, false);
+		spin_unlock(&p->lock);
 }
 
 /*
@@ -1241,21 +1272,23 @@ int free_swap_and_cache(swp_entry_t entr
 {
 	struct swap_info_struct *p;
 	struct page *page = NULL;
+	unsigned char count;
 
 	if (non_swap_entry(entry))
 		return 1;
 
-	p = swap_info_get(entry);
+	p = _swap_info_get(entry);
 	if (p) {
-		if (swap_entry_free(p, entry, 1, true) == SWAP_HAS_CACHE) {
+		count = __swap_entry_free(p, entry, 1);
+		if (count == SWAP_HAS_CACHE) {
 			page = find_get_page(swap_address_space(entry),
 					     swp_offset(entry));
 			if (page && !trylock_page(page)) {
 				put_page(page);
 				page = NULL;
 			}
-		}
-		spin_unlock(&p->lock);
+		} else if (!count)
+			swapcache_free_entries(&entry, 1);
 	}
 	if (page) {
 		/*
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are


