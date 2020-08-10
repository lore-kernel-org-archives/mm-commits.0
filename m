Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE300C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C3A206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026945;
	bh=Q58VBq7/OpB9c38nz3WEUlBpi/Dg7Iuihpg2Pn45Y7U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HrN7YEA+GMbZgtaZLbDGEsaydcpEF2MZ2X1RFgv35z7Sszb8SnwMnJpK+TqKTkrEs
	 b5oOvDO7Zo3oWhL7m2EsnJMqEonih3j14iBYrV75LncTbkf6Ue7vy5OLeFmhqztzzm
	 Elus7UNGeLThFcane1ZHVECgnFSRotPBkavVzXkI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJCfp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9912065D;
        Mon, 10 Aug 2020 02:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026944;
        bh=Q58VBq7/OpB9c38nz3WEUlBpi/Dg7Iuihpg2Pn45Y7U=;
        h=Date:From:To:Subject:From;
        b=Bp5AiuNS8WUMwrtgUFdPBe+o7VC/l8nhNIetAbO5w4c1nJc76LocQxaDAxt18AUCr
         G38eWlElMwR0KXD92W57dGF4qxFS1A4Sy4Qjs9hXrSq/iUhUV1RwC2TiCnMopMq6Ux
         yclfvNtyEKTCvoTXbWj8Or2az6Wm7dxRuYcHYUw8=
Date:   Sun, 09 Aug 2020 19:35:44 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged] mm-print-head-flags-in-dump_page.patch removed
 from -mm tree
Message-ID: <20200810023544.aNig9ddJw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: print head flags in dump_page
has been removed from the -mm tree.  Its filename was
     mm-print-head-flags-in-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: print head flags in dump_page

Tail page flags contain very little useful information.  Print the head
page's flags instead.  While the flags will contain "head" for tail pages,
this should not be too confusing as the previous line starts with the word
"head:" and so the flags should be interpreted as belonging to the head
page.

Link: http://lkml.kernel.org/r/20200709202117.7216-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-print-head-flags-in-dump_page
+++ a/mm/debug.c
@@ -168,7 +168,7 @@ void __dump_page(struct page *page, cons
 out_mapping:
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
-	pr_warn("%sflags: %#lx(%pGp)%s\n", type, page->flags, &page->flags,
+	pr_warn("%sflags: %#lx(%pGp)%s\n", type, head->flags, &head->flags,
 		page_cma ? " CMA" : "");
 
 hex_only:
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

