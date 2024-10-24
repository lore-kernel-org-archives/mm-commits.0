Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBAA17BD3
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750330; cv=none; b=lNC5b1NJHrqdnnBuk2t3O3SzqspecE3dUVSfKcZ2eyahJdf3+/RhZ9lFWqb4F2usFCAnvHHUfzaV5dlcwGgRYz66NhsU8bKBB+d9aF9cXfn/MoUAjp1sDSiEf75unyah6qL6tzAnThpVHbbf4cdN7/bzZbmg8cb7jiVTZ4RnwVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750330; c=relaxed/simple;
	bh=LY5luvwBEnkTC6MjoA7pLJoeqxRZwgsWUe2YsbymbkY=;
	h=Date:To:From:Subject:Message-Id; b=bIVB6zyxcOv8FfEHJ0QwI1WFOM6tlxAaTxapv27MM4P4Eo8Nw2jLmo3ZYlp3xnd2CTp1jrCgOhPV2fVGXPI+PYY+5WwyypHFNxn8z6/otZZ7a2bF4NSz1pf0LQUjfDtj+NiPbme3PK0NCaEbXjumgmP2igLzJvLk6JM7YIZTNvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kP4zsSOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kP4zsSOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E3BC4CEC7;
	Thu, 24 Oct 2024 06:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750330;
	bh=LY5luvwBEnkTC6MjoA7pLJoeqxRZwgsWUe2YsbymbkY=;
	h=Date:To:From:Subject:From;
	b=kP4zsSOHDswx1CSg+IFe4AFLc/tGUoauBtq4lv/qbVTPMBKTFaXwDMw4YsUjzk8O0
	 V6K2lO/Gt153ICGg4SCzDQOEywpaeJKwnyAcIWVzCjPqpCbNS0BRbxCWMVIGPz/4c5
	 FDEwsR8lJwt6fgvbhLUuXVNvcj5cZq0YckSFv/oM=
Date: Wed, 23 Oct 2024 23:12:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,syoshida@redhat.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,minchan@kernel.org,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,apopple@nvidia.com,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch removed from -mm tree
Message-Id: <20241024061209.E0E3BC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3
has been removed from the -mm tree.  Its filename was
     mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch

This patch was dropped because it was folded into mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch

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
mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch
kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

