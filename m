Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F1DC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1536F2065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026943;
	bh=wG8wELLpNop4wfRGeYRsjb0EkooU7pKu5fd7CLH/JR0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nnVKqGpOlKKxTrK1eoLeubbXRHyegw4pCIqGkKQg/dM9ZvQzf4sEpbd9DnofRV/3m
	 tqtw5cXG5Ja55296lB7o0z5BVMiqrLq74tUomu+ZiaRm6ct2Mp5c/ios6xIgsQAECt
	 j3qAdaWxuzVsMWp7Rx4mVDRwtrV3EID5PfjihObo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgHJCfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9591B2073E;
        Mon, 10 Aug 2020 02:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026941;
        bh=wG8wELLpNop4wfRGeYRsjb0EkooU7pKu5fd7CLH/JR0=;
        h=Date:From:To:Subject:From;
        b=Zq5sIUkMWsPfsL0fhDfKUeE7VQiTbP68onJJvxD3CK8XfRHRSF5aCbasgs5Lv3If3
         WEey6A8GfyQhwzJ/5ogX0G1HR7j//evhea4RHS9Nuw8WIELAf44OckM4EC5uz61Vno
         A0MSNcOcG2y7WUIrqwzZ75L8ipB9lxfS4dZgKaYE=
Date:   Sun, 09 Aug 2020 19:35:41 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged]
 mm-dump-compound-page-information-on-a-second-line.patch removed from -mm
 tree
Message-ID: <20200810023541.LirL2DYyW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: dump compound page information on a second line
has been removed from the -mm tree.  Its filename was
     mm-dump-compound-page-information-on-a-second-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: dump compound page information on a second line

Simplify both the implementation and the output by splitting all the
compound page information onto a second line.

Link: http://lkml.kernel.org/r/20200709202117.7216-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/mm/debug.c~mm-dump-compound-page-information-on-a-second-line
+++ a/mm/debug.c
@@ -95,27 +95,21 @@ void __dump_page(struct page *page, cons
 	 */
 	mapcount = PageSlab(head) ? 0 : page_mapcount(page);
 
-	if (compound)
+	pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
+			page, page_ref_count(head), mapcount, mapping,
+			page_to_pgoff(page));
+	if (compound) {
 		if (hpage_pincount_available(page)) {
-			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
-				"index:%#lx head:%px order:%u "
-				"compound_mapcount:%d compound_pincount:%d\n",
-				page, page_ref_count(head), mapcount,
-				mapping, page_to_pgoff(page), head,
-				compound_order(head), compound_mapcount(page),
-				compound_pincount(page));
+			pr_warn("head:%px order:%u compound_mapcount:%d compound_pincount:%d\n",
+					head, compound_order(head),
+					compound_mapcount(head),
+					compound_pincount(head));
 		} else {
-			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
-				"index:%#lx head:%px order:%u "
-				"compound_mapcount:%d\n",
-				page, page_ref_count(head), mapcount,
-				mapping, page_to_pgoff(page), head,
-				compound_order(head), compound_mapcount(page));
+			pr_warn("head:%px order:%u compound_mapcount:%d\n",
+					head, compound_order(head),
+					compound_mapcount(head));
 		}
-	else
-		pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
-			page, page_ref_count(page), mapcount,
-			mapping, page_to_pgoff(page));
+	}
 	if (PageKsm(page))
 		type = "ksm ";
 	else if (PageAnon(page))
_

Patches currently in -mm which might be from willy@infradead.org are

mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
poison-remove-obsolete-comment.patch

