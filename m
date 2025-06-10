Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D5265CAF
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588764; cv=none; b=BENtsx9AV7zSjZCRjiVSFDtADnNUMYz/xxiYWKkAtTqPKFu2XE30qu4HO69ylP0LL0ECmMmRF0ANlTV92EuDnDwvNKdCXpLHQ25PJaIaAqmqyKsVmXSfQ5e8IzVSLvNBw7f6gfLhdT16b8HBPbLtZ0oP84h86RNpWS0TZwwz4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588764; c=relaxed/simple;
	bh=i/2rNfRb7AoOuxsBKg73ZzlpQDgeZUkwqrzfZ/pApdQ=;
	h=Date:To:From:Subject:Message-Id; b=li+KIZzhl2bwGTVwREq5K5B5KF9wqXAKvEPkUSPDNhvW3Vxm+JxhsixFpnE4Rdje69UT4k8JjTB58tzqULfTCTk7iVsC67Nz1rbN1Lxzvq8aJxNrutw45+C+UvCkdqf3AYORaGm+6w6FBHVAl+G7J/SwM3im1dBVlgfbLG/gMMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gYBikhmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gYBikhmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1722C4CEED;
	Tue, 10 Jun 2025 20:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588763;
	bh=i/2rNfRb7AoOuxsBKg73ZzlpQDgeZUkwqrzfZ/pApdQ=;
	h=Date:To:From:Subject:From;
	b=gYBikhmBGc72xOvxxECn6lQ2wmIw5p05on2ZfKuZFpYBrDwN9Ks0LmabT/g4zNIVL
	 R5n9XRZW7bm+wcgGd5qgeKXoRS23dfh2EktM6DOknL0omDIqQNRb7dhn9YciOrkM7R
	 kDm8aFuStO0q8WULQqvMRJPiJELUBMm60LVtktFo=
Date: Tue, 10 Jun 2025 13:52:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch added to mm-new branch
Message-Id: <20250610205243.A1722C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools UAPI: Update copy of linux/mman.h from the kernel sources
has been added to the -mm mm-new branch.  Its filename is
     tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch

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
Subject: tools UAPI: Update copy of linux/mman.h from the kernel sources
Date: Mon, 9 Jun 2025 14:26:38 +0100

Import newly introduced MREMAP_RELOCATE_ANON_* defines.

Link: https://lkml.kernel.org/r/ad488a05068ece234efca1ef025208b2aaa127cb.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/mman.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/tools/include/uapi/linux/mman.h~tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources
+++ a/tools/include/uapi/linux/mman.h
@@ -6,9 +6,11 @@
 #include <asm-generic/hugetlb_encode.h>
 #include <linux/types.h>
 
-#define MREMAP_MAYMOVE		1
-#define MREMAP_FIXED		2
-#define MREMAP_DONTUNMAP	4
+#define MREMAP_MAYMOVE			1
+#define MREMAP_FIXED			2
+#define MREMAP_DONTUNMAP		4
+#define MREMAP_RELOCATE_ANON		8
+#define MREMAP_MUST_RELOCATE_ANON	16
 
 #define OVERCOMMIT_GUESS		0
 #define OVERCOMMIT_ALWAYS		1
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
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

