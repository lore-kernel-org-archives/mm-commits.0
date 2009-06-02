From: akpm@linux-foundation.org
Subject: + mm-modify-swap_map-and-add-swap_has_cache-flag-update.patch added to -mm tree
Date: Tue, 02 Jun 2009 13:25:28 -0700
Message-ID: <200906022025.n52KPSVL032463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbZFBUZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 16:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamoto@valinux.co.jp


The patch titled
     mm-modify-swap_map-and-add-swap_has_cache-flag-update
has been added to the -mm tree.  Its filename is
     mm-modify-swap_map-and-add-swap_has_cache-flag-update.patch

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
Subject: mm-modify-swap_map-and-add-swap_has_cache-flag-update


Several style fix are done....maybe easier to read.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   67 ++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff -puN mm/swapfile.c~mm-modify-swap_map-and-add-swap_has_cache-flag-update mm/swapfile.c
--- a/mm/swapfile.c~mm-modify-swap_map-and-add-swap_has_cache-flag-update
+++ a/mm/swapfile.c
@@ -54,17 +54,23 @@ static struct swap_info_struct swap_info
 static DEFINE_MUTEX(swapon_mutex);
 
 /* For reference count accounting in swap_map */
+/* enum for swap_map[] handling. internal use only */
+enum {
+	SWAP_MAP = 0,	/* ops for reference from swap users */
+	SWAP_CACHE,	/* ops for reference from swap cache */
+};
+
 static inline int swap_count(unsigned short ent)
 {
 	return ent & SWAP_COUNT_MASK;
 }
 
-static inline int swap_has_cache(unsigned short ent)
+static inline bool swap_has_cache(unsigned short ent)
 {
-	return ent & SWAP_HAS_CACHE;
+	return !!(ent & SWAP_HAS_CACHE);
 }
 
-static inline unsigned short make_swap_count(int count, int has_cache)
+static inline unsigned short encode_swapmap(int count, bool has_cache)
 {
 	unsigned short ret = count;
 
@@ -73,6 +79,7 @@ static inline unsigned short make_swap_c
 	return ret;
 }
 
+
 /*
  * We need this because the bdev->unplug_fn can sleep and we cannot
  * hold swap_lock while calling the unplug_fn. And swap_lock
@@ -306,10 +313,10 @@ checks:
 		si->lowest_bit = si->max;
 		si->highest_bit = 0;
 	}
-	if (cache) /* at usual swap-out via vmscan.c */
-		si->swap_map[offset] = make_swap_count(0, 1);
+	if (cache == SWAP_CACHE) /* at usual swap-out via vmscan.c */
+		si->swap_map[offset] = encode_swapmap(0, true);
 	else /* at suspend */
-		si->swap_map[offset] = make_swap_count(1, 0);
+		si->swap_map[offset] = encode_swapmap(1, false);
 	si->cluster_next = offset + 1;
 	si->flags -= SWP_SCANNING;
 
@@ -426,7 +433,7 @@ swp_entry_t get_swap_page(void)
 
 		swap_list.next = next;
 		/* This is called for allocating swap entry for cache */
-		offset = scan_swap_map(si, 1);
+		offset = scan_swap_map(si, SWAP_CACHE);
 		if (offset) {
 			spin_unlock(&swap_lock);
 			return swp_entry(type, offset);
@@ -451,7 +458,7 @@ swp_entry_t get_swap_page_of_type(int ty
 	if (si->flags & SWP_WRITEOK) {
 		nr_swap_pages--;
 		/* This is called for allocating swap entry, not cache */
-		offset = scan_swap_map(si, 0);
+		offset = scan_swap_map(si, SWAP_MAP);
 		if (offset) {
 			spin_unlock(&swap_lock);
 			return swp_entry(type, offset);
@@ -503,16 +510,18 @@ static int swap_entry_free(struct swap_i
 {
 	unsigned long offset = swp_offset(ent);
 	int count = swap_count(p->swap_map[offset]);
-	int has_cache = swap_has_cache(p->swap_map[offset]);
+	bool has_cache;
+
+	has_cache = swap_has_cache(p->swap_map[offset]);
 
-	if (!cache) { /* dropping usage count of swap */
+	if (cache == SWAP_MAP) { /* dropping usage count of swap */
 		if (count < SWAP_MAP_MAX) {
 			count--;
-			p->swap_map[offset] = make_swap_count(count, has_cache);
+			p->swap_map[offset] = encode_swapmap(count, has_cache);
 		}
 	} else { /* dropping swap cache flag */
 		VM_BUG_ON(!has_cache);
-		p->swap_map[offset] = make_swap_count(count, 0);
+		p->swap_map[offset] = encode_swapmap(count, false);
 
 	}
 	/* return code. */
@@ -542,7 +551,7 @@ void swap_free(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, entry, 0);
+		swap_entry_free(p, entry, SWAP_MAP);
 		spin_unlock(&swap_lock);
 	}
 }
@@ -558,7 +567,7 @@ void swapcache_free(swp_entry_t entry, s
 		mem_cgroup_uncharge_swapcache(page, entry);
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, entry, 1);
+		swap_entry_free(p, entry, SWAP_CACHE);
 		spin_unlock(&swap_lock);
 	}
 	return;
@@ -638,7 +647,7 @@ int free_swap_and_cache(swp_entry_t entr
 
 	p = swap_info_get(entry);
 	if (p) {
-		if (swap_entry_free(p, entry, 0) == SWAP_HAS_CACHE) {
+		if (swap_entry_free(p, entry, SWAP_MAP) == SWAP_HAS_CACHE) {
 			page = find_get_page(&swapper_space, entry.val);
 			if (page && !trylock_page(page)) {
 				page_cache_release(page);
@@ -1131,7 +1140,7 @@ static int try_to_unuse(unsigned int typ
 
 		if (swap_count(*swap_map) == SWAP_MAP_MAX) {
 			spin_lock(&swap_lock);
-			*swap_map = make_swap_count(0, 1);
+			*swap_map = encode_swapmap(0, true);
 			spin_unlock(&swap_lock);
 			reset_overflow = 1;
 		}
@@ -2011,12 +2020,13 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but there is already one. -> EEXIST
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  */
-static int __swap_duplicate(swp_entry_t entry, int cache)
+static int __swap_duplicate(swp_entry_t entry, bool cache)
 {
 	struct swap_info_struct * p;
 	unsigned long offset, type;
 	int result = -EINVAL;
-	int count, has_cache;
+	int count;
+	bool has_cache;
 
 	if (is_migration_entry(entry))
 		return -EINVAL;
@@ -2034,25 +2044,28 @@ static int __swap_duplicate(swp_entry_t 
 
 	count = swap_count(p->swap_map[offset]);
 	has_cache = swap_has_cache(p->swap_map[offset]);
-	if (cache) { /* called for swapcache/swapin-readahead */
+
+	if (cache == SWAP_CACHE) { /* called for swapcache/swapin-readahead */
+
 		/* set SWAP_HAS_CACHE if there is no cache and entry is used */
 		if (!has_cache && count) {
-			p->swap_map[offset] = make_swap_count(count, 1);
+			p->swap_map[offset] = encode_swapmap(count, true);
 			result = 0;
-		} else if (has_cache)
+		} else if (has_cache) /* someone added cache */
 			result = -EEXIST;
-		else if (!count)
+		else if (!count) /* no users */
 			result = -ENOENT;
+
 	} else if (count || has_cache) {
 		if (count < SWAP_MAP_MAX - 1) {
-			p->swap_map[offset] = make_swap_count(count + 1,
-							      has_cache);
+			p->swap_map[offset] = encode_swapmap(count + 1,
+							     has_cache);
 			result = 0;
 		} else if (count <= SWAP_MAP_MAX) {
 			if (swap_overflow++ < 5)
 				printk(KERN_WARNING
 				       "swap_dup: swap entry overflow\n");
-			p->swap_map[offset] = make_swap_count(SWAP_MAP_MAX,
+			p->swap_map[offset] = encode_swapmap(SWAP_MAP_MAX,
 							      has_cache);
 			result = 0;
 		}
@@ -2072,7 +2085,7 @@ bad_file:
  */
 void swap_duplicate(swp_entry_t entry)
 {
-	__swap_duplicate(entry, 0);
+	__swap_duplicate(entry, SWAP_MAP);
 }
 
 /*
@@ -2085,7 +2098,7 @@ void swap_duplicate(swp_entry_t entry)
  */
 int swapcache_prepare(swp_entry_t entry)
 {
-	return __swap_duplicate(entry, 1);
+	return __swap_duplicate(entry, SWAP_CACHE);
 }
 
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
migration-only-migrate_prep-once-per-move_pages.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
mm-add-swap-cache-interface-for-swap-reference.patch
mm-modify-swap_map-and-add-swap_has_cache-flag.patch
mm-modify-swap_map-and-add-swap_has_cache-flag-update.patch
mm-reuse-unused-swap-entry-if-necessary.patch
mm-reuse-unused-swap-entry-if-necessary-update.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch

