Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF4E4A3D37
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 22:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302446; cv=none; b=l6wiYxPuJ2o5DDKyVXuZI2TAaWHr1Rw5/SKASH2tuPFelE1NmNWS7gdZ06NWgfvDdRpx7aQMn64IHMfP2zaBgVLFVy6Zp5j1IyrbsIT+uUtig8xNE7/e1OXgA0+8dfEdLjug/Ea9bK8WtxlRTcr6Jx9aASZnUtpOOq0PKk9wOYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302446; c=relaxed/simple;
	bh=5rGiWKl9zj4vzQwC/3wrcHdOxjfCWMANbf7mKeDXGRg=;
	h=Date:To:From:Subject:Message-Id; b=CVDybJattp+ms9sl3KsBH2F28t7m/p2obtpPwB2EoEzus8Ic3I79Mn2Zgu7iG2mC+KsVa7K+lMOkqxakgoM9BcvZH203Y5JqhCqMnZEpxHy97ul233AZQOtwFiY5YjOkULb08bPWGUTcyGHXh8xlTMonw5V0afogrT55LFKhUuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2MLJ4S8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2MLJ4S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A631F000E9;
	Tue,  1 Sep 2026 22:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788302441;
	bh=0FGszTKXDHeiT+fi5f4/4fGS1k8iGSynAITJl42pSXw=;
	h=Date:To:From:Subject;
	b=p2MLJ4S8RnRJ1IxQ90HQbJs1rVysy6PepxTBzs7zAaDdcb+xPrgrcMnqsYlLbr8sx
	 PeIcwVZs/f2vDrRXgtxv2KALIy6xXxTuob3FIHcLCa63y4+LahkXTRiPu3MomZdCw+
	 4nRoI/iL1wJvFmWkgscbjumVQPM4nC720L9A2Eu0=
Date: Tue, 01 Sep 2026 15:40:41 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch removed from -mm tree
Message-Id: <20260901224041.76A631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: use explicit tier range in read_ctrl_pos()
has been removed from the -mm tree.  Its filename was
     mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: use explicit tier range in read_ctrl_pos()
Date: Wed, 26 Aug 2026 01:53:38 +0800

read_ctrl_pos() encodes the tier range in a single "tier" parameter via
"tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)" as the
end.  This is hard to follow, maintain, or extend.  Tier values 0..3
select a single tier, while tier == MAX_NR_TIERS selects the full range.

Replace it with explicit (tier_min, tier_max) parameters using a closed
[tier_min, tier_max] interval, and add LRU_TIER_MIN and LRU_TIER_MAX for
the tier bounds.  The call sites now become self-documenting:

  - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
                    (tier, tier) for each subsequent tier
  - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range

No functional change.

Link: https://lore.kernel.org/20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmscan.c            |   18 ++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/linux/mmzone.h~mm-mglru-use-explicit-tier-range-in-read_ctrl_pos
+++ a/include/linux/mmzone.h
@@ -495,6 +495,8 @@ enum lruvec_flags {
  * folio->flags, masked by LRU_REFS_MASK.
  */
 #define MAX_NR_TIERS		4U
+#define LRU_TIER_MIN		0U
+#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
 #ifndef __GENERATING_BOUNDS_H
 
--- a/mm/vmscan.c~mm-mglru-use-explicit-tier-range-in-read_ctrl_pos
+++ a/mm/vmscan.c
@@ -3198,8 +3198,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3208,7 +3208,7 @@ static void read_ctrl_pos(struct lruvec
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i <= tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4809,9 +4809,9 @@ static int get_tier_idx(struct lruvec *l
 	 * This value is chosen because any other tier would have at least twice
 	 * as many refaults as the first tier.
 	 */
-	read_ctrl_pos(lruvec, type, 0, 2, &sp);
-	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, 3, &pv);
+	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
+	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
+		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
 		if (!positive_ctrl_err(&sp, &pv))
 			break;
 	}
@@ -4832,8 +4832,10 @@ static int get_type_to_scan(struct lruve
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
+		      swappiness, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
+		      MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-fix-potential-generation-folio-number-leak.patch

