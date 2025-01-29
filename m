Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A41F1552E3
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 04:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738124154; cv=none; b=SZ6qL8KWEEXzjdaybeR8kQCM9SyD355iRDX5cy09TLoZalZJuVG9Wzmp2q7y1ShzpcV0VbJYHZRQyobxDZEqDOIJtVdXr6HX9kN01miHEGguno4O290Ag5yK9v5FCn5ZUsK7rQfUnUAGYCMWPiWaDHlmlYFmHk9gGWHnJrAIPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738124154; c=relaxed/simple;
	bh=PUHZhR0sFJVKFypN7d8kuxBuQc9HEIscm6lyswpFasY=;
	h=Date:To:From:Subject:Message-Id; b=gpNUOiaq8C7erzUsLdVmp+telKSB3tCuccMX7nGzFbR0iIgU4wExrMl4Edn/uWmqMul4ra0bgS7KJGAEFn0j2zl7d37Y/QLb++AulMQOFLH0nMOJwPlVVQpotQsmY0cxMQQcC0lLJLD1lT2kjNBFDO1bGHeZiy7sI3n8XMtyiZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L1ypazKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L1ypazKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE128C4CED3;
	Wed, 29 Jan 2025 04:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738124152;
	bh=PUHZhR0sFJVKFypN7d8kuxBuQc9HEIscm6lyswpFasY=;
	h=Date:To:From:Subject:From;
	b=L1ypazKDtMNtfMxyE+cPo5wcIL41xvhOwbEgjTtTj0xg73WvGpXsfg0/EonXOtDrT
	 4BkqDVwAYdmVFOb/ei9yACOVEXZvsDMgA3qooIH7rcPnJIFT4sACweT+qoyEeJlQgx
	 ziJt9YdijHxLbC+8+SuEdBBcnAetrqGbpC16ph8U=
Date: Tue, 28 Jan 2025 20:15:52 -0800
To: mm-commits@vger.kernel.org,zhanghao1@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch added to mm-unstable branch
Message-Id: <20250129041552.AE128C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: extract calculated pressure balance as a function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch

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
From: Hao Zhang <zhanghao1@kylinos.cn>
Subject: mm/vmscan: extract calculated pressure balance as a function
Date: Wed, 15 Jan 2025 09:58:29 +0800

Extract pressure balance calculation into a function.This doesn't change
current behaviour.

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
 
+static inline void calculate_pressure_balance(struct scan_control *sc, int swappiness,
+			u64 *fraction, u64 *denominator)
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

mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch

