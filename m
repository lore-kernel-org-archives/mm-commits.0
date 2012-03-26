From: akpm@linux-foundation.org
Subject: + mm-mark-mm-inline-functions-as-__always_inline.patch added to -mm tree
Date: Mon, 26 Mar 2012 16:56:25 -0700
Message-ID: <20120326235625.EFC30A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52708 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2CZX41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 19:56:27 -0400
Received: by ggnd2 with SMTP id d2so868959ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 16:56:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org


The patch titled
     Subject: mm: mark mm-inline functions as __always_inline
has been added to the -mm tree.  Its filename is
     mm-mark-mm-inline-functions-as-__always_inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: mark mm-inline functions as __always_inline

GCC sometimes ignores "inline" directives even for small and simple functions.
This supposed to be fixed in gcc 4.7, but it was released only yesterday.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/mm_inline.h~mm-mark-mm-inline-functions-as-__always_inline include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-mark-mm-inline-functions-as-__always_inline
+++ a/include/linux/mm_inline.h
@@ -21,7 +21,7 @@ static inline int page_is_file_cache(str
 	return !PageSwapBacked(page);
 }
 
-static inline void
+static __always_inline void
 add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
 	struct lruvec *lruvec;
@@ -31,7 +31,7 @@ add_page_to_lru_list(struct zone *zone, 
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, hpage_nr_pages(page));
 }
 
-static inline void
+static __always_inline void
 del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
 	mem_cgroup_lru_del_list(page, lru);
@@ -61,7 +61,7 @@ static inline enum lru_list page_lru_bas
  * Returns the LRU list a page was on, as an index into the array of LRU
  * lists; and clears its Unevictable or Active flags, ready for freeing.
  */
-static inline enum lru_list page_off_lru(struct page *page)
+static __always_inline enum lru_list page_off_lru(struct page *page)
 {
 	enum lru_list lru;
 
@@ -85,7 +85,7 @@ static inline enum lru_list page_off_lru
  * Returns the LRU list a page should be on, as an index
  * into the array of LRU lists.
  */
-static inline enum lru_list page_lru(struct page *page)
+static __always_inline enum lru_list page_lru(struct page *page)
 {
 	enum lru_list lru;
 
_
Subject: Subject: mm: mark mm-inline functions as __always_inline

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

