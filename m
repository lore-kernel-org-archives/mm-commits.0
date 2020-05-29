From: akpm@linux-foundation.org
Subject: + mm-gup-documentation-fix-for-pin_user_pages-apis.patch
 added to -mm tree
Date: Fri, 29 May 2020 13:08:43 -0700
Message-ID: <20200529200843.aGMW1M-PS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbgE2UIq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 16:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, david@redhat.com, jack@suse.cz, jhubbard@nvidia.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/gup: documentation fix for pin_user_pages*() APIs
has been added to the -mm tree.  Its filename is
     mm-gup-documentation-fix-for-pin_user_pages-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-documentation-fix-for-pin_user_pages-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-documentation-fix-for-pin_user_pages-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: documentation fix for pin_user_pages*() APIs

All of the pin_user_pages*() API calls will cause pages to be dma-pinned. 
As such, they are all suitable for either DMA, RDMA, and/or Direct IO. 
The documentation should say so, but it was instead saying that three of
the API calls were only suitable for Direct IO.  This was discovered when
a reviewer wondered why an API call that specifically recommended against
Case 2 (DMA/RDMA) was being used in a DMA situation [1].

Fix this by simply deleting those claims.  The gup.c comments already
refer to the more extensive Documentation/core-api/pin_user_pages.rst,
which does have the correct guidance.  So let's just write it once, there.

[1] https://lore.kernel.org/r/20200529074658.GM30374@kadam

Link: http://lkml.kernel.org/r/20200529084515.46259-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/mm/gup.c~mm-gup-documentation-fix-for-pin_user_pages-apis
+++ a/mm/gup.c
@@ -2876,9 +2876,6 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
  * see Documentation/core-api/pin_user_pages.rst for further details.
- *
- * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
  */
 int pin_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages)
@@ -2952,9 +2949,6 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast_on
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
  * see Documentation/core-api/pin_user_pages.rst for details.
- *
- * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
  */
 long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
@@ -2988,9 +2982,6 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
  * see Documentation/core-api/pin_user_pages.rst for details.
- *
- * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
  */
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages,
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code-fix.patch
mm-gup-introduce-pin_user_pages_fast_only.patch
drm-i915-convert-get_user_pages-pin_user_pages.patch
mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch
khugepaged-add-self-test-fix-3.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
