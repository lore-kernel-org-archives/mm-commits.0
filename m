From: akpm@linux-foundation.org
Subject: [patch 033/117] mm/slub.c: replace kick_all_cpus_sync() with
 synchronize_sched() in kmem_cache_shrink()
Date: Thu, 19 May 2016 17:10:34 -0700
Message-ID: <573e55fa.uWHbxyIy6glzVXXJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbcETAKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, peterz@infradead.org, rientjes@google.com

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm/slub.c: replace kick_all_cpus_sync() with synchronize_sched() in kmem_cache_shrink()

When we call __kmem_cache_shrink on memory cgroup removal, we need to
synchronize kmem_cache->cpu_partial update with put_cpu_partial that might
be running on other cpus.  Currently, we achieve that by using
kick_all_cpus_sync, which works as a system wide memory barrier.  Though
fast it is, this method has a flaw - it issues a lot of IPIs, which might
hurt high performance or real-time workloads.

To fix this, let's replace kick_all_cpus_sync with synchronize_sched. 
Although the latter one may take much longer to finish, it shouldn't be a
problem in this particular case, because memory cgroups are destroyed
asynchronously from a workqueue so that no user visible effects should be
introduced.  OTOH, it will save us from excessive IPIs when someone
removes a cgroup.

Anyway, even if using synchronize_sched turns out to take too long, we can
always introduce a kind of __kmem_cache_shrink batching so that this
method would only be called once per one cgroup destruction (not per each
per memcg kmem cache as it is now).

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-slub-replace-kick_all_cpus_sync-with-synchronize_sched-in-kmem_cache_shrink mm/slub.c
--- a/mm/slub.c~mm-slub-replace-kick_all_cpus_sync-with-synchronize_sched-in-kmem_cache_shrink
+++ a/mm/slub.c
@@ -3697,7 +3697,7 @@ int __kmem_cache_shrink(struct kmem_cach
 		 * s->cpu_partial is checked locklessly (see put_cpu_partial),
 		 * so we have to make sure the change is visible.
 		 */
-		kick_all_cpus_sync();
+		synchronize_sched();
 	}
 
 	flush_all(s);
_
