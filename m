Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4302BC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1082F206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026955;
	bh=FusuCiGGmgmxVuz4xdnoRZzQKVWgUc35TjZZ127Zv7A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KxO+rcncxBZT0E5K09oMVZHo3x0FapAj7fGa6Fbe5QP/iG54KQpLxQ5qAsEvJrVno
	 //wQfl3c3tMlJXCkXv3MGl1HO55LVM8zekvpwo+IHqRb+arTWKXKXt7OL8c4DoZyVI
	 zfspX3SwSkr2ECzDBj18WdFdZI8hIy6zQe+g65k8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHJCfy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A22E42065D;
        Mon, 10 Aug 2020 02:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026954;
        bh=FusuCiGGmgmxVuz4xdnoRZzQKVWgUc35TjZZ127Zv7A=;
        h=Date:From:To:Subject:From;
        b=VvtEvNOL4KY0iBvJjxmGbXIsu+FLWkE3kVAAlc3BItiYd47UPtEbFZ3AbJL2iPvwa
         dePCgI828q8XfF/j1TPSqiSlAtr7XCBn5LPPJz7poTYoqV7ACm7QdTH3Y1GfXNjwYf
         GNTp4sDjS6xvBnFl5SQukgfiQmwOeSYLFtQLaZgM=
Date:   Sun, 09 Aug 2020 19:35:53 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged] mm-print-hashed-address-of-struct-page.patch
 removed from -mm tree
Message-ID: <20200810023553.V2uAn2e8d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: print hashed address of struct page
has been removed from the -mm tree.  Its filename was
     mm-print-hashed-address-of-struct-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: print hashed address of struct page

The actual address of the struct page isn't particularly helpful, while
the hashed address helps match with other messages elsewhere.  Add the PFN
that the page refers to in order to help diagnose problems where the page
is improperly aligned for the purpose.

Link: http://lkml.kernel.org/r/20200709202117.7216-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/debug.c~mm-print-hashed-address-of-struct-page
+++ a/mm/debug.c
@@ -95,17 +95,17 @@ void __dump_page(struct page *page, cons
 	 */
 	mapcount = PageSlab(head) ? 0 : page_mapcount(page);
 
-	pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
+	pr_warn("page:%p refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			page, page_ref_count(head), mapcount, mapping,
-			page_to_pgoff(page));
+			page_to_pgoff(page), page_to_pfn(page));
 	if (compound) {
 		if (hpage_pincount_available(page)) {
-			pr_warn("head:%px order:%u compound_mapcount:%d compound_pincount:%d\n",
+			pr_warn("head:%p order:%u compound_mapcount:%d compound_pincount:%d\n",
 					head, compound_order(head),
 					compound_mapcount(head),
 					compound_pincount(head));
 		} else {
-			pr_warn("head:%px order:%u compound_mapcount:%d\n",
+			pr_warn("head:%p order:%u compound_mapcount:%d\n",
 					head, compound_order(head),
 					compound_mapcount(head));
 		}
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

