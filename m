From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 20/54] mm/gup: documentation fix for
 pin_user_pages*() APIs
Date: Sun, 07 Jun 2020 21:41:08 -0700
Message-ID: <20200608044108.hYJYlSc5C%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHElK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:10 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, david@redhat.com, jack@suse.cz, jhubbard@nvidia.com, jrdr.linux@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/mm/gup.c~mm-gup-documentation-fix-for-pin_user_pages-apis
+++ a/mm/gup.c
@@ -2918,9 +2918,6 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
  * see Documentation/core-api/pin_user_pages.rst for further details.
- *
- * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
  */
 int pin_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages)
@@ -2994,9 +2991,6 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast_on
  *
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
  * see Documentation/core-api/pin_user_pages.rst for details.
- *
- * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
- * is NOT intended for Case 2 (RDMA: long-term pins).
  */
 long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
@@ -3030,9 +3024,6 @@ EXPORT_SYMBOL(pin_user_pages_remote);
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
