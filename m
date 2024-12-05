Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09381D26D
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733373871; cv=none; b=HiTY5zvHHDmozc2RHYkhDrTPP/ezImNBwz53Tgf2DIGYvbK8Ahoj3WghG1vEfPkPabi35ZYGkl4CQ6/ijrC/daRhso6NcCmsO+yPCKcECFIdsBE2A4t5E8ptUgMIb54XAGBtgJs4tlKu63RtcZi0QQNfRdy+eFbT/4h4NbStX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733373871; c=relaxed/simple;
	bh=gXEDo+U72GWcISUbIoryxPuEXxUOIp68ncJ6uyFGbxI=;
	h=Date:To:From:Subject:Message-Id; b=aGtxm804iY01gNgp4oDqNBIqipy5N2fT/8IeKrCeGI+a4vIOQKr61t8JsuOyyRlTe0CkStHxJunv0cGklcdWyN0GRbNd684XqbhvpeNPOA5eaRbgapX+af/HvVyqleVHbAvlHat5AJFAo75wYw9mSPSjTCxdqsuy7QBFyLbdaAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZJZ9nGgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZJZ9nGgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0F7C4CED6;
	Thu,  5 Dec 2024 04:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733373870;
	bh=gXEDo+U72GWcISUbIoryxPuEXxUOIp68ncJ6uyFGbxI=;
	h=Date:To:From:Subject:From;
	b=ZJZ9nGgi65Oz1Y7HRI+pPv/KwqWc0wrXycKlBZXjVNk5ajyF8akhhAFnxAv4Cn8Jq
	 OxHq7rlU8jMYLQ/YybK5k5Ecg2Xd5mI3PDrp9zX6v7kZn+nHdLHRLUc/13v0hCd2Mf
	 PSlI3J3Y5lceCNKASww/VqqQwPeoKhlOnI09duVM=
Date: Wed, 04 Dec 2024 20:44:29 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-rework-type-selection.patch added to mm-unstable branch
Message-Id: <20241205044430.7B0F7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: rework type selection
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-rework-type-selection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-rework-type-selection.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: rework type selection
Date: Sun, 1 Dec 2024 20:28:21 -0700

With anon and file min_seq being able to move independently, rework type
selection so that it is based on the total refaults from all tiers of each
type.  Also allow a type to be selected until that type reaches
MIN_NR_GENS, and therefore abs_diff(min_seq[0],min_seq[1]) now can be 2
(MAX_NR_GENS-MIN_NR_GENS) instead of 1.

Since some tiers of a selected type can have higher refaults than the
first tier of the other type, use a less larger gain factor 2:3 instead of
1:2, in order for those tiers in the selected type to be better protected.

As an intermediate step to the final optimization, this change by itself
should not have userspace-visiable effects beyond performance.

Link: https://lkml.kernel.org/r/20241202032823.2741019-5-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: David Stevens <stevensd@chromium.org>
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   82 +++++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 56 deletions(-)

--- a/mm/vmscan.c~mm-mglru-rework-type-selection
+++ a/mm/vmscan.c
@@ -3089,15 +3089,20 @@ struct ctrl_pos {
 static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 			  struct ctrl_pos *pos)
 {
+	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
-	pos->refaulted = lrugen->avg_refaulted[type][tier] +
-			 atomic_long_read(&lrugen->refaulted[hist][type][tier]);
-	pos->total = lrugen->avg_total[type][tier] +
-		     lrugen->protected[hist][type][tier] +
-		     atomic_long_read(&lrugen->evicted[hist][type][tier]);
+	pos->refaulted = pos->total = 0;
 	pos->gain = gain;
+
+	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+		pos->refaulted += lrugen->avg_refaulted[type][i] +
+				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
+		pos->total += lrugen->avg_total[type][i] +
+			      lrugen->protected[hist][type][i] +
+			      atomic_long_read(&lrugen->evicted[hist][type][i]);
+	}
 }
 
 static void reset_ctrl_pos(struct lruvec *lruvec, int type, bool carryover)
@@ -4480,13 +4485,13 @@ static int get_tier_idx(struct lruvec *l
 	struct ctrl_pos sp, pv;
 
 	/*
-	 * To leave a margin for fluctuations, use a larger gain factor (1:2).
+	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
 	 * This value is chosen because any other tier would have at least twice
 	 * as many refaults as the first tier.
 	 */
-	read_ctrl_pos(lruvec, type, 0, 1, &sp);
+	read_ctrl_pos(lruvec, type, 0, 2, &sp);
 	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, 2, &pv);
+		read_ctrl_pos(lruvec, type, tier, 3, &pv);
 		if (!positive_ctrl_err(&sp, &pv))
 			break;
 	}
@@ -4494,68 +4499,34 @@ static int get_tier_idx(struct lruvec *l
 	return tier - 1;
 }
 
-static int get_type_to_scan(struct lruvec *lruvec, int swappiness, int *tier_idx)
+static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	int type, tier;
 	struct ctrl_pos sp, pv;
-	int gain[ANON_AND_FILE] = { swappiness, MAX_SWAPPINESS - swappiness };
 
+	if (!swappiness)
+		return LRU_GEN_FILE;
+
+	if (swappiness == MAX_SWAPPINESS)
+		return LRU_GEN_ANON;
 	/*
-	 * Compare the first tier of anon with that of file to determine which
-	 * type to scan. Also need to compare other tiers of the selected type
-	 * with the first tier of the other type to determine the last tier (of
-	 * the selected type) to evict.
+	 * Compare the sum of all tiers of anon with that of file to determine
+	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, gain[LRU_GEN_ANON], &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, gain[LRU_GEN_FILE], &pv);
-	type = positive_ctrl_err(&sp, &pv);
-
-	read_ctrl_pos(lruvec, !type, 0, gain[!type], &sp);
-	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, gain[type], &pv);
-		if (!positive_ctrl_err(&sp, &pv))
-			break;
-	}
-
-	*tier_idx = tier - 1;
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
 
-	return type;
+	return positive_ctrl_err(&sp, &pv);
 }
 
 static int isolate_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness,
 			  int *type_scanned, struct list_head *list)
 {
 	int i;
-	int type;
-	int tier = -1;
-	DEFINE_MIN_SEQ(lruvec);
-
-	/*
-	 * Try to make the obvious choice first, and if anon and file are both
-	 * available from the same generation,
-	 * 1. Interpret swappiness 1 as file first and MAX_SWAPPINESS as anon
-	 *    first.
-	 * 2. If !__GFP_IO, file first since clean pagecache is more likely to
-	 *    exist than clean swapcache.
-	 */
-	if (!swappiness)
-		type = LRU_GEN_FILE;
-	else if (min_seq[LRU_GEN_ANON] < min_seq[LRU_GEN_FILE])
-		type = LRU_GEN_ANON;
-	else if (swappiness == 1)
-		type = LRU_GEN_FILE;
-	else if (swappiness == MAX_SWAPPINESS)
-		type = LRU_GEN_ANON;
-	else if (!(sc->gfp_mask & __GFP_IO))
-		type = LRU_GEN_FILE;
-	else
-		type = get_type_to_scan(lruvec, swappiness, &tier);
+	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
 		int scanned;
-
-		if (tier < 0)
-			tier = get_tier_idx(lruvec, type);
+		int tier = get_tier_idx(lruvec, type);
 
 		*type_scanned = type;
 
@@ -4564,7 +4535,6 @@ static int isolate_folios(struct lruvec
 			return scanned;
 
 		type = !type;
-		tier = -1;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch

