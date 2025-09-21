Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559DA21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489944; cv=none; b=fSmypTgf5CJif6Z/E0BodRfkFp8u9smrbQ2cZAI1n3AjhoNGBLTcK/X8TLWumOKoEaA/nOkvi3eqU2G2i/79SoMjeihckPUE1GGD3xHfvDCJpXGH5jina1hyiuB8+xHK4m/NiWG1xGpuRWGrF5iop2x8wSIihLyIiBaJKNp8pB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489944; c=relaxed/simple;
	bh=v+rl78zq/erVbhNjwfmWsw6EtcPxfXKsP93oscnwdBQ=;
	h=Date:To:From:Subject:Message-Id; b=tF7anC9OjuKN2BdJrqmOMHCKokhsL1V9KMNQ9VY0STaCcH4XjYZJGIUSkV8NwkgIajq7weDBbEZft3/kDX4Yh4XkIR8xqdE/gFQsf/+ASQghb56q469JZGx7Z8AeRsDvNt5kdSuMyu+Qv6xosVDQoCFTikiJl1JCSPi4XeLpr8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QofSH8bJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QofSH8bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B177C4CEE7;
	Sun, 21 Sep 2025 21:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489944;
	bh=v+rl78zq/erVbhNjwfmWsw6EtcPxfXKsP93oscnwdBQ=;
	h=Date:To:From:Subject:From;
	b=QofSH8bJ2jgrQzbEuSnIAxXbATBPoa8sWh5PPpI/aIXStne6cVLwm0cdfOtH4eEbo
	 OnAfESkVKJP/rNLPJSQfPWtkrnW2VPPRa5tOuCK1xEmHzl25A9RDliVHVqBVeVTeTd
	 JmpQTUr9KYsMmFcTaoNCieK0AxXcvmx7DcgUqEFY=
Date: Sun, 21 Sep 2025 14:25:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch removed from -mm tree
Message-Id: <20250921212544.2B177C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem, swap: remove redundant error handling for replacing folio
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: remove redundant error handling for replacing folio
Date: Wed, 17 Sep 2025 00:00:54 +0800

Shmem may replace a folio in the swap cache if the cached one doesn't fit
the swapin's GFP zone.  When doing so, shmem has already double checked
that the swap cache folio is locked, still has the swap cache flag set,
and contains the wanted swap entry.  So it is impossible to fail due to an
XArray mismatch.  There is even a comment for that.

Delete the defensive error handling path, and add a WARN_ON instead: if
that happened, something has broken the basic principle of how the swap
cache works, we should catch and fix that.

Link: https://lkml.kernel.org/r/20250916160100.31545-10-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio
+++ a/mm/shmem.c
@@ -2121,35 +2121,17 @@ static int shmem_replace_folio(struct fo
 	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
 	for (i = 0; i < nr_pages; i++) {
-		void *item = xas_load(&xas);
-
-		if (item != old) {
-			error = -ENOENT;
-			break;
-		}
-
-		xas_store(&xas, new);
+		WARN_ON_ONCE(xas_store(&xas, new) != old);
 		xas_next(&xas);
 	}
-	if (!error) {
-		mem_cgroup_replace_folio(old, new);
-		shmem_update_stats(new, nr_pages);
-		shmem_update_stats(old, -nr_pages);
-	}
+
+	mem_cgroup_replace_folio(old, new);
+	shmem_update_stats(new, nr_pages);
+	shmem_update_stats(old, -nr_pages);
 	xa_unlock_irq(&swap_mapping->i_pages);
 
-	if (unlikely(error)) {
-		/*
-		 * Is this possible?  I think not, now that our callers
-		 * check both the swapcache flag and folio->private
-		 * after getting the folio lock; but be defensive.
-		 * Reverse old to newpage for clear and free.
-		 */
-		old = new;
-	} else {
-		folio_add_lru(new);
-		*foliop = new;
-	}
+	folio_add_lru(new);
+	*foliop = new;
 
 	folio_clear_swapcache(old);
 	old->private = NULL;
_

Patches currently in -mm which might be from kasong@tencent.com are


