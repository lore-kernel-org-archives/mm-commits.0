Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792621671;
	b=RKUVnBrghyNlsXZkQC8OVdPEM4ID8FLIhYowzoc7GTIIbqD88fLdhHZ/8zCGhvmSYgAO
	 YtVHIPgt+FdQcebZQUAxp9jNIFRoEDBy97MvJSLq0bbvZYgMlqk/ZFk7rMZfA6maeZWFn
	 8lt6cgGTLjaRABG+Ddy2Z2EbhhWeFfu7gWbwOGb2ykBJsfPla67UO2y2X/2pmKkW9RGYK
	 ApYpXNMiq7H0Yxif/GdsbdphNlJMjzGdOfgydx4u7wtjC4b8OtDB1jsS7bppXI1u+wYH7
	 Gi0GVVOM+qVGzSJzFZY842dpz7wL6/LQnZ0mDxRU1+Y0GxYTgQZeL7XsY6lZJPolzAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792621671;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ewa6IKEC08ki+BOOr/D0qlrOwLnk4BKGXOPpncSmTTs=;
	b=MshTw6tYc9St3y/0qiCy49EAAoNo5Qir6csoR/Ks1BsdTqb2OQCPBNOvoiZ0ibsauzRl
	 +BH+1PX9kFxfH/sd9y8jgB0T2XT0o0vwFDL7oZbPUl3kTveYsYngNvr5wekgr+AS9Xga5
	 T2rNjsu9kpOBp/1hZkEL5Vc50Cx9fy4Xofy19iuPx3aaIszCW5WN0kwa9JIHE/G9x0ahq
	 gD2w3SYsubzpt2CXzDhNHXX2otkK6CqcSby1I0J/lCsSULTdxEsEp+rRcgiOTF8ilFSfX
	 V96eFJf0/pjqH3NXwmYKmAzc8i1zz75bs+XAL1qLCxWznifSzDxQIW6Gw71RsGBduKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xGsMp5kW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31939606A319;
	Wed, 21 Oct 2026 22:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xGsMp5kW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923531F000C1;
	Wed, 21 Oct 2026 22:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792621670;
	bh=Ewa6IKEC08ki+BOOr/D0qlrOwLnk4BKGXOPpncSmTTs=;
	h=Date:To:From:Subject;
	b=xGsMp5kWSUNXKmTwAoJz5k7ovmYbtFR54sqnUKXeRC76os/y5JH6BFp/XbhYE43PX
	 cr/fCMTz3J19nJaGPWyxdg5+m9gEXz/sSJ9IQpRjWKzB7hQVkHI/Wa+aQKNdBMW/nd
	 M+EROVr/Ps5M/11BEkYQZlDaxCjxxhoPZStt1yqo=
Date: Wed, 21 Oct 2026 15:27:50 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rlmenge@gmail.com,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hargar@linux.microsoft.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,apais@microsoft.com,sidchintamaneni@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-fix-null-lruvec-pgdat-deref-with-memcg-disabled-on-cmdline.patch added to mm-unstable branch
Message-Id: <20261021222750.923531F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cmdline
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-fix-null-lruvec-pgdat-deref-with-memcg-disabled-on-cmdline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-fix-null-lruvec-pgdat-deref-with-memcg-disabled-on-cmdline.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-multi-gen-lru-fix-null-lruvec-pgdat-deref-with-memcg-disabled-on-cmdline.patch

