From: akpm@linux-foundation.org
Subject: + memcg-fix-swap-accounting-update.patch added to -mm tree
Date: Tue, 02 Jun 2009 13:28:03 -0700
Message-ID: <200906022028.n52KS3LZ002020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbZFBU2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 16:28:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg-fix-swap-accounting-update
has been added to the -mm tree.  Its filename is
     memcg-fix-swap-accounting-update.patch

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
Subject: memcg-fix-swap-accounting-update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This is a replacement for
  memcg-fix-swap-accounting.patch in mmotm.
Adjusted to style changes in 2/4 and 3/4.

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

 include/linux/swap.h |    4 ++--
 mm/memcontrol.c      |    2 +-
 mm/swapfile.c        |    8 +++++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~memcg-fix-swap-accounting-update include/linux/swap.h
--- a/include/linux/swap.h~memcg-fix-swap-accounting-update
+++ a/include/linux/swap.h
@@ -320,10 +320,10 @@ static inline void disable_swap_token(vo
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout);
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
 #else
 static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout)
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 {
 }
 #endif
diff -puN mm/memcontrol.c~memcg-fix-swap-accounting-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-swap-accounting-update
+++ a/mm/memcontrol.c
@@ -1559,7 +1559,7 @@ void mem_cgroup_uncharge_cache_page(stru
  * memcg information is recorded to swap_cgroup of "ent"
  */
 void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout)
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 {
 	struct mem_cgroup *memcg;
 	int ctype = MEM_CGROUP_CHARGE_TYPE_SWAPOUT;
diff -puN mm/swapfile.c~memcg-fix-swap-accounting-update mm/swapfile.c
--- a/mm/swapfile.c~memcg-fix-swap-accounting-update
+++ a/mm/swapfile.c
@@ -614,12 +614,14 @@ void swapcache_free(swp_entry_t entry, s
 
 	p = swap_info_get(entry);
 	if (p) {
-		ret = swap_entry_free(p, entry, 1);
+		ret = swap_entry_free(p, entry, SWAP_CACHE);
 		if (page) {
+			bool swapout;
 			if (ret)
-				mem_cgroup_uncharge_swapcache(page, entry, 1);
+				swapout = true; /* the end of swap out */
 			else
-				mem_cgroup_uncharge_swapcache(page, entry, 0);
+				swapout = false; /* no more swap users! */
+			mem_cgroup_uncharge_swapcache(page, entry, swapout);
 		}
 		spin_unlock(&swap_lock);
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
memcg-fix-swap-accounting-update.patch

