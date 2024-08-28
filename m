Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD21715B125
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 09:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724836887; cv=none; b=KU9TMoN7oYdqX76Z43FjI7UYAxjU9VyfLmawlF94lucL5kdY3wZfqjqIWo51JWGaPfVAaUNyr2P8mQtXxb4cxG+457MGAlvURKOYhU9/oDYwj1j5xSMS6r4R+Roe8F+vKvVcGgyULOUfQ0FavNtj80sbRAJlv/zPCQbGRZa5Vzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724836887; c=relaxed/simple;
	bh=hUAJcu6XvIHV/Qng0ccoWXbVG6HnuXHYt4dwtXTHSus=;
	h=Date:To:From:Subject:Message-Id; b=BeDjCRzI+yO+iQ+PMX4shkt+XoILYLBpDOnOfPF09ld/gQq8cOj+4ZU2mVoyA3EFlwUWRHvfI9nRzEQsVokHDg6b4zcyOkbCP+NXdlVpYTbay9GKPRwLPZMVT1TYjf7uVMWH2zd0JAEOGhJeY4bUx3cMLY+wqfusJpjv5jefTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2WmH1+DA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2WmH1+DA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813ECC8BFE8;
	Wed, 28 Aug 2024 09:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724836885;
	bh=hUAJcu6XvIHV/Qng0ccoWXbVG6HnuXHYt4dwtXTHSus=;
	h=Date:To:From:Subject:From;
	b=2WmH1+DAP/eKxvl+tkB+ba6mDS5D3O0gCAq2DOjSvBrVka9gel2NLzRSKkkInM2la
	 5K2AySNnBh2ap6aUgaY0Ljrs7S3zOiDat9Pd7I6FjZQUvP1V/Ow0TSh7eAHIxsTlcG
	 I3SCkVmCYXnl9a8h9+ftYuQeaLWfhlIFzl+4rCy4=
Date: Wed, 28 Aug 2024 02:21:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-duplicated-include-in-vma_internalh-fix.patch removed from -mm tree
Message-Id: <20240828092125.813ECC8BFE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fixup vma.h for nommu
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicated-include-in-vma_internalh-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: fixup vma.h for nommu
Date: Sun, 25 Aug 2024 12:29:47 +0100

Some series of includes result in vma.h being imported by nommu under
certain circumstances, which references FIRST_USER_ADDRESS and
USER_PGTABLES_CEILING, neither of which are necessarily defined in a nommu
scenario.

Work around this by wrapping the inline function which references these
(init_vma_munmap()) in an #ifdef CONFIG_MMU.

Link: https://lkml.kernel.org/r/7d0ea994-f750-49c5-b392-ae7117369cf3@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vma.h~mm-remove-duplicated-include-in-vma_internalh-fix
+++ a/mm/vma.h
@@ -225,6 +225,7 @@ static inline int vma_iter_store_gfp(str
 }
 
 
+#ifdef CONFIG_MMU
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
@@ -255,6 +256,7 @@ static inline bool is_data_mapping(vm_fl
 {
 	return (flags & (VM_WRITE | VM_SHARED | VM_STACK)) == VM_WRITE;
 }
+#endif
 
 
 static inline void vma_iter_config(struct vma_iterator *vmi,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-avoid-using-vma_merge-for-new-vmas-fix.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

