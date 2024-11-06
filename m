Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8D1311AC
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854886; cv=none; b=GA1yfEdR6+rDEs8wBrGyB10wt6safOfdkL5x8EwxhiUZTIFWQQLM2rwFtAlAIFeafy4lVZ0ILbC4zi8FSiT17dAFZwqChc9Jklc+63LSDGM395dAy/IN7gOeaAo6uSOlEBS8nngR3nThJwhMERUzNpcftV0sWxY6cm9FrPVOYQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854886; c=relaxed/simple;
	bh=g0PthcTGOPs/yjnHwD9xJWwd/0X04BetGjDDhQAJYyM=;
	h=Date:To:From:Subject:Message-Id; b=XJ15AzFm4TcyvNEFjy3/5Jd3c4ESnLHQIxDKtXv+YD4PM3KQnJiDnQFdo2c8RV+bxNF4jAxVJBjm/2oKiv9TL1UjO4JZfVmq3SBuSBWlgtNdSV2bQIXZFGazyHLVOs0zguAJumIIVdA9DpXCTFiQq6MOJQducazTa2vPyknBdYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KHg+ca7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KHg+ca7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBA3C4CECF;
	Wed,  6 Nov 2024 01:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854886;
	bh=g0PthcTGOPs/yjnHwD9xJWwd/0X04BetGjDDhQAJYyM=;
	h=Date:To:From:Subject:From;
	b=KHg+ca7FkgUIBNvSBy7H9moFN4gf5ejadtOGRwaXhAqQX5SyRcSadKdMLD68G11dC
	 +JDOgsUI7aiiSmJgsyiiiP4CrpJmv3difsNfNs6J2VzZMuj0aqpe7RrSSygxMBLgFg
	 V/QlEi3s1W3Yv1fjZmSPGi/Oi/YTWwla/RG5jnpc=
Date: Tue, 05 Nov 2024 17:01:25 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch removed from -mm tree
Message-Id: <20241106010125.ECBA3C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unnecessary reset state logic on merge new VMA
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove unnecessary reset state logic on merge new VMA
Date: Fri, 25 Oct 2024 13:26:26 +0100

The only place where this was used was in mmap_region(), which we have now
adjusted to not require this to be performed (we reset ourselves in
effect).

It also created a dangerous assumption that VMG state could be safely
reused after a merge, at which point it may have been mutated in
unexpected ways, leading to subtle bugs.

Note that it was discovered by Wei Yang that there was also an error in
this code - we are comparing vmg->vma with prev after setting it to NULL.

This however had no impact, as we previously reset VMA iterator state
before attempting merge again, but it was useless effort.

In any case, this patch removes all of the logic so also eliminates this
wasted effort.

Link: https://lkml.kernel.org/r/5d9a59eee6498ae017cc87d89aa723de7179f75d.1729858176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/vma.c~mm-remove-unnecessary-reset-state-logic-on-merge-new-vma
+++ a/mm/vma.c
@@ -963,7 +963,6 @@ struct vm_area_struct *vma_merge_new_ran
 	struct vm_area_struct *next = vmg->next;
 	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
-	pgoff_t pgoff = vmg->pgoff;
 	pgoff_t pglen = PHYS_PFN(end - start);
 	bool can_merge_left, can_merge_right;
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
@@ -1020,16 +1019,6 @@ struct vm_area_struct *vma_merge_new_ran
 		return vmg->vma;
 	}
 
-	/* If expansion failed, reset state. Allows us to retry merge later. */
-	if (!just_expand) {
-		vmg->vma = NULL;
-		vmg->start = start;
-		vmg->end = end;
-		vmg->pgoff = pgoff;
-		if (vmg->vma == prev)
-			vma_iter_set(vmg->vmi, start);
-	}
-
 	return NULL;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

