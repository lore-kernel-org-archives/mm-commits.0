From: akpm@linux-foundation.org
Subject: + fs-make-shrinker-memcg-aware.patch added to -mm tree
Date: Fri, 09 Jan 2015 16:12:39 -0800
Message-ID: <54b06e77.U8hrLDKDb4lVCEck%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbbAJAMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 19:12:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: make shrinker memcg aware
has been added to the -mm tree.  Its filename is
     fs-make-shrinker-memcg-aware.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-make-shrinker-memcg-aware.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-make-shrinker-memcg-aware.patch

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
Subject: fs: make shrinker memcg aware

Now, to make any list_lru-based shrinker memcg aware we should only
initialize its list_lru as memcg aware.  Let's do it for the general FS
shrinker (super_block::s_shrink).

There are other FS-specific shrinkers that use list_lru for storing
objects, such as XFS and GFS2 dquot cache shrinkers, but since they
reclaim objects that are shared among different cgroups, there is no point
making them memcg aware.  It's a big question whether we should account
them to memcg at all.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/super.c~fs-make-shrinker-memcg-aware fs/super.c
--- a/fs/super.c~fs-make-shrinker-memcg-aware
+++ a/fs/super.c
@@ -189,9 +189,9 @@ static struct super_block *alloc_super(s
 	INIT_HLIST_BL_HEAD(&s->s_anon);
 	INIT_LIST_HEAD(&s->s_inodes);
 
-	if (list_lru_init(&s->s_dentry_lru))
+	if (list_lru_init_memcg(&s->s_dentry_lru))
 		goto fail;
-	if (list_lru_init(&s->s_inode_lru))
+	if (list_lru_init_memcg(&s->s_inode_lru))
 		goto fail;
 
 	init_rwsem(&s->s_umount);
@@ -227,7 +227,7 @@ static struct super_block *alloc_super(s
 	s->s_shrink.scan_objects = super_cache_scan;
 	s->s_shrink.count_objects = super_cache_count;
 	s->s_shrink.batch = 1024;
-	s->s_shrink.flags = SHRINKER_NUMA_AWARE;
+	s->s_shrink.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE;
 	return s;
 
 fail:
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch

