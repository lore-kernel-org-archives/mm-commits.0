Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFEB24678F;
	Wed, 11 Jun 2025 22:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749681927; cv=none; b=JknzC82NxvLGwLZpYku9kJMqlLD+Ui9CAOPMdSAI7nFrcBBmuzWTqn6sHSdOKmHZj/XGwnx3W2fNMSpAzxeYpYRMQiM3wCBkz54+i5EcGiUJKBsKyn6UlxwpyBekrtHnWZGDm3nVrp9o01Fm5+C6iWKqPXRd0wvFGlqtRKX59DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749681927; c=relaxed/simple;
	bh=ktZrnTsAuW9WoplxS7wayrdM09UkkuWLA6kxAXEW1dk=;
	h=Date:To:From:Subject:Message-Id; b=kk1QAmNQJgqjiCfmaf8KEsbBwjw18Id7gWTkDyxFy0bqdmu+yBc92nWDYCALqXRftFeHXOaiZyTdqkmOt70urBQhCGlfOtnxsRt7RF3qv4FJWNHRhD0Z8egcSBNxIhMYP8hXf3O1F9kc8izhNnImzVtFYGcvkzCXUB7YTFWIELk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rQG5Y8IW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rQG5Y8IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B927FC4CEE3;
	Wed, 11 Jun 2025 22:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749681926;
	bh=ktZrnTsAuW9WoplxS7wayrdM09UkkuWLA6kxAXEW1dk=;
	h=Date:To:From:Subject:From;
	b=rQG5Y8IWlPgtPtH/rJRIGqLuE9Uo7OWbIznr3/xDbzmJrcFbEDpSjp+me8AOrbHQi
	 zjvxTc2x3xOWyBTtroca+sGRzuaSUwLDde1KrPLKmQpB2hhtg2FB60ohzvYhf+vlEw
	 CnK3TTBSMFCYn5wv60OAv+jaR1qwSQ8duoqavAn8=
Date: Wed, 11 Jun 2025 15:45:26 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,stable@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,hyesoo.yu@samsung.com,apopple@nvidia.com,akpm@linux-foundation.org,aijun.sun@unisoc.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch added to mm-hotfixes-unstable branch
Message-Id: <20250611224526.B927FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"
Date: Wed, 11 Jun 2025 15:13:14 +0200

After commit 1aaf8c122918 ("mm: gup: fix infinite loop within
__get_longterm_locked") we are able to longterm pin folios that are not
supposed to get longterm pinned, simply because they temporarily have the
LRU flag cleared (esp.  temporarily isolated).

For example, two __get_longterm_locked() callers can race, or
__get_longterm_locked() can race with anything else that temporarily
isolates folios.

The introducing commit mentions the use case of a driver that uses
vm_ops->fault to insert pages allocated through cma_alloc() into the page
tables, assuming they can later get longterm pinned.  These pages/ folios
would never have the LRU flag set and consequently cannot get isolated. 
There is no known in-tree user making use of that so far, fortunately.

To handle that in the future -- and avoid retrying forever to
isolate/migrate them -- we will need a different mechanism for the CMA
area *owner* to indicate that it actually already allocated the page and
is fine with longterm pinning it.  The LRU flag is not suitable for that.

Probably we can lookup the relevant CMA area and query the bitmap; we only
have have to care about some races, probably.  If already allocated, we
could just allow longterm pinning)

Anyhow, let's fix the "must not be longterm pinned" problem first by
reverting the original commit.

Link: https://lkml.kernel.org/r/20250611131314.594529-1-david@redhat.com
Fixes: 1aaf8c122918 ("mm: gup: fix infinite loop within __get_longterm_locked")
Signed-off-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/all/20250522092755.GA3277597@tiffany/
Reported-by: Hyesoo Yu <hyesoo.yu@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked
+++ a/mm/gup.c
@@ -2303,13 +2303,13 @@ static void pofs_unpin(struct pages_or_f
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
-static void collect_longterm_unpinnable_folios(
+static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
-	unsigned long i;
 
 	for (i = 0; i < pofs->nr_entries; i++) {
 		struct folio *folio = pofs_get_folio(pofs, i);
@@ -2321,6 +2321,8 @@ static void collect_longterm_unpinnable_
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
+		collected++;
+
 		if (folio_is_device_coherent(folio))
 			continue;
 
@@ -2342,6 +2344,8 @@ static void collect_longterm_unpinnable_
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
+
+	return collected;
 }
 
 /*
@@ -2418,9 +2422,11 @@ static long
 check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
 {
 	LIST_HEAD(movable_folio_list);
+	unsigned long collected;
 
-	collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
-	if (list_empty(&movable_folio_list))
+	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
+						       pofs);
+	if (!collected)
 		return 0;
 
 	return migrate_longterm_unpinnable_folios(&movable_folio_list, pofs);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch
mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch

