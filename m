Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0010C391851
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 19:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784318025; cv=none; b=YuyCS5f0p+wJiMp8v5IFYtjgjs5vv2llY38smAtAnV1tVvUQaGhoryCjP3EBXHIWlRjGX5gT//j5BnGBPQc2FSk2mQ4nMq+fbEgOlJWfCCM3BIdt1zOzY91jWlOI+Pfxh071/YC6f3jG3pThQuzZmAYblHaQZunIPz2P446w20s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784318025; c=relaxed/simple;
	bh=4oZJdUbFgWvmoIXAx9c9vQkbqX+E389zqbeqkXDN1nA=;
	h=Date:To:From:Subject:Message-Id; b=J7HHfOKHzrxIaLhJ0g0ahLqIl1xZVx3c3xfMBa7yD+cI1969GVC0df96rQEPgnAi3L9uy17whmhA1OUoEGfL2UT6YnfMt4tJDc6Z21tLvgKeE9gMI/qCrp38eiCcSEtcNce8/OR/pIu4Sb36+iu7QUSn8aFTHmrVoBVJhWjEQOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WutNL1t/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WutNL1t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A731F000E9;
	Fri, 17 Jul 2026 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784318023;
	bh=jDt9rGewIRGUs+E+F/cIzIh/uEg+WG3s3Xv6DaQaFpY=;
	h=Date:To:From:Subject;
	b=WutNL1t/j/zZH3B03mrHcjxX1CyPmIqh8OZnMH3uRHlrS1AJsufwowxtU/2Shn177
	 RZ2J3wwntdG7iUdvqya8BllUGiSmnVbxXNgaagAMBlTOoVZ7oga5CQzAsppGUsAnyJ
	 vzHwFNDQSIfZDryh4Ux8r45kvTENhEZR7Am6hwM0=
Date: Fri, 17 Jul 2026 12:53:43 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch added to mm-new branch
Message-Id: <20260717195343.88A731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Fri, 17 Jul 2026 19:33:00 +0800

Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
moved the scan_control construction out to the callers and passed the
struct in by pointer.  After that change every use of the gfp mask inside
__node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask parameter
unused.  Just remove the dead parameter and update the callers
accordingly.  No functional change.

Link: https://lore.kernel.org/20260717113300.214717-4-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
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
@@ -7729,7 +7729,7 @@ static unsigned long node_pagecache_recl
 /*
  * Try to free up some pages from this node through reclaim.
  */
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7821,7 +7821,7 @@ unsigned long node_reclaim(struct pglist
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return 0;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
+	ret = __node_reclaim(pgdat, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret >= nr_pages)
@@ -7834,7 +7834,7 @@ unsigned long node_reclaim(struct pglist
 
 #else
 
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7940,8 +7940,7 @@ int user_proactive_reclaim(char *buf,
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

