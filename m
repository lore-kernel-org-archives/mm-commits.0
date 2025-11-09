Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4D91CEAC2;
	Sun,  9 Nov 2025 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762715380; cv=none; b=oPbFH0KupGmrl5C5rE+jF204dahI3HWV9LNXrB1faJ/1ZEzIwUEnkIoacSD3tXlS9ESt1oRyRkFtB6hcEoBCkCjEM1cUQHCBfzfPd9PW0t0ASf4ILALhgoaorycUPNQdEte6ZF9p7bwSHER3XAyMifufr9hIF50BN6fPd8WrEKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762715380; c=relaxed/simple;
	bh=sB2FXV+GYzHfj2oM+bcPYDXLLVoWMiCTMOC5huYCt/I=;
	h=Date:To:From:Subject:Message-Id; b=Qvc/EDMklXynLmyEuygNOdMHnOkBxV2HDeBUdmZf2y49yPel55IBIXLuwS86ZJK+ru+9LbgYiAh9gje02Og++oiqLFIhZAFMRMYdXAEeFULt+ChybtFu8S1j5mn3AXBpwDqggC0NNMemYvtFhhehIP3vkhmvPpwSuycrxRJ6il4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tux/0bow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tux/0bow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B385BC4CEF7;
	Sun,  9 Nov 2025 19:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762715379;
	bh=sB2FXV+GYzHfj2oM+bcPYDXLLVoWMiCTMOC5huYCt/I=;
	h=Date:To:From:Subject:From;
	b=Tux/0bowNxWDVesvFuNZPBNouGoqJuo7In2OFfuDsVKCMeuR2MD9XKYzTSgpaF5IT
	 x2d8PXepy3T+KAOnS7uQWAABeurcIVZRySCvYaF+8dVE8f06qmmgT2RH6jb4SkFOQK
	 tq+cZYdpNGJsAAp5u56ArdNKUE8fy+H1+Um0AFBs=
Date: Sun, 09 Nov 2025 11:09:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-fix-thp-allocation-and-fallback-loop-v3.patch removed from -mm tree
Message-Id: <20251109190939.B385BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-fix-thp-allocation-and-fallback-loop-v3
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-thp-allocation-and-fallback-loop-v3.patch

This patch was dropped because it was folded into mm-shmem-fix-thp-allocation-and-fallback-loop.patch

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm-shmem-fix-thp-allocation-and-fallback-loop-v3
Date: Thu, 23 Oct 2025 14:59:13 +0800

introduce a temporary variable to improve code

Link: https://lkml.kernel.org/r/20251023065913.36925-1-ryncsn@gmail.com
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
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
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch
revert-mm-swap-avoid-redundant-swap-device-pinning.patch

