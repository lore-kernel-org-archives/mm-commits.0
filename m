Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600346;
	b=e+oWoXFG3IeAJPHwUlOdMdiR0WYsMiI9vszGdybzxp3rvIVWXCLu4FjUOF8LnhuSNLJ9
	 ngteQb8X44Oa+CbStrPFpVD+Yn11b0F7Io95EFT5wYePsjFT1nd4GGJB5tDi+IYjCSFN5
	 MHVmLwXjf+/JZvz/kx1OdemAk4qsSCRcLCscj98OW2o5LTkNrjzJUOruHXzZZtu16k+Ke
	 RlSRT/weZEqmI6EYoDQ7pau9xUUeDSUbRunopyST1Wr+FrCC8Yoj0yt/lARhzhAKfsJwH
	 9JgII9QUpOm3keRpabvu6XKCYOPa9yVOzP/t4ACqTuGadd7MknZ6ksvAw5K8zGX09og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600346;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3vSMQ0pvL1ODNLwiOBSdE96XjWCyxBkjHT10PfQc0CY=;
	b=iiyMLrgalCsCqUafUOsgbJNyN5fswq+hoBWdqDellHysFY1xuaq/KxRZtArikffgp+tW
	 OFKUs4ti1svsovx1aThCRsxcO5oEtoDH1AK+Bx3s8MmKP3cRiDcgH7mH1GjmGMwFjh1+o
	 Xuhomxmfc1LB7nLR6mn5kyGs9/4W0+7OLyxFe/7VN3V6dVtPbOaQf2NiTQ47Rw8tPBQpO
	 9W+/eS1ZbI56TxsUXZPbomIT8WpELrIN58PBQCJVgo7K6AwoO0LSrX45bXJVlkc/PCv+3
	 CbX8BeHL/48Wcy6y80Raq5N71JtZkIRvW8NDmt7IKHb0R18lW8A8ZbYYV69r2PUD1yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oWX6EKRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A70E606A32D
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 20:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oWX6EKRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E121F000C6;
	Fri, 13 Nov 2026 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794600345;
	bh=3vSMQ0pvL1ODNLwiOBSdE96XjWCyxBkjHT10PfQc0CY=;
	h=Date:To:From:Subject;
	b=oWX6EKRZLNuZT+0AORTNwzo8WwavbNgikQeTQ+nOMtm4lv8+XD6mj4EB/MIn6Fxgm
	 FMBigxKnlycLEf9aHBf0kiT8ia7tY9wKgZaehnbNW6+O6QxnqcoNTvZIo1sIqz7R52
	 EzXP9rew5QT7YMrRRlnelmkZm/jF93eT55xGDUR8=
Date: Fri, 13 Nov 2026 12:05:45 -0800
To: mm-commits@vger.kernel.org,lyugaofei@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch added to mm-new branch
Message-Id: <20261113200545.B5E121F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: run aging when pages are rare outside the youngest gen
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
Subject: mm/mglru: run aging when pages are rare outside the youngest gen
Date: Sat, 14 Nov 2026 02:55:35 +0800

Run aging when the total number of pages outside the youngest generation
across both types falls below 1/MAX_NR_GENS of the number of pages in the
youngest generation.  For extreme swappiness values such as 1 and 200,
also consider the balance of the corresponding type.

This improves reclaim efficiency, especially at extreme swappiness values,
while reducing system time.

To avoid the overhead of aging, we only allow imbalance-based aging when
the reclaim priority is low enough that we might reclaim the youngest
generation.

Link: https://lore.kernel.org/20261113185541.70203-11-baohua@kernel.org
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
---

 mm/vmscan.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen
+++ a/mm/vmscan.c
@@ -5073,6 +5073,41 @@ retry:
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
+	if (sc->priority > DEF_PRIORITY / 2)
+		return false;
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
+	if (youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	    (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS)
+		return true;
+
+	/* Swappiness extremes: the corresponding type matters */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		return youngest[LRU_GEN_FILE] > old[LRU_GEN_FILE] * MAX_NR_GENS;
+
+	if (swappiness == MAX_SWAPPINESS)
+		return youngest[LRU_GEN_ANON] > old[LRU_GEN_ANON] * MAX_NR_GENS;
+
+	return false;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
@@ -5087,7 +5122,11 @@ static bool should_run_aging(struct lruv
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

