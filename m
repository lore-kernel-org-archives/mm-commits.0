Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7034F29C327
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 22:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782857773; cv=none; b=stwK5/oB++nWfnflX5uR1uKBGBNPjB2TyReU60kNqQCtw9/FbKhkcdBHYfuU7f+a09wbUNUTqhgKPW1iDfAuZtCQp3dGDd6xe6i2iReDwKGw80bl4uvyfUw6pt86zbK7ADnisrznhAr9lxFJF1qK4s3jaCdLJSVmsMjllRC1dho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782857773; c=relaxed/simple;
	bh=W8wE64xrLMtgmMuTtYN8MlMF9ZALJpxH6GXvmtnvbxc=;
	h=Date:To:From:Subject:Message-Id; b=VsOLD0rmRUsHYFB0tXBEDONqisqebNotq3X5WXD9Pvpx9a07FWTHJXEl8UGbhuGWwpXfGVpuDdMVzvAQ+TWCMrh/HCClgn41xhntzHFtbVvlZI66IKe4A+vP+sA0ASqKOEE/VkZE2Yn/IzZR7pmTqjVf4PMnDsKz+ryn0liZ0VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a6KJuVLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a6KJuVLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E663E1F000E9;
	Tue, 30 Jun 2026 22:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782857772;
	bh=HhBnoFcchIEnzf8j1rsKMnAOa42YwIo9mAWZ786PN3g=;
	h=Date:To:From:Subject;
	b=a6KJuVLDI+hJJrAHCUbruMuZo5bSk4qsd5GAV14gDjZiVVxTjzTm7aFjHOVyD9COS
	 +1nobBiqen/JyRcLUHS6Z7HmO2FbcFuF1WSDK74+UOBLtJ6n0hNd50YPeh61jrp66N
	 QtPECRldFACIZlS8E4lrrImyv/ys2DR0YTquA7Xs=
Date: Tue, 30 Jun 2026 15:16:11 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sj@kernel.org,rdunlap@infradead.org,ljs@kernel.org,david@kernel.org,manuelebner@mailbox.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-mm-fix-braces.patch removed from -mm tree
Message-Id: <20260630221611.E663E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: fix braces
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manuel Ebner <manuelebner@mailbox.org>
Subject: docs/mm: Fix braces
Date: Mon, 29 Jun 2026 18:11:56 +0200

Correct typos in mm documentation by balancing parentheses.

Link: https://lore.kernel.org/20260629161156.90213-2-manuelebner@mailbox.org
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hmm.rst           |    4 ++--
 Documentation/mm/process_addrs.rst |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/hmm.rst~docs-mm-fix-braces
+++ a/Documentation/mm/hmm.rst
@@ -191,7 +191,7 @@ like a CPU page fault. The usage pattern
       mmap_read_unlock(mm);
 
       take_lock(driver->update);
-      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
+      if (mmu_interval_read_retry(&ni, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -316,7 +316,7 @@ between device driver specific code and
    system memory and device private memory.
 
    One of the first steps migrate_vma_setup() does is to invalidate other
-   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
+   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
    ``mmu_notifier_invalidate_range_end()`` calls around the page table
    walks to fill in the ``args->src`` array with PFNs to be migrated.
    The ``invalidate_range_start()`` callback is passed a
--- a/Documentation/mm/process_addrs.rst~docs-mm-fix-braces
+++ a/Documentation/mm/process_addrs.rst
@@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!
 
 Since it is assumed that all such steps have been taken, page table entries are
 cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
-:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
+:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).
 
 .. note:: It is possible for leaf page tables to be torn down independent of
           the page tables above it as is done by
_

Patches currently in -mm which might be from manuelebner@mailbox.org are


