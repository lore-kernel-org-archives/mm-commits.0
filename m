Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C943150980
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005894; cv=none; b=Ebmn9iNjZIRIkX/yF5+zf8tue1UJXoN4S6+Ci7/Xrgb/KMkIcFWDGMURuXrVMt5OYIIjJe4sndvbtZNTxqyeO0GiFXTaCVQFDqmgVoBqhdk1s2xtY8Lc5fPyEpj5Mu2caQJO6+LNKVU4ya5d4WzI2BCYoKFI2iOD1d1OydQ2PQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005894; c=relaxed/simple;
	bh=zBvLsh3c4LUIuyZ9ByaeVXKo03fwdA+3PSml/CSYkh8=;
	h=Date:To:From:Subject:Message-Id; b=VKichfnHGb/I3ZOKR9TkQS0jXIAgiM7k8UffVeEwCBpwcYU7Soz+k33IVmenIK4vW9KauQkVrD2hyb2ApmHTIspj6H1zt6daz7GhyK9wrJk+ThGgm9mSN062fXKv3leISXeLcJPk/z9Akbk/vCQW3pVvm3BWOx6u8y+BBhNvTic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2rUGEDBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2rUGEDBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCC0C4CED6;
	Thu, 16 Jan 2025 05:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737005893;
	bh=zBvLsh3c4LUIuyZ9ByaeVXKo03fwdA+3PSml/CSYkh8=;
	h=Date:To:From:Subject:From;
	b=2rUGEDBhaBmN2M3S8EKnJYedEdUWVpaJyJN9D1gHxj7KsbvzRg00dvpIWv/2NVCVA
	 q1N4YOsD8k2UW9MkijqRJjHN9tf9ISBeGJoslgwRNCv7+YnUgOC70jQk+R78xrVRX2
	 WJyxnTaBI37SGav96vPJTi7VSE0ccRf7B3eFD7tM=
Date: Wed, 15 Jan 2025 21:38:12 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,ryncsn@gmail.com,kaleshsingh@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mglru-rework-aging-feedback-fix.patch removed from -mm tree
Message-Id: <20250116053813.7FCC0C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mglru-rework-aging-feedback-fix
has been removed from the -mm tree.  Its filename was
     mm-mglru-rework-aging-feedback-fix.patch

This patch was dropped because it was folded into mm-mglru-rework-aging-feedback.patch

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm-mglru-rework-aging-feedback-fix
Date: Sun, 12 Jan 2025 23:51:37 -0700

restore behaviour for systems with swappiness == 200

Link: https://lkml.kernel.org/r/Z4S3-aJy5dj9tBTk@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~mm-mglru-rework-aging-feedback-fix
+++ a/mm/vmscan.c
@@ -2625,7 +2625,7 @@ static bool should_clear_pmd_young(void)
 	}
 
 #define evictable_min_seq(min_seq, swappiness)				\
-	min((min_seq)[!(swappiness)], (min_seq)[(swappiness) != MAX_SWAPPINESS])
+	min((min_seq)[!(swappiness)], (min_seq)[(swappiness) <= MAX_SWAPPINESS])
 
 #define for_each_gen_type_zone(gen, type, zone)				\
 	for ((gen) = 0; (gen) < MAX_NR_GENS; (gen)++)			\
@@ -2633,7 +2633,7 @@ static bool should_clear_pmd_young(void)
 			for ((zone) = 0; (zone) < MAX_NR_ZONES; (zone)++)
 
 #define for_each_evictable_type(type, swappiness)			\
-	for ((type) = !(swappiness); (type) <= ((swappiness) != MAX_SWAPPINESS); (type)++)
+	for ((type) = !(swappiness); (type) <= ((swappiness) <= MAX_SWAPPINESS); (type)++)
 
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
@@ -3279,7 +3279,7 @@ static int should_skip_vma(unsigned long
 	if (shmem_mapping(mapping))
 		return !walk->swappiness;
 
-	if (walk->swappiness == MAX_SWAPPINESS)
+	if (walk->swappiness > MAX_SWAPPINESS)
 		return true;
 
 	/* to exclude special mappings like dax, etc. */
@@ -3739,7 +3739,7 @@ static bool inc_min_seq(struct lruvec *l
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
-	if (type ? swappiness == MAX_SWAPPINESS : !swappiness)
+	if (type ? swappiness > MAX_SWAPPINESS : !swappiness)
 		goto done;
 
 	/* prevent cold/hot inversion if the type is evictable */
@@ -3800,7 +3800,7 @@ next:
 	}
 
 	/* see the comment on lru_gen_folio */
-	if (swappiness && swappiness != MAX_SWAPPINESS) {
+	if (swappiness && swappiness <= MAX_SWAPPINESS) {
 		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
 
 		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
@@ -4556,13 +4556,13 @@ static int isolate_folios(struct lruvec
 	 * 2. If !__GFP_IO, file first since clean pagecache is more likely to
 	 *    exist than clean swapcache.
 	 */
-	if (!swappiness)
+	if (swappiness <= MIN_SWAPPINESS + 1)
 		type = LRU_GEN_FILE;
 	else if (min_seq[LRU_GEN_ANON] < min_seq[LRU_GEN_FILE])
 		type = LRU_GEN_ANON;
 	else if (swappiness == 1)
 		type = LRU_GEN_FILE;
-	else if (swappiness == MAX_SWAPPINESS)
+	if (swappiness >= MAX_SWAPPINESS)
 		type = LRU_GEN_ANON;
 	else if (!(sc->gfp_mask & __GFP_IO))
 		type = LRU_GEN_FILE;
@@ -5447,7 +5447,7 @@ static int run_cmd(char cmd, int memcg_i
 
 	if (swappiness < MIN_SWAPPINESS)
 		swappiness = get_swappiness(lruvec, sc);
-	else if (swappiness > MAX_SWAPPINESS)
+	else if (swappiness > MAX_SWAPPINESS + 1)
 		goto done;
 
 	switch (cmd) {
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch
mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch
mm-mglru-fix-pte-mapped-large-folios.patch

