From: akpm@linux-foundation.org
Subject: [patch 02/14] mm: memcontrol: let v2 cgroups follow changes in
 system swappiness
Date: Thu, 05 May 2016 16:22:03 -0700
Message-ID: <572bd59b.rm52aqR3v7MV6wcn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbcEEXWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2016 19:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov@virtuozzo.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: let v2 cgroups follow changes in system swappiness

Cgroup2 currently doesn't have a per-cgroup swappiness setting.  We might
want to add one later - that's a different discussion - but until we do,
the cgroups should always follow the system setting.  Otherwise it will be
unchangeably set to whatever the ancestor inherited from the system
setting at the time of cgroup creation.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>	[4.5]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/swap.h~mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness include/linux/swap.h
--- a/include/linux/swap.h~mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness
+++ a/include/linux/swap.h
@@ -533,6 +533,10 @@ static inline swp_entry_t get_swap_page(
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
+	/* Cgroup2 doesn't have per-cgroup swappiness */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return vm_swappiness;
+
 	/* root ? */
 	if (mem_cgroup_disabled() || !memcg->css.parent)
 		return vm_swappiness;
_
