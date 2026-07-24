Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2808037A488
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 05:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870883; cv=none; b=YAsqnaXPNT+SGH6OETb0aRBb3UPaEz6g75jPc8l9T6/+uHFMxpQdT/3V3m43vd9pbIGnIUz7X9V4StfSjrrisi8USx8hMB0lNeLktRYt8vdPIVuqm3x0GPHF68w29D6wBsSz8GSm5OWHQ2oRYKPvKqOAHe2RUb44zIYeo966owc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870883; c=relaxed/simple;
	bh=2oHwmO1MwcNcnj/79SHJoKyqHP//K8H4ieb5hQE5XvU=;
	h=Date:To:From:Subject:Message-Id; b=qgpohUv9f4kpJHrLrTTP1L26Jws7EkfPogsrVnGa05JoX0RtoZJOihPSVSGlgGNktUxTfnNT44EUIPQFfUE0zAwVKQEjLstoXAVtIsYabEVnL+3epxFhE4Y1UecFieL37KIzgsUF+8oInpfFT0mzRlaYWqg0Tt0ICtDCfGwiOfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pxm/vObe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pxm/vObe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DCF1F00A3A;
	Fri, 24 Jul 2026 05:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784870882;
	bh=7EYCQyc8ZS5lCz9r8QfLUK/B5OJeRxtQARbpc2cQ1iY=;
	h=Date:To:From:Subject;
	b=pxm/vObeucn2XgSJ4St1Z3gElMhdSQI+zjyjKdnNF6YdIg/Z5Zo+kjpRnqWsiGNvu
	 7XoGNv9XaGHr4Dz5hyOOqJTwnN0lgeYSo2OhQ0Nd5FETnpfzTfAD4NVjirbILNIRdd
	 90igDzhiMmkuqfimoq+Ya9sgGTNN7zlRcmuLWZZY=
Date: Thu, 23 Jul 2026 22:28:01 -0700
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch removed from -mm tree
Message-Id: <20260724052801.F0DCF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch

This patch was dropped because an updated version will be issued

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
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
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
@@ -7732,7 +7732,7 @@ static unsigned long node_pagecache_recl
 /*
  * Try to free up some pages from this node through reclaim.
  */
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7824,7 +7824,7 @@ unsigned long node_reclaim(struct pglist
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return 0;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
+	ret = __node_reclaim(pgdat, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret >= nr_pages)
@@ -7837,7 +7837,7 @@ unsigned long node_reclaim(struct pglist
 
 #else
 
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7950,8 +7950,7 @@ int user_proactive_reclaim(char *buf,
 						  &pgdat->flags))
 				return -EBUSY;
 
-			reclaimed = __node_reclaim(pgdat, gfp_mask,
-						   batch_size, &sc);
+			reclaimed = __node_reclaim(pgdat, batch_size, &sc);
 			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

