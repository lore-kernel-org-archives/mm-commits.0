Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2784D322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391365; cv=none; b=Te4IPMvr5iNc+krVLkE9p7Y6CgSDGf/ErVSV51dmHgpMzWKjs26EF5AYwWvVvWhcGu0+9Te1pg7zP2zGXOybkTNW/2FamgEh1n6U1ToMOSQaupO+6MZf652GVDqSuKGMC8eNQ7RopvNN3YLkkAqj/Fo0KVegLfS198g4c5I9PQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391365; c=relaxed/simple;
	bh=Al/e1mubBLShTBLgXpdyPojyeuWlEUaNgonwLB9YLjs=;
	h=Date:To:From:Subject:Message-Id; b=FnR11MVc3tL41mNdUU/maBFReRXWLQqtoJpdrnER9hXNVwAdVLeV1ght9r+tbn0viEcYT+W9uvuFJx6xlJIXsPtdSATn5B1o16mYqvsOG3dl8dBUw5e1l3N112pe0tX3gz4SfeNmPtLlBSfnwFx59SZ+PcwCB3qYuoNThP326SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rsSCsGoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rsSCsGoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB51C4CEE3;
	Fri, 20 Jun 2025 03:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391364;
	bh=Al/e1mubBLShTBLgXpdyPojyeuWlEUaNgonwLB9YLjs=;
	h=Date:To:From:Subject:From;
	b=rsSCsGoFEVfDByA6KPnVHIFnzZDvXr4Se/RGJDJH5oA5qnXfvgIdUcf+MzPLo23JG
	 Dnl4gPxHAu53qUi5tRKV2OI9CyXQTYJvo5KxYrtr3VdORgVfnOzPHTlN6bbUHBKzEW
	 ZAxe0NVvXRiwBb1uYXL6WJ7zLOTbYYD2KKwoOn+8=
Date: Thu, 19 Jun 2025 20:49:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,Liam.Howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-stray-rmap-file-to-mm-rmap-section.patch removed from -mm tree
Message-Id: <20250620034924.AAB51C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add stray rmap file to mm rmap section
has been removed from the -mm tree.  Its filename was
     maintainers-add-stray-rmap-file-to-mm-rmap-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add stray rmap file to mm rmap section
Date: Tue, 17 Jun 2025 17:51:42 +0100

page_vma_mapped_walk() is used to traverse page tables from a VMA, used by
rmap logic once the reverse mapping has been traversed to the VMA level.

It is also used by other users (migration, damon, etc.) but is primarily
used by the reverse mapping and is a key part of its logic, so it seems
appropriate to place it here.

Link: https://lkml.kernel.org/r/20250617165142.173716-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-stray-rmap-file-to-mm-rmap-section
+++ a/MAINTAINERS
@@ -15893,6 +15893,7 @@ R:	Harry Yoo <harry.yoo@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
+F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
 
 MEMORY MANAGEMENT - SECRETMEM
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-files-to-mm-page-alloc-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
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

