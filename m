Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E85F25757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957071; cv=none; b=UdLEYjd/vHrtOYWjFkLASovWKn6jcDLmHswo3IjtCYJ+aluzgvQ3L14/+8jZx69yk33gB45uA1ndySCbei9Nlrn9OmbIok6mZ4jCdIj9qoXm2+cpn/eWR6Oe3l2DTD1+6q4TnBi0mR9Vga+EioWnnzuBGFTcjijT7zY3vvKlsjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957071; c=relaxed/simple;
	bh=TyHzNIsUKwHt38lGO8KmJVnbkuWNmoEyJ84Fn935yUQ=;
	h=Date:To:From:Subject:Message-Id; b=ItUWR7hqoDPfmlVqPDTkGYvUtkz2uwCuAYKmDT5szHc4bALYrLaZOWwborlxATAhlS90snHQIu5JpFewURz1yMcoaLUEsmvdwESQLEtI6GwzhjkqnjqaYeNBCXSJ4xhV/aWvqp2M4XFDzNyfxeNJN096zcHBfLMvOVd9paaoeg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pj3ERZWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pj3ERZWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D347AC113CC;
	Mon,  6 May 2024 00:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957070;
	bh=TyHzNIsUKwHt38lGO8KmJVnbkuWNmoEyJ84Fn935yUQ=;
	h=Date:To:From:Subject:From;
	b=pj3ERZWeQqFCw7IRODo1DevwVYdAJeFfEf9lqZ9bFNYCC4oXesI3VIBDXS9cqZUkR
	 cg9QgfXZ2DwF1CF4o2/HRNiFP+XykFSh8nV8WIeqteg99POPfhFQVioisSnK3XxNQD
	 zmP2BTCkyrqn/zF0irN4TcPNyZ1CZ7QxKqdPujIg=
Date: Sun, 05 May 2024 17:57:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,jhubbard@nvidia.com,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch removed from -mm tree
Message-Id: <20240506005750.D347AC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: improve split_huge_page_to_list_to_order() return value documentation
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: improve split_huge_page_to_list_to_order() return value documentation
Date: Thu, 18 Apr 2024 17:18:34 +0200

The documentation is wrong and relying on it almost resulted in BUGs in
new callers: ever since fd4a7ac32918 ("mm: migrate: try again if THP split
is failed due to page refcnt") we return -EAGAIN on unexpected folio
references, not -EBUSY.

Let's fix that and also document which other return values we can
currently see and why they could happen.

[david@redhat.com: v2]
  Link: https://lkml.kernel.org/r/20240422194217.442933-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240418151834.216557-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation
+++ a/mm/huge_memory.c
@@ -2956,7 +2956,7 @@ bool can_split_folio(struct folio *folio
  *
  * 3) The folio must not be pinned. Any unexpected folio references, including
  *    GUP pins, will result in the folio not getting split; instead, the caller
- *    will receive an -EBUSY.
+ *    will receive an -EAGAIN.
  *
  * 4) @new_order > 1, usually. Splitting to order-1 anonymous folios is not
  *    supported for non-file-backed folios, because folio->_deferred_list, which
@@ -2975,8 +2975,16 @@ bool can_split_folio(struct folio *folio
  *
  * Returns 0 if the huge page was split successfully.
  *
- * Returns -EBUSY if @page's folio is pinned, or if the anon_vma disappeared
- * from under us.
+ * Returns -EAGAIN if the folio has unexpected reference (e.g., GUP) or if
+ * the folio was concurrently removed from the page cache.
+ *
+ * Returns -EBUSY when trying to split the huge zeropage, if the folio is
+ * under writeback, if fs-specific folio metadata cannot currently be
+ * released, or if some unexpected race happened (e.g., anon VMA disappeared,
+ * truncation).
+ *
+ * Returns -EINVAL when trying to split to an order that is incompatible
+ * with the folio. Splitting to order 0 is compatible with all folios.
  */
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 				     unsigned int new_order)
_

Patches currently in -mm which might be from david@redhat.com are


