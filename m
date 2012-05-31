From: akpm@linux-foundation.org
Subject: [merged] mm-mark-mm-inline-functions-as-__always_inline.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:55 -0700
Message-ID: <20120531191655.77540A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:47005 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab2EaTQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:57 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so75419bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark mm-inline functions as __always_inline
has been removed from the -mm tree.  Its filename was
     mm-mark-mm-inline-functions-as-__always_inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

