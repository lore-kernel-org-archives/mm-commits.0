Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7656EDDC1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186074; cv=none; b=TQoxUsD83mjxqFJSz7fT/M2aKO1QFg6ULjly1COuNwBetfaVjbfSpuXqdCMdm/EjHz9vRkIZKMuwaxrRvlFkHRdrRsC73ISEMNjJTrnALNj3e1AsjuxOY1bgFuEZhlWb5lZ5voT3A5AdFvwmAj+0Lo4Oo6IVaBNj2AR5hMlWMzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186074; c=relaxed/simple;
	bh=oxyW/5Ir+3nTU6lvB8HTqbbK5z0XWqTnVRUWrJpsNTU=;
	h=Date:To:From:Subject:Message-Id; b=QeYW0mPLeCnNtdQTcCZlepVIN5zgIny1FvfNgj7tsuGS1YQipa6bywe1mxO/LkLQNFBHV54asn7aPwuU3w58mTTLu9g0W8gnxEhAI6WoaNkcbLxamKj6FC3CA8UtkMuyIgEBqyj9ZkU7Jop4+2w77lniYVA+Oh8fjfjsNGq1L28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cPHslLJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cPHslLJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D636FC4CEEC;
	Mon, 17 Mar 2025 04:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186073;
	bh=oxyW/5Ir+3nTU6lvB8HTqbbK5z0XWqTnVRUWrJpsNTU=;
	h=Date:To:From:Subject:From;
	b=cPHslLJ3rI7RQypRu8TtIpjT1lWsyQyajUZWKV7mGg1YQSauJJ6RZ95IsZPlhLc1m
	 u6MbcKl0+7cumW22Id50uUJfP/lcusZxBXdGiv4pgHTvwydna3ZJf3HP7sCB5BNME0
	 VDZYmPoExWmlgCmCL2RlQLmWoEp+PYnCfoM5eyUc=
Date: Sun, 16 Mar 2025 21:34:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jhubbard@nvidia.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-rename-guard-pages-to-guard-regions-fix.patch removed from -mm tree
Message-Id: <20250317043433.D636FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/selftests: fix guard regions invocation
has been removed from the -mm tree.  Its filename was
     selftests-mm-rename-guard-pages-to-guard-regions-fix.patch

This patch was dropped because it was folded into selftests-mm-rename-guard-pages-to-guard-regions.patch

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
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-rename-guard-pages-to-guard-regions-fix
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -395,7 +395,7 @@ CATEGORY="mremap" run_test ./mremap_dont
 CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
 
 # MADV_GUARD_INSTALL and MADV_GUARD_REMOVE tests
-CATEGORY="madv_guard" run_test ./guard-pages
+CATEGORY="madv_guard" run_test ./guard-regions
 
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
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

