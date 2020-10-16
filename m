Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC9FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D4221775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881288;
	bh=Fo2JSKXhe6+mRs01ELJJqUvX2uASm3w1OxIM/GJ9rfw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=i3krfB8X/IIifI9k3rdql9BxVPaLAhI80oG5ROq/giqrRjfpK5zMXNA+OQoiEECg7
	 3UwRxIHfvKqve7ZLMmf6r6YYWEafRojYyZ30ECieiAINv2sOB8HOiT+2rCXp/6t90w
	 9N1GyIB3A1ViAy1s+C2QyoNUUyLT1PZHBl8daNfo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392691AbgJPUsI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392676AbgJPUsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68612145D;
        Fri, 16 Oct 2020 20:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881287;
        bh=Fo2JSKXhe6+mRs01ELJJqUvX2uASm3w1OxIM/GJ9rfw=;
        h=Date:From:To:Subject:From;
        b=IKbU/K/jA/hb/nxXZPkJwHXr2JpvmFvaYg4r0i1zH/eXKuGNZvo5bnrQ41RqT1wHd
         hxy78AsCGRvXpGFT+fEwTingPh0egyC1KnGOFno2qnj+Khrsw8FpA6LEZt/HBOsuH4
         BTavr0y7kl3/cLtQQek4GHZrAtvHNS0jF9g51yZ0=
Date:   Fri, 16 Oct 2020 13:48:06 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, kirill@shutemov.name, mm-commits@vger.kernel.org,
        songliubraving@fb.com, willy@infradead.org
Subject:  [merged]
 mm-filemap-fix-storing-to-a-thp-shadow-entry.patch removed from -mm tree
Message-ID: <20201016204806.gHPqfibTf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix storing to a THP shadow entry
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-storing-to-a-thp-shadow-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: fix storing to a THP shadow entry

When a THP is removed from the page cache by reclaim, we replace it with a
shadow entry that occupies all slots of the XArray previously occupied by
the THP.  If the user then accesses that page again, we only allocate a
single page, but storing it into the shadow entry replaces all entries
with that one page.  That leads to bugs like

page dumped because: VM_BUG_ON_PAGE(page_to_pgoff(page) != offset)
------------[ cut here ]------------
kernel BUG at mm/filemap.c:2529!

https://bugzilla.kernel.org/show_bug.cgi?id=206569

This is hard to reproduce with mainline, but happens regularly with the
THP patchset (as so many more THPs are created).  This solution is take
from the THP patchset.  It splits the shadow entry into order-0 pieces at
the time that we bring a new page into cache.

Link: https://lkml.kernel.org/r/20200903183029.14930-4-willy@infradead.org
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-storing-to-a-thp-shadow-entry
+++ a/mm/filemap.c
@@ -829,13 +829,12 @@ EXPORT_SYMBOL_GPL(replace_page_cache_pag
 
 static int __add_to_page_cache_locked(struct page *page,
 				      struct address_space *mapping,
-				      pgoff_t offset, gfp_t gfp_mask,
+				      pgoff_t offset, gfp_t gfp,
 				      void **shadowp)
 {
 	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);
 	int error;
-	void *old;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
@@ -846,25 +845,46 @@ static int __add_to_page_cache_locked(st
 	page->index = offset;
 
 	if (!huge) {
-		error = mem_cgroup_charge(page, current->mm, gfp_mask);
+		error = mem_cgroup_charge(page, current->mm, gfp);
 		if (error)
 			goto error;
 	}
 
+	gfp &= GFP_RECLAIM_MASK;
+
 	do {
+		unsigned int order = xa_get_order(xas.xa, xas.xa_index);
+		void *entry, *old = NULL;
+
+		if (order > thp_order(page))
+			xas_split_alloc(&xas, xa_load(xas.xa, xas.xa_index),
+					order, gfp);
 		xas_lock_irq(&xas);
-		old = xas_load(&xas);
-		if (old && !xa_is_value(old))
-			xas_set_err(&xas, -EEXIST);
+		xas_for_each_conflict(&xas, entry) {
+			old = entry;
+			if (!xa_is_value(entry)) {
+				xas_set_err(&xas, -EEXIST);
+				goto unlock;
+			}
+		}
+
+		if (old) {
+			if (shadowp)
+				*shadowp = old;
+			/* entry may have been split before we acquired lock */
+			order = xa_get_order(xas.xa, xas.xa_index);
+			if (order > thp_order(page)) {
+				xas_split(&xas, old, order);
+				xas_reset(&xas);
+			}
+		}
+
 		xas_store(&xas, page);
 		if (xas_error(&xas))
 			goto unlock;
 
-		if (xa_is_value(old)) {
+		if (old)
 			mapping->nrexceptional--;
-			if (shadowp)
-				*shadowp = old;
-		}
 		mapping->nrpages++;
 
 		/* hugetlb pages do not participate in page cache accounting */
@@ -872,7 +892,7 @@ static int __add_to_page_cache_locked(st
 			__inc_lruvec_page_state(page, NR_FILE_PAGES);
 unlock:
 		xas_unlock_irq(&xas);
-	} while (xas_nomem(&xas, gfp_mask & GFP_RECLAIM_MASK));
+	} while (xas_nomem(&xas, gfp));
 
 	if (xas_error(&xas)) {
 		error = xas_error(&xas);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

