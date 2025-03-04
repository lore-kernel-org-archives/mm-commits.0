Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA31E13B58B
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 01:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053422; cv=none; b=CCKRi60ER/iAS5RT/Pe4DgK/C7waCP2B6bPA0OyF1vl9QX01SH+WKs3unNSTInU++ZbIDsLbOQ9R9+vlRW4MgNlWrYVxf2P38KxXeGE1xgR1ALlsmDTaQJggqJ9lJaZ5qiNSA8y7RTcVMWxySeG2GoMaSM2TKtRPHoAfHmUK/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053422; c=relaxed/simple;
	bh=BJ5ydr5iFxq5WZwBbo81MCwywz5A6BJIMthn/rKemDY=;
	h=Date:To:From:Subject:Message-Id; b=briEZApzzYZDgqf81tE1QGwVVIVG6+73DADFSJCzoHsVHwCMLzcN/LLfLYSi4YAgOYi70E7GGdRrr2uVxOhD1oKQ4e/zZjk/cy4ct9CVAKKkpDuknO9o35lFeoZ3s1xjac85BLiyVEp7zfllUX5ZdsV2pojtvFjWHgRI7lPtmFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EmPoTx1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EmPoTx1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06122C4CEE4;
	Tue,  4 Mar 2025 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741053422;
	bh=BJ5ydr5iFxq5WZwBbo81MCwywz5A6BJIMthn/rKemDY=;
	h=Date:To:From:Subject:From;
	b=EmPoTx1xKiTVhwQntgtx6OR00+RqQUw6Pc6sWSpauCtGErQBCOJrRzOEXEmloHdCv
	 s7jNuwCdGJWWCJkGC6A43iTZ8K7VmAfRGlISk9aIy6lDJJmkDL5opk2mi2ehE9aXjW
	 UBkMO6OJx5nMS0PdsYlJjpYW6SeyRq89WxuQ1/PE=
Date: Mon, 03 Mar 2025 17:57:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jhubbard@nvidia.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-rename-guard-pages-to-guard-regions-fix.patch added to mm-unstable branch
Message-Id: <20250304015702.06122C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/selftests: fix guard regions invocation
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-rename-guard-pages-to-guard-regions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-rename-guard-pages-to-guard-regions-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: tools/selftests: fix guard regions invocation
Date: Sun, 2 Mar 2025 08:31:57 +0000

Link: https://lkml.kernel.org/r/13426c71-d069-4407-9340-b227ff8b8736@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-rename-guard-pages-to-guard-regions-fix
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -393,7 +393,7 @@ CATEGORY="mremap" run_test ./mremap_dont
 CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
 
 # MADV_GUARD_INSTALL and MADV_GUARD_REMOVE tests
-CATEGORY="madv_guard" run_test ./guard-pages
+CATEGORY="madv_guard" run_test ./guard-regions
 
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-abort-vma_modify-on-merge-out-of-memory-failure.patch
mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
selftests-mm-rename-guard-pages-to-guard-regions-fix.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch
mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

