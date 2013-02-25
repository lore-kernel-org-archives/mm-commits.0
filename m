From: akpm@linux-foundation.org
Subject: [merged] memcg-cleanup-mem_cgroup_init-comment.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:09 -0800
Message-ID: <20130225205509.BA2D531C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:33572 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab3BYUzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:11 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70782qea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup mem_cgroup_init comment
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-mem_cgroup_init-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: cleanup mem_cgroup_init comment

We should encourage all memcg controller initialization independent on a
specific mem_cgroup to be done here rather than exploit css_alloc callback
and assume that nothing happens before root cgroup is created.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-cleanup-mem_cgroup_init-comment mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-mem_cgroup_init-comment
+++ a/mm/memcontrol.c
@@ -6830,10 +6830,12 @@ static void __init enable_swap_cgroup(vo
 #endif
 
 /*
- * The rest of init is performed during ->css_alloc() for root css which
- * happens before initcalls.  hotcpu_notifier() can't be done together as
- * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
- * dependency.  Do it from a subsys_initcall().
+ * subsys_initcall() for memory controller.
+ *
+ * Some parts like hotcpu_notifier() have to be initialized from this context
+ * because of lock dependencies (cgroup_lock -> cpu hotplug) but basically
+ * everything that doesn't depend on a specific mem_cgroup structure should
+ * be initialized from here.
  */
 static int __init mem_cgroup_init(void)
 {
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

