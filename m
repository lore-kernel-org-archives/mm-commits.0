From: akpm@linux-foundation.org
Subject: + z3fold-add-kref-refcounting-checkpatch-fixes.patch added to -mm tree
Date: Tue, 31 Jan 2017 14:37:37 -0800
Message-ID: <589111b1.GWyD6/hHctR/zgb9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdAaWhi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:37:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold-add-kref-refcounting-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     z3fold-add-kref-refcounting-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-add-kref-refcounting-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-add-kref-refcounting-checkpatch-fixes.patch

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
Subject: z3fold-add-kref-refcounting-checkpatch-fixes

WARNING: Missing a blank line after declarations
#93: FILE: mm/z3fold.c:172:
+	struct page *page = virt_to_page(zhdr);
+	if (!list_empty(&zhdr->buddy))

total: 0 errors, 1 warnings, 261 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/z3fold-add-kref-refcounting.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/z3fold.c~z3fold-add-kref-refcounting-checkpatch-fixes mm/z3fold.c
--- a/mm/z3fold.c~z3fold-add-kref-refcounting-checkpatch-fixes
+++ a/mm/z3fold.c
@@ -166,9 +166,12 @@ static void free_z3fold_page(struct page
 
 static void release_z3fold_page(struct kref *ref)
 {
-	struct z3fold_header *zhdr = container_of(ref, struct z3fold_header,
-						refcount);
-	struct page *page = virt_to_page(zhdr);
+	struct z3fold_header *zhdr;
+	struct page *page;
+
+	zhdr = container_of(ref, struct z3fold_header, refcount);
+	page = virt_to_page(zhdr);
+
 	if (!list_empty(&zhdr->buddy))
 		list_del(&zhdr->buddy);
 	if (!list_empty(&page->lru))
@@ -188,7 +191,6 @@ static inline void z3fold_page_unlock(st
 	spin_unlock(&zhdr->page_lock);
 }
 
-
 /*
  * Encodes the handle of a particular buddy within a z3fold page
  * Pool lock should be held as this function accesses first_num
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
z3fold-add-kref-refcounting-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

