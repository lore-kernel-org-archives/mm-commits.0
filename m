Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BD62E8B7D;
	Mon, 10 Nov 2025 05:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752017; cv=none; b=FAgYB5TyHH/6N7Xd7iRY9oEo1jS8ok7sHIlvrCOtaw+IYNOwyWzGBUbpgq2yD8x3GnpYqbIWOiw9YJLLopAN59ToRYv+dNG5+j/4yX5bzOuwQqkcqDhBNgvdw69EhZQXFJHXXiWoXEZDrcuRNwylZbRNBAS83x/YTIjpaY71at0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752017; c=relaxed/simple;
	bh=OP5XpU/aCm6zwTXIrqh0QBd/RrmBWSVxeEqQf+k5Omw=;
	h=Date:To:From:Subject:Message-Id; b=jykh1qpe55Y/6sNBoRLpq/pIG386UNAaeT0Pwu7RC2KxflrpMbTB0XFw6feKNtteNk5u4ukTigo5BJ4iaJWR3vDh7Q4NxYUzp0/qD3BxTp1zfqmkuVtm3Xcr8TDfdagpiRtM8iSVqHlj4wPiSqCRRDhei8/bZ3SAJVoAoOWkRmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nVfAuS4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nVfAuS4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BEBC19421;
	Mon, 10 Nov 2025 05:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752016;
	bh=OP5XpU/aCm6zwTXIrqh0QBd/RrmBWSVxeEqQf+k5Omw=;
	h=Date:To:From:Subject:From;
	b=nVfAuS4uGyResW6CcAD1PyZs8l19oKL6DFrk/O8lTyoOQLc/9h7byIRrWSwKbAB0p
	 PmjCigB8CL6Y69blk/Ai8ljXmTA1VDqT4b0IEeKnFogFfz4V5NgoEh2CUyIIX0nNIt
	 Xh8EO6sBSwNVEiN37WJwyAIhj7eZ6rM/T0UcukGY=
Date: Sun, 09 Nov 2025 21:20:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-thp-allocation-and-fallback-loop.patch removed from -mm tree
Message-Id: <20251110052016.73BEBC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: fix THP allocation and fallback loop
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-thp-allocation-and-fallback-loop.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem: fix THP allocation and fallback loop
Date: Wed, 22 Oct 2025 18:57:19 +0800

The order check and fallback loop is updating the index value on every
loop.  This will cause the index to be wrongly aligned by a larger value
while the loop shrinks the order.

This may result in inserting and returning a folio of the wrong index and
cause data corruption with some userspace workloads [1].

[kasong@tencent.com: introduce a temporary variable to improve code]
  Link: https://lkml.kernel.org/r/20251023065913.36925-1-ryncsn@gmail.com
  Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20251022105719.18321-1-ryncsn@gmail.com
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Closes: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-thp-allocation-and-fallback-loop
+++ a/mm/shmem.c
@@ -1882,6 +1882,7 @@ static struct folio *shmem_alloc_and_add
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
+	pgoff_t aligned_index;
 	long pages;
 	int error, order;
 
@@ -1895,10 +1896,12 @@ static struct folio *shmem_alloc_and_add
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
 			pages = 1UL << order;
-			index = round_down(index, pages);
-			folio = shmem_alloc_folio(gfp, order, info, index);
-			if (folio)
+			aligned_index = round_down(index, pages);
+			folio = shmem_alloc_folio(gfp, order, info, aligned_index);
+			if (folio) {
+				index = aligned_index;
 				goto allocated;
+			}
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch
revert-mm-swap-avoid-redundant-swap-device-pinning.patch

