From: akpm@linux-foundation.org
Subject: +
 reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch added to -mm tree
Date: Fri, 16 Dec 2016 13:41:34 -0800
Message-ID: <58545f8e.ZQXgewze/TJhQbj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932971AbcLPVkl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2016 16:40:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm.patch
linux-next-git-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

