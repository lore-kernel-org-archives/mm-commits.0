Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE4282F5
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757545409; cv=none; b=AMJ1mgXCE1jZMsk4zpfB1bql0it76Fb0nFyyJEDBcH2YPRTRFY/nAJCpW5pOrkv1fOGft3RnGxR6r8L4fXP+vhVDHMKJ+9J9AZ3r5X9qfsYeXp6f6oiOm9hl6ZRW1LkTRuRRO8mQf1y2M6XqCM5HgydZJFNg1p4eQKAkzq9C1p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757545409; c=relaxed/simple;
	bh=QGbhP1sg+G3eixcWgqi+j6e82CQRnwGQElShcGSogKc=;
	h=Date:To:From:Subject:Message-Id; b=szC1H69QjgJ3GEHMq7obI1jRYMchxMVMfHaMjxPjGJ5vGjEAFjwpzdcroAYn7K+ywLF8zS8CPWLYicMe6WWyRSxYUbLkNf29wKG2EJ+XqhNec9P8r2eyTQiY4XL7oqifNqSpfdT+FN8t5YqzOYziYYOsy12Aem8c2Nn0MtoKOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b/kc49ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b/kc49ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201A6C4CEEB;
	Wed, 10 Sep 2025 23:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757545408;
	bh=QGbhP1sg+G3eixcWgqi+j6e82CQRnwGQElShcGSogKc=;
	h=Date:To:From:Subject:From;
	b=b/kc49dscpm9C0gS2hL+8XqUrEiDF0pANkw3kGpBRkOg9MoOdI3OSruxYg2JQj/8R
	 nGqoT0jg70V+oEIozWxXko1mqwK8Ur/35X8EOmQVguDmD6axhzISIR27smEPyTRuBM
	 aTai1QKLmFP6Vq1G5vENy1G1vr2hcEagh5z4i7eg=
Date: Wed, 10 Sep 2025 16:03:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ast@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page-order.patch added to mm-new branch
Message-Id: <20250910230328.201A6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page->order
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-page-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page-order.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-introduce-memdesc_flags_t.patch
mm-introduce-memdesc_flags_t-fix.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch
mm-remove-mlock_count-from-struct-page.patch
ptdesc-convert-__page_flags-to-pt_flags.patch
ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch
ptdesc-remove-ptdesc_to_virt.patch
mm-constify-compound_order-and-page_size.patch
mm-remove-redundant-test-in-validate_page_before_insert.patch
mm-remove-page-order.patch

