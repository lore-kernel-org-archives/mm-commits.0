Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4AF43F08B
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 19:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784318021; cv=none; b=Ru2/frTbQeG3tMAIYYy3trG1I19x+tWOh+UwuYs3mv6jLjES+ZwiunAkI5BdhJC1w7q7mwhOAhS+78k+GYobejdr6niwD/g4k0W0skGfdbzo/9HdNDXWCMocMavTq7dsBWAxdupCg+B1Ha5OPsuIKGevyWCJsJfKnClOg0l0/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784318021; c=relaxed/simple;
	bh=TmDtZyfSDeM+qadEu5FkC0q5/MPhQSnGIYm7o9LE0ik=;
	h=Date:To:From:Subject:Message-Id; b=kW39qlmoWRJjJX87CI0iTdeu4a7qKgZw2233xPB2lqFGEqLbOsTCVQNEDSZ8I9mibZLJD3Ed3rz+7AQvkIkGlO3EbUuRrWHY9NaBC2ffTCP4JSPczYohrtNbINA/bWB3zwJDQ3htIyDBeCW3nJlf4XHpS9OMGE2ffz35ecgmcJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kaP2KF72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kaP2KF72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E521F000E9;
	Fri, 17 Jul 2026 19:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784318019;
	bh=vuGO7THKAZWW/CwT/a3Llnrs7A83+0sH6xEvdH6fVT8=;
	h=Date:To:From:Subject;
	b=kaP2KF72v9NM6oB4IcRqxf/diECk6G/FH1EQ3Q5KP29G/rpj/TEcTGJVjKLVnSYbg
	 MFkD43QMtTwdMR2GTkysltcvr1KM2/2IGmN5XCyeE88xEeMUEcLhkQQaOUDvaZfAFv
	 mHalx11REMMAz0c+WuX0quLfKGDglCOcPMN6Hyd4=
Date: Fri, 17 Jul 2026 12:53:38 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch added to mm-new branch
Message-Id: <20260717195339.44E521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

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
Subject: mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
Date: Fri, 17 Jul 2026 19:32:58 +0800

Patch series "mm/vmscan: fix swappiness=max and clean up per-node
proactive reclaim".

Two fixes and one cleanup.

Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
sat after the "cannot reclaim anon" check, so when no anon was
reclaimable the request fell back to SCAN_FILE and evicted page cache
instead.

Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
callers can no longer tell an invalid argument from a busy interface;
propagate the real error code, matching the memcg path.

Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().


This patch (of 3):

As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
the reclaim logic is expected to reclaim anonymous pages exclusively. 
However, due to the current ordering of checks in get_scan_count(), file
pages may still be evicted if can_reclaim_anon_pages() returns false,
which contradicts the semantics of SWAPPINESS_ANON_ONLY.

Reproducer in a cgroup holding 64M of file cache, with no swap configured:

  Before (file cache is wrongly evicted):
    # cat memory.stat
    anon 196608
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    # cat memory.stat
    anon 208896
    file 4096                 <- page cache evicted
    pgsteal_proactive 16400
    pgscan_proactive 16400

  After (file cache is left intact):
    # cat memory.stat
    anon 200704
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    -bash: echo: write error: Resource temporarily unavailable
    # cat memory.stat
    anon 208896
    file 67178496             <- page cache untouched
    pgsteal_proactive 0
    pgscan_proactive 0

Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
anonymous pages are reclaimable, before falling back to file reclaim.

Link: https://lore.kernel.org/20260717113300.214717-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260717113300.214717-2-ridong.chen@linux.dev
Link: https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/ [1]
Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Suggested-by: Qi Zheng <qi.zheng@linux.dev>
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
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max
+++ a/mm/vmscan.c
@@ -2492,6 +2492,17 @@ static void get_scan_count(struct lruvec
 	enum scan_balance scan_balance;
 	enum lru_list lru;
 
+	/* Proactive reclaim initiated by userspace for anonymous memory only */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
+			return;
+		}
+		scan_balance = SCAN_ANON;
+		goto out;
+	}
+
 	/* If we have no swap space, do not bother scanning anon folios. */
 	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
@@ -2510,13 +2521,6 @@ static void get_scan_count(struct lruvec
 		goto out;
 	}
 
-	/* Proactive reclaim initiated by userspace for anonymous memory only */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		scan_balance = SCAN_ANON;
-		goto out;
-	}
-
 	/*
 	 * Do not apply any pressure balancing cleverness when the
 	 * system is close to OOM, scan both anon and file equally
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch
mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch

