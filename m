Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F157394
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102721; cv=none; b=ZrX16SYdFog6+Iep2R/+rBdjea6riYJ7DrAiR6rSV8wHdmOpuPmoXhXJduBghV0peyJsdTF3LxQyBADH+sPvRGXwOB529rLXHsBNvPFVKhoIB0zojCA+XFAqjc3O1Tk7BCUDBYppxxV7sQrHDbRmsNTeUuVlWnSQB+ydheqygJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102721; c=relaxed/simple;
	bh=6wJBySXOAc7ssOernkzTR2ofO+b8jlUorUCxk5SNucc=;
	h=Date:To:From:Subject:Message-Id; b=kr+pAZFepMdbOTI1UyiP+Uh2gKvsjC6RcHtvq/2+ZJg5AoQTuXt2eaN51eFSH5QXA4VUJxyX3qTovX4zjtzkaI3FvFioyUm/USdJC4seWm4NoxXaDJ6JEA2m7IKeTHe9BRBUkQ1EFYlmqib6odtMPy3Bxm6LFZtaOjYp+FRr8Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ol1bw6Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ol1bw6Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8697AC113CD;
	Fri, 26 Apr 2024 03:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102720;
	bh=6wJBySXOAc7ssOernkzTR2ofO+b8jlUorUCxk5SNucc=;
	h=Date:To:From:Subject:From;
	b=ol1bw6Ccuzu94is9P5wYQV75uUbqnbbMsEm6BJsT0Fo3LxMZsvj2kdrBkZZJcdMPd
	 HTam/LIWnDzKJ28Cgu2sa1ZNPFTXr5UCoqVAG7lULr/fN2P7VHOPlbdwd5j5zyEal9
	 poXhthBXrsnPZFilPJ5RpJuxQD+YzEEQwdAUbtFc=
Date: Thu, 25 Apr 2024 20:38:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-arch-provide-pud_pfn-fallback-fix.patch removed from -mm tree
Message-Id: <20240426033840.8697AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! mm/arch: provide pud_pfn() fallback
has been removed from the -mm tree.  Its filename was
     mm-arch-provide-pud_pfn-fallback-fix.patch

This patch was dropped because it was folded into mm-arch-provide-pud_pfn-fallback.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm/arch: provide pud_pfn() fallback
Date: Tue, 2 Apr 2024 21:32:49 -0400

fix loongson defconfig

Link: https://lkml.kernel.org/r/20240403013249.1418299-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-arch-provide-pud_pfn-fallback-fix
+++ a/include/linux/pgtable.h
@@ -1824,9 +1824,13 @@ typedef unsigned int pgtbl_mod_mask;
  * code.  Now it happens too for pud_pfn (and can happen for larger
  * mappings too in the future; we're not there yet).  Instead of defining
  * it for all archs (like pmd_pfn), provide a fallback.
+ *
+ * Note that returning 0 here means any arch that didn't define this can
+ * get severely wrong when it hits a real pud leaf.  It's arch's
+ * responsibility to properly define it when a huge pud is possible.
  */
 #ifndef pud_pfn
-#define pud_pfn(x) ({ BUILD_BUG(); 0; })
+#define pud_pfn(x) 0
 #endif
 
 /*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch
mm-free-non-hugetlb-large-folios-in-a-batch-fix.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

