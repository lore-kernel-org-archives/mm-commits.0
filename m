From: akpm@linux-foundation.org
Subject: +
 mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch added to
 -mm tree
Date: Fri, 17 Apr 2020 20:30:28 -0700
Message-ID: <20200418033028.7UExnekS3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgDRDa3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 23:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix
has been added to the -mm tree.  Its filename is
     mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix

add missing `node' arg

Cc: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/test_vmalloc.c~mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix
+++ a/lib/test_vmalloc.c
@@ -91,7 +91,7 @@ static int random_size_align_alloc_test(
 		 */
 		size = ((rnd % 10) + 1) * PAGE_SIZE;
 
-		ptr = __vmalloc_node(size, align, GFP_KERNEL | __GFP_ZERO,
+		ptr = __vmalloc_node(size, align, GFP_KERNEL | __GFP_ZERO, 0,
 				__builtin_return_address(0));
 		if (!ptr)
 			return -1;
@@ -114,7 +114,7 @@ static int align_shift_alloc_test(void)
 	for (i = 0; i < BITS_PER_LONG; i++) {
 		align = ((unsigned long) 1) << i;
 
-		ptr = __vmalloc_node(PAGE_SIZE, align, GFP_KERNEL | __GFP_ZERO,
+		ptr = __vmalloc_node(PAGE_SIZE, align, GFP_KERNEL|__GFP_ZERO, 0,
 				__builtin_return_address(0));
 		if (!ptr)
 			return -1;
@@ -132,7 +132,7 @@ static int fix_align_alloc_test(void)
 
 	for (i = 0; i < test_loop_count; i++) {
 		ptr = __vmalloc_node(5 * PAGE_SIZE, THREAD_ALIGN << 1,
-				GFP_KERNEL | __GFP_ZERO,
+				GFP_KERNEL | __GFP_ZERO, 0,
 				__builtin_return_address(0));
 		if (!ptr)
 			return -1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
