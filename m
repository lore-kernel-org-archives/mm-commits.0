From: akpm@linux-foundation.org
Subject: + memcg-zap-memcg_can_account_kmem.patch added to -mm tree
Date: Wed, 24 Sep 2014 14:03:56 -0700
Message-ID: <542331bc.IebcV86tuiBQpN9M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaIXVD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 17:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap memcg_can_account_kmem
has been added to the -mm tree.  Its filename is
     memcg-zap-memcg_can_account_kmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-zap-memcg_can_account_kmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-zap-memcg_can_account_kmem.patch

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
Subject: memcg: zap memcg_can_account_kmem

memcg_can_account_kmem() returns true iff

    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
                                   memcg_kmem_is_active(memcg);

To begin with the !mem_cgroup_is_root(memcg) check is useless, because one
can't enable kmem accounting for the root cgroup (mem_cgroup_write()
returns EINVAL on an attempt to set the limit on the root cgroup).

Furthermore, the !mem_cgroup_disabled() check also seems to be redundant. 
The point is memcg_can_account_kmem() is called from three places:
mem_cgroup_salbinfo_read(), __memcg_kmem_get_cache(), and
__memcg_kmem_newpage_charge().  The latter two functions are only invoked
if memcg_kmem_enabled() returns true, which implies that the memory cgroup
subsystem is enabled.  And mem_cgroup_slabinfo_read() shows the output of
memory.kmem.slabinfo, which won't exist if the memory cgroup is completely
disabled.

So let's substitute all the calls to memcg_can_account_kmem() with plain
memcg_kmem_is_active(), and kill the former.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-zap-memcg_can_account_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-memcg_can_account_kmem
+++ a/mm/memcontrol.c
@@ -2748,12 +2748,6 @@ static DEFINE_MUTEX(memcg_slab_mutex);
 
 static DEFINE_MUTEX(activate_kmem_mutex);
 
-static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
-{
-	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
-		memcg_kmem_is_active(memcg);
-}
-
 /*
  * This is a bit cumbersome, but it is rarely used and avoids a backpointer
  * in the memcg_cache_params struct.
@@ -2773,7 +2767,7 @@ static int mem_cgroup_slabinfo_read(stru
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	struct memcg_cache_params *params;
 
-	if (!memcg_can_account_kmem(memcg))
+	if (!memcg_kmem_is_active(memcg))
 		return -EIO;
 
 	print_slabinfo_header(m);
@@ -3150,7 +3144,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
 
-	if (!memcg_can_account_kmem(memcg))
+	if (!memcg_kmem_is_active(memcg))
 		goto out;
 
 	memcg_cachep = cache_from_memcg_idx(cachep, memcg_cache_id(memcg));
@@ -3235,7 +3229,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
 
-	if (!memcg_can_account_kmem(memcg)) {
+	if (!memcg_kmem_is_active(memcg)) {
 		css_put(&memcg->css);
 		return true;
 	}
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
mm-memcontrol-fix-transparent-huge-page-allocations-under-pressure.patch
memcg-zap-memcg_can_account_kmem.patch
linux-next.patch

