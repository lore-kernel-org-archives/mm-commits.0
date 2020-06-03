From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 007/131] mm/gup: might_lock_read(mmap_sem) in
 get_user_pages_fast()
Date: Wed, 03 Jun 2020 15:56:40 -0700
Message-ID: <20200603225640.p1jX5JqMA%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFCW4l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:56:41 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, walken@google.com, willy@infradead.org

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
