Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E023C1F
	for <mm-commits@vger.kernel.org>; Sat, 15 Nov 2025 00:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763165232; cv=none; b=TvHT8MeQfEvJMRAI3MqU2HgpSjKQJ9rHGtJQnDhuWn82Lx0Jwifz7/tftSdq0klAHZGFeVgafqopGPYJ07d2QQdQQbYfw6yEpilQk9eUNJFedCOjgpweliqAZjaJonjYVTKX/Mx/+fgGRkRKUBFAsVV5EaUQQNGqPxDy8pDNsOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763165232; c=relaxed/simple;
	bh=aFuWnsVekl7U6YhExjdnuVO2kQX7ktdpbzwux1JZVks=;
	h=Date:To:From:Subject:Message-Id; b=vDQwxaf1qHh2uzw3wS2Vu2/KXSXBVzvD+2xR9Fg3s4JS1F+BZz3PBC5YW86YkP3mLdQVY+RLKXGVQlWNdsxKPG4ds8ccgNOZHXahVtN2Z06+qrIHOIiAnSIsbAytd2nWiZGSyFrjsYgmcDj2H7h0tAZIdV/gnHM4oXLLXullgRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vAs7nDak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vAs7nDak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D433EC4CEF5;
	Sat, 15 Nov 2025 00:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763165231;
	bh=aFuWnsVekl7U6YhExjdnuVO2kQX7ktdpbzwux1JZVks=;
	h=Date:To:From:Subject:From;
	b=vAs7nDakbkPc0sZW9f2C0lANKWJA0IJ22f6QFnZheUAkXlA6B6a77gJvGZlf2XDdt
	 FkokSHgsnbPP/Y/2e08WblkUzSDXrcckNmFM9DYdd0fqk++X3T8SOvrnvVUXa3jQm7
	 q6UGAalSpYfJbU0F0ZE4CQAtedOk5PiFEgLYn1co=
Date: Fri, 14 Nov 2025 16:07:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lorenzo.stoakes@oracle.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch added to mm-new branch
Message-Id: <20251115000711.D433EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: allow fallback to smaller large orders for tmpfs mmap() access
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch
mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch
mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch
mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

