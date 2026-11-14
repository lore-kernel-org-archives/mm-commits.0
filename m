Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694252;
	b=IuNHvIANQqUA2zCPmM+UjCq0CVqDG+ym7gu7ihUsweXrOnrlr3xzXvEPqUB1g2lcgRME
	 CzdeP/gU5UFU32p4Nj/nw30/a14ceohPpTJuNUqb9iCf2lH8oyPFy2t61ykg/QKQ/hUJS
	 uTYswyYDN3zFQo5qKTmhfOvmrK7GtT96N0OcE4aOWkBTXpdUvZcS1t6bTXv0I8XJMRxFY
	 ApSpVO2fSHSBxiKNNyi5JMLFa8TvZw4Ah8HLQd9Hope+Lj4nXzO9pbUUBd1Im2Cd+I5A3
	 +xicagQeU2/Ga6nfDlZukqCQI3IhaGU1SP9Zal9TKc+VfNoy3TrG0U52fTW/N+EG4KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694252;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CEEqzLkJdwjwFftgTP87mBtd8CeWh/uuWiuFAnnXs9E=;
	b=hi/f814xxQ+CgDPMJE7YoyTcdD81P9E5etQoQ3d4+nL8epD/1IrTrCJGVqyZzfXAl0PG
	 edH4QZR+RnMmmCIIJvQy6ujwmTPvOkHw1nixa1b8lXK39cFcCrmYv8wGkjtIjSySrlgR9
	 0TYVOPDIRPmEDrTdzF0AsEWJXmyshX0YKZU1bUv4q0MnQ28iD2iTSyQfFtNKztZij7Q6J
	 SBjM7GvYRd+wrMMC7Ds6mrJIisIQ5wbJ9tbPDDcZhh1QCNxAu1WlQUB7lTNz0nF2ogQyD
	 24l/G9atll35T5L4r+hP1Cbkq1YA3gfcmGPzo7hFV47dn7bE92LD8Y8J9ACXw3umFvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Po4aqlVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F861606A329
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Po4aqlVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3A71F000C5;
	Sat, 14 Nov 2026 22:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694252;
	bh=CEEqzLkJdwjwFftgTP87mBtd8CeWh/uuWiuFAnnXs9E=;
	h=Date:To:From:Subject;
	b=Po4aqlVmg5w0xn4X1av3/FJ+JywHMQ7JlMbwONhrT+SApzMQ/m8I9m/90E47RBWYd
	 0Ze9rjlv8Wn7Dk0ToSbNu5nmkWgtHKarTFIdm/EfMZzLKRrYTTtSGdaZmUSSpondPh
	 a89YE/ExQqf0/XbxmDuT+NqxNbt7RuOyabByWFAA=
Date: Sat, 14 Nov 2026 14:10:52 -0800
To: mm-commits@vger.kernel.org,lyugaofei@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch added to mm-new branch
Message-Id: <20261114221052.6A3A71F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: Run aging when pages are rare outside the youngest gen
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch

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
From: Gaofei Lyu <lyugaofei@xiaomi.com>
Subject: mm/mglru: Run aging when pages are rare outside the youngest gen
Date: Sun, 15 Nov 2026 04:07:57 +0800

Run aging when the total number of pages outside the youngest
generation across both types falls below 1/MAX_NR_GENS of the number
of pages in the youngest generation. For extreme swappiness values
such as 1 and 200, also consider the balance of the corresponding
type.

This improves reclaim efficiency, especially at extreme swappiness
values, while reducing system time.

To avoid the overhead of aging, we only allow imbalance-based aging
when the reclaim priority is low enough that we might reclaim the
youngest generation.

Link: https://lore.kernel.org/20261114200803.23129-11-baohua@kernel.org
Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Bo Zhang <zhangbo0325@gmail.com>

 mm/vmscan.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen
+++ a/mm/vmscan.c
@@ -2743,6 +2743,8 @@ static bool should_clear_pmd_young(void)
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
 
+#define AGING_PRIORITY	(DEF_PRIORITY / 2)
+
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -4780,7 +4782,7 @@ static int scan_folios(unsigned long nr_
 	 */
 	if (sc->priority == DEF_PRIORITY)
 		seq = lrugen->max_seq - MIN_NR_GENS;
-	else if (sc->priority > DEF_PRIORITY / 2)
+	else if (sc->priority > AGING_PRIORITY)
 		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
@@ -5073,6 +5075,40 @@ retry:
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness)
+{
+	unsigned long youngest[ANON_AND_FILE] = {0}, old[ANON_AND_FILE] = {0};
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+	int type;
+
+	if (sc->priority > AGING_PRIORITY)
+		return false;
+
+	/*
+	 * Round up or down corner swappiness, to balance the heavy biased
+	 * type better
+	 */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		swappiness = MIN_SWAPPINESS;
+	else if (swappiness == MAX_SWAPPINESS)
+		swappiness = MAX_SWAPPINESS + 1;
+
+	for_each_evictable_type(type, swappiness) {
+		unsigned long seq;
+
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		for (seq = min_seq[type]; seq < max_seq; seq++)
+			old[type] += lruvec_gen_size(lrugen, type, seq);
+	}
+
+	/* the vast majority of pages sit in the youngest gen */
+	return youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	       (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
@@ -5087,7 +5123,11 @@ static bool should_run_aging(struct lruv
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* run aging when folios outside the youngest gen are rare */
+	return lru_gen_imbalanced(lruvec, sc, swappiness);
 }
 
 static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
_

Patches currently in -mm which might be from lyugaofei@xiaomi.com are

mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch
mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch

