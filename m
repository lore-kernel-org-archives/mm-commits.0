Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832549;
	b=pRzBgZshSSzXvQnlymSh8HwuXmbdQTmpovhquD3Bby5zTs3E0UfEaMCbYv98gly1mBsM
	 W/2dgQU4l6xKv4EfQIZoYn9NUGuAMSrFnxSf7C8C+Ogy/tO/Ljd+cOZROi9WD1aM02BNb
	 z8R/joJZi7Xl3MW0IMfGTqyM7vpOlVAsCYN6JY6JY+OrqgxmuOFhEMlKZqO6KO7z91evH
	 u2nMdSW7zpU286Hki+3flc+GIEIVli5R0EjFIyfljdGjPZO5SzjkyHuljXLxplZKNS5c4
	 aAzWCcI2Fp/a8VgSrtIcZRmfDO8EMZ8tH5k+BKPE9ZchMqAEB3FFl/EgR3/4UEIH6/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832549;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=sWz2nDFUmKXTZmGcYHOnNJ1G2kATAILCMR9ej/9hQ50=;
	b=TyPWrY8CpkEyTrGfjrElqWCq7YAlxNiW5/gbR2up88y9gRJ1+ON1wggztOqgWU6D+pUK
	 D8S9U96aWBTedBbfK0EJVp9ZCdm8c1fz+d+fN0KVotKOsXp4Zl8xPYqGTxIQ1v/Eaijgj
	 zViGIqUQYrXAdv39vCQPgdnguze2Vh7KHjfI0Rrl+Yy6crhbV0KUmgWSe9IOy2a2Gw+PZ
	 oL5ToInhMvdO1jKZPE1sl1fZXlRyuZgoypf14Ocf2GRnX9BjbgNmap2kKXKqTywimbGM1
	 qfHdr1mFJjguZP0t9uM5WluqYiCRm0VHooIfCWcxX3LFXkNPOf5flqKXplEVndiAl4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HfJmlLS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A20606A31A;
	Sat, 24 Oct 2026 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HfJmlLS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BA51F01828;
	Sat, 24 Oct 2026 09:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832549;
	bh=sWz2nDFUmKXTZmGcYHOnNJ1G2kATAILCMR9ej/9hQ50=;
	h=Date:To:From:Subject;
	b=HfJmlLS20xatDHEbpKu15feaytn/gl5JyadqFD3xBb1bLi/iEklZYMOWfQ65ifk0c
	 qCXjx6ow9ydbT1ix5XqP9vJvTjl+slCysjNRFwbMa0zdf4S9SCqgpVKll+POKujNBu
	 5dc5iSyuCqy52R0NgzzGv7CjAJDcKoqXZcqehh4k=
Date: Sat, 24 Oct 2026 02:02:28 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rlmenge@gmail.com,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hargar@linux.microsoft.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,apais@microsoft.com,sidchintamaneni@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-fix-null-lruvec-pgdat-deref-with-memcg-disabled-on-cmdline.patch removed from -mm tree
Message-Id: <20261024090229.50BA51F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cmdline
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-fix-null-lruvec-pgdat-deref-with-memcg-disabled-on-cmdline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cmdline
Date: Sat, 17 Oct 2026 05:09:27 +0000

When CONFIG_MEMCG=y, lruvec_pgdat() returns lruvec->pgdat, which for the
per-node pgdat->__lruvec is left NULL by lruvec_init() and only filled in
lazily by mem_cgroup_lruvec(). Normally that happens early, e.g. on the
first folio_add_lru().

With cgroup_disable=memory, lru_gen_shrink_node() passes &pgdat->__lruvec
directly to shrink_one(). If direct reclaim runs before anything has
called mem_cgroup_lruvec() for the node, which can happen during early
boot under memory pressure (e.g. a kdump kernel), get_swappiness() ends
up dereferencing a NULL pgdat:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
  pc : get_swappiness+0x68/0xb0
  lr : try_to_shrink_lruvec+0x54/0x2c0
  Call trace:
   get_swappiness+0x68/0xb0 (P)
   try_to_shrink_lruvec+0x54/0x2c0
   shrink_one+0x8c/0x240
   shrink_node+0xc6c/0xe08
   do_try_to_free_pages+0xdc/0x570
   try_to_free_pages+0x124/0x278
   __alloc_frozen_pages_noprof+0x6e8/0xf78
   alloc_pages_mpol+0xc4/0x1c0
   alloc_frozen_pages_noprof+0x54/0xe8
   alloc_pages_noprof+0x1c/0x40
   atomic_pool_expand+0x98/0x300
   __dma_atomic_pool_init+0x58/0xd8
   dma_atomic_pool_init+0x154/0x170
   do_one_initcall+0x64/0x350
   kernel_init_freeable+0x214/0x430
   kernel_init+0x2c/0x208
   ret_from_fork+0x10/0x20

The classic LRU path and MGLRU before per-node lru_gen_folio lists
obtained the lruvec through mem_cgroup_lruvec(), which sets
lruvec->pgdat.

The above was hit on an arm64 kdump kernel (6.18-based) booted with
cgroup_disable=memory nr_cpus=4. It also reproduces on mainline on an
arm64 VM with CONFIG_ARM64_64K_PAGES=y, CONFIG_MEMCG=y,
CONFIG_LRU_GEN_ENABLED=y and:

  mem=160M nr_cpus=4 coherent_pool=512M cgroup_disable=memory

These options only serve to force direct reclaim early in boot; with
160M the boot eventually ends in OOM regardless. On mainline the first
LRU reclaim happens while unpacking the initramfs, and faults the same
way:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
  pc : get_swappiness+0xd4/0x150
  Call trace:
   get_swappiness+0xd4/0x150 (P)
   try_to_shrink_lruvec+0x44/0x2b8
   shrink_one+0x80/0x1a0
   shrink_node+0xd98/0xea8
   do_try_to_free_pages+0xf4/0x4b0
   try_to_free_pages+0x110/0x360
   __alloc_frozen_pages_noprof+0x8b0/0x1718
   ...
   __filemap_get_folio_mpol+0x2ac/0x548
   simple_write_begin+0x44/0xf8
   page_symlink+0x178/0x198
   ...
   do_populate_rootfs+0x13c/0x200

Link: https://lore.kernel.org/20261017050928.128582-1-sidchintamaneni@gmail.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <apais@microsoft.com>
Cc: <rlmenge@gmail.com>
Cc: <stable@vger.kernel.org> # 6.3+
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-fix-null-lruvec-pgdat-deref-with-memcg-disabled-on-cmdline
+++ a/mm/vmscan.c
@@ -5454,7 +5454,7 @@ static void lru_gen_shrink_node(struct p
 		sc->nr_reclaimed = 0;
 
 	if (mem_cgroup_disabled())
-		shrink_one(&pgdat->__lruvec, sc);
+		shrink_one(mem_cgroup_lruvec(NULL, pgdat), sc);
 	else
 		shrink_many(pgdat, sc);
 
_

Patches currently in -mm which might be from sidchintamaneni@gmail.com are


