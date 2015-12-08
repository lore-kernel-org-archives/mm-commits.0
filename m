From: akpm@linux-foundation.org
Subject: + mm-memcontrol-remove-double-kmem-page_counter-init.patch added
 to -mm tree
Date: Tue, 08 Dec 2015 15:06:38 -0800
Message-ID: <5667627e.2aSjaaJqLT8uf3h8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLHXGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:06:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove double kmem page_counter init
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-double-kmem-page_counter-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-double-kmem-page_counter-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-double-kmem-page_counter-init.patch

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
Subject: mm: memcontrol: remove double kmem page_counter init

The kmem page_counter's limit is initialized to PAGE_COUNTER_MAX inside
mem_cgroup_css_online().  There is no need to repeat this from
memcg_propagate_kmem().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-double-kmem-page_counter-init mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-double-kmem-page_counter-init
+++ a/mm/memcontrol.c
@@ -2840,8 +2840,7 @@ static u64 mem_cgroup_read_u64(struct cg
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_activate_kmem(struct mem_cgroup *memcg,
-			       unsigned long nr_pages)
+static int memcg_activate_kmem(struct mem_cgroup *memcg)
 {
 	int err = 0;
 	int memcg_id;
@@ -2876,13 +2875,6 @@ static int memcg_activate_kmem(struct me
 		goto out;
 	}
 
-	/*
-	 * We couldn't have accounted to this cgroup, because it hasn't got
-	 * activated yet, so this should succeed.
-	 */
-	err = page_counter_limit(&memcg->kmem, nr_pages);
-	VM_BUG_ON(err);
-
 	static_branch_inc(&memcg_kmem_enabled_key);
 	/*
 	 * A memory cgroup is considered kmem-active as soon as it gets
@@ -2903,10 +2895,14 @@ static int memcg_update_kmem_limit(struc
 	int ret;
 
 	mutex_lock(&memcg_limit_mutex);
-	if (!memcg_kmem_is_active(memcg))
-		ret = memcg_activate_kmem(memcg, limit);
-	else
-		ret = page_counter_limit(&memcg->kmem, limit);
+	/* Top-level cgroup doesn't propagate from root */
+	if (!memcg_kmem_is_active(memcg)) {
+		ret = memcg_activate_kmem(memcg);
+		if (ret)
+			goto out;
+	}
+	ret = page_counter_limit(&memcg->kmem, limit);
+out:
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
@@ -2925,7 +2921,7 @@ static int memcg_propagate_kmem(struct m
 	 * after this point, because it has at least one child already.
 	 */
 	if (memcg_kmem_is_active(parent))
-		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
+		ret = memcg_activate_kmem(memcg);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
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

