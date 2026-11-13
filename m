Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598885;
	b=es50oqKy5QccVKC1Eknm5N5EKpXqxrXa7we9f1LL5n60VMti1jpv6day6/eU7fhn0589
	 mv5y/UXgyCCYF+0I9+zpEhaewGgrmXEXvn8b6aSm6rruDyFoiqZltZcODbn2x5vJQf+Wo
	 fxgADBkJKopUq2s2cmkInFlf6hDqzz3mFJA8pQPrGA+/DYAkaNtjL4SK5alusnSHFHtT3
	 QjKoMnrBKRFDIe+r8keqrv2hXh2fSHfnISjZGMp07t+YyY/1NuaNDL2LmCFghAcyPYgY8
	 9ZykjrCTLJpupBtoeUUvEnpamGLu8ua6r75eYyuDHHVzxBkUkVUMR7tFNrOlLUSB0KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598885;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xDRfyv/hUJ2j/fmedKir9AFpRQX8Y2bIf17PIJuXdkA=;
	b=EpF5tDaVSUuFprrrv65ncY7abAe5NoJirsfagqDQ/u+45dW4NCoiKF9CEbD0I9GQ90jh
	 Q2mLfX6w2Udy1wun5GZY5fwG+7XSGSnxdlTliTQrx+sE/wkvyOVQ7WnUJAuIz4wRIGTt0
	 qDTxYd0YRts0lFgPFXb3fvMA9nrAMoWwSh0IuS85GJo6XRQU5sMlsY4S+D/nQwCQ//v1W
	 AjZYRvYbCMY4spXH5kbPLmkoOn648gar2fo7f35vUehUujNsvgu2aQaSGMVSvmC7hoW54
	 3A+eqeaAyPYbvdZE8jLvJpmFdYP2SaT7Ld+FJHPxdKpFe8Ol8leq5GW+6T7eOKn17sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xKskLvKd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3406E606A32D
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xKskLvKd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6311F000C4;
	Fri, 13 Nov 2026 19:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598884;
	bh=xDRfyv/hUJ2j/fmedKir9AFpRQX8Y2bIf17PIJuXdkA=;
	h=Date:To:From:Subject;
	b=xKskLvKdoCuF3HsfoQVy2TerRmNkhG+Y8AWcBiksltTmsCRhxzxWwiFDjpAY65NpO
	 B7QEChKJjNk0sRthhUq+a/fpQDJQAxz4S/QG9B8i5T/5itFk5sQThNWLStmFlLZbbP
	 t7nRzFSfWe5qSYtKtRqsh0s0v6xsWgVc2uicP+B0=
Date: Fri, 13 Nov 2026 11:41:24 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch removed from -mm tree
Message-Id: <20261113194124.CE6311F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: make swappiness=1 file reclaim more aggressive
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

This patch was dropped because an updated version will be issued

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

