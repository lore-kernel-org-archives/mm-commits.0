Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C9E21518D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188209; cv=none; b=OvF4nNoprhr9MftloWxvtm56ISi7fueyqyYHw/v9dW8YeHK7pJJWTPShl5VKS1eI0xKwCGkD7KJx/YeSwrZ3H4A1QulcZDw6jTRrubOSqsrKcYvJq+9u4ec5cWWR7usCv8kpdQh4EdT4u2C6o+WW2/4r8aUO6EjpsJ8maTmljJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188209; c=relaxed/simple;
	bh=OeNtQ/Nd6OGyWvnrtFQEJ2eWfFWtJRStVZsCuU/5QPY=;
	h=Date:To:From:Subject:Message-Id; b=e3C2sMarnSTIIHGbNTMcyHNeCOiRBmhPoQ/+iKm3vDQd2Z5BRpUu7fHX/0r39++4AODMBfGQzG6nhuF+T3JLSQ9uoIRV2oySSdqzNDMatXc7iWLdCXK2WH70tuLwcGhMx6LK1AHkfhnA1xZHRVaBAzIQ0SR4I8JQIYIxozi/dIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKW1s2x9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKW1s2x9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D4AC4CEEF;
	Mon, 17 Mar 2025 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188209;
	bh=OeNtQ/Nd6OGyWvnrtFQEJ2eWfFWtJRStVZsCuU/5QPY=;
	h=Date:To:From:Subject:From;
	b=RKW1s2x9goUufHQWpsQhXp5NMoh1k3JCpvNoKS1VqJ+PvBwmS1aDlQREptD3/9/QX
	 UeTSwVtZesa/4wyhl8S1kGCznYnVtu6EG4hYTV+4GPBKaQkScjxGALpGeMLzED2PWS
	 8METtksQ9CYtkBlOXguOoYKh03CrJzMDrB3tTJzs=
Date: Sun, 16 Mar 2025 22:10:08 -0700
To: mm-commits@vger.kernel.org,zhanghao1@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch removed from -mm tree
Message-Id: <20250317051009.47D4AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: extract calculated pressure balance as a function
has been removed from the -mm tree.  Its filename was
     mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Zhang <zhanghao1@kylinos.cn>
Subject: mm/vmscan: extract calculated pressure balance as a function
Date: Wed, 15 Jan 2025 09:58:29 +0800

Extract pressure balance calculation into a function.This doesn't change
current behaviour.

[akpm@linux-foundation.org: 80-col wrapping]
Link: https://lkml.kernel.org/r/tencent_735DB36A2306C08B8568049E4C0B99716C07@qq.com
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   68 +++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-extract-calculated-pressure-balance-as-a-function
+++ a/mm/vmscan.c
@@ -2400,6 +2400,43 @@ static void prepare_scan_control(pg_data
 	}
 }
 
+static inline void calculate_pressure_balance(struct scan_control *sc,
+			int swappiness, u64 *fraction, u64 *denominator)
+{
+	unsigned long anon_cost, file_cost, total_cost;
+	unsigned long ap, fp;
+
+	/*
+	 * Calculate the pressure balance between anon and file pages.
+	 *
+	 * The amount of pressure we put on each LRU is inversely
+	 * proportional to the cost of reclaiming each list, as
+	 * determined by the share of pages that are refaulting, times
+	 * the relative IO cost of bringing back a swapped out
+	 * anonymous page vs reloading a filesystem page (swappiness).
+	 *
+	 * Although we limit that influence to ensure no list gets
+	 * left behind completely: at least a third of the pressure is
+	 * applied, before swappiness.
+	 *
+	 * With swappiness at 100, anon and file have equal IO cost.
+	 */
+	total_cost = sc->anon_cost + sc->file_cost;
+	anon_cost = total_cost + sc->anon_cost;
+	file_cost = total_cost + sc->file_cost;
+	total_cost = anon_cost + file_cost;
+
+	ap = swappiness * (total_cost + 1);
+	ap /= anon_cost + 1;
+
+	fp = (MAX_SWAPPINESS - swappiness) * (total_cost + 1);
+	fp /= file_cost + 1;
+
+	fraction[WORKINGSET_ANON] = ap;
+	fraction[WORKINGSET_FILE] = fp;
+	*denominator = ap + fp;
+}
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.
@@ -2412,12 +2449,10 @@ static void get_scan_count(struct lruvec
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	unsigned long anon_cost, file_cost, total_cost;
 	int swappiness = sc_swappiness(sc, memcg);
 	u64 fraction[ANON_AND_FILE];
 	u64 denominator = 0;	/* gcc */
 	enum scan_balance scan_balance;
-	unsigned long ap, fp;
 	enum lru_list lru;
 
 	/* If we have no swap space, do not bother scanning anon folios. */
@@ -2466,35 +2501,8 @@ static void get_scan_count(struct lruvec
 	}
 
 	scan_balance = SCAN_FRACT;
-	/*
-	 * Calculate the pressure balance between anon and file pages.
-	 *
-	 * The amount of pressure we put on each LRU is inversely
-	 * proportional to the cost of reclaiming each list, as
-	 * determined by the share of pages that are refaulting, times
-	 * the relative IO cost of bringing back a swapped out
-	 * anonymous page vs reloading a filesystem page (swappiness).
-	 *
-	 * Although we limit that influence to ensure no list gets
-	 * left behind completely: at least a third of the pressure is
-	 * applied, before swappiness.
-	 *
-	 * With swappiness at 100, anon and file have equal IO cost.
-	 */
-	total_cost = sc->anon_cost + sc->file_cost;
-	anon_cost = total_cost + sc->anon_cost;
-	file_cost = total_cost + sc->file_cost;
-	total_cost = anon_cost + file_cost;
-
-	ap = swappiness * (total_cost + 1);
-	ap /= anon_cost + 1;
-
-	fp = (MAX_SWAPPINESS - swappiness) * (total_cost + 1);
-	fp /= file_cost + 1;
+	calculate_pressure_balance(sc, swappiness, fraction, &denominator);
 
-	fraction[0] = ap;
-	fraction[1] = fp;
-	denominator = ap + fp;
 out:
 	for_each_evictable_lru(lru) {
 		bool file = is_file_lru(lru);
_

Patches currently in -mm which might be from zhanghao1@kylinos.cn are


