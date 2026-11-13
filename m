Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598869;
	b=atl203em4HVaOcgqDWxfJ3Qd4ECwp4OT9Gu+Q6HtRIRCvFdzVTj9D6exgtUZX/0uQMkS
	 KkkoAZE5Bv7fpJHt2qXCCrzsfjTvmTz5E6C5j8aRMkpLOBBxKNzcD6GSp2709NcClmE37
	 6qA1IicbVTNI2YZKa0wb7kPX2CbfnLj1iQ+5JuZEOixSGf425DAUAlhQyu0ZxClqH2uqW
	 2XbT2ZJI7Mp88fLQkd6bruDjh46kXKfoSkoOCQfQA4rkhDXjjufgAg7cB50CifqydV3XO
	 12e1lAwT2n04a8jrKg8tIkcI7hUWoRcU7yE5QgAGQZeMfhvGlcCaU8tFZ5dMaqnJ98Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598869;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5fH8xs3JRbiVpNhR8IZcWnvEzjt1WZiUvIJeNsVg3TY=;
	b=0Nyift00uZmRBb82kZNVoXz7HaNPTF9DPviKdfIrcYNyrtaRPvqZj20+yyjbVJWID2L7
	 v2YsyQAHgwASkm7WHOmp4CAdB8e1r2KCP4MVn2tR6i3i7ccjtAX0tNQOuBsUzAoKR5Ycj
	 0FuqZCRhz4AVfAxABTMsnkXQTlGVSec/rOIRNxGIbHSzJD4b/tx651MQ70pcfR7jyRLW6
	 5lHqaYpuTOpX364PnNn37gxL6/2rY6nEw9kv8TZymsVHTEqGBCjFG4REDwzq0KoID4FDL
	 7/tAwY9ciHQdkuFxwLK3Kca3iW5dLxHQ5w1cB+uZ2OpJ5foCTOQ7Al9eld3HioaEgCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=U2H0rX13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22883606A332
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=U2H0rX13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0C61F000C5;
	Fri, 13 Nov 2026 19:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598868;
	bh=5fH8xs3JRbiVpNhR8IZcWnvEzjt1WZiUvIJeNsVg3TY=;
	h=Date:To:From:Subject;
	b=U2H0rX136Q7P5cscwLFMUHFM8CiTo8tajR5aU5sWF/normRJdwq91IAS/lIS9cwYh
	 ymkhcBOOPuCvlh/DzCevltooLwpulQdbkaVFI7lypHAQMYJCIGnMlH6Q/euqdsybaX
	 OTFyfhxqXyZ97NVfuE0U8eUDBgZ9uvrSm4iD37M0=
Date: Fri, 13 Nov 2026 11:41:08 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-report-evictable-sizes-per-type.patch removed from -mm tree
Message-Id: <20261113194108.9E0C61F000C5@smtp.kernel.org>
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
Date: Thu, 12 Nov 2026 07:25:48 +0800

Patch series "mm: mglru: fix swappiness behavior", v7.

Classic LRU respects swappiness, while MGLRU only weakly
honors it when selecting the scan type. The fallback logic
can easily override the bias established by
get_type_to_scan(). As a result, swappiness has a much
smaller overall impact when changing from 1 to 200, as
shown by the data presented later in this cover letter.

In this patchset, patches 1-8 from Kairui introduce a model that uses
refaults to determine nr_to_scan[] for both file and anon in MGLRU.
For each reclaim operation, we calculate how many file and anon
folios to scan, similar to CLRU, rather than relying on
get_type_to_scan() and fallback mechanisms to decide what to
reclaim, which have proven rather unreliable in honoring swappiness.
This model also allows scanning and reclaiming from the two youngest
generations, including the youngest generation itself. This can help
resolve OOM situations[1] and reduce the need for aging.

As Kairui mentioned, the OOM reproducer was demonstrated
previously [2], and that series was merged in v7 [3].
The problem was largely alleviated as described, but not
completely fixed. Under higher memory pressure, the system
could still hit OOM. Before this series, Kairui could still
reproduce OOM after hundreds of iterations. With the fixing
patch in this series applied, the problem no longer occurs.

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
1            6,620,680     745,968       6,249,276
36           807,807       508,974       569,354
71           553,144       417,700       419,718
106          402,880       402,474       329,145
141          240,293       337,797       296,131
176          187,682       330,045       260,850
200          0             343,949       128

pgsteal_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            4,436,199     2,671,934     4,960,289
36           2,858,117     3,032,747     3,066,513
71           3,042,392     2,827,735     3,258,388
106          3,292,622     3,184,314     3,217,699
141          3,612,869     2,999,000     3,417,135
176          3,827,154     3,134,127     3,720,778
200          13,825,283    3,269,753     14,551,425

pgscan_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            11,853,625    877,311       13,703,243
36           1,016,826     582,783       680,534
71           662,823       474,772       467,822
106          496,374       451,285       356,494
141          277,109       382,604       307,866
176          206,261       372,059       268,584
200          0             393,608       128

pgscan_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            20,804,386    5,847,747     6,766,764
36           17,830,330    6,740,075     5,870,434
71           18,357,293    6,126,194     7,333,437
106          19,938,920    6,431,355     7,702,863
141          19,609,579    5,997,762     8,915,973
176          21,612,749    6,071,032     10,590,224
200          44,776,474    6,544,125     30,318,894

refault_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            6,523,070     667,302       6,171,580
36           722,110       431,585       492,267
71           477,062       340,241       342,626
106          327,610       324,747       262,786
141          161,827       265,959       224,831
176          115,551       258,515       184,601
200          0             268,049       88

refault_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            867,728       552,829       1,382,052
36           419,635       657,745       675,629
71           536,299       611,345       706,445
106          580,742       693,689       718,644
141          706,151       639,850       785,236
176          706,499       685,086       906,427
200          4,693,850     733,273       5,489,076

With a normal swappiness setting (without extreme bias), I
see almost no noticeable performance difference between
the two versions.

For example, with `swappiness=60`, the average results
over 5 rounds are:
metric          W/o patch     W/ patch
real            1m49.273s     1m48.876s
user            25m33.186s    25m31.449s
sys             3m41.851s     3m39.935s


This patch (of 16):

Change lruvec_evictable_size() to return the number of evictable
anonymous and file pages separately instead of a single total, so
that callers can weigh the two types independently.

Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the
summed totals are unchanged, so there is no functional change.

Link: https://lore.kernel.org/20261111232603.9934-1-baohua@kernel.org
Link: https://lore.kernel.org/20261111232603.9934-2-baohua@kernel.org
Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [1]
Link: https://lore.kernel.org/all/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/ [2]
Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/ [3]
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
Cc: Michal Hocko <mhocko@suse.com>
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

