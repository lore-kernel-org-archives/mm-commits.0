Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F726C64EC5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjBCGgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjBCGf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9588C408
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F97ACE2ED9
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0B5C433EF;
        Fri,  3 Feb 2023 06:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406155;
        bh=Pd/P9/EvVkzjOHN+c0fsHQDWQppCsXWX2J5tMdyACCQ=;
        h=Date:To:From:Subject:From;
        b=PiWJK5lWK/t/6gXPCt7W9tGgdf7ePHKEmKm0RG8v5f+gKfFZwQGlg98qjImAZU1L2
         KDcDue7fKArn3m/QvFACdUA7b9Qyn3jlWBUrXDkW/DveHb0wmHq89yotSYvsaFIG3I
         fa/W3Pw81XFuWr2+U0lD2hM46zc7PsvImK+uwMPU=
Date:   Thu, 02 Feb 2023 22:35:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch removed from -mm tree
Message-Id: <20230203063555.4E0B5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: remove uses of compound_dtor and compound_nr
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: remove uses of compound_dtor and compound_nr
Date: Wed, 11 Jan 2023 14:29:07 +0000

Convert the entire file to use the folio equivalents.

Link: https://lkml.kernel.org/r/20230111142915.1001531-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlb-remove-uses-of-compound_dtor-and-compound_nr
+++ a/mm/hugetlb.c
@@ -2038,11 +2038,12 @@ static bool prep_compound_gigantic_folio
  */
 int PageHuge(struct page *page)
 {
+	struct folio *folio;
+
 	if (!PageCompound(page))
 		return 0;
-
-	page = compound_head(page);
-	return page[1].compound_dtor == HUGETLB_PAGE_DTOR;
+	folio = page_folio(page);
+	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
@@ -2052,10 +2053,11 @@ EXPORT_SYMBOL_GPL(PageHuge);
  */
 int PageHeadHuge(struct page *page_head)
 {
-	if (!PageHead(page_head))
+	struct folio *folio = (struct folio *)page_head;
+	if (!folio_test_large(folio))
 		return 0;
 
-	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
+	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
 }
 EXPORT_SYMBOL_GPL(PageHeadHuge);
 
_

Patches currently in -mm which might be from willy@infradead.org are


