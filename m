Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994B9C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 455FA216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881291;
	bh=oyz5orblhLp8J+UsRWUNO8aYctRr31vbF1JcrQinnsk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bL+FNm8TjIU+QqAkwqWmrSjwA4Am/7tS/72Wo7xHhEmD3wRtBb7CWVuSY7bo/HNOv
	 HNy1KMRmNEYueAyHEakU+UQca8SuGOt+/NYS/xgGfL5mgkSv/LzWj2O8u5LRWk0IBY
	 9NXpT+XeWRs6D+4O+ZOm6oJJG/ngYHhT9PAq3pVM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392692AbgJPUsK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392676AbgJPUsK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5ECC214DB;
        Fri, 16 Oct 2020 20:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881290;
        bh=oyz5orblhLp8J+UsRWUNO8aYctRr31vbF1JcrQinnsk=;
        h=Date:From:To:Subject:From;
        b=LFJDmm9QEqQOGvGTLQYKYIY9pIjrZKlum8Mtl7iumGpud27uzs9j8HHNcY78+9DwD
         mt56FMuqvv5vRs0ldXOMbl/eddlzCTsWaJ3OY8RmCKtr7il9xqJn4pwtzpEWov6vjt
         V4v/JmFjzX8pfuXTW7VXlp8Z6SU2dVezMFpfk+xs=
Date:   Fri, 16 Oct 2020 13:48:09 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch removed
 from -mm tree
Message-ID: <20201016204809.eYeCQc5mA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix page cache removal for arbitrary sized THPs
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: fix page cache removal for arbitrary sized THPs

Patch series "Remove assumptions of THP size".

There are a number of places in the VM which assume that a THP is a PMD in
size.  That's true today, and remains true after this patch series, but
this is a prerequisite for switching to arbitrary-sized THPs. 
thp_nr_pages() still returns either HPAGE_PMD_NR or 1, but will be changed
later.


This patch (of 11):

page_cache_free_page() assumes THPs are PMD_SIZE; fix that assumption.

Link: https://lkml.kernel.org/r/20200908195539.25896-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200908195539.25896-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps
+++ a/mm/filemap.c
@@ -249,7 +249,7 @@ static void page_cache_free_page(struct
 		freepage(page);
 
 	if (PageTransHuge(page) && !PageHuge(page)) {
-		page_ref_sub(page, HPAGE_PMD_NR);
+		page_ref_sub(page, thp_nr_pages(page));
 		VM_BUG_ON_PAGE(page_count(page) <= 0, page);
 	} else {
 		put_page(page);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

