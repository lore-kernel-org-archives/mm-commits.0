Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41834DDC1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186282; cv=none; b=lGu4ulobVieCm+NrpGn+HQETD6Oo5y9ibVmQwyJeFgQNp+cnSYidte5PA2L2ifS66hu3xg8mmWwg2LMDWWMdnP0u0hgTOtSfP1snIjXHSWzYx0dG/i/nZepY0EvcsgcsfcI995u+MCwlKbAod8p3uQsjyZdvefPnVMNnpM0V5is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186282; c=relaxed/simple;
	bh=BwlhA5I8/W2uAyHF+EyYeR8pqjYyuw/HkGKClCSieos=;
	h=Date:To:From:Subject:Message-Id; b=f7UeinheLVl7WX913s4E9NtFIX0MMSFbpMBvgkPq1XGvWuXiBEAIUM7s67UGBtbP4644VqC/KN9TtDekmOiEEjl+bqP432mr3jp1Wg9Ayv5kLb3yWRk1jUaqDLkEbAAWT2GAbk/k9Oll7kMLbBW/lbg+Q9cDpXPRpgqdcqG+IUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hvLV5OtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hvLV5OtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0007CC4CEEC;
	Mon, 17 Mar 2025 04:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186282;
	bh=BwlhA5I8/W2uAyHF+EyYeR8pqjYyuw/HkGKClCSieos=;
	h=Date:To:From:Subject:From;
	b=hvLV5OtMJ+OVbX/EHJqqNHgO3u88kChoiVDrd8RvuRUaQDQwEPSsL8jRkNuh6tLzG
	 2OQ33zQXmNLGZEgzpjnbbobys2k/IADDpRbusY4A6xHZh3Xi/Z8dFxZwOWGp8JidTb
	 Y9X9DkMlIRVXNg9MrLTJ0rBpdcqH7MuhQ3A+BiBQ=
Date: Sun, 16 Mar 2025 21:38:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,corbet@lwn.net,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch removed from -mm tree
Message-Id: <20250317043802.0007CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup define name
has been removed from the -mm tree.  Its filename was
     tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch

This patch was dropped because it was folded into tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fixup define name
Date: Fri, 21 Feb 2025 13:45:48 +0000

Fix badly named define so it's consistent with the others.

Link: https://lkml.kernel.org/r/32e83941-e6f5-42ee-9292-a44c16463cf1@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |    6 +++---
 tools/testing/selftests/mm/vm_util.h       |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -2054,7 +2054,7 @@ TEST_F(guard_regions, pagemap)
 	for (i = 0; i < 10; i++) {
 		char *ptr_p = &ptr[i * page_size];
 		unsigned long entry = pagemap_get_entry(proc_fd, ptr_p);
-		unsigned long masked = entry & PM_GUARD_REGION_MASK;
+		unsigned long masked = entry & PM_GUARD_REGION;
 
 		ASSERT_EQ(masked, 0);
 	}
@@ -2070,9 +2070,9 @@ TEST_F(guard_regions, pagemap)
 	for (i = 0; i < 10; i++) {
 		char *ptr_p = &ptr[i * page_size];
 		unsigned long entry = pagemap_get_entry(proc_fd, ptr_p);
-		unsigned long masked = entry & PM_GUARD_REGION_MASK;
+		unsigned long masked = entry & PM_GUARD_REGION;
 
-		ASSERT_EQ(masked, i % 2 == 0 ? PM_GUARD_REGION_MASK : 0);
+		ASSERT_EQ(masked, i % 2 == 0 ? PM_GUARD_REGION : 0);
 	}
 
 	ASSERT_EQ(close(proc_fd), 0);
--- a/tools/testing/selftests/mm/vm_util.h~tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -10,7 +10,7 @@
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
 #define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
 #define PM_UFFD_WP                    BIT_ULL(57)
-#define PM_GUARD_REGION_MASK          BIT_ULL(58)
+#define PM_GUARD_REGION               BIT_ULL(58)
 #define PM_FILE                       BIT_ULL(61)
 #define PM_SWAP                       BIT_ULL(62)
 #define PM_PRESENT                    BIT_ULL(63)
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
mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

