Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B631EDA1E
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119237; cv=none; b=DuFF35/+04nKV6YpReL1LKayH0D7WUsqtD5O6S8zn+ngHFGegNqz2KO9OzgS/LPRGBvand+IhumObbcQO3h8KE9ogPdjmBCxHBHOg9YhAAKjotWDN3liFuhzQYcyUsB7IJacXhD3wcSIO+FyPjchEmn+OUWWiF0BDbo2GplisTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119237; c=relaxed/simple;
	bh=ozJQSmNPaAGlVgE4mmXH+KepoF8Ds1c7+1soI72OUHU=;
	h=Date:To:From:Subject:Message-Id; b=SAOvlXuqJeXPhRK12ZUwHJ6sNIhyKtsw14UfUuuaC1HHeWCDHsYn8eL7jepWN8rO8o5UBmf1vnwChdudt1mi7iV4/isDRdphwa/R16n3KVXFjt0Hje3BjMM1Mg3Pn5UivNzVuItVB/eq+3Z9isCztzOUmc/QfzFE+crJiU0d8s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CJ85ZPu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CJ85ZPu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CAEC4CEE4;
	Tue, 13 May 2025 06:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119237;
	bh=ozJQSmNPaAGlVgE4mmXH+KepoF8Ds1c7+1soI72OUHU=;
	h=Date:To:From:Subject:From;
	b=CJ85ZPu5H62EUzIQroG06pjMKlM2ANe2cfDFjx5XTMzCbm/SXrAGZmZOvDOoANtUV
	 7JR4j1G0GTtlSjXS757TNyXcMznds1ig3HyygkhIo5+0mQKysnt4F7B2EPSItPFAg4
	 PtG+co1fUnHNxXY64WaxQvNyryBWWxNYzRM/M4U0=
Date: Mon, 12 May 2025 23:53:57 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-using-swappiness_anon_only-in-mglru.patch removed from -mm tree
Message-Id: <20250513065357.A7CAEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use SWAPPINESS_ANON_ONLY in MGLRU
has been removed from the -mm tree.  Its filename was
     mm-using-swappiness_anon_only-in-mglru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2705,8 +2705,12 @@ static bool should_clear_pmd_young(void)
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
@@ -2714,7 +2718,7 @@ static bool should_clear_pmd_young(void)
 			for ((zone) = 0; (zone) < MAX_NR_ZONES; (zone)++)
 
 #define for_each_evictable_type(type, swappiness)			\
-	for ((type) = !(swappiness); (type) <= ((swappiness) <= MAX_SWAPPINESS); (type)++)
+	for ((type) = min_type(swappiness); (type) <= max_type(swappiness); (type)++)
 
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
@@ -3865,7 +3869,12 @@ static bool inc_min_seq(struct lruvec *l
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
@@ -5531,7 +5540,7 @@ static int run_cmd(char cmd, int memcg_i
 
 	if (swappiness < MIN_SWAPPINESS)
 		swappiness = get_swappiness(lruvec, sc);
-	else if (swappiness > MAX_SWAPPINESS + 1)
+	else if (swappiness > SWAPPINESS_ANON_ONLY)
 		goto done;
 
 	switch (cmd) {
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch

