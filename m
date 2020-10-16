Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285D2C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D78002087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817525;
	bh=PKgMNX+8KteQF96qFEtB1MKyx9EewpWQNMl2uQYUp8o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aLKw9u/OZmpRKOOyLMnXsXEiarcwwqI3tgQSX+fbc+F2UQW7ZC7R/MLDDXkyzW9fm
	 FolxfBHUxy9dyhNlYNsQ49iq3em9JLw0eL/NtV1ALo5JzCi8B8GvFG2g60KXlorByw
	 +YwHTBRZC59UrFwRiFzDpRMQRNQwTBv4aN1k+1C8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393936AbgJPDFZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 061C220897;
        Fri, 16 Oct 2020 03:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817524;
        bh=PKgMNX+8KteQF96qFEtB1MKyx9EewpWQNMl2uQYUp8o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bHKWxpEffcMZV969d6YntZYoGdEhAxerpP3MyytNJMv3K0H1Xk8A2asUEN8tdzZrJ
         kiDxwLBKnU1d/ufUhXr/Poa5fSf2b3pKEJ4VGuqmK7oFBWQjmXY4xckmhUuQnJq51U
         tx6YEZsdOFyvHPNZ1rsQ7an77/siMk9zXl0bHFIk=
Date:   Thu, 15 Oct 2020 20:05:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 019/156] mm/filemap: fix page cache removal for
 arbitrary sized THPs
Message-ID: <20201016030523.AL6me_biW%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
