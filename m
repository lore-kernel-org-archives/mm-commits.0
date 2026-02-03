Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940DA30FC3C;
	Tue,  3 Feb 2026 02:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770086674; cv=none; b=qyWlAwk24SggYM7Xw8uwUW+cgwa6a9tDVYZlJV0QT/Igj/EQh7MSuvb4Q0kXK8F0ap3XCbmrMNzYuouFDzJsPOiuCZHhv/Gmbqeob/U6xAfRe23pRFXjkx2EnDEJ1xc5Lm+Ry871bMGNhepXLTm9XMXSrV31GezjzJdpx9l1KaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770086674; c=relaxed/simple;
	bh=0mLPVjLBuAMhKxTPguxXdTiuzyrN2Pswn1FlJUfsqvY=;
	h=Date:To:From:Subject:Message-Id; b=aPkvlnSQ0hj6O6GyAvQg1JB3N2Wgq30FdbOBvPbKJNE6GjIuFs0/6kazTVLIqw96opE9FexrTqGnAYV9K8Bwz9gVwsZr7REpFvt/WBQR/i7vezYL7JtL4y8yYdSbc2LaKbalwWlPjpuErJSvSzmSk1vQ+R0/wzoa0jpJr1XS8vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eqP0z5uR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eqP0z5uR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382DDC116C6;
	Tue,  3 Feb 2026 02:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086674;
	bh=0mLPVjLBuAMhKxTPguxXdTiuzyrN2Pswn1FlJUfsqvY=;
	h=Date:To:From:Subject:From;
	b=eqP0z5uRI1RXEW4e0Axb0+xO4Y3fsGy1YyDeOFMF2jQYHH0OdlPGrgfwASSM3fDL4
	 pxIehLr3bNVs8jA5NnYlusJCMVqDptNh/jhA85y7Jms1Nv52NBRNANzeZ9DSfmYn56
	 B6Ox2lcE3cAHMCzpq2/0Hvl74ZbFwvT8FN1804BA=
Date: Mon, 02 Feb 2026 18:44:33 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,clm@meta.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch removed from -mm tree
Message-Id: <20260203024434.382DDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, shmem: prevent infinite loop on truncate race
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, shmem: prevent infinite loop on truncate race
Date: Thu, 29 Jan 2026 00:19:23 +0800

When truncating a large swap entry, shmem_free_swap() returns 0 when the
entry's index doesn't match the given index due to lookup alignment.  The
failure fallback path checks if the entry crosses the end border and
aborts when it happens, so truncate won't erase an unexpected entry or
range.  But one scenario was ignored.

When `index` points to the middle of a large swap entry, and the large
swap entry doesn't go across the end border, find_get_entries() will
return that large swap entry as the first item in the batch with
`indices[0]` equal to `index`.  The entry's base index will be smaller
than `indices[0]`, so shmem_free_swap() will fail and return 0 due to the
"base < index" check.  The code will then call shmem_confirm_swap(), get
the order, check if it crosses the END boundary (which it doesn't), and
retry with the same index.

The next iteration will find the same entry again at the same index with
same indices, leading to an infinite loop.

Fix this by retrying with a round-down index, and abort if the index is
smaller than the truncate range.

Link: https://lkml.kernel.org/r/aXo6ltB5iqAKJzY8@KASONG-MC4
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/linux-mm/20260128130336.727049-1-clm@meta.com/
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split
+++ a/mm/shmem.c
@@ -1211,17 +1211,22 @@ whole_folios:
 				swaps_freed = shmem_free_swap(mapping, indices[i],
 							      end - 1, folio);
 				if (!swaps_freed) {
-					/*
-					 * If found a large swap entry cross the end border,
-					 * skip it as the truncate_inode_partial_folio above
-					 * should have at least zerod its content once.
-					 */
+					pgoff_t base = indices[i];
+
 					order = shmem_confirm_swap(mapping, indices[i],
 								   radix_to_swp_entry(folio));
-					if (order > 0 && indices[i] + (1 << order) > end)
-						continue;
-					/* Swap was replaced by page: retry */
-					index = indices[i];
+					/*
+					 * If found a large swap entry cross the end or start
+					 * border, skip it as the truncate_inode_partial_folio
+					 * above should have at least zerod its content once.
+					 */
+					if (order > 0) {
+						base = round_down(base, 1 << order);
+						if (base < start || base + (1 << order) > end)
+							continue;
+					}
+					/* Swap was replaced by page or extended, retry */
+					index = base;
 					break;
 				}
 				nr_swaps_freed += swaps_freed;
_

Patches currently in -mm which might be from kasong@tencent.com are


