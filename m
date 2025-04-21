Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E53D1EF0BE
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 18:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745261673; cv=none; b=D0zVLLLAK0W+GxZF2gQwZvT8vbZkwAbeteU/jc/2dlFFu9QZWE0rfkrVCSHdKb/qiEchfkwfZVPkib0g36HwdkkuR/Y3eu2ZUGXneG7L2cXwM0bXhiKh5qXPjb7gPrV05je4o8OkdfJ23i9mXu670Vuompyd6WOf3msjpKm8BLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745261673; c=relaxed/simple;
	bh=HbzOYOesWiKQAb5QdO804EUMet67Nm+OIyLebF+FF6g=;
	h=Date:To:From:Subject:Message-Id; b=bIXNVxcK8ys8ZAEU0OpYtq2vDn1u9j7uyHyuIJLdZSjSTNe3aWG9AU4dc1rp9bDMBNqfH0ULbYWWymaMAPNlUexMfCsYbwwTc9eiFo3xdYlXRJTpDF1XOIV0b/Gf0wowN3WeufbLBCb5YqJkLb+qYQrKA2XhsTReKFuJjpMsXQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfYQ+ri0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfYQ+ri0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F42AC4CEE4;
	Mon, 21 Apr 2025 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745261673;
	bh=HbzOYOesWiKQAb5QdO804EUMet67Nm+OIyLebF+FF6g=;
	h=Date:To:From:Subject:From;
	b=rfYQ+ri0Urb7j+xxPOaxet7WUZwafpc0PHBwaK1XveVozaphe93IiyS5GxT8iI7nX
	 pTVF11Xe6W3ePX4Of9e/8SrZYE020gjr11C0lySrDi1JZ2fXUUALVugsncPfiXUW59
	 JOVqSWrCMX0VlmoOqs8T0ZXa5UquU2yBNnj6pqfE=
Date: Mon, 21 Apr 2025 11:54:32 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-using-swappiness_anon_only-in-mglru.patch added to mm-new branch
Message-Id: <20250421185433.4F42AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use SWAPPINESS_ANON_ONLY in MGLRU
has been added to the -mm mm-new branch.  Its filename is
     mm-using-swappiness_anon_only-in-mglru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-using-swappiness_anon_only-in-mglru.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: use SWAPPINESS_ANON_ONLY in MGLRU
Date: Mon, 21 Apr 2025 17:13:31 +0800

Using SWAPPINESS_ANON_ONLY instead of MAX_SWAPPINESS + 1 to indicate
reclaiming only from anonymous pages makes the code more readable and
explicit.

Add some comment in the SWAPPINESS_ANON_ONLY context.

Link: https://lkml.kernel.org/r/529db7ae6098ee712b81e4df290622e4e64ac50c.1745225696.git.hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-using-swappiness_anon_only-in-mglru
+++ a/mm/vmscan.c
@@ -2699,8 +2699,12 @@ static bool should_clear_pmd_young(void)
 		READ_ONCE((lruvec)->lrugen.min_seq[LRU_GEN_FILE]),	\
 	}
 
+/* Get the min/max evictable type based on swappiness */
+#define min_type(swappiness) (!(swappiness))
+#define max_type(swappiness) ((swappiness) < SWAPPINESS_ANON_ONLY)
+
 #define evictable_min_seq(min_seq, swappiness)				\
-	min((min_seq)[!(swappiness)], (min_seq)[(swappiness) <= MAX_SWAPPINESS])
+	min((min_seq)[min_type(swappiness)], (min_seq)[max_type(swappiness)])
 
 #define for_each_gen_type_zone(gen, type, zone)				\
 	for ((gen) = 0; (gen) < MAX_NR_GENS; (gen)++)			\
@@ -2708,7 +2712,7 @@ static bool should_clear_pmd_young(void)
 			for ((zone) = 0; (zone) < MAX_NR_ZONES; (zone)++)
 
 #define for_each_evictable_type(type, swappiness)			\
-	for ((type) = !(swappiness); (type) <= ((swappiness) <= MAX_SWAPPINESS); (type)++)
+	for ((type) = min_type(swappiness); (type) <= max_type(swappiness); (type)++)
 
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
@@ -3859,7 +3863,12 @@ static bool inc_min_seq(struct lruvec *l
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
-	if (type ? swappiness > MAX_SWAPPINESS : !swappiness)
+	/* For file type, skip the check if swappiness is anon only */
+	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
+		goto done;
+
+	/* For anon type, skip the check if swappiness is zero (file only) */
+	if (!type && !swappiness)
 		goto done;
 
 	/* prevent cold/hot inversion if the type is evictable */
@@ -5530,7 +5539,7 @@ static int run_cmd(char cmd, int memcg_i
 
 	if (swappiness < MIN_SWAPPINESS)
 		swappiness = get_swappiness(lruvec, sc);
-	else if (swappiness > MAX_SWAPPINESS + 1)
+	else if (swappiness > SWAPPINESS_ANON_ONLY)
 		goto done;
 
 	switch (cmd) {
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch
mm-vmscan-add-more-comments-about-cache_trim_mode.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-using-swappiness_anon_only-in-mglru.patch

