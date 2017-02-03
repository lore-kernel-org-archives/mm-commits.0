From: akpm@linux-foundation.org
Subject: +
 slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches.patch
 added to -mm tree
Date: Fri, 03 Feb 2017 15:16:00 -0800
Message-ID: <58950f30.z5Pou0Ip/S2LVo0d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39772 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbdBCXQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 18:16:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, jsvana@fb.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: remove slub sysfs interface files early for empty memcg caches
has been added to the -mm tree.  Its filename is
     slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: slab: remove slub sysfs interface files early for empty memcg caches

With kmem cgroup support enabled, kmem_caches can be created and destroyed
frequently and a great number of near empty kmem_caches can accumulate if
there are a lot of transient cgroups and the system is not under memory
pressure.  When memory reclaim starts under such conditions, it can lead
to consecutive deactivation and destruction of many kmem_caches, easily
hundreds of thousands on moderately large systems, exposing scalability
issues in the current slab management code.  This is one of the patches to
address the issue.

Each cache has a number of sysfs interface files under /sys/kernel/slab. 
On a system with a lot of memory and transient memcgs, the number of
interface files which have to be removed once memory reclaim kicks in can
reach millions.

Link: http://lkml.kernel.org/r/20170117235411.9408-10-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jay Vana <jsvana@fb.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches mm/slub.c
--- a/mm/slub.c~slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches
+++ a/mm/slub.c
@@ -3955,8 +3955,20 @@ int __kmem_cache_shrink(struct kmem_cach
 #ifdef CONFIG_MEMCG
 static void kmemcg_cache_deact_after_rcu(struct kmem_cache *s)
 {
-	/* called with all the locks held after a sched RCU grace period */
-	__kmem_cache_shrink(s);
+	/*
+	 * Called with all the locks held after a sched RCU grace period.
+	 * Even if @s becomes empty after shrinking, we can't know that @s
+	 * doesn't have allocations already in-flight and thus can't
+	 * destroy @s until the associated memcg is released.
+	 *
+	 * However, let's remove the sysfs files for empty caches here.
+	 * Each cache has a lot of interface files which aren't
+	 * particularly useful for empty draining caches; otherwise, we can
+	 * easily end up with millions of unnecessary sysfs files on
+	 * systems which have a lot of memory and transient cgroups.
+	 */
+	if (!__kmem_cache_shrink(s))
+		sysfs_slab_remove(s);
 }
 
 void __kmemcg_cache_deactivate(struct kmem_cache *s)
@@ -5655,6 +5667,15 @@ static void sysfs_slab_remove(struct kme
 		 */
 		return;
 
+	if (!s->kobj.state_in_sysfs)
+		/*
+		 * For a memcg cache, this may be called during
+		 * deactivation and again on shutdown.  Remove only once.
+		 * A cache is never shut down before deactivation is
+		 * complete, so no need to worry about synchronization.
+		 */
+		return;
+
 #ifdef CONFIG_MEMCG
 	kset_unregister(s->memcg_kset);
 #endif
_

Patches currently in -mm which might be from tj@kernel.org are

revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch
slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove.patch
slab-remove-synchronous-rcu_barrier-call-in-memcg-cache-release-path.patch
slab-reorganize-memcg_cache_params.patch
slab-link-memcg-kmem_caches-on-their-associated-memory-cgroup.patch
slab-implement-slab_root_caches-list.patch
slab-introduce-__kmemcg_cache_deactivate.patch
slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path.patch
slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches.patch
slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations.patch

