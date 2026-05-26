Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A222571B8
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813542; cv=none; b=H+LQqG5mRUlYFGiPPgxC8p/F9pxlrix7L1AB7FT31lkLLti3hDhPf4GMEJEyuWiUrioCW+ohSFSaEy0vnGRjoLwJ2brPn9guFueDOBs+3nE/QxYHyS/fusqGaKDYmKbEiQwB7ITb3bQAn9iKimHyOk40bKp62I/YVN2FoxYHgU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813542; c=relaxed/simple;
	bh=9OrEOlXXQ+SH4q6LIalLq7yhVKEkhrFx4127lIld0GI=;
	h=Date:To:From:Subject:Message-Id; b=vEIAFcA285puEAl7ZfvZ5pJW2FxvvCc/LD948kiK7zsQinu2iMhNrjznBTky/f2yDJmDxGUATsePZ3Xuu3WBwaUr9nn8G9NQa4HGSViU8333Z9IB5Pn8k0mQ7F0YhOnQqP2SnBIxywPm1mANiSQNqlqxU9L9bNwQiiA/aXj3Hxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nxe5b/UJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nxe5b/UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA931F000E9;
	Tue, 26 May 2026 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779813540;
	bh=02FSbFeCjoIep0BqHQSe1tqlDqViu/60VGMPk3mxoOM=;
	h=Date:To:From:Subject;
	b=Nxe5b/UJDcpOslLlRF3ZxYQtdjxlg9Lq3PiGdqP0fNpJU6dyfILJUYtWz4nAU+sij
	 RQylH2YJDqcQaRep6yzMB7nKQWhTXFe6ZRH1JryecNZtN5qOyfrZbF4uJhRNfPbJk+
	 bunfGEIfAGMPqK13r8zBRnvYMqiWZttAROvSreBk=
Date: Tue, 26 May 2026 09:38:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch added to mm-unstable branch
Message-Id: <20260526163900.4EA931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: add a clarifying comment and change warn_on
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: add a clarifying comment and change warn_on
Date: Tue May 26 05:54:04 2026 -0600

Add a clarifying comment describing how the locking/mmu notifier is
handled and change the WARN_ON_ONCE to VM_WARN_ON_ONCE per davids
suggestion.

Link: https://lore.kernel.org/a48032dd-7881-43c0-b439-5cda6124ea58@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix
+++ a/mm/khugepaged.c
@@ -1284,6 +1284,13 @@ static enum scan_result collapse_huge_pa
 	anon_vma_lock_write(vma->anon_vma);
 	anon_vma_locked = true;
 
+	/*
+	 * Only notify about the PTE range we will actually modify. While we
+	 * temporary unmap the whole PTE table for mTHP collapse, we'll remap
+	 * it later, leaving other PTEs effectively unmodified. The locks we
+	 * hold prevent anybody from stumbling over such temporarily unmapped
+	 * PTE tables.
+	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
 				end_addr);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1349,7 +1356,7 @@ static enum scan_result collapse_huge_pa
 	 */
 	__folio_mark_uptodate(folio);
 	spin_lock(pmd_ptl);
-	WARN_ON_ONCE(!pmd_none(*pmd));
+	VM_WARN_ON_ONCE(!pmd_none(*pmd));
 	if (is_pmd_order(order)) {
 		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-introduce-mthp-collapse-support-fix.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

