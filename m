From: akpm@linux-foundation.org
Subject: + mm-reuse-unused-swap-entry-if-necessary-update.patch added to -mm tree
Date: Tue, 02 Jun 2009 13:25:32 -0700
Message-ID: <200906022025.n52KPW5t032510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZFBUZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 16:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamoto@valinux.co.jp


The patch titled
     mm-reuse-unused-swap-entry-if-necessary-update
has been added to the -mm tree.  Its filename is
     mm-reuse-unused-swap-entry-if-necessary-update.patch

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
Subject: mm-reuse-unused-swap-entry-if-necessary-update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This is a replacement for
 mm-reuse-unused-swap-entry-if-necessary.patch in mmotm.
 function is renamed and comments are added.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN mm/swapfile.c~mm-reuse-unused-swap-entry-if-necessary-update mm/swapfile.c
--- a/mm/swapfile.c~mm-reuse-unused-swap-entry-if-necessary-update
+++ a/mm/swapfile.c
@@ -79,9 +79,9 @@ static inline unsigned short encode_swap
 	return ret;
 }
 
-
+/* returnes 1 if swap entry is freed */
 static int
-try_to_reuse_swap(struct swap_info_struct *si, unsigned long offset)
+__try_to_reclaim_swap(struct swap_info_struct *si, unsigned long offset)
 {
 	int type = si - swap_info;
 	swp_entry_t entry = swp_entry(type, offset);
@@ -91,6 +91,13 @@ try_to_reuse_swap(struct swap_info_struc
 	page = find_get_page(&swapper_space, entry.val);
 	if (!page)
 		return 0;
+	/*
+	 * This function is called from scan_swap_map() and it's called
+	 * by vmscan.c at reclaiming pages. So, we hold a lock on a page, here.
+	 * We have to use trylock for avoiding deadlock. This is a special
+	 * case and you should use try_to_free_swap() with explicit lock_page()
+	 * in usual operations.
+	 */
 	if (trylock_page(page)) {
 		ret = try_to_free_swap(page);
 		unlock_page(page);
@@ -323,13 +330,14 @@ checks:
 
 	/* reuse swap entry of cache-only swap if not busy. */
 	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
-		int ret;
+		int swap_was_freed;
 		spin_unlock(&swap_lock);
-		ret = try_to_reuse_swap(si, offset);
+		swap_was_freed = __try_to_reclaim_swap(si, offset);
 		spin_lock(&swap_lock);
-		if (ret)
-			goto checks; /* we released swap_lock. retry. */
-		goto scan; /* In some racy case */
+		/* entry was freed successfully, try to use this again */
+		if (swap_was_freed)
+			goto checks;
+		goto scan; /* check next one */
 	}
 
 	if (si->swap_map[offset])
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

