From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch added to -mm
 tree
Date: Fri, 22 May 2020 17:56:39 -0700
Message-ID: <20200523005639.Ncmp1PRRZ%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731169AbgEWA4l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 20:56:41 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jgg@ziepe.ca, jhubbard@nvidia.com, mm-commits@vger.kernel.org, walken@google.com, willy@infradead.org


The patch titled
     Subject: mm/gup: might_lock_read(mmap_sem) in get_user_pages_fast()
has been added to the -mm tree.  Its filename is
     mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch

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
@@ -2723,6 +2723,9 @@ static int internal_get_user_pages_fast(
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

rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
selftests-vm-gitignore-add-mremap_dontunmap.patch
selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch
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
