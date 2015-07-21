From: akpm@linux-foundation.org
Subject: + memcg-zap-try_get_mem_cgroup_from_page.patch added to -mm tree
Date: Tue, 21 Jul 2015 16:33:57 -0700
Message-ID: <55aed6e5.hDTfOGi2oIWCMwYK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbbGUXd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 19:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap try_get_mem_cgroup_from_page
has been added to the -mm tree.  Its filename is
     memcg-zap-try_get_mem_cgroup_from_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-zap-try_get_mem_cgroup_from_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-zap-try_get_mem_cgroup_from_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap try_get_mem_cgroup_from_page

It is only used in mem_cgroup_try_charge, so fold it in and zap it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ------
 mm/memcontrol.c            |   48 ++++++++---------------------------
 2 files changed, 13 insertions(+), 44 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-zap-try_get_mem_cgroup_from_page include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-zap-try_get_mem_cgroup_from_page
+++ a/include/linux/memcontrol.h
@@ -305,11 +305,9 @@ struct lruvec *mem_cgroup_zone_lruvec(st
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg);
-
-struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
-
 struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
+
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -556,11 +554,6 @@ static inline struct lruvec *mem_cgroup_
 	return &zone->lruvec;
 }
 
-static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
-{
-	return NULL;
-}
-
 static inline bool mm_match_cgroup(struct mm_struct *mm,
 		struct mem_cgroup *memcg)
 {
diff -puN mm/memcontrol.c~memcg-zap-try_get_mem_cgroup_from_page mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-try_get_mem_cgroup_from_page
+++ a/mm/memcontrol.c
@@ -2094,40 +2094,6 @@ static void cancel_charge(struct mem_cgr
 	css_put_many(&memcg->css, nr_pages);
 }
 
-/*
- * try_get_mem_cgroup_from_page - look up page's memcg association
- * @page: the page
- *
- * Look up, get a css reference, and return the memcg that owns @page.
- *
- * The page must be locked to prevent racing with swap-in and page
- * cache charges.  If coming from an unlocked page table, the caller
- * must ensure the page is on the LRU or this can race with charging.
- */
-struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
-{
-	struct mem_cgroup *memcg;
-	unsigned short id;
-	swp_entry_t ent;
-
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-
-	memcg = page->mem_cgroup;
-	if (memcg) {
-		if (!css_tryget_online(&memcg->css))
-			memcg = NULL;
-	} else if (PageSwapCache(page)) {
-		ent.val = page_private(page);
-		id = lookup_swap_cgroup_id(ent);
-		rcu_read_lock();
-		memcg = mem_cgroup_from_id(id);
-		if (memcg && !css_tryget_online(&memcg->css))
-			memcg = NULL;
-		rcu_read_unlock();
-	}
-	return memcg;
-}
-
 static void lock_page_lru(struct page *page, int *isolated)
 {
 	struct zone *zone = page_zone(page);
@@ -5324,8 +5290,20 @@ int mem_cgroup_try_charge(struct page *p
 		 * the page lock, which serializes swap cache removal, which
 		 * in turn serializes uncharging.
 		 */
+		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		if (page->mem_cgroup)
 			goto out;
+
+		if (do_swap_account) {
+			swp_entry_t ent = { .val = page_private(page), };
+			unsigned short id = lookup_swap_cgroup_id(ent);
+
+			rcu_read_lock();
+			memcg = mem_cgroup_from_id(id);
+			if (memcg && !css_tryget_online(&memcg->css))
+				memcg = NULL;
+			rcu_read_unlock();
+		}
 	}
 
 	if (PageTransHuge(page)) {
@@ -5333,8 +5311,6 @@ int mem_cgroup_try_charge(struct page *p
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 	}
 
-	if (do_swap_account && PageSwapCache(page))
-		memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
 		memcg = get_mem_cgroup_from_mm(mm);
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

