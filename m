From: akpm@linux-foundation.org
Subject: + fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
 added to -mm tree
Date: Tue, 13 Jan 2015 15:56:49 -0800
Message-ID: <54b5b0c1.s8KK1rm/UUJ9j4vV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbAMX4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 18:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, david@fromorbit.com, hannes@cmpxchg.org, mhocko@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: shrinker: always scan at least one object of each type
has been added to the -mm tree.  Its filename is
     fs-shrinker-always-scan-at-least-one-object-of-each-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-shrinker-always-scan-at-least-one-object-of-each-type.patch

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
Subject: fs: shrinker: always scan at least one object of each type

In super_cache_scan() we divide the number of objects of particular type
by the total number of objects in order to distribute pressure among As a
result, in some corner cases we can get nr_to_scan=0 even if there are
some objects to reclaim, e.g.  dentries=1, inodes=1, fs_objects=1,
nr_to_scan=1/3=0.

This is unacceptable for per memcg kmem accounting, because this means
that some objects may never get reclaimed after memcg death, preventing it
from being freed.

This patch therefore assures that super_cache_scan() will scan at least
one object of each type if any.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type fs/super.c
--- a/fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type
+++ a/fs/super.c
@@ -92,13 +92,13 @@ static unsigned long super_cache_scan(st
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
 	 */
-	sc->nr_to_scan = dentries;
+	sc->nr_to_scan = dentries + 1;
 	freed = prune_dcache_sb(sb, sc);
-	sc->nr_to_scan = inodes;
+	sc->nr_to_scan = inodes + 1;
 	freed += prune_icache_sb(sb, sc);
 
 	if (fs_objects) {
-		sc->nr_to_scan = fs_objects;
+		sc->nr_to_scan = fs_objects + 1;
 		freed += sb->s_op->free_cached_objects(sb, sc);
 	}
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

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
vmscan-force-scan-offline-memory-cgroups.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-remove-unnecessary-soft-limit-tree-node-test.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch

