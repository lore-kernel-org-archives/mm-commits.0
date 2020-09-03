Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8379FC433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C7C4208C7
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599160377;
	bh=6Z6ED9aEWK1+rVkd+G90INxVrRGYOHwcnp1nbguOpTM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MGxHT3gtTxW76WE4tjSTa1r7SCJFy9t/AOoyW+VBk0ZCNQTdXTwPmL1Jd6sz5Hhzy
	 NbCpat9zRBPXrPL+LojWjL9P12TA0gWgp3Iynp+ZhuI36Hk23ofUXAjpuY/a+f9Ew8
	 wxeshjIKHIKD2u72ZfFSIS/dzLTU5NzZuV5TWukA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgICTM5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgICTMz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:12:55 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95D11208CA;
        Thu,  3 Sep 2020 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599160374;
        bh=6Z6ED9aEWK1+rVkd+G90INxVrRGYOHwcnp1nbguOpTM=;
        h=Date:From:To:Subject:From;
        b=vFQWfvDFxq/fIshwWd1gwLwlm3qdt+kiQMwfKUN0u/uKy/bTBMqjxfg2jm+f4CQkr
         2VgKIx/bWlVFPFVyecOxyfihfazWLkwJjG7WTqj/G4Pc/abl6M1m/iaD6SPoV17yNE
         +P/RYKO84C7WZD2V/KeKUZnzNyd/KNUzYCFzSXTI=
Date:   Thu, 03 Sep 2020 12:12:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songliubraving@fb.com,
        kirill@shutemov.name, cai@lca.pw, willy@infradead.org
Subject:  + mm-filemap-fix-storing-to-a-thp-shadow-entry.patch added
 to -mm tree
Message-ID: <20200903191254.lkHH0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix storing to a THP shadow entry
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-storing-to-a-thp-shadow-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-storing-to-a-thp-shadow-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
harden-autofs-ioctl-table.patch

