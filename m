Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFDB30C37E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439032; cv=none; b=ScDcIAo7YadLGsmT8B8fKht62rjhTxvz6wTmIU5oE5mjSq4AlV1WlbuTZqWhDm5PGkCD/nECgSMae7ybRmawR5tb3aIg+bYmfD9ThkzhBNLesDH7vnF6Dnc7f+fa/S1qf72sIViIxkESvTkgZrIvoHNtJImGIdnjMtRP2mAptWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439032; c=relaxed/simple;
	bh=0gjx6LwZ+W78FOHMKCWs1GZjbgYvHPhistvuT9ERHnA=;
	h=Date:To:From:Subject:Message-Id; b=qAo2RUNte0dpjRoWd0ZbRvMtFEyKhqHUZU+7P8hOFRAFwI5Yoo1gRPT1qXjnqVFH0BLftzcpnRF2F0tnitoE2ObacaqW4ro6oZgwKKg+1UxmMVd7lkiDIqTBi02L5YxRKuinpKHAYdS6oiguJCPXFfDLMo3pvqoLBIWlz3Hnpj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XAqb8DCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XAqb8DCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F55A1F00898;
	Tue,  2 Jun 2026 22:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439031;
	bh=p/uo7EpdzGmEFWqAVyk7nKADgWdAyowyuFM65RXXujw=;
	h=Date:To:From:Subject;
	b=XAqb8DCgR+2YVNQvASC1wgw6h7211rXAqQGu4+kE1rTpkuaGJlT+F7g+zBNw9ji6G
	 14B+6hG0FkmnuTbzMzm7p6aCkV6AStfJOrNtF7+0fupHqvgTRjDCMvhDbEiYy1Ebm5
	 wYI8gy4305O4nNV+o00ovJTPu0I7JZtQp+gWVHuw=
Date: Tue, 02 Jun 2026 15:23:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xhao@linux.alibaba.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch removed from -mm tree
Message-Id: <20260602222351.9F55A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag due to allocation failure order
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag due to allocation failure order
Date: Mon, 11 May 2026 10:54:07 +0800

__khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
corresponding mm_slot.  If mm_slot_alloc() fails, the function returns
with the flag set but without inserting the mm into the khugepaged
tracking structures, leaving the mm in an inconsistent state where future
registration attempts are skipped.

Fix this by reordering: allocate the mm_slot first, then check and set the
flag.  If the flag is already set, free the allocated slot and return. 
This ensures the flag is only set when the mm is successfully registered
in the khugepaged tracking structures.

Link: https://lore.kernel.org/20260511025408.54035-1-ye.liu@linux.dev
Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order
+++ a/mm/khugepaged.c
@@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
-	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
-		return;
 
 	slot = mm_slot_alloc(mm_slot_cache);
 	if (!slot)
 		return;
 
+	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
+		mm_slot_free(mm_slot_cache, slot);
+		return;
+	}
+
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
_

Patches currently in -mm which might be from liuye@kylinos.cn are


