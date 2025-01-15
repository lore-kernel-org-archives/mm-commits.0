Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7B835949
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 04:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736913752; cv=none; b=gC1D4Fi6ABa27ki0TmDrMNMyc3bT7iuVzheHywNpe1jZpjuwd/0Wc8ZGj8iZg6TcPUV8xHAHaYJXLtOacTye7LH2fOE5vl9gQABePlWY5leStdq6p0aoVKtaXHOOTKnTRDFocuAxIK8NNgy4VwJJEd8oZoZ4dPGVDwEh2gr1WJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736913752; c=relaxed/simple;
	bh=Lud8MlyNL8UhHO44F5wkuVt3pvRHO8pWxSah4KARylE=;
	h=Date:To:From:Subject:Message-Id; b=RacE8I/WIpGUUw5hakogEQfL+4+JRbMvTYkAWyRQD2zp0ZDrnNL1sL7OW23ho62rTvCyesXOm/gY82j+4urhTkSsR2XITZVka+eMbAwrG2PFJIpb6c2lVpLpfjPGnM0BW69iQK9la/ttoWcXRVG6lOhW4j/ZSoF2a06pvLXGBrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tyOtzaZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tyOtzaZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E691C4CEDF;
	Wed, 15 Jan 2025 04:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736913751;
	bh=Lud8MlyNL8UhHO44F5wkuVt3pvRHO8pWxSah4KARylE=;
	h=Date:To:From:Subject:From;
	b=tyOtzaZfLnyDuN61+5Cag2gpEqniTSZn7Hc/KDvxlBDcKVoE/kqwgbv2FP+zZoZW1
	 dEsisKZuNakP2svXzRcP/ZYYx8/v3ZT7X0oPtxLL1oclK5NdUBo9YzbD9EefeXOkQP
	 Uhv+n7P5FgP2SxVY4nFSz3yAyH1aiqUkr0PPUoYU=
Date: Tue, 14 Jan 2025 20:02:30 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,ryncsn@gmail.com,kaleshsingh@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-rework-aging-feedback-fix.patch added to mm-unstable branch
Message-Id: <20250115040231.4E691C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mglru-rework-aging-feedback-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-rework-aging-feedback-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-rework-aging-feedback-fix.patch

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
@@ -5449,7 +5449,7 @@ static int run_cmd(char cmd, int memcg_i
 
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
mm-mglru-rework-aging-feedback-fix.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch
mm-mglru-fix-pte-mapped-large-folios.patch

