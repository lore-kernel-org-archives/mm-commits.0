Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420662AE99
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489917; cv=none; b=oNMOk5mMH9kjNA1dCMIACBQ5IfSuHmozDMECRYhfB1Hxp6bKtx4qlbQt9bzI/VWYzDI2N1HYutYP9mWlynmkXtrcQZ3rAptbFq+m3Z2Fw9i9gOrT84goiZ4c3W6EOOfcQx+Ghto+LM3vpe7vPDvgmd/OCMJNXt3Lxj/tdnFoNOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489917; c=relaxed/simple;
	bh=amZwPOZPQtkUC9X6kTiRfPFHv8wBGG74cxpCYIMkflg=;
	h=Date:To:From:Subject:Message-Id; b=V+zyNxwjr3q3F3ucerZ0N18EpW5Iv/pywwSg4dj+16swfEqrm+VDKVFyPvE8EF8fC0iXGr06Dh3B0nHmgHa3a6XOw+X+JvlGs8wpI19p7ZGU8s+BNxu6wzexzZjgzr3QOza7iOzOZoDNIiPxqkFJXbjzSgRZsFouqHNxgXe6YK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ffAoo+8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ffAoo+8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2944C4CEE7;
	Sun, 21 Sep 2025 21:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489916;
	bh=amZwPOZPQtkUC9X6kTiRfPFHv8wBGG74cxpCYIMkflg=;
	h=Date:To:From:Subject:From;
	b=ffAoo+8R5tfGDK2PUv3M3D54XO9zt/+qlCMycR2NQbj6cXORRm04l6xnjQNESqvhI
	 3uDlglPLxwIe1215dcPdRypM2gDl5o6i4NTkWWcn7706TK+0rZX2DgMOs8rbHVq9F1
	 UxC/hNSdG6K5XuM/BQBwL0lRqjX0dIkJesBHYIt8=
Date: Sun, 21 Sep 2025 14:25:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-the-strategy-for-the-tmpfs-huge=-options.patch removed from -mm tree
Message-Id: <20250921212516.C2944C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix the strategy for the tmpfs 'huge=' options
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-the-strategy-for-the-tmpfs-huge=-options.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix the strategy for the tmpfs 'huge=' options
Date: Wed, 3 Sep 2025 16:54:24 +0800

After commit acd7ccb284b8 ("mm: shmem: add large folio support for
tmpfs"), we have extended tmpfs to allow any sized large folios, rather
than just PMD-sized large folios.

The strategy discussed previously was:

: Considering that tmpfs already has the 'huge=' option to control the
: PMD-sized large folios allocation, we can extend the 'huge=' option to
: allow any sized large folios.  The semantics of the 'huge=' mount option
: are:
: 
:     huge=never: no any sized large folios
:     huge=always: any sized large folios
:     huge=within_size: like 'always' but respect the i_size
:     huge=advise: like 'always' if requested with madvise()
: 
: Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
: allocate the PMD-sized huge folios if huge=always/within_size/advise is
: set.
: 
: Moreover, the 'deny' and 'force' testing options controlled by
: '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
: semantics.  The 'deny' can disable any sized large folios for tmpfs, while
: the 'force' can enable PMD sized large folios for tmpfs.

This means that when tmpfs is mounted with 'huge=always' or
'huge=within_size', tmpfs will allow getting a highest order hint based on
the size of write() and fallocate() paths.  It will then try each
allowable large order, rather than continually attempting to allocate
PMD-sized large folios as before.

However, this might break some user scenarios for those who want to use
PMD-sized large folios, such as the i915 driver which did not supply a
write size hint when allocating shmem [1].

Moreover, Hugh also complained that this will cause a regression in userspace
with 'huge=always' or 'huge=within_size'.

So, let's revisit the strategy for tmpfs large page allocation. A simple fix
would be to always try PMD-sized large folios first, and if that fails, fall
back to smaller large folios. This approach differs from the strategy for
large folio allocation used by other file systems, however, tmpfs is somewhat
different from other file systems, as quoted from David's opinion:

: There were opinions in the past that tmpfs should just behave like any
: other fs, and I think that's what we tried to satisfy here: use the write
: size as an indication.
: 
: I assume there will be workloads where either approach will be beneficial.
: I also assume that workloads that use ordinary fs'es could benefit from
: the same strategy (start with PMD), while others will clearly not.

Link: https://lkml.kernel.org/r/10e7ac6cebe6535c137c064d5c5a235643eebb4a.1756888965.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/ [1]
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    6 ++
 mm/shmem.c                                 |   47 ++-----------------
 2 files changed, 10 insertions(+), 43 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-fix-the-strategy-for-the-tmpfs-huge=-options
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -419,6 +419,8 @@ option: ``huge=``. It can have following
 
 always
     Attempt to allocate huge pages every time we need a new page;
+    Always try PMD-sized huge pages first, and fall back to smaller-sized
+    huge pages if the PMD-sized huge page allocation fails;
 
 never
     Do not allocate huge pages. Note that ``madvise(..., MADV_COLLAPSE)``
@@ -426,7 +428,9 @@ never
     is specified everywhere;
 
 within_size
-    Only allocate huge page if it will be fully within i_size.
+    Only allocate huge page if it will be fully within i_size;
+    Always try PMD-sized huge pages first, and fall back to smaller-sized
+    huge pages if the PMD-sized huge page allocation fails;
     Also respect madvise() hints;
 
 advise
--- a/mm/shmem.c~mm-shmem-fix-the-strategy-for-the-tmpfs-huge=-options
+++ a/mm/shmem.c
@@ -573,42 +573,6 @@ static int shmem_confirm_swap(struct add
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-/**
- * shmem_mapping_size_orders - Get allowable folio orders for the given file size.
- * @mapping: Target address_space.
- * @index: The page index.
- * @write_end: end of a write, could extend inode size.
- *
- * This returns huge orders for folios (when supported) based on the file size
- * which the mapping currently allows at the given index. The index is relevant
- * due to alignment considerations the mapping might have. The returned order
- * may be less than the size passed.
- *
- * Return: The orders.
- */
-static inline unsigned int
-shmem_mapping_size_orders(struct address_space *mapping, pgoff_t index, loff_t write_end)
-{
-	unsigned int order;
-	size_t size;
-
-	if (!mapping_large_folio_support(mapping) || !write_end)
-		return 0;
-
-	/* Calculate the write size based on the write_end */
-	size = write_end - (index << PAGE_SHIFT);
-	order = filemap_get_order(size);
-	if (!order)
-		return 0;
-
-	/* If we're not aligned, allocate a smaller folio */
-	if (index & ((1UL << order) - 1))
-		order = __ffs(index);
-
-	order = min_t(size_t, order, MAX_PAGECACHE_ORDER);
-	return order > 0 ? BIT(order + 1) - 1 : 0;
-}
-
 static unsigned int shmem_get_orders_within_size(struct inode *inode,
 		unsigned long within_size_orders, pgoff_t index,
 		loff_t write_end)
@@ -655,22 +619,21 @@ static unsigned int shmem_huge_global_en
 	 * For tmpfs mmap()'s huge order, we still use PMD-sized order to
 	 * allocate huge pages due to lack of a write size hint.
 	 *
-	 * Otherwise, tmpfs will allow getting a highest order hint based on
-	 * the size of write and fallocate paths, then will try each allowable
-	 * huge orders.
+	 * For tmpfs with 'huge=always' or 'huge=within_size' mount option,
+	 * we will always try PMD-sized order first. If that failed, it will
+	 * fall back to small large folios.
 	 */
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
 		if (vma)
 			return maybe_pmd_order;
 
-		return shmem_mapping_size_orders(inode->i_mapping, index, write_end);
+		return THP_ORDERS_ALL_FILE_DEFAULT;
 	case SHMEM_HUGE_WITHIN_SIZE:
 		if (vma)
 			within_size_orders = maybe_pmd_order;
 		else
-			within_size_orders = shmem_mapping_size_orders(inode->i_mapping,
-								       index, write_end);
+			within_size_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
 		within_size_orders = shmem_get_orders_within_size(inode, within_size_orders,
 								  index, write_end);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch

