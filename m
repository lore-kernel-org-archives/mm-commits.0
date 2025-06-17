Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078EE2957AD
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 23:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750202398; cv=none; b=GE0t8ckDGTX2+Q5ip6hmNLKHLOZNGrCwEW1+vREh6ZtwMiYXV+4hJvvbv5NyLGPMT1Lx4cxwpIW0Tv+m/zZ9V+55dYBTelrcaXV2EygsBihes48aRKbGsYFaMKaxxRsgityywlDMQcF5oTk3Nh05sOW0DF3pFQi4Tn8pdUqKo5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750202398; c=relaxed/simple;
	bh=QgXnrJ552fcMC4/wSYg3ddt/fi6ufal+JxFZ6KbWiM8=;
	h=Date:To:From:Subject:Message-Id; b=siwtLC1YpovzxinixefRy80AL5sofbbB6FgWY2koimRwXdH0p6QeSXXXXTQeUr0/NJv4R5KpjsndCvmo1JhaM705Q2ok2JRNzYAbEHFPumZztMqnBqjcC/dO1op5HdM/pkiu3E6qZLb6mUnGvekkw3sIcF8wQnWvKWHeg9C1/xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hkmK7n/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hkmK7n/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838ABC4CEE3;
	Tue, 17 Jun 2025 23:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750202397;
	bh=QgXnrJ552fcMC4/wSYg3ddt/fi6ufal+JxFZ6KbWiM8=;
	h=Date:To:From:Subject:From;
	b=hkmK7n/UQIEo6ThIBPN5xYV3UREr3O3JUNYnK+6oJF/HGtJ7te2sWeXb7cozu3GoH
	 DZVAwSnq8YwD7kiU0RPg8I9vf0TnnA5+7/HrWAbR1hR8RocWpElHMw1qx+MCzxfpVd
	 OzGhNQq6YvbggWgZ8iRVsVlz+fE81QHf6qTBgjyM=
Date: Tue, 17 Jun 2025 16:19:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,Liam.Howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-stray-rmap-file-to-mm-rmap-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250617231957.838ABC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add stray rmap file to mm rmap section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-stray-rmap-file-to-mm-rmap-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-stray-rmap-file-to-mm-rmap-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
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
mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch
mm-nommu-use-file_has_valid_mmap_hooks-helper.patch
fs-consistently-use-file_has_valid_mmap_hooks-helper.patch
fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch
fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch
fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch
fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare.patch
fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch

