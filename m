Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1BDC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F4DD208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816125;
	bh=PKgMNX+8KteQF96qFEtB1MKyx9EewpWQNMl2uQYUp8o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=oeOPu1sQokffYIjr7To8o2HtivtBhJTsnaZRa0diejqXViAWZouDYBp3VcUTemnkz
	 YwACpe8muCs4d+Vhb3/8yhzgzOznRVwvC6V7+NR2RnA50InjCNJCxrX+x0TI9vE8Co
	 kfytJ26uFlHlzKfN18yy+2GieP1hadpDgCFT9YFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404296AbgJPCmE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgJPCmE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA5132087D;
        Fri, 16 Oct 2020 02:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816124;
        bh=PKgMNX+8KteQF96qFEtB1MKyx9EewpWQNMl2uQYUp8o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P/E5wr8s1/fgXkMVZ8DSCStHSSH+9cuDvdg2rHZd5ZtxjNBPl7kwsB4IF98gkl+dK
         jo0DUb52Wu/zqIyLBw07TS9b93ZPXtlWJFjmG37FNEp8igD/5D8HOLWeMHx6ELKphr
         EDvJH/XzLHn6M86ZbcHfJ+O5cVLUJaxVFZ+Ndd14=
Date:   Thu, 15 Oct 2020 19:42:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 019/156] mm/filemap: fix page cache removal for
 arbitrary sized THPs
Message-ID: <20201016024203.sQRJX93MR%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
