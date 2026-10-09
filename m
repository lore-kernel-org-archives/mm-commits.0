Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C18E3F106D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525405; cv=none; b=LrFRtfLThAwVOcjVVdPss0FQ8AEwS9hytyQ3q5HQ5+gbHGqY8yaDCKpW2x72bmE0tZa1Vr4qF3dFMnzMIWcUY2M8T37yS3yuzxcLOGXkaYWUftLcLbHReF/xgdOpmJ7ngQPmpDtwyBbMEJdKLYSFixAWnKzYuHSPBfxEwuNF0jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525405; c=relaxed/simple;
	bh=AYiaabVBXGbxUAte3snGAv8X+JI4d4Ym1JNNrapHL0M=;
	h=Date:To:From:Subject:Message-Id; b=BB90EaLHh9I9CbxSVM8HO+vFKrE3g8SMAh6ftvFjZ0KXMg7wG11jSbrF0JDNLmxhcTVb6At5Cswct6JvxX7qFPfIIRUNso2j8z8f1Jr3RYdXb5MrkVJO4GBGShJrcqBGK6K+8/qlnrxt1koLqE5DL+X19iMNtS37o/PrffEvxN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S4pWrDi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S4pWrDi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D451F00893;
	Fri,  9 Oct 2026 05:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525403;
	bh=43kA5tN3rDzuko1mhaiAsn/jrar0WVQq6ZDDAZr/LfQ=;
	h=Date:To:From:Subject;
	b=S4pWrDi1sV/iRv6bmTRez6CfXiy9cPqca1UPvZBgznMH70d+v8uraKdoeJBCalJ3K
	 W3uq1G3DhvAJJA56Wv5QG/TvtaD87QMYspviExBMtVzJDxAN5jEs3GjEvhFyO9ZinT
	 cTzq9nzjVQWd4rt30dBxmjn8eVJG3NJp0KG4L75k=
Date: Thu, 08 Oct 2026 22:56:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch removed from -mm tree
Message-Id: <20261009055643.C7D451F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: use explicit tier range in read_ctrl_pos()
has been removed from the -mm tree.  Its filename was
     mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: use explicit tier range in read_ctrl_pos()
Date: Sun, 06 Sep 2026 00:51:10 +0800

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

Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-5-9aacbd77d4ca@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
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
@@ -3223,8 +3223,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3233,7 +3233,7 @@ static void read_ctrl_pos(struct lruvec
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i <= tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4879,9 +4879,9 @@ static int get_tier_idx(struct lruvec *l
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
@@ -4902,8 +4902,10 @@ static int get_type_to_scan(struct lruve
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


