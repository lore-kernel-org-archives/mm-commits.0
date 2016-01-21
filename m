From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:30:05 -0800
Message-ID: <56a169fd.5pLHop16b5rveKG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUXaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:30:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not uncharge old page in page cache replacement
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: do not uncharge old page in page cache replacement

Changing page->mem_cgroup of a live page is tricky and fragile.  In
particular, the memcg writeback code relies on that mapping being stable
and users of mem_cgroup_replace_page() not overlapping with dirtyable
inodes.

Page cache replacement doesn't have to do that, though.  Instead of being
clever and transferring the charge from the old page to the new,
force-charge the new page and leave the old page alone.  A temporary
overcharge won't matter in practice, and the old page is going to be freed
shortly after this anyway.  And this is not performance critical.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement
+++ a/mm/memcontrol.c
@@ -366,13 +366,6 @@ mem_cgroup_zone_zoneinfo(struct mem_cgro
  *
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
- *
- * XXX: The above description of behavior on the default hierarchy isn't
- * strictly true yet as replace_page_cache_page() can modify the
- * association before @page is released even on the default hierarchy;
- * however, the current and planned usages don't mix the the two functions
- * and replace_page_cache_page() will soon be updated to make the invariant
- * actually true.
  */
 struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
 {
@@ -5464,7 +5457,8 @@ void mem_cgroup_uncharge_list(struct lis
 void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage)
 {
 	struct mem_cgroup *memcg;
-	int isolated;
+	unsigned int nr_pages;
+	bool compound;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
@@ -5484,11 +5478,21 @@ void mem_cgroup_replace_page(struct page
 	if (!memcg)
 		return;
 
-	lock_page_lru(oldpage, &isolated);
-	oldpage->mem_cgroup = NULL;
-	unlock_page_lru(oldpage, isolated);
+	/* Force-charge the new page. The old one will be freed soon */
+	compound = PageTransHuge(newpage);
+	nr_pages = compound ? hpage_nr_pages(newpage) : 1;
+
+	page_counter_charge(&memcg->memory, nr_pages);
+	if (do_memsw_account())
+		page_counter_charge(&memcg->memsw, nr_pages);
+	css_get_many(&memcg->css, nr_pages);
 
 	commit_charge(newpage, memcg, true);
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(memcg, newpage, compound, nr_pages);
+	memcg_check_events(memcg, newpage);
+	local_irq_enable();
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

