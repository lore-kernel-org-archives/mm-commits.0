Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331FE28F4
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 03:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740280388; cv=none; b=lpJYHucSNMz86rQ/mqadqftwdaHs8krRrnEXIQ3KpHN7aBP4jToHUtjUMxp+9obeoqGXbxjUVS7cq1gXVoh8tiq3Udeo3Kx2b5CgPMa2adipD9SF6937f4pJ8D/HXwQOYmfXX7lafqCZnr/MACD1pRSL/W4MnCZyQz8FBzXT910=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740280388; c=relaxed/simple;
	bh=GYiqdSaZfHUummPXk8BAV+QNW1xOL/4upRVSocqlndQ=;
	h=Date:To:From:Subject:Message-Id; b=G1eLxftxNAPQkcZVtxOCWW33R4oNmqVy7G0ouEztxZ5r6JTzricHLUkdeVOtpfGnXjyl2T0W5sXxsBRy6CbdKKM2MtAfi0SvnNGgPrpjbFhaBhQ7OYuuyeG2RvpJlYA+aau7TJlC2WMMu0wxRw4bO64c6pA7LgNLUOKJZJONBms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aLlQeLG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aLlQeLG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8CFC4CEE4;
	Sun, 23 Feb 2025 03:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740280387;
	bh=GYiqdSaZfHUummPXk8BAV+QNW1xOL/4upRVSocqlndQ=;
	h=Date:To:From:Subject:From;
	b=aLlQeLG+AJ6W9LMsjVySTjgyekmPQBmyuzOSiZDVGu1wDO35wgurJaqOOu5rnXtdZ
	 5Buzl52PIQlP7vYEQ6TUFAHu98epDfaPrhcQ5bQmGN1biqMondAZdqZ//73+kAnV1D
	 Ki6Bfs05tqxATwLB/jhAquNeahqWIeINeBeH0Cz4=
Date: Sat, 22 Feb 2025 19:13:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,corbet@lwn.net,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch added to mm-unstable branch
Message-Id: <20250223031307.9A8CFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup define name
has been added to the -mm mm-unstable branch.  Its filename is
     tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch

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
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
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
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch

