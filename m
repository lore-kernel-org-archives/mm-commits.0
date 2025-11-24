Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CBB274FF5
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024851; cv=none; b=gLIRlvDELBMxbL99GCul6OMuPNVBEGrYZZgXZXDp59syIO1+hTNJx6Qy6+BlW/1YhlQ1KRnzqA1EDFElLVNsgBOp6UkHh/V9I6+LvVlzYTf0hVxQ2FgdSZQoj+IG7+sAxMf4g+oYdzMTw9BdUvk3L1fK3Hf8DWgepMSZzVf4E/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024851; c=relaxed/simple;
	bh=QbPTShvBrzj9qNNjXEFeIo+jqQzM/HDoiZEEDteNDYo=;
	h=Date:To:From:Subject:Message-Id; b=hDEizKNkiycfxz5kJm8vMJMFV21keTVyWaj0hnNP1GnnEQJDNthd0vtvrcDjiKaG4W8rnVy7vbSjvJwIIoNx35nPww1m5eKKlXs4EExlDfpdJIWOcGA4M1qn1Hp1kg1xeEd/mxyXnUJhmBDiN8QbHshOwe67hn1/SNQhjG4Y4mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2F7hRNDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2F7hRNDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8EAC16AAE;
	Mon, 24 Nov 2025 22:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764024850;
	bh=QbPTShvBrzj9qNNjXEFeIo+jqQzM/HDoiZEEDteNDYo=;
	h=Date:To:From:Subject:From;
	b=2F7hRNDQWtM123tV2oRKbBnzdrZ5kGRuRNRKKLy+a1zDp2B1XqJAmJTVQyw64laXa
	 k8rCX5WRnMH672zq4jPADBZY4gmhnwNZxIdoXV/WNwG8kt55qg08hVdGvNm+PF1B3G
	 ZnoNZlRB1YGpSxpB/PXClG4mYPrdCTebBprqNc14=
Date: Mon, 24 Nov 2025 14:54:09 -0800
To: mm-commits@vger.kernel.org,zhangchunyan@iscas.ac.cn,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch removed from -mm tree
Message-Id: <20251124225410.6A8EAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-softdirty-add-pgtable_supports_soft_dirty-fix
has been removed from the -mm tree.  Its filename was
     mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch

This patch was dropped because it was folded into mm-softdirty-add-pgtable_supports_soft_dirty.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-softdirty-add-pgtable_supports_soft_dirty-fix
Date: Fri, 21 Nov 2025 16:55:37 +0000

fix VMA selftests

Link: https://lkml.kernel.org/r/dac6ddfe-773a-43d5-8f69-021b9ca4d24b@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/vma/vma_internal.h~mm-softdirty-add-pgtable_supports_soft_dirty-fix
+++ a/tools/testing/vma/vma_internal.h
@@ -212,6 +212,8 @@ typedef __bitwise unsigned int vm_fault_
 
 #define ASSERT_EXCLUSIVE_WRITER(x)
 
+#define pgtable_supports_soft_dirty() 1
+
 /**
  * swap - swap values of @a and @b
  * @a: first value
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-softdirty-add-pgtable_supports_soft_dirty.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

