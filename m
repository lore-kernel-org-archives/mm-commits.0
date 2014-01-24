From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-kmem_accounted_activated-flag.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:58:53 -0800
Message-ID: <52e2b7ed.7YxCpaHC2jPDpzER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-remove-kmem_accounted_activated-flag.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:53 -0800


The patch titled
     Subject: memcg: remove KMEM_ACCOUNTED_ACTIVATED flag
has been removed from the -mm tree.  Its filename was
     memcg-remove-kmem_accounted_activated-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: remove KMEM_ACCOUNTED_ACTIVATED flag

Currently we have two state bits in mem_cgroup::kmem_account_flags
regarding kmem accounting activation, ACTIVATED and ACTIVE.  We start kmem
accounting only if both flags are set (memcg_can_account_kmem()), plus
throughout the code there are several places where we check only the
ACTIVE flag, but we never check the ACTIVATED flag alone.  These flags are
both set from memcg_update_kmem_limit() under the set_limit_mutex, the
ACTIVE flag always being set after ACTIVATED, and they never get cleared. 
That said checking if both flags are set is equivalent to checking only
for the ACTIVE flag, and since there is no ACTIVATED flag checks, we can
safely remove the ACTIVATED flag, and nothing will change.

Let's try to understand what was the reason for introducing these flags. 
The purpose of the ACTIVE flag is clear - it states that kmem should be
accounting to the cgroup.  The only requirement for it is that it should
be set after we have fully initialized kmem accounting bits for the cgroup
and patched all static branches relating to kmem accounting.  Since we
always check if static branch is enabled before actually considering if we
should account (otherwise we wouldn't benefit from static branching), this
guarantees us that we won't skip a commit or uncharge after a charge due
to an unpatched static branch.

Now let's move on to the ACTIVATED bit.  As I proved in the beginning of
this message, it is absolutely useless, and removing it will change
nothing.  So what was the reason introducing it?

The ACTIVATED flag was introduced by commit a8964b9b ("memcg: use static
branches when code not in use") in order to guarantee that
static_key_slow_inc(&memcg_kmem_enabled_key) would be called only once for
each memory cgroup when its kmem accounting was activated.  The point was
that at that time the memcg_update_kmem_limit() function's work-flow
looked like this:

        bool must_inc_static_branch = false;

        cgroup_lock();
        mutex_lock(&set_limit_mutex);
        if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
                /* The kmem limit is set for the first time */
                ret = res_counter_set_limit(&memcg->kmem, val);

                memcg_kmem_set_activated(memcg);
                must_inc_static_branch = true;
        } else
                ret = res_counter_set_limit(&memcg->kmem, val);
        mutex_unlock(&set_limit_mutex);
        cgroup_unlock();

        if (must_inc_static_branch) {
                /* We can't do this under cgroup_lock */
                static_key_slow_inc(&memcg_kmem_enabled_key);
                memcg_kmem_set_active(memcg);
        }

So that without the ACTIVATED flag we could race with other threads trying
to set the limit and increment the static branching ref-counter more than
once.  Today we call the whole memcg_update_kmem_limit() function under
the set_limit_mutex and this race is impossible.

As now we understand why the ACTIVATED bit was introduced and why we don't
need it now, and know that removing it will change nothing anyway, let's
get rid of it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-kmem_accounted_activated-flag mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-kmem_accounted_activated-flag
+++ a/mm/memcontrol.c
@@ -382,15 +382,10 @@ struct mem_cgroup {
 
 /* internal only representation about the status of kmem accounting. */
 enum {
-	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
-	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
+	KMEM_ACCOUNTED_ACTIVE, /* accounted by this cgroup itself */
 	KMEM_ACCOUNTED_DEAD, /* dead memcg with pending kmem charges */
 };
 
-/* We account when limit is on, but only after call sites are patched */
-#define KMEM_ACCOUNTED_MASK \
-		((1 << KMEM_ACCOUNTED_ACTIVE) | (1 << KMEM_ACCOUNTED_ACTIVATED))
-
 #ifdef CONFIG_MEMCG_KMEM
 static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
 {
@@ -402,16 +397,6 @@ static bool memcg_kmem_is_active(struct
 	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
 
-static void memcg_kmem_set_activated(struct mem_cgroup *memcg)
-{
-	set_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
-}
-
-static void memcg_kmem_clear_activated(struct mem_cgroup *memcg)
-{
-	clear_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
-}
-
 static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
 {
 	/*
@@ -2995,8 +2980,7 @@ static DEFINE_MUTEX(set_limit_mutex);
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
 	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
-		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK) ==
-							KMEM_ACCOUNTED_MASK;
+		memcg_kmem_is_active(memcg);
 }
 
 /*
@@ -3120,19 +3104,10 @@ static int memcg_update_cache_sizes(stru
 				0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
 	if (num < 0)
 		return num;
-	/*
-	 * After this point, kmem_accounted (that we test atomically in
-	 * the beginning of this conditional), is no longer 0. This
-	 * guarantees only one process will set the following boolean
-	 * to true. We don't need test_and_set because we're protected
-	 * by the set_limit_mutex anyway.
-	 */
-	memcg_kmem_set_activated(memcg);
 
 	ret = memcg_update_all_caches(num+1);
 	if (ret) {
 		ida_simple_remove(&kmem_limited_groups, num);
-		memcg_kmem_clear_activated(memcg);
 		return ret;
 	}
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

