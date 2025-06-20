Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3098A322E;
	Fri, 20 Jun 2025 03:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391345; cv=none; b=KGHQFzCgzeROIECPSAgZeyIrC3u7HjGpD4mliRNrsn1ytwKtw16roE4tyOD4F3cNeZMPAPr35g0O2D84uWmjl+hgwRzOMSzpqoNJmmrWzIaK4aV7+qgq2pzvB4LYUUdxOYRcDqYlgd4VYvee3ldId8z5TSfS7RvWdgXjg5LOcb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391345; c=relaxed/simple;
	bh=wtR4rQAlyMNprnuOcfytJjolCJy/SGkMihU3Qwh99F0=;
	h=Date:To:From:Subject:Message-Id; b=j8cEdsWLoUSDMndJR4vSz4zPJq46cw0gMzu1cqLPfUwdTWxtYS8DoW6RPTWJ1Q6xKBO+b3nPYlbUva9KgHuanwV155vdoicjdUqMRiu6g+znrlThkTNA8G1A4jTN4FtypC0wU4rZiWWDqtd9Ae3rW0gkldbeDQJ7NCwOwZcZr0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zGfNcbB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zGfNcbB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5998C4CEE3;
	Fri, 20 Jun 2025 03:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391345;
	bh=wtR4rQAlyMNprnuOcfytJjolCJy/SGkMihU3Qwh99F0=;
	h=Date:To:From:Subject:From;
	b=zGfNcbB9LOplKXLqJkQav6bE8HushOny+rnGrZLXaHlJrtyqmeGiRElaPlOrL3DMh
	 50tAYIm5PhyxrCX8P/nwtKL8mdl4nF7J/wwx9VzKbQ915OUBvmNkkcuBIiI0q1ZhZD
	 mwM6Bg60/eVhdWi0kiYWsoIibbNVwjn0RfmejoZY=
Date: Thu, 19 Jun 2025 20:49:04 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,stable@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,hyesoo.yu@samsung.com,apopple@nvidia.com,aijun.sun@unisoc.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch removed from -mm tree
Message-Id: <20250620034904.E5998C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"
has been removed from the -mm tree.  Its filename was
     mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
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

fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio.patch
mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch

