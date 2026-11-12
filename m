Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446246;
	b=NnSVwkAvGmjuZJcQK8YapX2ftrGO59/845YHGrfo83EOpXyNfaY+b4J4ZI6CSJfAssU8
	 uSBUFzhK5+UMeCdFNU5D0Dt+JZKhuU1UH8N0aUd2MtUev3iU8Jkh7NJjqnYLwPqlNkTON
	 uSNrc0yf07yU9g9rk6UEfFhLXh99N/iadefu/mLyLZPVz9qXb30O+Yo6gU2Tu7DRphtRi
	 dihS1qBqpxpmoV9qtOs1MyfFAU6fcog89eyRoeYsDnqc6lml3/3/6rNp7CO7aOAYEIwUY
	 hKAVVYb6aRPDYt5qRiMTCT/CH/eVJavtKGPrZVfEh41dcdn7856jc5PoT50LhT80FBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446246;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=m7iQzAlSN//C0HZtnV3esWyRzXZHqX6hanAychI8utI=;
	b=HN57duEaoxHzPxANLSMJdlywXN3jV5YyqRhBRci11vsmFgmTg6RMGFbPMxETMzb+ssuO
	 i+gMuV8A/qNMsvFRRh4KcKkk4wlYayezcx8BVyyyCGuEXY6UcqEoDdfjyXFEUHuoWDRYk
	 1PA3Y1epT2Xxb2dkDrCT8HkjDvr9OfuhXFjSp6wl6aD4JzIschB81th6uQyFXu5EAjrdq
	 XYmrnBPtTDw0xcvY2A9Wq/cmPzhxL5RGrgWcwPQzfFunnbnD23iTDbzq2fH4ph6Vajrcn
	 KHNf/aTBkggPYaUFaJBDZM2N0W1OWmboHpM4Q9JIMGS4ojuuPk+0ItQHd3SD5vQUOzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ojR05ZNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29311606A327
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 01:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ojR05ZNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917851F00A05;
	Thu, 12 Nov 2026 01:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794446245;
	bh=m7iQzAlSN//C0HZtnV3esWyRzXZHqX6hanAychI8utI=;
	h=Date:To:From:Subject;
	b=ojR05ZNg7hTwRoM7MYgUIcHam3YwDzQce1VCrF14nL6dvjkfwDqeMWLbWh4EsnYmQ
	 8lanANiK0p67sDw8WYWgaCKDM3c3h//vK8jR9kg/b2iGguzA9Rf9uCeHK0PSVqPYyx
	 72DR0kSfjbkr8uVsVqX7UTVfcPcoQhqTdPmykAB4=
Date: Wed, 11 Nov 2026 17:17:25 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,mhocko@suse.com,
	lyugaofei@xiaomi.com,liuxiang.277@bytedance.com,lianux.mm@gmail.com,
	liam@infradead.org,kunwu.chan@gmail.com,kasong@tencent.com,hui.zhu@linux.dev,
	hannes@cmpxchg.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch added to mm-new branch
Message-Id: <20261112011725.917851F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: make swappiness=1 file reclaim more aggressive
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

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
Subject: mm/mglru: make swappiness=1 file reclaim more aggressive
Date: Thu, 12 Nov 2026 07:26:02 +0800

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1
favors file reclaim. Swappiness=0 allows only file reclaim, while
swappiness=201 allows only anon reclaim. Thus, swappiness=1 and
swappiness=200 are counterparts for file and anon reclaim,
respectively.

Before this patchset, get_type_to_scan() always returned
LRU_GEN_ANON for swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim
priorities. Similarly, anon_factor is set to 0 for swappiness=1
at higher reclaim priorities, making the two settings behave
similarly, although the thresholds are slightly different.

This allows file pages to be reclaimed more aggressively and
benefits workloads that prioritize file reclaim by using
swappiness=1.

Link: https://lore.kernel.org/20261111232603.9934-16-baohua@kernel.org
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

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-make-swappiness=1-file-reclaim-more-aggressive
+++ a/mm/vmscan.c
@@ -4952,7 +4952,11 @@ static void lru_gen_balance_scan(struct
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < DEF_PRIORITY / 2 ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
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

