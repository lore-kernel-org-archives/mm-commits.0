Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CDAC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A90622246
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633362;
	bh=V8afr/ISGu8bfolhVbNirbweRZXldyRBGEBPEl5Gnh8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hTAjD2x8YSGV+NGI8BwoT+RuR9cjF76dcTvicUkNfHf4QetWLTdkwaJ6Df4aV0Mcz
	 4YTUQ9IShKVFRD7qQmjCmoHIXR14y4KX0uSSIJSuxyZbZNRVdzlsFCp/GhLDCW2/eA
	 gnCy8CY0wbnKRhD0EJoc9CkJSbTTPoPyZtchW2NI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388581AbgJMX4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX4C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 311082222F;
        Tue, 13 Oct 2020 23:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633361;
        bh=V8afr/ISGu8bfolhVbNirbweRZXldyRBGEBPEl5Gnh8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yeNs/z7vmwEriocEBEZJdKik9CP/MkDiG5iWZsHTMjh7F6BLb0hMPewZgzBUOJwfO
         p5IpW5PYe485XTCY0zLt10uOc0Oqgk8Tp21pkrAt8cKr/AGk/3e3VNPm/bAoP7OAs8
         vUWny5RFwSZZBSJpZu9GyakvEb6LcJTRAAsRuWM4=
Date:   Tue, 13 Oct 2020 16:56:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, torvalds@linux-foundation.org,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 138/181] mm: move call to compound_head() in
 release_pages()
Message-ID: <20201013235600.qVPy8ZgOD%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: move call to compound_head() in release_pages()

The function is_huge_zero_page() doesn't call compound_head() to make sure
the page pointer is a head page. The call to is_huge_zero_page() in
release_pages() is made before compound_head() is called so the test would
fail if release_pages() was called with a tail page of the huge_zero_page
and put_page_testzero() would be called releasing the page.
This is unlikely to be happening in normal use or we would be seeing all
sorts of process data corruption when accessing a THP zero page.

Looking at other places where is_huge_zero_page() is called, all seem to
only pass a head page so I think the right solution is to move the call
to compound_head() in release_pages() to a point before calling
is_huge_zero_page().

Link: https://lkml.kernel.org/r/20200917173938.16420-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-move-call-to-compound_head-in-release_pages
+++ a/mm/swap.c
@@ -889,6 +889,7 @@ void release_pages(struct page **pages,
 			locked_pgdat = NULL;
 		}
 
+		page = compound_head(page);
 		if (is_huge_zero_page(page))
 			continue;
 
@@ -910,7 +911,6 @@ void release_pages(struct page **pages,
 			}
 		}
 
-		page = compound_head(page);
 		if (!put_page_testzero(page))
 			continue;
 
_
