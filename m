Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20318405C;
	Thu, 23 Oct 2025 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761257429; cv=none; b=GjKdoQluLFRsR7bZEmcc5LJPuqUlzUrv092Ut/Fq2pejP+mRVCvxUaw7skdGKCBcUw6f34uf+OqGvYV4smgg+tmxovK19J0gw0ecUWBWX/cSlt3DCnQdZpmIqe3bhAL/3zrU0YPdM1l54YqjBQr7FE5YJhidrQ3zTpG4ylqG7AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761257429; c=relaxed/simple;
	bh=zVzi8JPFFKcdiVLrixflS8iwyGUm4h0mqx/TSW/q/yE=;
	h=Date:To:From:Subject:Message-Id; b=lc5P2LpK3ooWl6WacAEYYwRp7/2yGhiqlku/AlA4MwqctnQlNcwh3CFcADb/6ZUDY45f5HuxcbaFP+wBixetaQSYKYXq3MD2VmMQJTpeRZAYvrrl8xN+PXEZcyGPvJt4LDGvnqgO0oEfnfb5BAe6xbdMWhL1hYQUuvJdEL6RKXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNU57mIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNU57mIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49F9C4CEE7;
	Thu, 23 Oct 2025 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761257429;
	bh=zVzi8JPFFKcdiVLrixflS8iwyGUm4h0mqx/TSW/q/yE=;
	h=Date:To:From:Subject:From;
	b=wNU57mIKtfOw+dSY6D1bju9vjM508osoqMyYLAaPwUvF7whCCLHNioD7G3J1qG9M0
	 zBUduwowK93p3TLpe4Qg8HlGovf8xHdwqiIMBLS+NO9xFWYtnK6+z2E/70IzZSpX1f
	 Y/XX9oDYouN1SIrO300UwCw9GDmcy2xQNQH98xYI=
Date: Thu, 23 Oct 2025 15:10:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-thp-allocation-and-fallback-loop-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20251023221028.E49F9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-fix-thp-allocation-and-fallback-loop-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-thp-allocation-and-fallback-loop-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-thp-allocation-and-fallback-loop-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kairui Song <kasong@tencent.com>
Subject: mm-shmem-fix-thp-allocation-and-fallback-loop-v3
Date: Thu, 23 Oct 2025 14:59:13 +0800

introduce a temporary variable to improve code

Link: https://lkml.kernel.org/r/20251023065913.36925-1-ryncsn@gmail.com
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-thp-allocation-and-fallback-loop-v3
+++ a/mm/shmem.c
@@ -1882,6 +1882,7 @@ static struct folio *shmem_alloc_and_add
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
+	pgoff_t aligned_index;
 	long pages;
 	int error, order;
 
@@ -1895,9 +1896,10 @@ static struct folio *shmem_alloc_and_add
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
 			pages = 1UL << order;
-			folio = shmem_alloc_folio(gfp, order, info, round_down(index, pages));
+			aligned_index = round_down(index, pages);
+			folio = shmem_alloc_folio(gfp, order, info, aligned_index);
 			if (folio) {
-				index = round_down(index, pages);
+				index = aligned_index;
 				goto allocated;
 			}
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-fix-thp-allocation-and-fallback-loop.patch
mm-shmem-fix-thp-allocation-and-fallback-loop-v3.patch
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

