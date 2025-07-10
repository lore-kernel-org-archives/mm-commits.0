Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D3469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122469; cv=none; b=QzZNW8OZmQncMVGp7hHYobOazBtj9JNcmPp1sb9yYo0983ke8G5E+aQ/ja7z4UT0odyJrRHXQhR5GXK2Sxra+a7ND/w9hMVjhu8afpZwT3p6kSE8wvEWs8wTulCyc4x+Se0gIg+/4bmKRWkhi/vR7Qmuq+q+b3V/ph23fWWJJI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122469; c=relaxed/simple;
	bh=LvAyQr3RIv9ohDUKAKowsHFylWwFJOGz8oBGZcPTkxc=;
	h=Date:To:From:Subject:Message-Id; b=sL43ipjElmq6dCSKN1exPfP+LEPdUEAXVWdvOS39VzE68cNRkf7txyW11fZ1mr5euSTxo5zb6srfdFyDW3bgeI22ouBEwFfpyPJK59Y64AqR8jxHc6dmiRs1ThBTAGCLQEG6eoLSGUD1X5+xbJt6i6nYVqIEfocTSjdXCJoHWqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g5FcKW4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g5FcKW4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51870C4CEE3;
	Thu, 10 Jul 2025 04:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122469;
	bh=LvAyQr3RIv9ohDUKAKowsHFylWwFJOGz8oBGZcPTkxc=;
	h=Date:To:From:Subject:From;
	b=g5FcKW4ApqmX79d9T3KmzflMVqhPpAhVRSZk22ObxI/g4oFXHWuopMRTSWfQz1rYe
	 2vEsBM2GPESr/EytDT72+EdHjlOm0X7IMbQGO8x6vYvcShB9RFGIOpmWGEL6cP/9OI
	 JMx0Bjf/8OmQeWlZwX/NVJOYTxWYFc8OMWgUtkkc=
Date: Wed, 09 Jul 2025 21:41:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] secretmem-remove-uses-of-struct-page-fix.patch removed from -mm tree
Message-Id: <20250710044109.51870C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix check of filemap_lock_folio() return value
has been removed from the -mm tree.  Its filename was
     secretmem-remove-uses-of-struct-page-fix.patch

This patch was dropped because it was folded into secretmem-remove-uses-of-struct-page.patch

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
secretmem-remove-uses-of-struct-page.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

