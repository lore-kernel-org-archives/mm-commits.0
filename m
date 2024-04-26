Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69607604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104004; cv=none; b=mNS0iIfZSdgK6bxIuxb9vBTEvr8m9nWx74AAvexaMpV9tKTtM/2GQnH9V2iaZ72XVJc7WKjanG0rn5JhkkXrDI/3e1PBxhm60S5VuQaZ/tGeKWDGeV83vnUargsenvQU0GTvsdqfcekFa9nF7SatE1BZBNLdVUPWrM2Vo3QUyQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104004; c=relaxed/simple;
	bh=njT6RIGvYd5wQiRYehBAnyDzSs2/jEPVwKbfYABbIZo=;
	h=Date:To:From:Subject:Message-Id; b=uy9bB4LHomd23GRBiIO3c4pE53mBBJ3RfWSkbf5X1nIsiCX8ht7uInDxIPPyr4RJYLGV/0Nrz7jhyKS68FzcO6NF2W32uKic3NhORiOymTnvEWNSLGQmCQCRxMNbQaqjlAPEA1sgzkFC4ZKtrjEWeyp03K/o9IsygDpfAYyjzfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bx+blDXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bx+blDXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF06C113CD;
	Fri, 26 Apr 2024 04:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104004;
	bh=njT6RIGvYd5wQiRYehBAnyDzSs2/jEPVwKbfYABbIZo=;
	h=Date:To:From:Subject:From;
	b=Bx+blDXh9n9ly9b06IGy7I9nR7NlhmoqZPQ7qslDJzAp4nkT+l/47pDj5lq9dh8Ly
	 Sjh8q175LQ1Bj/thjionMdbQquCuaoNpfdZ7cZAW+jtuf5jdytCK8BLxIJXTGKLjbt
	 JmdEv079AykogqiscW8OZSn8vxBcfJWHyZzOHsyw=
Date: Thu, 25 Apr 2024 21:00:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] huge_memoryc-document-huge-page-splitting-rules-more-thoroughly.patch removed from -mm tree
Message-Id: <20240426040004.ABF06C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: huge_memory.c: document huge page splitting rules more thoroughly
has been removed from the -mm tree.  Its filename was
     huge_memoryc-document-huge-page-splitting-rules-more-thoroughly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: huge_memory.c: document huge page splitting rules more thoroughly
Date: Sun, 24 Mar 2024 21:44:52 -0700

1. Add information about the behavior of huge page splitting, with
   respect to page/folio refcounts, and gup/pup pins.

2. Update and clarify the existing documentation, to compensate for the
   ravages of time and code change.

Link: https://lkml.kernel.org/r/20240325044452.217463-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   46 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/mm/huge_memory.c~huge_memoryc-document-huge-page-splitting-rules-more-thoroughly
+++ a/mm/huge_memory.c
@@ -3006,28 +3006,40 @@ bool can_split_folio(struct folio *folio
 }
 
 /*
- * This function splits huge page into pages in @new_order. @page can point to
- * any subpage of huge page to split. Split doesn't change the position of
- * @page.
- *
- * NOTE: order-1 anonymous folio is not supported because _deferred_list,
- * which is used by partially mapped folios, is stored in subpage 2 and an
- * order-1 folio only has subpage 0 and 1. File-backed order-1 folios are OK,
- * since they do not use _deferred_list.
- *
- * Only caller must hold pin on the @page, otherwise split fails with -EBUSY.
- * The huge page must be locked.
+ * This function splits a large folio into smaller folios of order @new_order.
+ * @page can point to any page of the large folio to split. The split operation
+ * does not change the position of @page.
+ *
+ * Prerequisites:
+ *
+ * 1) The caller must hold a reference on the @page's owning folio, also known
+ *    as the large folio.
+ *
+ * 2) The large folio must be locked.
+ *
+ * 3) The folio must not be pinned. Any unexpected folio references, including
+ *    GUP pins, will result in the folio not getting split; instead, the caller
+ *    will receive an -EBUSY.
+ *
+ * 4) @new_order > 1, usually. Splitting to order-1 anonymous folios is not
+ *    supported for non-file-backed folios, because folio->_deferred_list, which
+ *    is used by partially mapped folios, is stored in subpage 2, but an order-1
+ *    folio only has subpages 0 and 1. File-backed order-1 folios are supported,
+ *    since they do not use _deferred_list.
+ *
+ * After splitting, the caller's folio reference will be transferred to @page,
+ * resulting in a raised refcount of @page after this call. The other pages may
+ * be freed if they are not mapped.
  *
  * If @list is null, tail pages will be added to LRU list, otherwise, to @list.
  *
- * Pages in new_order will inherit mapping, flags, and so on from the hugepage.
+ * Pages in @new_order will inherit the mapping, flags, and so on from the
+ * huge page.
  *
- * GUP pin and PG_locked transferred to @page or the compound page @page belongs
- * to. Rest subpages can be freed if they are not mapped.
+ * Returns 0 if the huge page was split successfully.
  *
- * Returns 0 if the hugepage is split successfully.
- * Returns -EBUSY if the page is pinned or if anon_vma disappeared from under
- * us.
+ * Returns -EBUSY if @page's folio is pinned, or if the anon_vma disappeared
+ * from under us.
  */
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 				     unsigned int new_order)
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


