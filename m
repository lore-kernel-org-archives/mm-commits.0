From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:43 -0800
Message-ID: <20120113203343.BA12410004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49865 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:44 -0500
Received: by yenl1 with SMTP id l1so72157yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: lookup_page_cgroup (almost) never returns NULL
has been removed from the -mm tree.  Its filename was
     mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: lookup_page_cgroup (almost) never returns NULL

Pages have their corresponding page_cgroup descriptors set up before they
are used in userspace, and thus managed by a memory cgroup.

The only time where lookup_page_cgroup() can return NULL is in the
CONFIG_DEBUG_VM-only page sanity checking code that executes while feeding
pages into the page allocator for the first time.

Remove the NULL checks against lookup_page_cgroup() results from all
callsites where we know that corresponding page_cgroup descriptors must be
allocated, and add a comment to the callsite that actually does have to
check the return value.

[hughd@google.com: stop oops in mem_cgroup_update_page_stat()]
Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null
+++ a/mm/memcontrol.c
@@ -1960,7 +1960,7 @@ void mem_cgroup_update_page_stat(struct 
 	bool need_unlock = false;
 	unsigned long uninitialized_var(flags);
 
-	if (unlikely(!pc))
+	if (mem_cgroup_disabled())
 		return;
 
 	rcu_read_lock();
@@ -2735,8 +2735,6 @@ static int mem_cgroup_charge_common(stru
 	}
 
 	pc = lookup_page_cgroup(page);
-	BUG_ON(!pc); /* XXX: remove this and move pc lookup into commit */
-
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret || !memcg)
 		return ret;
@@ -3008,7 +3006,7 @@ __mem_cgroup_uncharge_common(struct page
 	 * Check if our page_cgroup is valid
 	 */
 	pc = lookup_page_cgroup(page);
-	if (unlikely(!pc || !PageCgroupUsed(pc)))
+	if (unlikely(!PageCgroupUsed(pc)))
 		return NULL;
 
 	lock_page_cgroup(pc);
@@ -3436,6 +3434,11 @@ static struct page_cgroup *lookup_page_c
 	struct page_cgroup *pc;
 
 	pc = lookup_page_cgroup(page);
+	/*
+	 * Can be NULL while feeding pages into the page allocator for
+	 * the first time, i.e. during boot or memory hotplug;
+	 * or when mem_cgroup_disabled().
+	 */
 	if (likely(pc) && PageCgroupUsed(pc))
 		return pc;
 	return NULL;
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

