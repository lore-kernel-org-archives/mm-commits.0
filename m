Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694243;
	b=4YSzTcMMZ7jA5zIcHYeYM6zdBzlLG5WZFDkQ97zsUNHic8OEDMFOsXF70m7/3mswiiaT
	 TcnGH+fU3KxH6PoKOq4xWYVfkLXxygg9jJF1dZ8ad8nEKiumoACnAevF2wj23ABJpqKHH
	 jnWDmX7K5JYaICgESe0iNoU8Y3A5MFdE1jFr85OlVbxm8K3V41NlrNM9ojRobmmyJARrN
	 05+p4wV9ZanNDkVcA8dk827hxon00jUzoF7hXzcsQP7uY4Gfd0zSpQCtC5VjpiqrwpxLm
	 1GOmZfxkRByGTBJU8SH23P+1scrgij0l2wH+hjb24JQktR5XEhutNFJOYVECc/olNnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694243;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=XtnQFpK9ECg9X5/1N30dQHKEAx4koNSrXpraLaTClP0=;
	b=oyGZBH766rxJfoXf2S6ql5J2AbZnZ3+li479tiz15Q0CMNFALW3VG32lSxn7CIaI6SCt
	 2F7sIL9kTmRxQSgn+mrOgiA5TeGdb2Bv0yoHQbfApz6f5dzQVbfpA8+GoHz3rDnD9ZyYX
	 hQX17Cixp0vYpNS0HOeJZA/RMVIwdKr4gAoq7UDq0A1ski8FwHBbG8OjlAgllu+mspCFi
	 +HUM3QuWukpCVgMHmZqM97M/b5KGvt630Ku+yy2HUJp6z6utOJkRHZ9ZiLi+6UpiTPZT0
	 /AYLu/M3KvgQLt/X6jlM4iUHZF0ZO8tXP+av0Cxjf+sLdJtI8wulOGifBRyS/bZIHXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fJ1jNeGq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615A7606A327
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fJ1jNeGq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72171F000C4;
	Sat, 14 Nov 2026 22:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694243;
	bh=XtnQFpK9ECg9X5/1N30dQHKEAx4koNSrXpraLaTClP0=;
	h=Date:To:From:Subject;
	b=fJ1jNeGqgrDd64xZT2BmqnK5Q4Wl5fVHkvx4JVbMU7s6AvcVgVfgMHbwuvoAbJ4XG
	 rX36vJEUVDlng7IdJsj/qcbBWk6+blIKY5cF2YWBRchLUplJjUcIN7tbDR+HekM2u5
	 ICyIYU9XaWjmVux62vuInbvBzWtOhxUHMEAAS/g8=
Date: Sat, 14 Nov 2026 14:10:42 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch added to mm-new branch
Message-Id: <20261114221042.E72171F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: return for unavailable anon reclaim earlier
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: return for unavailable anon reclaim earlier
Date: Sun, 15 Nov 2026 04:07:53 +0800

No feature change, just shuffle some code, prepare for later commits.

Link: https://lore.kernel.org/20261114200803.23129-7-baohua@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Bo Zhang <zhangbo0325@gmail.com>

 mm/vmscan.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/vmscan.c~mm-mglru-return-for-unavailable-anon-reclaim-earlier
+++ a/mm/vmscan.c
@@ -5060,20 +5060,6 @@ static long get_nr_to_scan(struct lruvec
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-	/*
-	 * Proactive reclaim initiated by userspace for anonymous memory only.
-	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
-	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
-	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
-	 * work when there is nothing eligible to reclaim.
-	 */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
-			return 0;
-	}
 
 	lruvec_evictable_size(lruvec, swappiness, sizes);
 	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
@@ -5126,6 +5112,19 @@ static bool try_to_shrink_lruvec(struct
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
+			return false;
+	}
+
 	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
 	while (nr_to_scan > 0) {
 		int delta;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

