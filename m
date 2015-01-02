From: akpm@linux-foundation.org
Subject: + mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
 added to -mm tree
Date: Fri, 02 Jan 2015 14:19:57 -0800
Message-ID: <54a7198d.OBB8vjBnki6uvTRT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbABWT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:19:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: switch soft limit default back to infinity
has been added to the -mm tree.  Its filename is
     mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch

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
Subject: mm: memcontrol: switch soft limit default back to infinity

3e32cb2e0a12 ("mm: memcontrol: lockless page counters") accidentally
switched the soft limit default from infinity to zero, which turns all
memcgs with even a single page into soft limit excessors and engages soft
limit reclaim on all of them during global memory pressure.  This makes
global reclaim generally more aggressive, but also inverts the meaning of
existing soft limit configurations where unset soft limits are usually
more generous than set ones.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-switch-soft-limit-default-back-to-infinity mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-switch-soft-limit-default-back-to-infinity
+++ a/mm/memcontrol.c
@@ -4679,6 +4679,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (parent_css == NULL) {
 		root_mem_cgroup = memcg;
 		page_counter_init(&memcg->memory, NULL);
+		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
 	}
@@ -4724,6 +4725,7 @@ mem_cgroup_css_online(struct cgroup_subs
 
 	if (parent->use_hierarchy) {
 		page_counter_init(&memcg->memory, &parent->memory);
+		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 
@@ -4733,6 +4735,7 @@ mem_cgroup_css_online(struct cgroup_subs
 		 */
 	} else {
 		page_counter_init(&memcg->memory, NULL);
+		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
 		/*
@@ -4807,7 +4810,7 @@ static void mem_cgroup_css_reset(struct
 	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
 	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
 	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
-	memcg->soft_limit = 0;
+	memcg->soft_limit = PAGE_COUNTER_MAX;
 }
 
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch

