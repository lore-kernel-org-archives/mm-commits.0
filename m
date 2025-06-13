Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D992F433F
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 04:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749789461; cv=none; b=HT9G1aKJm46M9QNyWUwTmdzLSxN7uk/tFbLvIKqUQ6deno4JeZQh32kdci44r6QS+3nTQ/KE1D18twBHY4hTsyNUvayaW/JsrhYZaHVHZY9RBiN16Ait3UA8fiqsq0rtLVHtqcPyN3I5urozlINVpN4OU9DU45/3STapOrbjg80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749789461; c=relaxed/simple;
	bh=wCycmCaivO2xB9UQJ9QxvPdex1eql9Pilc5vcMffhck=;
	h=Date:To:From:Subject:Message-Id; b=ia169DizJS+xWnxPx5A7jYEE5AxrOi0vfNbmlT6QxfFSamU/Ntggt7thYLSLJ+ZXFH0X/q7bI6lPsiBkDIcUbhhgrfc6x62Db04eMXI52hk6e62+YuUNXyZLMvt/bc3iiX0RuYDH6dwADYkvbYuopF8pUnNJsHuk53To2LlzN44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IS4bHvHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IS4bHvHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB32C4CEE3;
	Fri, 13 Jun 2025 04:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749789460;
	bh=wCycmCaivO2xB9UQJ9QxvPdex1eql9Pilc5vcMffhck=;
	h=Date:To:From:Subject:From;
	b=IS4bHvHF8NUIxOU5hYiUoMzMw7KAaRdVtdxPxsaoG1Jc7DAkQ+Ab3S0f9n2mlKAXU
	 fpVZxT8oDQTJw1SHC/+5gxGAZVINZ/TfUuT2KNzGDNTjFB5Wq6nqkNg377CvYcQqd9
	 GYEXkZ8g6H4O2clGCnroqd8HitzaNDk02eUj70KQ=
Date: Thu, 12 Jun 2025 21:37:40 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch removed from -mm tree
Message-Id: <20250613043740.BEB32C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2
has been removed from the -mm tree.  Its filename was
     mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch

This patch was dropped because it was folded into mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2
Date: Tue, 10 Jun 2025 11:03:11 +0100

remove unused declarations

Link: https://lkml.kernel.org/r/ac3ae324-4c65-432a-8c6d-2af988b18ac8@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/vma.h~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2
+++ a/mm/vma.h
@@ -617,8 +617,4 @@ int create_init_stack_vma(struct mm_stru
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
 #endif
 
-struct vm_area_desc *vma_to_desc(struct vm_area_struct *vma,
-		struct vm_area_desc *desc);
-void set_vma_from_desc(struct vm_area_struct *vma, struct vm_area_desc *desc);
-
 #endif	/* __MM_VMA_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
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

