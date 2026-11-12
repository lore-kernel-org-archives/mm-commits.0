Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446240;
	b=g6HdixJ65r85hvQQBRDPSXot3+fHXjUYbDFCdqfnPUbXaDybg3xUR1XAOIY92033eLMN
	 J7YRz3wMW+0A6+xfdRpoybL+c7jz1EyQ7kPVA8f0iO2JE/SnTRit766iHRED7mJHwgmzY
	 NIdCBisXDF+IpC24gOT0oFyHsKMV/1TW/P7GZoA/XPtZT6KHqy2XUtmIsmaPwQag0nJT6
	 W1bE4TMc4ouAs065ibAmTJn60wo8kgDvS0izPTBMugxPgsiFwRgXocKifxG8EnpyY2TS6
	 +LmHvyZhqAyOAzil2NwKeHjSASa6CUyRkfKZPAuv9lcaYtSBzqYMtLr2wuV6img3wCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446240;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1qN9zxYNFiTcfIR5ZDeWMYfTwEIDOUY3/F5oGovd3VI=;
	b=LCDm2POJ3+Xofg+Tx3v5WKG+1tgvMDhkmHsxbcvdrOfh2h6TAsoGbawzqb6keVfb6vDL
	 Q9s2fUO7EgCUJpzsKBPeyBDB6pDGj7Dgn75zsqB6WCdPCtt4ieHW+Pj7v6NBIScqY14Wi
	 M8uYS79YGhdXste0j/ryCf47QdTnbVN3u6kMjAQ6rVn+Uv/2aaT1oEsws19vv7xQ/YkVO
	 evCmjfy0EiNRlQqPLvJyU9qptoHsAgxrC2vAoJ0xr65D9GKOGHGKElvZspNuT5R1gbHNv
	 XfNCMDU3E1px2uJCP9qR567bCUsSzVkNVKjXTOpvQlJDAW0VpekkLYryprCA9PGFOuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dg9ZLO92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B5E606A33D
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 01:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dg9ZLO92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DF91F00A05;
	Thu, 12 Nov 2026 01:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794446240;
	bh=1qN9zxYNFiTcfIR5ZDeWMYfTwEIDOUY3/F5oGovd3VI=;
	h=Date:To:From:Subject;
	b=dg9ZLO92rUvPSKlaoCO1UPIi2UGfoZVnIVCyZ7IxjhQ1KyKtIWobuvdodmJECU/Gf
	 I3ec+ihQ3k5yyUhCHJgIDUNsHZ4iNX3fB8KkEBcNZp9QXMvKm0IzdE3q5Od4n0kkPA
	 2dxMZvsaDwc9Zs7J3bjxwJRia2/GP8rslGUCyrhc=
Date: Wed, 11 Nov 2026 17:17:20 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,mhocko@suse.com,
	lyugaofei@xiaomi.com,liuxiang.277@bytedance.com,lianux.mm@gmail.com,
	liam@infradead.org,kunwu.chan@gmail.com,kasong@tencent.com,hui.zhu@linux.dev,
	hannes@cmpxchg.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch added to mm-new branch
Message-Id: <20261112011720.58DF91F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: run aging when one type has no populatable folios
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch

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
mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch
mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

