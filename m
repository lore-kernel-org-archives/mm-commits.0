Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5431233926
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 05:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871486; cv=none; b=Z2I6papdBP6PmSOcWI2+cylsVF+pXCYFExzLgEXmmVCo9VL6a1uU8u3OutKhGDS8GYoMENrbURzQLoWEwSWBIoWR6u9hV0Ll2X0njS/sPE+X38nShNZ1NTIgT/BjgijMGz+r37MyWb02mNZNSWt9LgUPHgOtJnLjWqIeMePZ8wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871486; c=relaxed/simple;
	bh=wzTfhSDY0gNge6UjRYlFZcntyLuM3x6gkBYq17fGxbM=;
	h=Date:To:From:Subject:Message-Id; b=NkNSbLa0vLnh2dKUqT/9brMNNOrcXgk///V9VhOsQImGFTYiToTIRSu/kZAIwRjVhcqGqNuX9pdBe1VyIK60xxRSyP2XGYs2Ilg2UU0u9HrSnRz4jVUeYeN00Ctx6iN9vN4ZTB5YmYrKwfVPeTh94XKh5/JkYGZdCmu6ZFEoDTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xSQ6kxzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xSQ6kxzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D881F000E9;
	Fri, 24 Jul 2026 05:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784871484;
	bh=/IdIjUPm3+/b+6JHAlApi169ob2Hn118WeViKYJCUZk=;
	h=Date:To:From:Subject;
	b=xSQ6kxzVJUgk+0xX/Dl6adptvZL8K7EI0EIacR1b1KMRqaomOevxpxeDIM0qQXNIV
	 vprvsWsD/gwW3HDO7B2UFfAsAA8AmRGowh6gJvXX0E4tdyIx/3DljEpXkgdKnKVLLB
	 Fu33ybZKhPsJI/KlrLS74oV7fbV4C24I5J5sQLd0=
Date: Thu, 23 Jul 2026 22:38:03 -0700
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch added to mm-unstable branch
Message-Id: <20260724053804.21D881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

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
Subject: mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max
Date: Fri, 24 Jul 2026 11:34:35 +0800

The previous patch fixed this issue for the traditional LRU.  The same
problem exists in MGLRU [1]: when swappiness=max (SWAPPINESS_ANON_ONLY) is
set, reclaim is expected to evict anonymous pages exclusively, but file
pages can still be reclaimed when anonymous pages cannot be reclaimed
(e.g.  no swap and no demotion target).

Fix it the same way as the traditional LRU: keep returning
SWAPPINESS_ANON_ONLY in get_swappiness(), and return 0 from
get_nr_to_scan() when SWAPPINESS_ANON_ONLY is set but anon pages cannot be
reclaimed.  Since get_nr_to_scan() decides how much MGLRU scans, returning
0 skips the scan entirely and avoids the useless scan work when there is
nothing eligible to reclaim.

The test result:
Before fix:

  # cat /sys/kernel/mm/lru_gen/enabled
  0x0007
  # cat memory.stat
  anon 204800
  file 67108864
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  # cat memory.stat
  anon 208896
  file 0
  ...
  pgsteal_proactive 16384
  pgscan_proactive 16384

After fix:

  # cat memory.stat
  anon 188416
  file 67215360
  kernel 1970176
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat memory.stat
  anon 204800
  file 67215360
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

Link: https://lore.kernel.org/20260724033435.2573323-5-ridong.chen@linux.dev
Link: https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev [1]
Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max
+++ a/mm/vmscan.c
@@ -2699,6 +2699,10 @@ static int get_swappiness(struct lruvec
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int swappiness = sc_swappiness(sc, memcg);
+
+	if (swappiness == SWAPPINESS_ANON_ONLY)
+		return swappiness;
 
 	if (!sc->may_swap)
 		return 0;
@@ -2707,7 +2711,7 @@ static int get_swappiness(struct lruvec
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
-	return sc_swappiness(sc, memcg);
+	return swappiness;
 }
 
 static int get_nr_gens(struct lruvec *lruvec, int type)
@@ -4909,6 +4913,20 @@ static long get_nr_to_scan(struct lruvec
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
+			return 0;
+	}
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch
mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch
mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

