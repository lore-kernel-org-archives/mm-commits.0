Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2908282F5
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757545404; cv=none; b=RbJvfTDAHToP5lpbYvzL6XfnW777iOh3g2uCGjHbmNJ5VrwLGY2bMnS+0BvHj5ajnOI63hJPyNOHxX9ToU/KcEYWb6g7QKmuaeuxPEXW+h+i+Ib2eDD/28JTGpVAmmtQg1NiGb1MmfhjrjKiAAKHlYl0xjEkaXNfJKJ3ybnGj5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757545404; c=relaxed/simple;
	bh=lCuiXdSSgFysoJW3I5QOfkDlt4hDoDYDc/hOe/iSRqo=;
	h=Date:To:From:Subject:Message-Id; b=VxSHnS9pwXsWwzRNmtabnAcCQBge8OE65mGxdUZs/6Cxl+U2n3nVPFWsvC6oQ0UIusRBdpAjYCMwWUDRPCZedXq6bABuFMqmjpBHwyCzdB5V2Fj5h/xvd4osni754aXcIJ6AxvTnfQvUhtwuSntT2onE34pwe8NgoI4XbERB/us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iu38KyJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iu38KyJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42267C4CEEB;
	Wed, 10 Sep 2025 23:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757545404;
	bh=lCuiXdSSgFysoJW3I5QOfkDlt4hDoDYDc/hOe/iSRqo=;
	h=Date:To:From:Subject:From;
	b=iu38KyJl8vET0fzm5MGh5d4gPiBc3swwUFIsQ/KktCGZfjtyhrRqlxYSAvtFHv8c4
	 tF9zv1Ns1fXsgnH1qf9j/QUdio0SzBrHUXI8T73FsMqO3DiUbqSlXi4eFnmL6XJo8W
	 xt8fA9+CpzL3BA0Ty3IzYuL+mPRsV16Xz8ilbsOs=
Date: Wed, 10 Sep 2025 16:03:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-compound_order-and-page_size.patch added to mm-new branch
Message-Id: <20250910230324.42267C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: constify compound_order() and page_size()
has been added to the -mm mm-new branch.  Its filename is
     mm-constify-compound_order-and-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-compound_order-and-page_size.patch

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
Subject: mm: constify compound_order() and page_size()
Date: Wed, 10 Sep 2025 15:29:17 +0100

Patch series "Small cleanups".

These small cleanups can be applied now to reduce conflicts during the
next merge window.  They're all from various efforts to split struct page
from other memdescs.  Thanks to Vlastimil for the suggestion.


This patch (of 3):

These functions do not modify their arguments.  Telling the compiler this
may improve code generation, and allows us to pass const arguments from
other functions.

Link: https://lkml.kernel.org/r/20250910142923.2465470-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250910142923.2465470-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-constify-compound_order-and-page_size
+++ a/include/linux/mm.h
@@ -1051,9 +1051,9 @@ static inline unsigned long folio_large_
  * set before the order is initialised, or this may be a tail page.
  * See compaction.c for some good examples.
  */
-static inline unsigned int compound_order(struct page *page)
+static inline unsigned int compound_order(const struct page *page)
 {
-	struct folio *folio = (struct folio *)page;
+	const struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags.f))
 		return 0;
@@ -1272,7 +1272,7 @@ int folio_mc_copy(struct folio *dst, str
 unsigned long nr_free_buffer_pages(void);
 
 /* Returns the number of bytes in this potentially compound page. */
-static inline unsigned long page_size(struct page *page)
+static inline unsigned long page_size(const struct page *page)
 {
 	return PAGE_SIZE << compound_order(page);
 }
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

