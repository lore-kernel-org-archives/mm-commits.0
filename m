Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415103;
	b=YKF2K9fIeTbk6FnCugK+l2ix5cFrI5QTtTdMAYhohUKXn+B/t7gENLrbwrtHOHz+ta02
	 o7bbqIezKjdQ43TTKtY4SxDBT1frXXT9NL1TU/+0Ai8wtwrO/MKE5A/H1ragd/RqOIBaD
	 5LHpJiuV4CYrx1fkmv1siiLd4sB0CBQMDqDZ3KQhqzUz3UxF9GuQeKYRYePnSERfUbFH5
	 5I3c8+YQduOpU+kc9AalRj/roD15EvEZAQcwHkqK6dFATaf7DeakKQlGzsaQIZW72oYc7
	 Xt3HmT19JCnELdhhupNB0mm5jNfCwukSdRdkHISEw5S3YrM4j+hMzaF9hjNicsUSxJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415103;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=TnJyOvBLrgt8vLlJcT3pjaKl8p+XpMNOiY/hHNNgkh0=;
	b=p8PtlDITWVne2xTI1CAlL8lkUnBOpzKmHulFHH1MYAUP5UWEZlJHra/A30O+BJRQwlNo
	 prxp0zTMr9S62Ou7+pssreRRd5ihulFmwzEoqzr/TzCOGaV2b2EIUEWvwe2nQSTRAl+9+
	 a0Fk+j4j6q9frYA7sHFLJFmEtK3I8GYlTVxaFkDfWR+L7FGrC0403/gnKBM7UZTAS8x9v
	 lA0zEb6l8/J5rV2IpwrSVxUMHgzu1avO/LC8aMUvDCTw6rWv/Ay9yRaxgSmatbJyrIPSA
	 SmcM0mFEcjeM3UpRpzzVaNC9dKmGzyFdmrSsKokXiyn1qT7YXZmQ2j1P/Q4WFxn2BtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NGDR1Hg7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C102606A32A;
	Mon, 23 Nov 2026 06:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NGDR1Hg7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609E51F000E0;
	Mon, 23 Nov 2026 06:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415102;
	bh=TnJyOvBLrgt8vLlJcT3pjaKl8p+XpMNOiY/hHNNgkh0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=NGDR1Hg7Z3sELWLLc7EIFuxcRCigz7bnieyP7gL3m6NK6jtzeV1t+G6aCPXaELEXj
	 cT36+0eaAfFAsv4CqSDAVJ7EfiDNyV7ZxSXTWtsrvKgtMGYOuOsrhghbRFvWlzONsK
	 VdCs0AxQUYjOEuMS4E3tvqVv5UoOC8mizrzwVcRU=
Date: Sun, 22 Nov 2026 22:25:01 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,youngjun.park@lge.com,
	willy@infradead.org,weixugc@google.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,
	qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,
	hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261110151407.789960-4-nphamcs@gmail.com>
References: <20261110151407.789960-4-nphamcs@gmail.com>
Subject: [merged mm-hotfixes-stable] mm-swap-skip-relocation-of-tableless-clusters.patch removed from -mm tree
Message-Id: <20261123062502.609E51F000E0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/swap: skip relocation of tableless clusters
has been removed from the -mm tree.  Its filename was
     mm-swap-skip-relocation-of-tableless-clusters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://patch.msgid.link/20261110151407.789960-4-nphamcs@gmail.com
Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-203018@kernel.org/
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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


