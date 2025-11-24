Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45EB3358CD
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025849; cv=none; b=H39l5l3PMe7x8fiatOMSgjuHEGs6RXoLdz8Qwy1BIFR8PNxqFGMy3L70+M1TUw8ej5bpu2aiw+QyzQ0GATeNIAJAbY1+9Zgk40X0Qk302rsoIQvlplFG8Y9cnfvZm7SCOpB8eIEM93hPXRAx5FBrp6JlKwBKTHZQdQsdUWHLcHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025849; c=relaxed/simple;
	bh=owuYSQgVShrlOFjJD8G778BoT8RF9rGu3vzd2u4xXe0=;
	h=Date:To:From:Subject:Message-Id; b=tvnpCieooFMU59AVZv4xByF99sxo8GCczN3e6oaRJCQ1dWzpsgeY5NFU4/cpHkUH5zmReAtfJ4yUssrdyKCMkx5wPslmbvcA2VndLZw8p6D/bAfFnW4+hk+iV2QQe1C95aGtNoc7BrC6/EDCqvoloDt+sA7qjLIyQxoYco+A77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pMY7Lanb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pMY7Lanb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B10C4CEFB;
	Mon, 24 Nov 2025 23:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025849;
	bh=owuYSQgVShrlOFjJD8G778BoT8RF9rGu3vzd2u4xXe0=;
	h=Date:To:From:Subject:From;
	b=pMY7LanbT72vRDSD61PR0enHAX5bKQUpt54aJV+uqRrpmOK34EWJrUmnyqCcKoEUM
	 rbSiZh5awgMhsbSXw2xnsjHp6xRDtUAZ2Js5BY4jpO97HLpq3OSMkWXLbKEioBh5Rz
	 /R7bvTH5asQdrhTeFRwjfoE9m4HH5y1v8VHYA9Yg=
Date: Mon, 24 Nov 2025 15:10:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lorenzo.stoakes@oracle.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch removed from -mm tree
Message-Id: <20251124231049.97B10C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: allow fallback to smaller large orders for tmpfs mmap() access
has been removed from the -mm tree.  Its filename was
     mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: allow fallback to smaller large orders for tmpfs mmap() access
Date: Fri, 14 Nov 2025 08:46:32 +0800

After commit 69e0a3b49003 ("mm: shmem: fix the strategy for the tmpfs
'huge=' options"), we have fixed the large order allocation strategy for
tmpfs, which always tries PMD-sized large folios first, and if that fails,
falls back to smaller large folios.  For tmpfs large folio allocation via
mmap(), we should maintain the same strategy as well.  Let's unify the
large order allocation strategy for tmpfs.

There is no functional change for large folio allocation of anonymous shmem.

Link: https://lkml.kernel.org/r/283a0bdfd6ac7aa334a491422bcae70919c572bd.1763008453.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/mm/shmem.c~mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access
+++ a/mm/shmem.c
@@ -645,34 +645,23 @@ static unsigned int shmem_huge_global_en
 	 * the mTHP interface, so we still use PMD-sized huge order to
 	 * check whether global control is enabled.
 	 *
-	 * For tmpfs mmap()'s huge order, we still use PMD-sized order to
-	 * allocate huge pages due to lack of a write size hint.
-	 *
 	 * For tmpfs with 'huge=always' or 'huge=within_size' mount option,
 	 * we will always try PMD-sized order first. If that failed, it will
 	 * fall back to small large folios.
 	 */
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
-		if (vma)
-			return maybe_pmd_order;
-
 		return THP_ORDERS_ALL_FILE_DEFAULT;
 	case SHMEM_HUGE_WITHIN_SIZE:
-		if (vma)
-			within_size_orders = maybe_pmd_order;
-		else
-			within_size_orders = THP_ORDERS_ALL_FILE_DEFAULT;
-
-		within_size_orders = shmem_get_orders_within_size(inode, within_size_orders,
-								  index, write_end);
+		within_size_orders = shmem_get_orders_within_size(inode,
+				THP_ORDERS_ALL_FILE_DEFAULT, index, write_end);
 		if (within_size_orders > 0)
 			return within_size_orders;
 
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
 		if (vm_flags & VM_HUGEPAGE)
-			return maybe_pmd_order;
+			return THP_ORDERS_ALL_FILE_DEFAULT;
 		fallthrough;
 	default:
 		return 0;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


