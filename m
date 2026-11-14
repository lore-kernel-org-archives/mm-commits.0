Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693544;
	b=cwkJCnDlQ0btxiDvbsg/r3KYQEI483m07BgdsRT1s82a0cZr+0fmStCl1AJpHHJWyake
	 SM0Hwu9o7FjUIJBHGm6tLZLiDDbLMYsMx8iQQ+9y/5ify6zYoKxDAEwWIDrQ4dD+eFin6
	 8eWk8J/M73cJrdp4/7AsmeBVlqFqMy5hoFmbi6/34N3wEvcSp6DPZTIfNNRxPlCXfSO7M
	 7W9n3iZWCS0CpuATvY/dXyPHqips81ct8aI8plU4Yh2gNe114fKm6MEk8CB5l16jCf6j/
	 QjeQjD3unO1UM7C8zmVioB/wKE+QIcrH8mK5OdDWnLavza0EsoibS2kYsHxcTSaG5iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693544;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NQ/4aKLJpsGdnJW7yki1N5slGMs9Hm086N/fsBOIXF4=;
	b=Z83mSeDT01ModCdfuUvyGI0M7k/TA3kqkcawjX9ifq3dP3pmqVMKCE5qyRBTAteyPl9S
	 8pZzxJUoQYrlT3l3mjUP3I+KHfY+8JWDqnw/HVAdVOsm/VESVIIjrXfXZKmvao5IZUqPG
	 yBZSCuG8ejzj17egpmIQIfe6BWuu+mtkf1LV2B89sA+xou8i5KaMmn/1DUiww0ZEJv4aZ
	 SHaGdO9ee6fPWCyvjWokyylpsaWsdpLnZDE92OEWFmz5Q+qYy+xEHhCEuce2q1lXeLIEX
	 lArBrKn9lLimX5O6TJDa6hcEZSHyufgEv1mT+4dO7ahSpPvopJNw1Zte8rsAnQDJEpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QPDWUCOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23705606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QPDWUCOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37651F000C4;
	Sat, 14 Nov 2026 21:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693543;
	bh=NQ/4aKLJpsGdnJW7yki1N5slGMs9Hm086N/fsBOIXF4=;
	h=Date:To:From:Subject;
	b=QPDWUCOsmz1iVd9HNoZg0rSrhXmyxsB4nP3dkCrWMwHdaraqdPoMC249weAAEsdas
	 44Pgy4sXMBAPGGyjcOV5E6VDPaf4fWi0GbaTaoE76E9Fy68zsAUo/IblMcFGwh7tYw
	 Dce6rexUOHBJ7+6gg12F1iIegSjqZxuWnABH8YN4=
Date: Sat, 14 Nov 2026 13:59:03 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-report-evictable-sizes-per-type.patch removed from -mm tree
Message-Id: <20261114215903.B37651F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: report evictable sizes per type
has been removed from the -mm tree.  Its filename was
     mm-mglru-report-evictable-sizes-per-type.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: report evictable sizes per type
Date: Sat, 14 Nov 2026 02:55:26 +0800

Patch series "mm: mglru: fix swappiness behavior", v8.

Classic LRU respects swappiness, while MGLRU only weakly honors it when
selecting the scan type.  The fallback logic can easily override the bias
established by get_type_to_scan().  As a result, swappiness has a much
smaller overall impact when changing from 1 to 200, as shown by the data
presented later in this cover letter.

In this patchset, patches 1-8 from Kairui introduce a model that uses
refaults to determine nr_to_scan[] for both file and anon in MGLRU.  For
each reclaim operation, we calculate how many file and anon folios to
scan, similar to CLRU, rather than relying on get_type_to_scan() and
fallback mechanisms to decide what to reclaim, which have proven rather
unreliable in honoring swappiness.  This model also allows scanning and
reclaiming from the two youngest generations, including the youngest
generation itself.  This can help resolve OOM situations[1] and reduce the
need for aging.

As Kairui mentioned, the OOM reproducer was demonstrated previously [2],
and that series was merged in v7 [3].  The problem was largely alleviated
as described, but not completely fixed.  Under higher memory pressure, the
system could still hit OOM.  Before this series, Kairui could still
reproduce OOM after hundreds of iterations.  With the fixing patch in this
series applied, the problem no longer occurs.

Patch 9 from Barry fixes a cold/hot inversion exacerbated by patches
1–8 (which also exists in mainline) and improves reclaim efficiency.

Patches 10-15 from Gaofei and Barry optimize aging based on folio
distribution imbalance and improve reclaim behavior at extreme
swappiness values such as 1 and 200.

Patch 16 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.

After the patchset, the results track CLRU across the full swappiness
range (see table below), with more file scanning at low swappiness
and more anon scanning at high swappiness.

pgsteal_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            6,620,680     745,968       6,190,575
36           807,807       508,974       525,304
71           553,144       417,700       405,545
106          402,880       402,474       348,365
141          240,293       337,797       305,170
176          187,682       330,045       231,038
200          0             343,949       256

pgsteal_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            4,436,199     2,671,934     5,103,813
36           2,858,117     3,032,747     3,134,511
71           3,042,392     2,827,735     3,170,171
106          3,292,622     3,184,314     3,225,293
141          3,612,869     2,999,000     3,590,478
176          3,827,154     3,134,127     3,873,163
200          13,825,283    3,269,753     14,399,074

pgscan_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            11,853,625    877,311       12,715,103
36           1,016,826     582,783       612,867
71           662,823       474,772       443,149
106          496,374       451,285       364,203
141          277,109       382,604       327,444
176          206,261       372,059       236,838
200          0             393,608       256

pgscan_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            20,804,386    5,847,747     7,142,640
36           17,830,330    6,740,075     6,297,912
71           18,357,293    6,126,194     7,046,149
106          19,938,920    6,431,355     7,876,121
141          19,609,579    5,997,762     9,672,762
176          21,612,749    6,071,032     11,195,357
200          44,776,474    6,544,125     30,225,030

refault_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            6,523,070     667,302       6,103,539
36           722,110       431,585       448,161
71           477,062       340,241       331,108
106          327,610       324,747       272,266
141          161,827       265,959       228,015
176          115,551       258,515       172,882
200          0             268,049       212

refault_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            867,728       552,829       1,415,594
36           419,635       657,745       668,238
71           536,299       611,345       672,096
106          580,742       693,689       728,319
141          706,151       639,850       817,954
176          706,499       685,086       949,643
200          4,693,850     733,273       5,475,622

With a normal swappiness setting (without extreme bias), I see almost no
noticeable performance difference between the two versions.

For example, with `swappiness=60`, the average results
over 5 rounds are:

metric          W/o patch     W/ patch
real            1m49.273s     1m49.051s
user            25m33.186s    25m31.778s
sys             3m41.851s     3m40.721s


This patch (of 16):

Change lruvec_evictable_size() to return the number of evictable anonymous
and file pages separately instead of a single total, so that callers can
weigh the two types independently.

Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the
summed totals are unchanged, so there is no functional change.

Link: https://lore.kernel.org/20261113185541.70203-1-baohua@kernel.org
Link: https://lore.kernel.org/20261113185541.70203-2-baohua@kernel.org
Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [1]
Link: https://lore.kernel.org/all/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/ [2]
Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/ [3]
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
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
---

 mm/vmscan.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-mglru-report-evictable-sizes-per-type
+++ a/mm/vmscan.c
@@ -4193,28 +4193,31 @@ static void set_initial_priority(struct
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
+static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
+				  unsigned long nr[])
 {
 	int type;
-	unsigned long seq, total = 0;
+	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
+	nr[LRU_GEN_ANON] = 0;
+	nr[LRU_GEN_FILE] = 0;
+
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			total += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq);
 	}
-
-	return total;
 }
 
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
-	unsigned long total;
+	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	total = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
 	return total >> sc->priority;
@@ -5028,7 +5031,7 @@ static bool should_run_aging(struct lruv
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
-	unsigned long nr_to_scan, evictable;
+	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	/*
@@ -5044,7 +5047,8 @@ static long get_nr_to_scan(struct lruvec
 			return 0;
 	}
 
-	evictable = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
 	nr_to_scan >>= sc->priority;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

