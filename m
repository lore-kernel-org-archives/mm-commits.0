Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C81BC40
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824325; cv=none; b=S/m6ATA5tLqeBUoyehjYgv5j1uG/kTzKc7igIy0O0yhQ537wmY7UsgkdKaWXmTgUZ2Q4UN2DsJuBY/SbrRMCCkcQ4WhmQ5Hib+xBp55+j5GSJVoa34zf1jgSX7txlY2spLV21gBtszR3zDyS7Ri7YOTYVmElIDwLEEZ45tV7mWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824325; c=relaxed/simple;
	bh=p+cNBjrt8fkQj6enlhfaKpIbU9AKvRk661DhhyTOtiM=;
	h=Date:To:From:Subject:Message-Id; b=Z9wdW5RYa1xaXIgNEXWD2lj7+c9td1i2EKEkbzvmuPTPlnAPNZ8/ljhhvyDLK7V2fa2XhrQOrOE42zTkQSutOXvZDWGdLs04SgCgJwYymFzgZEMGbtIM74bcNBjNCnRxTAVNhSoHJqnwmhkMzBB58X/UHnf4iP9v3cZe1XLz7pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P3w7g3vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P3w7g3vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB78AC32782;
	Fri, 12 Jul 2024 22:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824323;
	bh=p+cNBjrt8fkQj6enlhfaKpIbU9AKvRk661DhhyTOtiM=;
	h=Date:To:From:Subject:From;
	b=P3w7g3vjMBmRWGh5T9jvzvdmlOuf1Gx76bIY/6wVcGj4s+bDg/xu4Tux5xM2v7w3q
	 4nQyEc2YDZP7Ju3j66SdSPK/+Z29poGjLDLgzLffKX99UxMIRMfDPN/mSlSX0TnXfy
	 rbXJze3W3t1Ig9xuv6FvNkX1ddmr8EpJ1dnVIeq4=
Date: Fri, 12 Jul 2024 15:45:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-per-order-mthp-split-counters-v3.patch removed from -mm tree
Message-Id: <20240712224523.BB78AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-per-order-mthp-split-counters-v3
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-split-counters-v3.patch

This patch was dropped because it was folded into mm-add-per-order-mthp-split-counters.patch

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-add-per-order-mthp-split-counters-v3
Date: Thu, 4 Jul 2024 09:29:04 +0800

make things more readable, per Barry and Baolin

Link: https://lkml.kernel.org/r/20240704012905.42971-2-ioworker0@gmail.com
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Barry Song <baohua@kernel.org>
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-add-per-order-mthp-split-counters-v3
+++ a/mm/huge_memory.c
@@ -3083,7 +3083,7 @@ int split_huge_page_to_list_to_order(str
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
-	if (new_order >= order)
+	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
 	if (folio_test_anon(folio)) {
@@ -3286,14 +3286,13 @@ void deferred_split_folio(struct folio *
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup *memcg = folio_memcg(folio);
 #endif
-	int order = folio_order(folio);
 	unsigned long flags;
 
 	/*
 	 * Order 1 folios have no space for a deferred list, but we also
 	 * won't waste much memory by not adding them to the deferred list.
 	 */
-	if (order <= 1)
+	if (folio_order(folio) <= 1)
 		return;
 
 	/*
@@ -3314,9 +3313,9 @@ void deferred_split_folio(struct folio *
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(&folio->_deferred_list)) {
-		if (order >= HPAGE_PMD_ORDER)
+		if (folio_test_pmd_mappable(folio))
 			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
-		count_mthp_stat(order, MTHP_STAT_SPLIT_DEFERRED);
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-per-order-mthp-split-counters-fix.patch
mm-add-docs-for-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters-v3.patch
mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch

