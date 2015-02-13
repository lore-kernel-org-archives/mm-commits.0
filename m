From: akpm@linux-foundation.org
Subject: [merged]
 fs-shrinker-always-scan-at-least-one-object-of-each-type.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:20:09 -0800
Message-ID: <54de5c79.LpH+Cxjtg9p3ftNW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbBMUUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, david@fromorbit.com, hannes@cmpxchg.org, mhocko@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: shrinker: always scan at least one object of each type
has been removed from the -mm tree.  Its filename was
     fs-shrinker-always-scan-at-least-one-object-of-each-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: add comment]
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type fs/super.c
--- a/fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type
+++ a/fs/super.c
@@ -91,14 +91,17 @@ static unsigned long super_cache_scan(st
 	/*
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
+	 *
+	 * Ensure that we always scan at least one object - memcg kmem
+	 * accounting uses this to fully empty the caches.
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

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

