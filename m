Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F0FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6033A2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816123;
	bh=Nmw9wX1eASn4GgNDc9jm2A1Y4EdGgerStKFFG3lEero=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0sXiJssJfulUA3U6q7SF1ny34PAlwdV2BhLBpFhDJsXLSe8faUWg1Qn14T4QtjX9S
	 L32OrIbIZhgz4A/oskRgocEQzFBW8x682dhWSxcfssMR/nGWsJyVJ+wdDSIyGSBy+u
	 UpWKNEzUaC7cKLbeE/KTDZod2efiptg2fm0c+RaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404295AbgJPCmD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgJPCmC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 577A220897;
        Fri, 16 Oct 2020 02:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816120;
        bh=Nmw9wX1eASn4GgNDc9jm2A1Y4EdGgerStKFFG3lEero=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wrEmz5txQbLlH2OxXIypBIlZ1kezet0kf4RSDYJsTAyPFcC14CGsm5r3ZGGfyuvy0
         6DB50wLXJ1DqfLhNRxDJcuPy4yhzyBTgY62+JA2KPT+Fwl+fDbyXO9xMKllstgxZTw
         rZWkSG4iLRXCx1t7SZOCeWHvjKQBw44AdPzq6PPs=
Date:   Thu, 15 Oct 2020 19:41:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, kirill@shutemov.name,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 018/156] mm/filemap: fix storing to a THP shadow
 entry
Message-ID: <20201016024159.MuK94mohm%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
