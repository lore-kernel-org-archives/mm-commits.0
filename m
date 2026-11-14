Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694267;
	b=a75ybwBOJWoO6fVbMBzwOEeF7KfeaaeYs/1PBpR4/tZpJA6AlYhE10AxLXOSjklg3SRo
	 uIZnUmBL9T+dWDikuvLaQHlfOL86cn3iMSVHcQVvQF32XMGG8LKZfwUo/D5CpRW1Zfsbj
	 s54AuZDlnXTfYp8+b7ziFYiGOYVLrIXpKLC+n12y2dTppwlFllpC9j6uFxvHC2wne2rzp
	 VUX8C65WXhmj12qcRBfm/zduVyUF7JxWRQwzRPwqFrEJzvK+6H/ma0bbfG7vQsiTJyRtG
	 gHNjUhJ/RN4ROE0vDm94OV9opPqaj6OxaQrKY96hPTTalCB251mt8U3yGcc83erBqIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694267;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KvTLQ8j2sYRiajLX0atCTD0gJBk1Ontox/fRAfiQszw=;
	b=fJKkr4mXWnwlVfqupWfEN+z8ltgVOwS3FwfX4AKHT6obCluqe+nYeje3K2OfIYwQHL43
	 TZidWj2pKogRHpUHX92+sYZ0bMiNk8+ZrNeoAzBCffSBpLWZLni/qW1ljCKaHKT0LWQBe
	 mtJz2eJBll3vQyIp4ZJUl2jWB5UeRnT+uIyyvblG59LGz1myPr2co/3+XXfX790X1N/6/
	 qSida6AqkI1GyZgOu1lyF9J97ZhmSMK+VuRgRNlLb9llLKk3o9lzMVy30aglgCf6wcuFs
	 7CUIghdeD1/G61QvaqDZanmiNq7nxIunmtti/Ed8m7rpudlUurpEj3coWEVrM5mlOWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ykOMkOGf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F70C606A331
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ykOMkOGf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA591F000C4;
	Sat, 14 Nov 2026 22:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694266;
	bh=KvTLQ8j2sYRiajLX0atCTD0gJBk1Ontox/fRAfiQszw=;
	h=Date:To:From:Subject;
	b=ykOMkOGfk4kJVI4ujRMeneae9DHHJSXoKEU+/7DosgtvC6EoaNW6EHrEvdIq4ssLc
	 wFh6wSU7taztI5AKUAdUx9+PZ1Gh9btYjKWJ4iU0pYqjYuCZlCEpHtSq2LSu73+oFh
	 1DnLY+axm5BKlyg6FZOvHSMTDAvVXocO3Byslguk=
Date: Sat, 14 Nov 2026 14:11:06 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch added to mm-new branch
Message-Id: <20261114221106.CDA591F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: Make swappiness=1 file reclaim more aggressive
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
Subject: mm/mglru: Make swappiness=1 file reclaim more aggressive
Date: Sun, 15 Nov 2026 04:08:02 +0800

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1
favors file reclaim. Swappiness=0 allows only file reclaim, while
swappiness=201 allows only anon reclaim. Thus, swappiness=1 and
swappiness=200 are counterparts for file and anon reclaim,
respectively.

Before this patchset, get_type_to_scan() always returned
LRU_GEN_ANON for swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim
priorities. Similarly, for swappiness=1, anon_factor is set to 0
at higher reclaim priorities. This makes the two settings behave
similarly, although the thresholds differ slightly based on
testing.

This allows file pages to be reclaimed more aggressively and
benefits workloads that prioritize file reclaim by using
swappiness=1.

Link: https://lore.kernel.org/20261114200803.23129-16-baohua@kernel.org
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

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-make-swappiness=1-file-reclaim-more-aggressive
+++ a/mm/vmscan.c
@@ -4958,7 +4958,11 @@ static void lru_gen_balance_scan(struct
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= AGING_PRIORITY ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < AGING_PRIORITY ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch
mm-mglru-run-aging-when-one-type-is-drained.patch
mm-mglru-run-aging-when-one-type-is-drained-fix.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

