Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3AD2FB2
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 04:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730177175; cv=none; b=iRXS2Vn5x84h7LZxTYUXtMdw7fLpNd3DqFXRpew2sC/7EMyeUYw3w6NARJr8z29x3amQHQiY9TnqYEM9/aFZBmuPj2zQ9CVuno0xViOyMj//avR9FzNijmZVrJe2qxM6rwDnPIpY9e2daFrHyuDaukwM/JEbnz3xp6ySAoVMlHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730177175; c=relaxed/simple;
	bh=cA21RFB7I56Q+S5hKJLWvLw7XRVIqf8GcFhUQt2IHaE=;
	h=Date:To:From:Subject:Message-Id; b=UqVTw62bIv++OXrWI76nxtkR4JVbtrMdF2say7QCx1+JWb8xyRa/fsz3O9fxH4yInXSyU5ga8LbkXpnY0O6HFsiJDBF2krF8QihAAc1p3t4fP6/NhlvPhqeBHwCARNJ2/XC1rTDeECTm3ise32OzIr97swJQYzxaAQwY/T8aBg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TK1/enw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TK1/enw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C5C4CECD;
	Tue, 29 Oct 2024 04:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730177175;
	bh=cA21RFB7I56Q+S5hKJLWvLw7XRVIqf8GcFhUQt2IHaE=;
	h=Date:To:From:Subject:From;
	b=TK1/enw3RE5WN7KTpwwpEn7ay88p1y8iGgthJL7H0QgMnrJgk9hGET3FazyGtlf8g
	 DIKLaQyudsnwVEOfHcTIMEDgS8M9dn7SFV39J9fsiQgpkEtIU271FQslgp7yBaX9na
	 H5HqtzKKj2g5721UIbpdrKiP04pnNLQfxlXP3MaM=
Date: Mon, 28 Oct 2024 21:46:14 -0700
To: mm-commits@vger.kernel.org,syoshida@redhat.com,pasha.tatashin@soleen.com,minchan@kernel.org,jgg@nvidia.com,david@redhat.com,apopple@nvidia.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch added to mm-hotfixes-unstable branch
Message-Id: <20241029044615.272C5C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: stop leaking pinned pages in low memory conditions
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch
kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

