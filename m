From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-cleanup-css_reset-callback.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:39:46 -0700
Message-ID: <56f03ff2.XspzIGUJY+5xFYyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbcCUT4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: cleanup css_reset callback
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-cleanup-css_reset-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: cleanup css_reset callback

- Do not take memcg_limit_mutex for resetting limits - the cgroup cannot
  be altered from userspace anymore, so no need to protect them.

- Use plain page_counter_limit() for resetting ->memory and ->memsw
  limits instead of mem_cgrouop_resize_* helpers - we enlarge the limits,
  so no need in special handling.

- Reset ->swap and ->tcpmem limits as well.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-cleanup-css_reset-callback mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-cleanup-css_reset-callback
+++ a/mm/memcontrol.c
@@ -4257,9 +4257,11 @@ static void mem_cgroup_css_reset(struct
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
-	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
-	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->swap, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->memsw, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->kmem, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	memcg->low = 0;
 	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

