Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA481E4110
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745262165; cv=none; b=mJR7lB3+6JrzUXQO8Xi99zZKgSD3YQkCn3QxfS3k/+c0+DUPmfsKlOCMdmkWxI3czWbL3aBgvzISYaPZM3BcBghmmbNe/v7Xp4ZwT84sXN9cY7WE2vsOJGVCN0/9722v1kZzjM6lH/qqxZKfh1ulQny+hkaN4GxZ1VNlcwcQyao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745262165; c=relaxed/simple;
	bh=s4t0JmhdDbHbL5rr749vp2C404Y93VgUZbx4vGL5wnw=;
	h=Date:To:From:Subject:Message-Id; b=ArLVpCUKBzCkPyQrPEVzXNMemMj2AIMSwjLAOa/Oib7v/w0jt6AOQtiey5gMwSYEgwTzYLnHrLVQ5ijnfnkM4SizPlXc2MpKDDO6+10EMrmP1FimQJWytPzCjOuHNb8ZvZw35zAcX21Kqg/vbhRGdBmrISwV62r5lJ61J4CM8bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hFekTb8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hFekTb8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C5AC4CEE4;
	Mon, 21 Apr 2025 19:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745262163;
	bh=s4t0JmhdDbHbL5rr749vp2C404Y93VgUZbx4vGL5wnw=;
	h=Date:To:From:Subject:From;
	b=hFekTb8zXjPTfFV63bfaLXez4/neaQz8KE7NCE+XuPZVeDV8TxpX//mHxa0vq5jwB
	 MM2/MuGNG1qNgU4sgmNe2oKjA2QEPeKEvMODKkHcwpIUlQFq+jEk+7j/mHhewLSKRI
	 p6+WeUCG6hh3xh2nMDYlYMkzvEpvZp/yRz0bd9N4=
Date: Mon, 21 Apr 2025 12:02:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch added to mm-new branch
Message-Id: <20250421190243.80C5AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: rename page__anon_vma to anon_vma for consistency
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/rmap: rename page__anon_vma to anon_vma for consistency
Date: Mon, 21 Apr 2025 16:57:28 +0800

Patch series "mm: minor cleanups in rmap", v3.

Minor cleanups in mm/rmap.c:

- Rename a local variable for consistency
- Fix a typo in a comment

No functional changes.


This patch (of 2):

Rename local variable page__anon_vma in page_address_in_vma() to anon_vma.
The previous naming convention of using double underscores (__) is
unnecessary and inconsistent with typical kernel style, which uses single
underscores to denote local variables.  Also updated comments to reflect
the new variable name.

Functionality unchanged.

Link: https://lkml.kernel.org/r/20250421085729.127845-1-ye.liu@linux.dev
Link: https://lkml.kernel.org/r/20250421085729.127845-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency
+++ a/mm/rmap.c
@@ -789,13 +789,13 @@ unsigned long page_address_in_vma(const
 		const struct page *page, const struct vm_area_struct *vma)
 {
 	if (folio_test_anon(folio)) {
-		struct anon_vma *page__anon_vma = folio_anon_vma(folio);
+		struct anon_vma *anon_vma = folio_anon_vma(folio);
 		/*
 		 * Note: swapoff's unuse_vma() is more efficient with this
 		 * check, and needs it to match anon_vma when KSM is active.
 		 */
-		if (!vma->anon_vma || !page__anon_vma ||
-		    vma->anon_vma->root != page__anon_vma->root)
+		if (!vma->anon_vma || !anon_vma ||
+		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
 	} else if (!vma->vm_file) {
 		return -EFAULT;
@@ -803,7 +803,7 @@ unsigned long page_address_in_vma(const
 		return -EFAULT;
 	}
 
-	/* KSM folios don't reach here because of the !page__anon_vma check */
+	/* KSM folios don't reach here because of the !anon_vma check */
 	return vma_address(vma, page_pgoff(folio, page), 1);
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch
fs-proc-page-refactoring-to-reduce-code-duplication.patch
mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch

