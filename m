Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A871721D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489994; cv=none; b=usgX7M2SVL/rzjPcRXsVfWZrkaTo6BcrVvM0oqPhAm3Q8hjbCxPE9OFnOH047jn2Lh1OFPSAsWQMvspCsZrFJC+xjlHjoJi0QHaO52JfzTko/WDBHqfjfKwWe64lcnZgXH4yXV1TzdM4iZXOPfLh5i8WeC5xoaTzqsH78ORLGy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489994; c=relaxed/simple;
	bh=tKBi+x0+erXm889lY6UZ9zIATlaz9xzo/v6CxrhdTKg=;
	h=Date:To:From:Subject:Message-Id; b=VMnsGSQ0IVQNmNmX28xbzFIzbl91A6R/5DQUzpWrLc4PEo+Hu4k428KUMndzy3SFtJzhbHS1Je/IOMd/SKcBCM2QFX3LGiTL/Q1in56txHGE39EVNhArI6XWdKWioVJRnaujrTgErF805zw7/QbpX7eGbYql4XE2gyCc6AwKfQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D2UwaNxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D2UwaNxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECD2C4CEE7;
	Sun, 21 Sep 2025 21:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489994;
	bh=tKBi+x0+erXm889lY6UZ9zIATlaz9xzo/v6CxrhdTKg=;
	h=Date:To:From:Subject:From;
	b=D2UwaNxfF4udFzIT2aPzlwFqetDsGtpV1KTLnept6qyr45UBdFkO3rYxa/BXaHxOa
	 lh4xlQufbZSTo7S/2gtINDBMMy18Vvn+gi+Ga6h7hKG/kHg7gimnBO+/habOJdJO8D
	 101sKMRgNkU2VNECqoQ2fmQ15CAQGa2afYhZpXcc=
Date: Sun, 21 Sep 2025 14:26:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ast@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page-order.patch removed from -mm tree
Message-Id: <20250921212634.2ECD2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page->order
has been removed from the -mm tree.  Its filename was
     mm-remove-page-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page->order
Date: Wed, 10 Sep 2025 15:29:19 +0100

We already use page->private for storing the order of a page while it's in
the buddy allocator system; extend that to also storing the order while
it's in the pcp_llist.

Link: https://lkml.kernel.org/r/20250910142923.2465470-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 +++-----
 mm/page_alloc.c          |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/include/linux/mm_types.h~mm-remove-page-order
+++ a/include/linux/mm_types.h
@@ -97,10 +97,7 @@ struct page {
 				/* Or, free page */
 				struct list_head buddy_list;
 				struct list_head pcp_list;
-				struct {
-					struct llist_node pcp_llist;
-					unsigned int order;
-				};
+				struct llist_node pcp_llist;
 			};
 			struct address_space *mapping;
 			union {
@@ -111,7 +108,8 @@ struct page {
 			 * @private: Mapping-private opaque data.
 			 * Usually used for buffer_heads if PagePrivate.
 			 * Used for swp_entry_t if swapcache flag set.
-			 * Indicates order in the buddy system if PageBuddy.
+			 * Indicates order in the buddy system if PageBuddy
+			 * or on pcp_llist.
 			 */
 			unsigned long private;
 		};
--- a/mm/page_alloc.c~mm-remove-page-order
+++ a/mm/page_alloc.c
@@ -1520,7 +1520,7 @@ static void add_page_to_zone_llist(struc
 				   unsigned int order)
 {
 	/* Remember the order */
-	page->order = order;
+	page->private = order;
 	/* Add the page to the free list */
 	llist_add(&page->pcp_llist, &zone->trylock_free_pages);
 }
@@ -1549,7 +1549,7 @@ static void free_one_page(struct zone *z
 
 		llnode = llist_del_all(llhead);
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
-			unsigned int p_order = p->order;
+			unsigned int p_order = p->private;
 
 			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
 			__count_vm_events(PGFREE, 1 << p_order);
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-inside-cmp_and_merge_page.patch

