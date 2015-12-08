From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 15:06:44 -0800
Message-ID: <56676284.+UmQ0QhWVASV8N7C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLHXGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:06:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: separate kmem code from legacy tcp accounting code
has been added to the -mm tree.  Its filename is
     mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch

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
Subject: mm: memcontrol: separate kmem code from legacy tcp accounting code

The cgroup2 memory controller will include important in-kernel memory
consumers per default, including socket memory, but it will no longer
carry the historic tcp control interface.

Separate the kmem state init from the tcp control interface init in
preparation for that.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code
+++ a/mm/memcontrol.c
@@ -2925,17 +2925,6 @@ static int memcg_propagate_kmem(struct m
 	return ret;
 }
 
-static int memcg_init_kmem(struct mem_cgroup *memcg)
-{
-	int ret;
-
-	ret = memcg_propagate_kmem(memcg);
-	if (ret)
-		return ret;
-
-	return tcp_init_cgroup(memcg);
-}
-
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct cgroup_subsys_state *css;
@@ -2988,7 +2977,6 @@ static void memcg_free_kmem(struct mem_c
 		static_branch_dec(&memcg_kmem_enabled_key);
 		WARN_ON(page_counter_read(&memcg->kmem));
 	}
-	tcp_destroy_cgroup(memcg);
 }
 #else
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
@@ -2996,16 +2984,9 @@ static int memcg_update_kmem_limit(struc
 {
 	return -EINVAL;
 }
-static int memcg_init_kmem(struct mem_cgroup *memcg)
-{
-	return 0;
-}
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 }
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
@@ -4241,9 +4222,14 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	ret = memcg_init_kmem(memcg);
+#ifdef CONFIG_MEMCG_KMEM
+	ret = memcg_propagate_kmem(memcg);
 	if (ret)
 		return ret;
+	ret = tcp_init_cgroup(memcg);
+	if (ret)
+		return ret;
+#endif
 
 #ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
@@ -4288,11 +4274,16 @@ static void mem_cgroup_css_free(struct c
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	memcg_free_kmem(memcg);
 #ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 #endif
+
+#ifdef CONFIG_MEMCG_KMEM
+	memcg_free_kmem(memcg);
+	tcp_destroy_cgroup(memcg);
+#endif
+
 	__mem_cgroup_free(memcg);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
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
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

