Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694262;
	b=VgnmWVOZE2VYLVUyg/zRzf/A00BKC7sR/RgkC2JhbbQglTy4tb0F3X7i89rf1MCHHq8h
	 wV3l4AVLPE97tkia0EnKfgja/DOxsSeMyWIMhQmVXDrwRgpLauSNScN7NUMLxTPuIMDbg
	 NmI55XhW2VkPAsj/TQgi9E4w/OhCDF7ElDCk3CatWhLs0/kIn6z5+x3h5VBV6+Kv4DIU/
	 HKwA+L0A/IngsxXXgiQHwW8RpRMC1mid4imw/zqAj3RCic3FG4Iiedrn19FNqiZPIRr7b
	 oA0AezTJizF9BEPX0osRD6iJXw4ANoWRrkZQ+golni3fpJWeiAbTKxYnXljh3IlTEfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694262;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6+8+kRcZXWqZcCOPMqyQRSpT9FY+drQ1MvcJU+1rjBE=;
	b=yFRvGJygno/jiEX0O4Tp6OnnyW4gdMXvvfICjBfa2Ro0MDj7m9AZmugZZx0iAsjIyjVw
	 6TWIsEyKZracnNp0a0bg+nbRBTmNNht2Hsjl2B7XLBH04tt0mORwfTQF9ZPlLx0kOVygN
	 i5LAAVqbJWqzH3gPbS4DjQr5Jtf1ZIBHakgtyJz88vvXIvHwzEANcNeYFpAITJ0xCZEp7
	 y/GC7skUarbkUC+t4WKYXy8YIlZdkVnxwtWoLG1uWogJuWuCERwuonL+6OPbH1pboVR0S
	 9nv7pUK0pQcg2eSJ/TN2TcKzYtUdYnij1RMSG90mR7I30HtnmJUS2kp7mLvd8qt4xqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cIruqY8t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2937606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cIruqY8t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDEC1F000C4;
	Sat, 14 Nov 2026 22:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694262;
	bh=6+8+kRcZXWqZcCOPMqyQRSpT9FY+drQ1MvcJU+1rjBE=;
	h=Date:To:From:Subject;
	b=cIruqY8tjXzFtjwH/ttqYJ070hXSohhJANP9gm4v84EIMwuBCxG8vPuYe3m5sCMW6
	 cvDy/FC33yeE0vcGh6IMxZ9gsA07dIWCi19aBFmMQKVa35nRdXTjGZ7Z7Vro7sILr2
	 sNLEl3ruERmWerDXMKqEdX5Jc3Eq8GD0qryBW2SM=
Date: Sat, 14 Nov 2026 14:11:02 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch added to mm-new branch
Message-Id: <20261114221102.6BDEC1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: Reduce LRU lock contention by shrinking folio batches in inc_min_seq
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
Subject: mm/mglru: Reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Sun, 15 Nov 2026 04:08:00 +0800

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch. This shortens the time the
lruvec lock is held, allowing concurrent LRU operations to make
progress and significantly reducing LRU lock contention.

Link: https://lore.kernel.org/20261114200803.23129-14-baohua@kernel.org
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

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq
+++ a/mm/vmscan.c
@@ -3914,7 +3914,7 @@ static inline void flush_lru_batch(struc
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
mm-mglru-run-aging-when-one-type-is-drained.patch
mm-mglru-run-aging-when-one-type-is-drained-fix.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

