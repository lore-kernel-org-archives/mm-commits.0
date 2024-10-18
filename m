Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFEF17C7CA
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 22:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729291668; cv=none; b=LDkuQtXMEFA60K9O2Ey55ORBv+6sdrQa7jP71oqQ35o9J+gfbovyG3MgrCz9H2/RNZAFcyifSIgujeNtD6Qv0Eat08BEwt3xkKwQ+bvyDaL8J3hiEX3RKG0f7eoSLeYf+nO5OQIlEg07lxjmm3nSCqlDllic0ohxL/olPyO5m8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729291668; c=relaxed/simple;
	bh=TwWf9tSjD/7SryI5DzyLDVOYmIOSRr5nqjMjANLdt80=;
	h=Date:To:From:Subject:Message-Id; b=lng+mik/axjuMFqicGDGQuRsvLpWKpYn8bj5NqaxAtrd7/PljGnnrIzSwN7toQEK98+LxdoIYjXwcvJ/NdFcmIFw4o3Ll7vYiN4fg0u0BXEQsUWURlq5eyv9ByWWQwLw21B8aVd6JbWQ5/elHGVLQlFLP3OVBJkzZhcDYYzJjg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CoZS+gez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CoZS+gez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC0BC4CEC3;
	Fri, 18 Oct 2024 22:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729291668;
	bh=TwWf9tSjD/7SryI5DzyLDVOYmIOSRr5nqjMjANLdt80=;
	h=Date:To:From:Subject:From;
	b=CoZS+gezN13eiyGkUiQIuKznHUMX7Xx1zcG+e73GZgE6KHEKnst2Z8MNUN88Hph9H
	 y2J4tNuS7Z7zt6KJvbecGV/RdhWe8pzOAEec7XXK1ySzE4va8zLrW7MbrpMTJA9pBR
	 7xIVb3FDATUCVf+p41g6erusQ0/vknNfuOqDyF8M=
Date: Fri, 18 Oct 2024 15:47:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,syoshida@redhat.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,minchan@kernel.org,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,apopple@nvidia.com,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20241018224747.DBC0BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch

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
Subject: mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3
Date: Fri, 18 Oct 2024 15:34:11 -0700

1) Applied the fix to check_and_migrate_movable_pages(), instead of its
   caller, as per David Hildenbrand's suggestion (thanks!).

2) Dropped Alistair's reviewed-by tag, because the fix has changed.

3) Reworked the relevant documentation, and commit description.

Link: https://lkml.kernel.org/r/20241018223411.310331-1-jhubbard@nvidia.com
Fixes: 24a95998e9ba ("mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/mm/gup.c~mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3
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
mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch
mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch
kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

