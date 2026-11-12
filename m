Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446243;
	b=BdnDR+Ntd2pdCA9LRfo7pfj+dzecQ1NQ7kYtzsYMUw2ffGXNi6yiKHCAIYac6vyaAn94
	 bMuHyLDKwwNtfGKSRHsr5/UICOJV/hk+bzOqC0V74n5QzaTNqbIxBE6Xs+jP+rcz3GXZX
	 TYr8ppj5biwCTTmMzY4WBEilSbaa07ofpyXNRVRflb2E27oUfJOQIXK0h/lPdKAjTY3qj
	 xvFiTtJpqse9IrM0ZNM3LgwHwt6R/D1/W6/mkRDjWy9BPwPP3VtXvKy8QSdLQEy8E5hzw
	 m+byRQw+Comy++SWoqvAFH1UG7PiytexSQMFv56NtRbJLI7TVJqElnJD9h2ELmFnmdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446243;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Uf5VMJ8miQpSyfCnPGKFNY+DIy/ZOZLYwDhMEMj76kk=;
	b=FU9nw8Gm8rV7DxxPqsq9cmZlzTWpT4fbAxh1jIK1kenuFq+HSALFCH1m9tLfMb1fIP+r
	 z+9kk1IGGsdr9iQBrJd1rBVLtZ9k4OYNHDmSM9RCermrkgtoQt9Jxw0vb8tpGmHXbHz2k
	 YzaiLbmPyE2/qJQWfrOrb2kM+VfRGQcd4TvV9zKPZErDTSeuktcOxupCi31WoaHikzryt
	 dpi+l/TZEd8WoW36qooNiNfB6jPpPBjS/l8xIahTBrIkS8YgsBTzI9i6w5gIUSJ7r+lnV
	 8cups22LB/UQneqrTiKDVF96LeXKKHvamDA/Rv6Fzxz/7QSq1O0unp/z3N2EVT7cf4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sWjqjAH6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FCD606A31C
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 01:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sWjqjAH6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF411F00A09;
	Thu, 12 Nov 2026 01:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794446243;
	bh=Uf5VMJ8miQpSyfCnPGKFNY+DIy/ZOZLYwDhMEMj76kk=;
	h=Date:To:From:Subject;
	b=sWjqjAH68ly51A0fBSBg/9c+bwMHQyyxFnj3Baeqwa9CTxlx9iG3agUlHKwzx+SUD
	 si0VTrvTuQmDR4vaBMbOs5aIb/c8XP3cxOGNz020oqSyj8zw1c0jQklWNz4pFjVL7b
	 go5WViwHrGmLgPKj9gcGZfuVopo9J8b10PHY5RY8=
Date: Wed, 11 Nov 2026 17:17:22 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,mhocko@suse.com,
	lyugaofei@xiaomi.com,liuxiang.277@bytedance.com,lianux.mm@gmail.com,
	liam@infradead.org,kunwu.chan@gmail.com,kasong@tencent.com,hui.zhu@linux.dev,
	hannes@cmpxchg.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch added to mm-new branch
Message-Id: <20261112011723.0AF411F00A09@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: reduce LRU lock contention by shrinking folio batches in inc_min_seq
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch

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
Subject: mm/mglru: reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Thu, 12 Nov 2026 07:26:00 +0800

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch. This shortens the time the
lruvec lock is held, allowing concurrent LRU operations to make
progress and significantly reducing LRU lock contention.

Link: https://lore.kernel.org/20261111232603.9934-14-baohua@kernel.org
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

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq
+++ a/mm/vmscan.c
@@ -3912,7 +3912,7 @@ static inline void flush_lru_batch(struc
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
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

