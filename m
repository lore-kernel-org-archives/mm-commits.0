From: akpm@linux-foundation.org
Subject: + mm-swap-allocate-swap-slots-in-batches.patch added to -mm tree
Date: Wed, 11 Jan 2017 15:42:46 -0800
Message-ID: <5876c2f6.q3ZS4mc8kewrdbyo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757779AbdAKXnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 18:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, vdavydov.dev@gmail.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: allocate swap slots in batches
has been added to the -mm tree.  Its filename is
     mm-swap-allocate-swap-slots-in-batches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-allocate-swap-slots-in-batches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-allocate-swap-slots-in-batches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap: allocate swap slots in batches

Currently, the swap slots are allocated one page at a time, causing
contention to the swap_info lock protecting the swap partition on every
page being swapped.

This patch adds new functions get_swap_pages and scan_swap_map_slots to
request multiple swap slots at once.  This will reduces the lock
contention on the swap_info lock.  Also scan_swap_map_slots can operate
more efficiently as swap slots often occurs in clusters close to each
other on a swap device and it is quicker to allocate them together.

Link: http://lkml.kernel.org/r/9fec2845544371f62c3763d43510045e33d286a6.1484082593.git.tim.c.chen@linux.intel.com
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

 include/linux/swap.h |    2 
 mm/swapfile.c        |  136 +++++++++++++++++++++++++++++++++--------
 2 files changed, 113 insertions(+), 25 deletions(-)

diff -puN include/linux/swap.h~mm-swap-allocate-swap-slots-in-batches include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-allocate-swap-slots-in-batches
+++ a/include/linux/swap.h
@@ -27,6 +27,7 @@ struct bio;
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
+#define SWAP_BATCH 64
 
 static inline int current_is_kswapd(void)
 {
@@ -385,6 +386,7 @@ static inline long get_nr_swap_pages(voi
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
+extern int get_swap_pages(int n, swp_entry_t swp_entries[]);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
diff -puN mm/swapfile.c~mm-swap-allocate-swap-slots-in-batches mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-allocate-swap-slots-in-batches
+++ a/mm/swapfile.c
@@ -501,7 +501,7 @@ scan_swap_map_ssd_cluster_conflict(struc
  * Try to get a swap entry from current cpu's swap entry pool (a cluster). This
  * might involve allocating a new cluster for current CPU too.
  */
-static void scan_swap_map_try_ssd_cluster(struct swap_info_struct *si,
+static bool scan_swap_map_try_ssd_cluster(struct swap_info_struct *si,
 	unsigned long *offset, unsigned long *scan_base)
 {
 	struct percpu_cluster *cluster;
@@ -525,7 +525,7 @@ new_cluster:
 			*scan_base = *offset = si->cluster_next;
 			goto new_cluster;
 		} else
-			return;
+			return false;
 	}
 
 	found_free = false;
@@ -557,16 +557,22 @@ new_cluster:
 	cluster->next = tmp + 1;
 	*offset = tmp;
 	*scan_base = tmp;
+	return found_free;
 }
 
-static unsigned long scan_swap_map(struct swap_info_struct *si,
-				   unsigned char usage)
+static int scan_swap_map_slots(struct swap_info_struct *si,
+			       unsigned char usage, int nr,
+			       swp_entry_t slots[])
 {
 	struct swap_cluster_info *ci;
 	unsigned long offset;
 	unsigned long scan_base;
 	unsigned long last_in_cluster = 0;
 	int latency_ration = LATENCY_LIMIT;
+	int n_ret = 0;
+
+	if (nr > SWAP_BATCH)
+		nr = SWAP_BATCH;
 
 	/*
 	 * We try to cluster swap pages by allocating them sequentially
@@ -584,8 +590,10 @@ static unsigned long scan_swap_map(struc
 
 	/* SSD algorithm */
 	if (si->cluster_info) {
-		scan_swap_map_try_ssd_cluster(si, &offset, &scan_base);
-		goto checks;
+		if (scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
+			goto checks;
+		else
+			goto scan;
 	}
 
 	if (unlikely(!si->cluster_nr--)) {
@@ -629,8 +637,14 @@ static unsigned long scan_swap_map(struc
 
 checks:
 	if (si->cluster_info) {
-		while (scan_swap_map_ssd_cluster_conflict(si, offset))
-			scan_swap_map_try_ssd_cluster(si, &offset, &scan_base);
+		while (scan_swap_map_ssd_cluster_conflict(si, offset)) {
+		/* take a break if we already got some slots */
+			if (n_ret)
+				goto done;
+			if (!scan_swap_map_try_ssd_cluster(si, &offset,
+							&scan_base))
+				goto scan;
+		}
 	}
 	if (!(si->flags & SWP_WRITEOK))
 		goto no_page;
@@ -655,7 +669,10 @@ checks:
 
 	if (si->swap_map[offset]) {
 		unlock_cluster(ci);
-		goto scan;
+		if (!n_ret)
+			goto scan;
+		else
+			goto done;
 	}
 
 	if (offset == si->lowest_bit)
@@ -674,9 +691,43 @@ checks:
 	inc_cluster_info_page(si, si->cluster_info, offset);
 	unlock_cluster(ci);
 	si->cluster_next = offset + 1;
-	si->flags -= SWP_SCANNING;
+	slots[n_ret++] = swp_entry(si->type, offset);
 
-	return offset;
+	/* got enough slots or reach max slots? */
+	if ((n_ret == nr) || (offset >= si->highest_bit))
+		goto done;
+
+	/* search for next available slot */
+
+	/* time to take a break? */
+	if (unlikely(--latency_ration < 0)) {
+		if (n_ret)
+			goto done;
+		spin_unlock(&si->lock);
+		cond_resched();
+		spin_lock(&si->lock);
+		latency_ration = LATENCY_LIMIT;
+	}
+
+	/* try to get more slots in cluster */
+	if (si->cluster_info) {
+		if (scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
+			goto checks;
+		else
+			goto done;
+	}
+	/* non-ssd case */
+	++offset;
+
+	/* non-ssd case, still more slots in cluster? */
+	if (si->cluster_nr && !si->swap_map[offset]) {
+		--si->cluster_nr;
+		goto checks;
+	}
+
+done:
+	si->flags -= SWP_SCANNING;
+	return n_ret;
 
 scan:
 	spin_unlock(&si->lock);
@@ -714,17 +765,41 @@ scan:
 
 no_page:
 	si->flags -= SWP_SCANNING;
-	return 0;
+	return n_ret;
 }
 
-swp_entry_t get_swap_page(void)
+static unsigned long scan_swap_map(struct swap_info_struct *si,
+				   unsigned char usage)
+{
+	swp_entry_t entry;
+	int n_ret;
+
+	n_ret = scan_swap_map_slots(si, usage, 1, &entry);
+
+	if (n_ret)
+		return swp_offset(entry);
+	else
+		return 0;
+
+}
+
+int get_swap_pages(int n_goal, swp_entry_t swp_entries[])
 {
 	struct swap_info_struct *si, *next;
-	pgoff_t offset;
+	long avail_pgs;
+	int n_ret = 0;
 
-	if (atomic_long_read(&nr_swap_pages) <= 0)
+	avail_pgs = atomic_long_read(&nr_swap_pages);
+	if (avail_pgs <= 0)
 		goto noswap;
-	atomic_long_dec(&nr_swap_pages);
+
+	if (n_goal > SWAP_BATCH)
+		n_goal = SWAP_BATCH;
+
+	if (n_goal > avail_pgs)
+		n_goal = avail_pgs;
+
+	atomic_long_sub(n_goal, &nr_swap_pages);
 
 	spin_lock(&swap_avail_lock);
 
@@ -750,14 +825,14 @@ start_over:
 			spin_unlock(&si->lock);
 			goto nextsi;
 		}
-
-		/* This is called for allocating swap entry for cache */
-		offset = scan_swap_map(si, SWAP_HAS_CACHE);
+		n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
+					    n_goal, swp_entries);
 		spin_unlock(&si->lock);
-		if (offset)
-			return swp_entry(si->type, offset);
+		if (n_ret)
+			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
-		       si->type);
+			si->type);
+
 		spin_lock(&swap_avail_lock);
 nextsi:
 		/*
@@ -768,7 +843,8 @@ nextsi:
 		 * up between us dropping swap_avail_lock and taking si->lock.
 		 * Since we dropped the swap_avail_lock, the swap_avail_head
 		 * list may have been modified; so if next is still in the
-		 * swap_avail_head list then try it, otherwise start over.
+		 * swap_avail_head list then try it, otherwise start over
+		 * if we have not gotten any slots.
 		 */
 		if (plist_node_empty(&next->avail_list))
 			goto start_over;
@@ -776,9 +852,19 @@ nextsi:
 
 	spin_unlock(&swap_avail_lock);
 
-	atomic_long_inc(&nr_swap_pages);
+check_out:
+	if (n_ret < n_goal)
+		atomic_long_add((long) (n_goal-n_ret), &nr_swap_pages);
 noswap:
-	return (swp_entry_t) {0};
+	return n_ret;
+}
+
+swp_entry_t get_swap_page(void)
+{
+	swp_entry_t entry;
+
+	get_swap_pages(1, &entry);
+	return entry;
 }
 
 /* The only caller of this function is now suspend routine */
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch
mm-swap-allocate-swap-slots-in-batches.patch
mm-swap-free-swap-slots-in-batch.patch
mm-swap-add-cache-for-swap-slots-allocation.patch
mm-swap-enable-swap-slots-cache-usage.patch

