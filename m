Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694232;
	b=uis8kwR3dpdU2g2rsltLaneIAdpJqYTb25V7tRLw4CiGwEfEDTvwuudqSIWuIsQY62Mo
	 QaqQwjs6LS2kCGh0hKG2/Q4hrbCh+fDI2A/u2zR/jtNesg+Dk4jCgFZalGuDjiB9uOnq6
	 PN0okEhfjdEPpELrZvbiH3Awne49c1rDi2tj1k3abDKQJ3d5M7/45O6sDT3C6hYnBsrWF
	 lMHcVifw+StOEWSb4telfE2bu3K3y/ZDVBddrARqrSdlGj+NRCbqiaIC3P1m+BEovgOyZ
	 nSGNMeVBksFJd35kX8Z1/v8thV5KlWnIAR7CIF30KGxxSUhqo649nXeZPBb1o5AxpzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694232;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Uo8wuJjAxNgaOnEmlh1dlRzh9M5XgqIdAHw2bboFIP8=;
	b=zCAzPMGRAym47g7UfTZKlqNDh9doZ+upu8ort/JUHV8anyGsDRlI7W40SK6mlIQ3qAZ1
	 7xXA6vgtDtJrZ0FRwHB3yHWRu0Gf56Iv6DylAjsoajqD0fs3MNqH8fkn4NwAboW2ATzV6
	 GS05PLGl1x1yxj4oukyjn3mhdJgAVcioZ31+zCJ2UWFYQitkwJTud3PupItdndLv1FSB8
	 3XwGr5cnUFZnLJL3HVWOars0UAF4qZSEFG5iXyP+6MAgXR/nxSWtO8T/x59LI9EEwlMGy
	 L/oKZRjSprmlI+26ulyyMTSLjfVRTvTEk+kf4bVMVCNX2wS5+/16ulvyh9rkIpU5b4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kNQ3UOg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF9A606A32D
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kNQ3UOg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0632B1F000C4;
	Sat, 14 Nov 2026 22:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694232;
	bh=Uo8wuJjAxNgaOnEmlh1dlRzh9M5XgqIdAHw2bboFIP8=;
	h=Date:To:From:Subject;
	b=kNQ3UOg5KCxke5zcBH7GJZt+YtKxTu17GP2D4IPU8Aa7WJatnrs8b08XcdW01D7pK
	 n25Rk9Ioz5YOAipYt6ipsvhPkthnI194e6usJNnuvw78jClDnKf/7gM9h4hJAUQU6T
	 tCsKzGo5yl//5/I6IcxCnCtncbgCT2Myeoc5oIlU=
Date: Sat, 14 Nov 2026 14:10:31 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-report-evictable-sizes-per-type.patch added to mm-new branch
Message-Id: <20261114221032.0632B1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: report evictable sizes per type
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-report-evictable-sizes-per-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-report-evictable-sizes-per-type.patch

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
Subject: mm/mglru: report evictable sizes per type
Date: Sun, 15 Nov 2026 04:07:48 +0800

Patch series "mm: mglru: fix swappiness behavior", v9.

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

Patch 9 from Barry fixes a cold/hot inversion exacerbated by patches 1–8
(which also exists in mainline) and improves reclaim efficiency.

Patches 10-15 from Gaofei and Barry optimize aging based on folio
distribution imbalance and improve reclaim behavior at extreme swappiness
values such as 1 and 200.

Patch 16 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.

After the patchset, the results track CLRU across the full swappiness
range (see table below), with more file scanning at low swappiness and
more anon scanning at high swappiness.

pgsteal_file

swappiness   CLRU          MGLRU         MGLRU+patches
1            6,620,680     745,968       6,197,601
36           807,807       508,974       564,256
71           553,144       417,700       420,008
106          402,880       402,474       363,635
141          240,293       337,797       312,624
176          187,682       330,045       238,722
200          0             343,949       0


pgsteal_anon

swappiness   CLRU          MGLRU         MGLRU+patches
1            4,436,199     2,671,934     5,011,932
36           2,858,117     3,032,747     3,039,483
71           3,042,392     2,827,735     3,132,431
106          3,292,622     3,184,314     3,238,658
141          3,612,869     2,999,000     3,306,901
176          3,827,154     3,134,127     3,714,411
200          13,825,283    3,269,753     14,481,445


pgscan_file

swappiness   CLRU          MGLRU         MGLRU+patches
1            11,853,625    877,311       13,108,154
36           1,016,826     582,783       657,973
71           662,823       474,772       457,686
106          496,374       451,285       390,056
141          277,109       382,604       329,819
176          206,261       372,059       246,141
200          0             393,608       0


pgscan_anon

swappiness   CLRU          MGLRU         MGLRU+patches
1            20,804,386    5,847,747     6,936,021
36           17,830,330    6,740,075     5,975,744
71           18,357,293    6,126,194     6,797,243
106          19,938,920    6,431,355     7,602,990
141          19,609,579    5,997,762     8,540,965
176          21,612,749    6,071,032     10,532,510
200          44,776,474    6,544,125     30,296,434


refault_file

swappiness   CLRU          MGLRU         MGLRU+patches
1            6,523,070     667,302       6,118,731
36           722,110       431,585       486,604
71           477,062       340,241       342,746
106          327,610       324,747       286,465
141          161,827       265,959       233,860
176          115,551       258,515       171,174
200          0             268,049       0


refault_anon

swappiness   CLRU          MGLRU         MGLRU+patches
1            867,728       552,829       1,368,563
36           419,635       657,745       636,567
71           536,299       611,345       689,528
106          580,742       693,689       707,227
141          706,151       639,850       753,779
176          706,499       685,086       934,553
200          4,693,850     733,273       5,491,234

With a normal swappiness setting (without extreme bias), I see almost no
noticeable performance difference between the two versions.

For example, with `swappiness=60`, the average results
over 5 rounds are:

metric          W/o patch     W/ patch
real            1m49.273s     1m48.836s
user            25m33.186s    25m33.368s
sys             3m41.851s     3m38.388s


This patch (of 16):

Change lruvec_evictable_size() to return the number of evictable anonymous
and file pages separately instead of a single total, so that callers can
weigh the two types independently.

Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the summed
totals are unchanged, so there is no functional change.

Link: https://lore.kernel.org/20261114200803.23129-1-baohua@kernel.org
Link: https://lore.kernel.org/20261114200803.23129-2-baohua@kernel.org
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

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

