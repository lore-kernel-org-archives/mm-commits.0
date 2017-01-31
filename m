From: akpm@linux-foundation.org
Subject: [merged]
 reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 31 Jan 2017 12:28:43 -0800
Message-ID: <5890f37b.mU/FTjS+pDR5EXpa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbdAaU2o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 15:28:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#143: FILE: tools/testing/radix-tree/idr-test.c:88:
+	for (i = 0; i < 10; i++) {
+		assert(idr_alloc(&idr, NULL, 0, 0, GFP_KERNEL) == i);
+	}

WARNING: braces {} are not necessary for single statement blocks
#167: FILE: tools/testing/radix-tree/idr-test.c:112:
+	for (i = 1; i < 10; i++) {
+		assert(idr_alloc(&idr, NULL, 1, 0, GFP_KERNEL) == i);
+	}

total: 0 errors, 2 warnings, 159 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/idr-test.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN tools/testing/radix-tree/idr-test.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes tools/testing/radix-tree/idr-test.c
--- a/tools/testing/radix-tree/idr-test.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes
+++ a/tools/testing/radix-tree/idr-test.c
@@ -85,9 +85,8 @@ void idr_null_test(void)
 	int i;
 	DEFINE_IDR(idr);
 
-	for (i = 0; i < 10; i++) {
+	for (i = 0; i < 10; i++)
 		assert(idr_alloc(&idr, NULL, 0, 0, GFP_KERNEL) == i);
-	}
 
 	assert(idr_replace(&idr, DUMMY_PTR, 3) == NULL);
 	assert(idr_replace(&idr, DUMMY_PTR, 4) == NULL);
@@ -109,9 +108,8 @@ void idr_null_test(void)
 	idr_destroy(&idr);
 	assert(idr_is_empty(&idr));
 
-	for (i = 1; i < 10; i++) {
+	for (i = 1; i < 10; i++)
 		assert(idr_alloc(&idr, NULL, 1, 0, GFP_KERNEL) == i);
-	}
 
 	idr_destroy(&idr);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

