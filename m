Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D261C175D47
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750541; cv=none; b=iUSPJbyk1BbwhZBosz8BfAz/dAlok4uokhWUBihuQtZ3DFuL4eLR1/vlFonaK4EUf4rFk/RSGXK7bwflYbCdMg5mA66u6KksNuao5QOm8IvPeH2eSNnrhQm2LhtK2ISx8QTu00O3ON6wdrUrdk2RDpawAd9A0eUyZ/GV0XDjy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750541; c=relaxed/simple;
	bh=fytMmxJavIn5tN1CdM26NqKPOEKz2lwUgtj5C7/cxVU=;
	h=Date:To:From:Subject:Message-Id; b=CLflJ84wgjezCfKKkaZuBSBdIK+kJN6bvGp4LsJsXL8e/IRwRsNZNAA8MxcdY1HZNSuB7cxmA8rXphrNarhrmfDCj1q/ujhGZC5RMykXZ9QIw8kYBF/tbWPCLrOHTvHk8veBmx0nUcJBwRTmrhk1HfSO4n7MsXoQu5D2wieeXAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4+n4Bq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4+n4Bq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD80C4CECC;
	Thu, 24 Oct 2024 06:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750541;
	bh=fytMmxJavIn5tN1CdM26NqKPOEKz2lwUgtj5C7/cxVU=;
	h=Date:To:From:Subject:From;
	b=N4+n4Bq9pcU5TYbyvtufLDNgOCGMRvfgnapMFjcE8dUA6W2wN7szOFhAa41tGSMrt
	 ULRUXKxPGqIbi+0d6WHgi/Il20sfmrvom+hJhdXuc7p6EJxyFGyZxrEp5aScp/rrrK
	 0IpXw4bPLfsXU6idIVqRPgw6M3hTxnyh9LMhMooE=
Date: Wed, 23 Oct 2024 23:15:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,syoshida@redhat.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,minchan@kernel.org,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,apopple@nvidia.com,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch removed from -mm tree
Message-Id: <20241024061541.4FD80C4CECC@smtp.kernel.org>
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
Date: Thu, 17 Oct 2024 18:17:10 -0700

Patch series "mm/gup: stop leaking pinned pages in low memory conditions",
v2.


This patch (of 2):

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

Fix this by making check_and_migrate_movable_pages() behave in exactly
the same way as check_and_migrate_movable_folios(): unpin all pages in
**pages, before returning an error.

Also, documentation was an aggravating factor, so:

1) Consolidate the documentation for these two routines, now that they
   have identical external behavior.

2) Rewrite the consolidated documentation:

    a) Clearly list the three return code cases, and what happens in
    each case.

    b) Mention that one of the cases unpins the pages or folios, before
    returning an error code.

[jhubbard@nvidia.com: updates per David]
  Link: https://lkml.kernel.org/r/20241018223411.310331-1-jhubbard@nvidia.comLink: https://lkml.kernel.org/r/20241018011711.183642-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20241018011711.183642-2-jhubbard@nvidia.com
Fixes: 24a95998e9ba ("mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

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
@@ -2492,6 +2497,17 @@ static long __gup_longterm_locked(struct
 
 		/* FOLL_LONGTERM implies FOLL_PIN */
 		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages);
+
+		/*
+		 * The __get_user_pages_locked() call happens before we know if
+		 * it's possible to successfully complete the whole operation.
+		 * To compensate for this, if we get an unexpected error (such
+		 * as -ENOMEM) then we must unpin everything, before erroring
+		 * out.
+		 */
+		if (rc != -EAGAIN && rc != 0)
+			unpin_user_pages(pages, nr_pinned_pages);
+
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 	return rc ? rc : nr_pinned_pages;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

