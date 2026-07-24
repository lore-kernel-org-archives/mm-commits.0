Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFF437B011
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 05:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871483; cv=none; b=AukLHbexA6KA329mXKh44Sv1gEfUPzEg2QL1ytq8mnng4v6rAI+Gpdr8XY9ZUEBUMectjodqOAjPILakJOGM2b6yVUr5+EWLc6F6QJnTR06ObBGVgvKcFZUC0l97Eyy0hq4a5Halba7m5+Uvj+t4HXyCGK5sR9tHLJtrGDVTqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871483; c=relaxed/simple;
	bh=YMVOUlNGJ9yb0e5tiYUR0RWa1gSKr1C1eNkJ+JZwplU=;
	h=Date:To:From:Subject:Message-Id; b=s6NSaZO7aV5sMRocoWK6LA/TUZ7AXIMDX8CSUHABU/Np+Pievr2n0nXHyYoCxY0WThu26G3oy1RJ/Z0grlUDOP1AIqredRQprSzFY5V7vTS1/ArHx07VvUESQ9GJPtozdRyaGdDrixsorwDDSLrZRMRFHhY1tvMbo5CORW92gUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duQiFCwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duQiFCwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6BA1F000E9;
	Fri, 24 Jul 2026 05:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784871481;
	bh=yKvRNv7hBXbXdSTEPgbppaxZ8vl4artXMTLt7sqGW5M=;
	h=Date:To:From:Subject;
	b=duQiFCwZt1p8vaJbAZprCWcX2ONip5sU7SlrjYgCmumm6Jq0+D9EZZVj49oijWmPM
	 mFbxR6EKQyETPADhaqJtHxYN0QZpdMmQHq2q/cdBo3y5DDQvQIeXO5BLOtTIeTkf+L
	 jvqVr0ZrSDznU4MiIrJREMCKV3cRuyrMHREq5f4E=
Date: Thu, 23 Jul 2026 22:38:01 -0700
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch added to mm-unstable branch
Message-Id: <20260724053801.BA6BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
Date: Fri, 24 Jul 2026 11:34:34 +0800

Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
moved the scan_control construction out to the callers and passed the
struct in by pointer.  After that change every use of the gfp mask inside
__node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask parameter
unused.  Just remove the dead parameter and update the callers
accordingly.  No functional change.

Link: https://lore.kernel.org/20260724033435.2573323-4-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim
+++ a/mm/vmscan.c
@@ -7738,7 +7738,7 @@ static unsigned long node_pagecache_recl
 /*
  * Try to free up some pages from this node through reclaim.
  */
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7830,7 +7830,7 @@ unsigned long node_reclaim(struct pglist
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return 0;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
+	ret = __node_reclaim(pgdat, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret >= nr_pages)
@@ -7843,7 +7843,7 @@ unsigned long node_reclaim(struct pglist
 
 #else
 
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7956,8 +7956,7 @@ int user_proactive_reclaim(char *buf,
 						  &pgdat->flags))
 				return -EBUSY;
 
-			reclaimed = __node_reclaim(pgdat, gfp_mask,
-						   batch_size, &sc);
+			reclaimed = __node_reclaim(pgdat, batch_size, &sc);
 			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch
mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch
mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

