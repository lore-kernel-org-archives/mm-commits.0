Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCDA2264A6
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 22:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750114239; cv=none; b=RWOT+DfCVfeW0yyMg4njSHSOiYA8SJa53lJVtKHE9uiL0Aj++t3WR8m8oLyKWU7DjPfUEo5816ztuDoG6xpmOpQCsxHVMP4/fk51SrGc+HUV9oqGJHwLFL8IFonZZmDUqOrVAEdOP0fA/fsPpZksNnB5A3GVxK/LimFIIrNFIqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750114239; c=relaxed/simple;
	bh=BiNvgdGPfs619gVwMoEEK4RGH5PjrPQoMS6ekvse1iI=;
	h=Date:To:From:Subject:Message-Id; b=WTgaz4IrOHRZ5BvniXFFgJZeKfiVUfIdjkH0X30pzChFvs+J+5Aiuq2HfIBFxuPQnpG+Lh1OovK7VZnPBr3P1i3NVeMpOXk6kdQVBWfMEh7ip1rLj+FpKCAAsMTIQAM6SuP4ZmCEoIUqAOmSziEIs2E33I+1D/Vi16cpxAdxoz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sneZ0T2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sneZ0T2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDA0C4CEEA;
	Mon, 16 Jun 2025 22:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750114237;
	bh=BiNvgdGPfs619gVwMoEEK4RGH5PjrPQoMS6ekvse1iI=;
	h=Date:To:From:Subject:From;
	b=sneZ0T2r2B9GfOPupnsILSZfz+IxWXlqUBe3lFwpiv53zmMfsZUXKuXFTOiJz4tHf
	 k7LV2i7Mg+3nIrbbj9itPH4IF5fXkh/7M8vxNbXhkQdQN4eqKo4SizaJzzVP6KScZ/
	 rYyb6pX1EYV6GsBbgcc0B9m+peAscywz/wjO/E9A=
Date: Mon, 16 Jun 2025 15:50:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + secretmem-remove-uses-of-struct-page-fix.patch added to mm-new branch
Message-Id: <20250616225037.0BDA0C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix check of filemap_lock_folio() return value
has been added to the -mm mm-new branch.  Its filename is
     secretmem-remove-uses-of-struct-page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/secretmem-remove-uses-of-struct-page-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fix check of filemap_lock_folio() return value
Date: Mon, 16 Jun 2025 14:56:27 +0100

Link: https://lkml.kernel.org/r/fdbca1d0-01a3-4653-85ed-cf257bb848be@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>\
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~secretmem-remove-uses-of-struct-page-fix
+++ a/mm/secretmem.c
@@ -65,7 +65,7 @@ static vm_fault_t secretmem_fault(struct
 
 retry:
 	folio = filemap_lock_folio(mapping, offset);
-	if (!folio) {
+	if (IS_ERR(folio)) {
 		folio = folio_alloc(gfp | __GFP_ZERO, 0);
 		if (!folio) {
 			ret = VM_FAULT_OOM;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch

