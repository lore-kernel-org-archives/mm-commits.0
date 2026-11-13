Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598880;
	b=gEPfgmpJGahd+ztcjfvQeHe/c9FKdtDtT+kkTNeoXp4Wq/cCJuvg9qoVoJ0h0Uu/MuJ5
	 LI22AS3h3PRd6DhWeJXfDyCjk6ZzD5E1F1OcXfLWvXk3xiktyEYJVweh73wkCo9R0eJ48
	 lWsmAXTG1VK24F5XFFK4Diy6CJVbHKDf8Db1ertIyMw5i+ljUsAG8T7hEQdPnsPoXU6HP
	 KPzB/awDecAPrDrBFrsnSXTnkzwbOYH6xyZlKEnvBYs8ZjZuzcZAtGsJrE/fAuVmMfqd2
	 ZlibVtVtP0H9irSn5JVNNXetK3OZopx9HASfiUZ4082cIkV08b6My3/nNKpjz22FKBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598880;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PCqM273okY3C7pJ3QkaaqQuC4atwmjhJqYQXWe26hGc=;
	b=wQPF2zeK7QhLdcuUkM1PUH9qFJI9FqPjc+Q8jrMznIwZQFnjGj8fqqzzoCYO6jG1KRWU
	 /vqLxyADd9i16pm7uewYnyScCEzdpudgOfu69SfEtGe5onJZboeGWLPRWL1E9FNBp67tl
	 aig5JHrS8ScRVYLo9BGd4mOayqAtwkzhRk5E2yJl/Qf5BrNhVsfuh5Nbc0edhhT8zk0CU
	 NLz4jvyD8t8uoXlKwTTcS7fzvl0u/qQY+m0BF26XRo1Wpay0Oz7zmZJheXOVZttyok4gO
	 RwXw+BuqVv5QU10CxznE01KviXao3ewWI4zWZ/hYQTASAXYI5hnFuy1+ZiCLBHmtaTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jkhs+x6Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73571606A32D
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jkhs+x6Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352F71F000C4;
	Fri, 13 Nov 2026 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598880;
	bh=PCqM273okY3C7pJ3QkaaqQuC4atwmjhJqYQXWe26hGc=;
	h=Date:To:From:Subject;
	b=Jkhs+x6Q8x5FAJP7+tkcND4MbCGAmlrEovOtJ0GF35qYK8srQ2PJPwhtVtw7RHfvx
	 NTy0K209rTVQKIgpvm7ni+Ub1zEExFQSQkQ5VRNqy2PDPlpX7D4S1B/QCJ9N8yMFbj
	 UCca0DbM6stXeRcL+7gxxEFOp2VQTDCtsuNyWbg8=
Date: Fri, 13 Nov 2026 11:41:19 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch removed from -mm tree
Message-Id: <20261113194120.352F71F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: run aging when one type has no populatable folios
has been removed from the -mm tree.  Its filename was
     mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: run aging when one type has no populatable folios
Date: Thu, 12 Nov 2026 07:25:58 +0800

We may have scan budget remaining for anon or file
but no folios in populatable generations to scan.
In this case, `scan_folios()` may waste time scanning
that type while the other type still has populatable
folios.

Run aging in this case to make more folios
populatable. This also helps respect the scan budget
distribution determined by swappiness.

Link: https://lore.kernel.org/20261111232603.9934-12-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@suse.com>
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
---

 mm/vmscan.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-one-type-has-no-populatable-folios
+++ a/mm/vmscan.c
@@ -5111,7 +5111,8 @@ static bool lru_gen_imbalanced(struct lr
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, int swappiness)
+			     struct scan_control *sc, int swappiness,
+			     bool no_populatable)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -5123,6 +5124,13 @@ static bool should_run_aging(struct lruv
 	if (sc->priority == DEF_PRIORITY)
 		return false;
 
+	/*
+	 * Run aging if scan budget remains but no folios
+	 * in populatable generations are available to scan.
+	 */
+	if (no_populatable)
+		return true;
+
 	/* better to run aging even though eviction is still possible */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
 		return true;
@@ -5227,20 +5235,17 @@ static bool try_to_shrink_lruvec(struct
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
+		unsigned long orig_file, orig_anon;
 		DEFINE_MAX_SEQ(lruvec);
+		bool no_populatable;
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
 			need_rotate = true;
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
-			trace_mm_mglru_aging(lruvec, sc, swappiness);
-			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
-				need_rotate = true;
-			should_age = true;
-		}
-
+		orig_anon = nr[LRU_GEN_ANON];
+		orig_file = nr[LRU_GEN_FILE];
 		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
 			break;
 
@@ -5254,6 +5259,15 @@ static bool try_to_shrink_lruvec(struct
 		if (root_reclaim(sc) && should_age)
 			break;
 
+		no_populatable = (nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
+				 (nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file);
+		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			should_age = true;
+		}
+
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

