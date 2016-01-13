From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
 added to -mm tree
Date: Wed, 13 Jan 2016 14:40:03 -0800
Message-ID: <5696d243.ChmiHGB1OQVXjKOY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbcAMWkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jan 2016 17:40:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not uncharge old page in page cache replacement
has been added to the -mm tree.  Its filename is
     mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: do not uncharge old page in page cache replacement

Changing page->mem_cgroup of a live page is tricky and fragile.  In
particular, the memcg writeback code relies on that mapping being stable
and users of mem_cgroup_replace_page() not overlapping with dirtyable
inodes.

Page cache replacement doesn't have to do that, though.  Instead of being
clever and transfering the charge from the old page to the new,
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
@@ -5463,7 +5456,8 @@ void mem_cgroup_uncharge_list(struct lis
 void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage)
 {
 	struct mem_cgroup *memcg;
-	int isolated;
+	unsigned int nr_pages;
+	bool compound;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
@@ -5483,11 +5477,21 @@ void mem_cgroup_replace_page(struct page
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

mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch

