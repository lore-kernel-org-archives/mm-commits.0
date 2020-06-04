From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch removed from
 -mm tree
Date: Thu, 04 Jun 2020 10:16:10 -0700
Message-ID: <20200604171610.XruCCkN1r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFDRQM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jgg@ziepe.ca, jhubbard@nvidia.com, mm-commits@vger.kernel.org, walken@google.com, willy@infradead.org


The patch titled
     Subject: mm/gup: might_lock_read(mmap_sem) in get_user_pages_fast()
has been removed from the -mm tree.  Its filename was
     mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: might_lock_read(mmap_sem) in get_user_pages_fast()

Instead of scattering these assertions across the drivers, do this
assertion inside the core of get_user_pages_fast*() functions.  That also
includes pin_user_pages_fast*() routines.

Add a might_lock_read(mmap_sem) call to internal_get_user_pages_fast().

Link: http://lkml.kernel.org/r/20200522010443.1290485-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/gup.c~mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast
+++ a/mm/gup.c
@@ -2739,6 +2739,9 @@ static int internal_get_user_pages_fast(
 				       FOLL_FAST_ONLY)))
 		return -EINVAL;
 
+	if (!(gup_flags & FOLL_FAST_ONLY))
+		might_lock_read(&current->mm->mmap_sem);
+
 	start = untagged_addr(start) & PAGE_MASK;
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

rapidio-convert-get_user_pages-pin_user_pages.patch
mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-introduce-pin_user_pages_locked-v2.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
vhost-convert-get_user_pages-pin_user_pages.patch
