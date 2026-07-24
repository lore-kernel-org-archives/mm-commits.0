Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF31737A848
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 05:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871479; cv=none; b=dcXLJlZnimq+tCGT6kCV4R1+WP+KrX9KIwOqphu3PCdwq0tiqmiTDcSnNjfUL6xVWSCXXuKtGT5DPbKC8GjxLgz2NNoF+WNfupEgyvf1Alt8vaVwsAl5H/zk3jNPeDDtvs2WYKvkXvtXIZjmkCDlbNngJLmE3y/uwbth7Jebilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871479; c=relaxed/simple;
	bh=bctUxMpoC75oA5NTCNPKU33GnZFIW5S5QzD4GjNfLJw=;
	h=Date:To:From:Subject:Message-Id; b=Wopmp3FMbteU8CXCTcdAsOBOIXb5JD9dwLaDz5nme0+8H4y1eMUWx+Dtmt63WTAAYs1STpAg3GIaiRmndmaXEDhUX4fdqYfFF2ohAM8e5HyJxaxnp/H2hfEZkq+5vGb1yYuxNDUhFV6mVhnO57ScoCutD9KqWPU6QSYaHRFxA/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QTKwP9aQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QTKwP9aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA591F000E9;
	Fri, 24 Jul 2026 05:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784871477;
	bh=oGV5nrGbzu3KcGeOuQHt7QrnWzpN+SWSFf1Yd5r86DY=;
	h=Date:To:From:Subject;
	b=QTKwP9aQiDmHeFpqvM8j0qt/DURTa/MuOdrFUYNU4ZQCCp61uHJG/EJ4a8zhp4GT9
	 0jjKI1OJd1zWayUyb/leegeK+6C7ojzSep0H+oBnY5q8qUvOFzr/kiBUAtfuuZfm3A
	 ZCRQm0wR3NdrVViDfTWtrByhZt3LFACpK0c/0tGk=
Date: Thu, 23 Jul 2026 22:37:56 -0700
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch added to mm-unstable branch
Message-Id: <20260724053757.3BA591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

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
Subject: mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
Date: Fri, 24 Jul 2026 11:34:32 +0800

Patch series "mm/vmscan: fix swappiness=max and clean up per-node
proactive reclaim", v4.

Fixes and one cleanup.

Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count() sat
after the "cannot reclaim anon" check, so when no anon was reclaimable the
request fell back to SCAN_FILE and evicted page cache instead.

Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
callers can no longer tell an invalid argument from a busy interface;
propagate the real error code, matching the memcg path.

Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().

Patch 4 fixes the same "swappiness=max" issue for MGLRU.


This patch (of 4):

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

Link: https://lore.kernel.org/20260724033435.2573323-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260724033435.2573323-2-ridong.chen@linux.dev
Link: https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/ [1]
Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Suggested-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
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

 mm/vmscan.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max
+++ a/mm/vmscan.c
@@ -2492,6 +2492,23 @@ static void get_scan_count(struct lruvec
 	enum scan_balance scan_balance;
 	enum lru_list lru;
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), bail out instead of falling back to evicting file pages,
+	 * which would violate the anon-only semantics.
+	 */
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
@@ -2510,13 +2527,6 @@ static void get_scan_count(struct lruvec
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
mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

