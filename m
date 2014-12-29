From: akpm@linux-foundation.org
Subject: +
 memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch added to
 -mm tree
Date: Mon, 29 Dec 2014 13:56:39 -0800
Message-ID: <54a1ce17.NpURHoWF6fgoEcpR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaL2V4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Dec 2014 16:56:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix destination cgroup leak on task charges migration
has been added to the -mm tree.  Its filename is
     memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch

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
Subject: memcg: fix destination cgroup leak on task charges migration

We are supposed to take one css reference per each memory page and per
each swap entry accounted to a memory cgroup.  However, during task
charges migration we take a reference to the destination cgroup twice per
each swap entry: first in mem_cgroup_do_precharge()->try_charge() and then
in mem_cgroup_move_swap_account(), permanently leaking the destination
cgroup.

The hunk taking the second reference seems to be a leftover from the
pre-00501b531c472 ("mm: memcontrol: rewrite charge API") era.  Remove it
to fix the leak.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-destination-cgroup-leak-on-task-charges-migration mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-destination-cgroup-leak-on-task-charges-migration
+++ a/mm/memcontrol.c
@@ -3043,18 +3043,6 @@ static int mem_cgroup_move_swap_account(
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
 		mem_cgroup_swap_statistics(to, true);
-		/*
-		 * This function is only called from task migration context now.
-		 * It postpones page_counter and refcount handling till the end
-		 * of task migration(mem_cgroup_clear_mc()) for performance
-		 * improvement. But we cannot postpone css_get(to)  because if
-		 * the process that has been moved to @to does swap-in, the
-		 * refcount of @to might be decreased to 0.
-		 *
-		 * We are in attach() phase, so the cgroup is guaranteed to be
-		 * alive, so we can just call css_get().
-		 */
-		css_get(&to->css);
 		return 0;
 	}
 	return -EINVAL;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch

