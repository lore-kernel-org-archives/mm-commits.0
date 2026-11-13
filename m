Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600358;
	b=0DG5msoce1oV7inrkTJEgp50kcvX9ZfgqEm+WrivixuMHtP7e0X4M6A6iwBL4f0GhVA9
	 G7w3YlO7EkgPT4Hd6BN1HIKaPoQ4qIeSLRENmK2SRwP4VSWECmmkHjLXLWvKqgHbEB+WR
	 Fp5h+DakJrktw+cYHKQDRs14wjmkqapTa272C4s08W7+SQlTAO5VT0FbEMkYZdXgRqBr1
	 t5bruyKwSrMnXbV8P+Xon5uI0msSMyzJ191+4Be0hErLpA0/UhSqDkjAU9bnjBJQTHhkZ
	 5jiiAEszxjBGBtX8znfHVznpbxiUjQN87YYKrvdldVWlMzMgu1Iy+CQODNJgm+ROOXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600358;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=L6KHFQTZLEASylfXBeJ8lH8DORdi9H2fwbd9RMfi7nY=;
	b=fk9BD9lilDmB+waeF+hMSefqvOZ+IVRUkFYNNpCAHyvqkq7+bw5uDETi7YVAOlun4uIA
	 l39bNrgUmNz+9gUk6YBkmunU7eTK3YZ677MJCuS+6IdAi8EjFbZoFgAEzMrwlcnyPicLY
	 Tn47QOOrkDHiSDxhpKYp63//qzBA+i+F/kFZM2t8EC0nT+7axxV5J4IgWEhbVW+cDbsiz
	 HEjyA4XXppph0tiQL7ThsXBQWAfvuKMOlNHrdgvUbTWFaq2o0UHHc0W3MslX/42x8umlH
	 SOfcR8YKKQQzI11lwzj4N10YE6GfPS0Rc+P55O6XBVjvWgYKELgFFg7JHPhNkFrOGVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gb8eFB4f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F665606A333
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 20:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gb8eFB4f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B301F000C4;
	Fri, 13 Nov 2026 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794600358;
	bh=L6KHFQTZLEASylfXBeJ8lH8DORdi9H2fwbd9RMfi7nY=;
	h=Date:To:From:Subject;
	b=gb8eFB4fAJ4LQrM3wMyUxb1gCWQgw/3thPAibZgMbK/6mshdKGuEoCuE0gEcqRqoQ
	 S2sqQ6QdgzZTnZMxmG9BzPWxYVwIn7LbuFT3JVW981f/6Q4z3i4Bi5it30aVzqJfrR
	 YPtVv3ai1gq9WyA6yHXu8Kc3m/OXEeVaFW9SCpFo=
Date: Fri, 13 Nov 2026 12:05:57 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch added to mm-new branch
Message-Id: <20261113200558.16B301F000C4@smtp.kernel.org>
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
Date: Sat, 14 Nov 2026 02:55:40 +0800

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1 favors
file reclaim.  Swappiness=0 allows only file reclaim, while swappiness=201
allows only anon reclaim.  Thus, swappiness=1 and swappiness=200 are
counterparts for file and anon reclaim, respectively.

Before this patchset, get_type_to_scan() always returned LRU_GEN_ANON for
swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim priorities. 
Similarly, for swappiness=1, anon_factor is set to 0 at higher reclaim
priorities.  This makes the two settings behave similarly, although the
thresholds differ slightly based on testing.

This allows file pages to be reclaimed more aggressively and benefits
workloads that prioritize file reclaim by using swappiness=1.

Link: https://lore.kernel.org/20261113185541.70203-16-baohua@kernel.org
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
---

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-make-swappiness=1-file-reclaim-more-aggressive
+++ a/mm/vmscan.c
@@ -4956,7 +4956,11 @@ static void lru_gen_balance_scan(struct
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

