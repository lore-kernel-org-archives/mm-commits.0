Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD2FCA64
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 01:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720058385; cv=none; b=QXQ1i/omapa64AWx7XdKxYRHN7YJNlgHG0prwbB0Y7gaV2YRXYrtQELG/mKra7bEpRFsxGeMYhKANz3T9zIyZrBPO3EbaFcEsi7cq38eXtZgkMk2PMasrzzcogyv6t+mqY6pDk17+Ac0B5Ng+Mu0jtpEnSNZzB4Ay7uBbvJkBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720058385; c=relaxed/simple;
	bh=MSnuhRnBhCXHvyowQGp84WmEg98f5WDcPp/Z+IhqWco=;
	h=Date:To:From:Subject:Message-Id; b=hBB08VkuYq/y/jRpN20tD8aMRT9rmsiqeuoQBD4/eY3neYwiKSkwoKrIUto/7Zk7LDbhQmtagEZ+0CUDYY6X1zQsTkhTP3gWdoc82GCBQEUINF+7mXSKDmqirbH0d0AnxAFMYU/KRCTZGAszD+3c37ZYuUn4DM0KYgY+aa6sqtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ixKVx9UP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ixKVx9UP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE7EC2BD10;
	Thu,  4 Jul 2024 01:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720058384;
	bh=MSnuhRnBhCXHvyowQGp84WmEg98f5WDcPp/Z+IhqWco=;
	h=Date:To:From:Subject:From;
	b=ixKVx9UPho2KzGA1grgS77t890JdTgAll/DqPr5JwcrEexlZhjC5o/IVL0gSyGuq0
	 3Wv99CtQILoOhJmv1IAxd3HMEjXZa3sttXztcDDdQ2Zjt0nur8bsvmXCsKsbhQfUsF
	 gN9OgcPI1Rp3HM3Ef9ghjXZd4dfOLxq1zyu42kQQ=
Date: Wed, 03 Jul 2024 18:59:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-split-counters-v3.patch added to mm-unstable branch
Message-Id: <20240704015944.7AE7EC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-per-order-mthp-split-counters-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-split-counters-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-split-counters-v3.patch

This patch will later appear in the mm-unstable branch at
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
@@ -3082,7 +3082,7 @@ int split_huge_page_to_list_to_order(str
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
-	if (new_order >= order)
+	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
 	if (folio_test_anon(folio)) {
@@ -3285,14 +3285,13 @@ void deferred_split_folio(struct folio *
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
@@ -3313,9 +3312,9 @@ void deferred_split_folio(struct folio *
 
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
mm-add-per-order-mthp-split-counters-v3.patch
mm-add-docs-for-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters-v3.patch

