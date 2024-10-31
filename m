Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823A812F5B3
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 03:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344503; cv=none; b=Ee3Ow2F+KbhrTy7Uov/pk8O0QPs8ZcGpJRDEzW/ig1etkYfyLbLXbiRsGWcS8L+TvkaQuhVFCEGizfLkU9eLFrpp5t+2u3P0JOvzJtu/sR+iDeQyTToscJKxs11iCy0Rb2qNwuBJEgEJUSrErhohUHGtzkcMvDB8mJzPDUyEzyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344503; c=relaxed/simple;
	bh=B/vHZ4mvEO4MMHvlHFOs7bmXTkG2PPTmXmUkO1SflcY=;
	h=Date:To:From:Subject:Message-Id; b=ZOv/gwp3jUAIUFkMbSXOGEi0rIF6vzBzeImCZM9Nyw74u+akkwXYTV3en9qOcCRtoIg3PXOgOVpFzEViVB3QmGbs26ePAmZLJs5LwLz776ybsWvCTpduiiJcimQ32n1XCgg8Y7oRrNJLe9KqZV64e5jlFxAW3kpJ+1W2Qdcfnh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vmbE6/+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vmbE6/+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE035C4CECE;
	Thu, 31 Oct 2024 03:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344503;
	bh=B/vHZ4mvEO4MMHvlHFOs7bmXTkG2PPTmXmUkO1SflcY=;
	h=Date:To:From:Subject:From;
	b=vmbE6/+yU32Nk2TBqB/dXcHIGqn9Dw470JNa0o17KZEpabRHtiRTgKTEMs4pgVNGw
	 Vf0QLudJxQb6NFShihiS5EObJz3z+eGR06RfwCGea7uGwFErEUmUYrtQ7N6v6u0OuE
	 n2KQ5PcdCwMmkm8PSW/3LXiY/Jri3VNH5X+wOXKY=
Date: Wed, 30 Oct 2024 20:15:02 -0700
To: mm-commits@vger.kernel.org,syoshida@redhat.com,pasha.tatashin@soleen.com,minchan@kernel.org,jgg@nvidia.com,david@redhat.com,apopple@nvidia.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch removed from -mm tree
Message-Id: <20241031031502.EE035C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: stop leaking pinned pages in low memory conditions
has been removed from the -mm tree.  Its filename was
     mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: stop leaking pinned pages in low memory conditions
Date: Fri, 18 Oct 2024 15:34:11 -0700

If a driver tries to call any of the pin_user_pages*(FOLL_LONGTERM) family
of functions, and requests "too many" pages, then the call will
erroneously leave pages pinned.  This is visible in user space as an
actual memory leak.

Repro is trivial: just make enough pin_user_pages(FOLL_LONGTERM) calls to
exhaust memory.

The root cause of the problem is this sequence, within
__gup_longterm_locked():

    __get_user_pages_locked()
    rc = check_and_migrate_movable_pages()

...which gets retried in a loop.  The loop error handling is incomplete,
clearly due to a somewhat unusual and complicated tri-state error API. 
But anyway, if -ENOMEM, or in fact, any unexpected error is returned from
check_and_migrate_movable_pages(), then __gup_longterm_locked() happily
returns the error, while leaving the pages pinned.

In the failed case, which is an app that requests (via a device driver)
30720000000 bytes to be pinned, and then exits, I see this:

    $ grep foll /proc/vmstat
        nr_foll_pin_acquired 7502048
        nr_foll_pin_released 2048

And after applying this patch, it returns to balanced pins:

    $ grep foll /proc/vmstat
        nr_foll_pin_acquired 7502048
        nr_foll_pin_released 7502048

Note that the child routine, check_and_migrate_movable_folios(), avoids
this problem, by unpinning any folios in the **folios argument, before
returning an error.

Fix this by making check_and_migrate_movable_pages() behave in exactly the
same way as check_and_migrate_movable_folios(): unpin all pages in
**pages, before returning an error.

Also, documentation was an aggravating factor, so:

1) Consolidate the documentation for these two routines, now that they
have identical external behavior.

2) Rewrite the consolidated documentation:

    a) Clearly list the three return code cases, and what happens in
    each case.

    b) Mention that one of the cases unpins the pages or folios, before
    returning an error code.

Link: https://lkml.kernel.org/r/20241018223411.310331-1-jhubbard@nvidia.com
Fixes: 24a95998e9ba ("mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/mm/gup.c~mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions
+++ a/mm/gup.c
@@ -2394,20 +2394,25 @@ err:
 }
 
 /*
- * Check whether all folios are *allowed* to be pinned indefinitely (longterm).
+ * Check whether all folios are *allowed* to be pinned indefinitely (long term).
  * Rather confusingly, all folios in the range are required to be pinned via
  * FOLL_PIN, before calling this routine.
  *
- * If any folios in the range are not allowed to be pinned, then this routine
- * will migrate those folios away, unpin all the folios in the range and return
- * -EAGAIN. The caller should re-pin the entire range with FOLL_PIN and then
- * call this routine again.
+ * Return values:
  *
- * If an error other than -EAGAIN occurs, this indicates a migration failure.
- * The caller should give up, and propagate the error back up the call stack.
- *
- * If everything is OK and all folios in the range are allowed to be pinned,
+ * 0: if everything is OK and all folios in the range are allowed to be pinned,
  * then this routine leaves all folios pinned and returns zero for success.
+ *
+ * -EAGAIN: if any folios in the range are not allowed to be pinned, then this
+ * routine will migrate those folios away, unpin all the folios in the range. If
+ * migration of the entire set of folios succeeds, then -EAGAIN is returned. The
+ * caller should re-pin the entire range with FOLL_PIN and then call this
+ * routine again.
+ *
+ * -ENOMEM, or any other -errno: if an error *other* than -EAGAIN occurs, this
+ * indicates a migration failure. The caller should give up, and propagate the
+ * error back up the call stack. The caller does not need to unpin any folios in
+ * that case, because this routine will do the unpinning.
  */
 static long check_and_migrate_movable_folios(unsigned long nr_folios,
 					     struct folio **folios)
@@ -2425,10 +2430,8 @@ static long check_and_migrate_movable_fo
 }
 
 /*
- * This routine just converts all the pages in the @pages array to folios and
- * calls check_and_migrate_movable_folios() to do the heavy lifting.
- *
- * Please see the check_and_migrate_movable_folios() documentation for details.
+ * Return values and behavior are the same as those for
+ * check_and_migrate_movable_folios().
  */
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages)
@@ -2437,8 +2440,10 @@ static long check_and_migrate_movable_pa
 	long i, ret;
 
 	folios = kmalloc_array(nr_pages, sizeof(*folios), GFP_KERNEL);
-	if (!folios)
+	if (!folios) {
+		unpin_user_pages(pages, nr_pages);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < nr_pages; i++)
 		folios[i] = page_folio(pages[i]);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

