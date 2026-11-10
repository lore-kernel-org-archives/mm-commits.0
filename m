Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339384;
	b=PfhAxbCJBayoQCk+HY3/5tJxl5XJNlX8F7MRFOY4wwLJByDx90n450/vvgJSiNd9v7tb
	 8mJh9t2+/dXVNMgQiRjIS5lSZ2GFjxkSiL8HNcjXRoZFDOEUTfuADfDMd/J8xxyt/jahV
	 CG22cwBg7QSswUqv9F7m6mRHIkmqu0mTg93rfQXeIsTlX6aawtf1tl+VzoW0mZThXSoWo
	 wzrgmLMEzB+B86uvkLDnkdx9MJRkUeXLKObKGbuNYUK5yHm5QOXFb6EkrJP2XmmjdMBJh
	 9W+A2LqoQtg62d6GIUycO2pRNtB94eu/oMv+UduInsyJza0p8OE58KxN3RmfA4JJxOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339384;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yYz3H+pD/vFn1+lKtq8Boo+NqSXtDe822uNHHFAYhxA=;
	b=12Kb1Gk83cTnzPO+qdeeq15x4pM16xXyHAEsNmgV3u7EVzsttKmwSA3zzENZSG+8U9am
	 VRWB4//pZ+OuKiMlM6HsDXlxj8EW+r7my3qNk2m8s8d+1rtBp4EKV4aYgrT8PgcFZAxAU
	 me8eKVY1z36U4gOOpAIrMaRVNdHRdzLgBBBLy7eMCHOs9UzYDBHZc1k/iR9W9CLr+0Dz4
	 +NiaccQQ6nx2V7G2tGFX5L7xvqFbmhdyKTLMAv9T38cNXnJ+jz/BxwTZE+HYuKPpD5Ya2
	 lYTgRrSKc9y7GDJXis/m/TXFkqz4QGB/MTUisydEeHPE8KE4daXsIOqQh3YByM3TGng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hPuRG4Cc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461C1606A32D;
	Tue, 10 Nov 2026 19:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hPuRG4Cc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7571F0089F;
	Tue, 10 Nov 2026 19:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794339384;
	bh=yYz3H+pD/vFn1+lKtq8Boo+NqSXtDe822uNHHFAYhxA=;
	h=Date:To:From:Subject;
	b=hPuRG4Ccfi2vP20l1JT0rm0V4Q7E9Xlz9Lsq93XhNuC5j1CR7wPkbB01Q5oV2urbS
	 K93ZKjTr84XZ08W3fEJRxLfHtXSnd4iCQOfFHtNuGi5eYPWPHsIh3f6TOYpkvFWVgu
	 qBK9XMh5QFoI/FRo3DoT7q0cmvRZslpfuqsHCbjA=
Date: Tue, 10 Nov 2026 11:36:23 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,youngjun.park@lge.com,
	willy@infradead.org,weixugc@google.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,
	qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,
	hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-skip-relocation-of-tableless-clusters.patch added to mm-hotfixes-unstable branch
Message-Id: <20261110193624.0A7571F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/swap: skip relocation of tableless clusters
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-skip-relocation-of-tableless-clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-skip-relocation-of-tableless-clusters.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/swap: skip relocation of tableless clusters
Date: Tue, 10 Nov 2026 07:14:07 -0800

A stale reclaimer can reach relocate_cluster() after another allocator
re-isolates an emptied cluster and drops its locks to populate the table.
The cluster has zero count, CLUSTER_FLAG_NONE and no table, so relocation
can free it again and dereference NULL in the DEBUG_VM empty check.

    CPU0                                    CPU1
    Reclaimer                               Allocator
    alloc_swap_scan_cluster()
      cluster_reclaim_range()
        spin_unlock(&ci->lock)
        __try_to_reclaim_swap()
          swap_cache_del_folio()
            __swap_cache_del_folio()
              __swap_cache_do_del_folio()
                __swap_cluster_free_entries()
                  free_cluster()
                    __free_cluster()
                      swap_cluster_free_table()
            swap_cluster_unlock(ci)
                                            isolate_lock_cluster()
                                              swap_cluster_populate()
                                                drop ci and outer locks
                                                swap_cluster_alloc_table()
        spin_lock(&ci->lock)
      relocate_cluster()
        free_cluster()
          __free_cluster()
            swap_cluster_assert_empty()
              __swap_table_get()  /* NULL table */

Leave tableless clusters to the allocator under ci->lock. This also stops
a stale reclaimer from returning a cluster to the free list while table
population is pending, avoiding the resulting FREE-to-NONE state cycle.
The existing cluster lock serializes the table check and relocation with
population.

Link: https://lore.kernel.org/20261110151407.789960-4-nphamcs@gmail.com
Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-203018@kernel.org/
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/swapfile.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/swapfile.c~mm-swap-skip-relocation-of-tableless-clusters
+++ a/mm/swapfile.c
@@ -815,6 +815,13 @@ static void relocate_cluster(struct swap
 	if (cluster_is_discard(ci))
 		return;
 
+	/*
+	 * An allocator may still be preparing the table.
+	 * Leave the cluster to it.
+	 */
+	if (!cluster_table_is_alloced(ci))
+		return;
+
 	if (!ci->count) {
 		if (ci->flags != CLUSTER_FLAG_FREE)
 			free_cluster(si, ci);
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings.patch
mm-swap-publish-cluster-tables-after-reacquiring-allocator-locks.patch
mm-swap-skip-relocation-of-tableless-clusters.patch

