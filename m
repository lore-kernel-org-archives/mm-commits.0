Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC981C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A0EE221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709380;
	bh=w0oGJdnKICWvxYPw2Yqb0GriofdhukY6G2JWHdTnlvA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CWWZl3QBYenoG7ApkhhCCPlj+EI83aIAyNw8v4WJ84kRp8ZaBjoI0bLMZVj42Sh5u
	 hBdfz5/gNrsn+iCsF0v7wMmiUkPCgz8vR3chZ8MU2dZ5xSWRbiJps90L+IWOKSMPVV
	 GdCIsZ4HmyXZt5urnC8kut/rdWoRX5bUbuyzI/0I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgJNVDA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVC7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5DDC214D8;
        Wed, 14 Oct 2020 21:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709379;
        bh=w0oGJdnKICWvxYPw2Yqb0GriofdhukY6G2JWHdTnlvA=;
        h=Date:From:To:Subject:From;
        b=RHmrrU4Htp1lYv4aL0PHrsAAjghGxiQED064YDsWD8uXizltINO3XIMAToKWfVPHC
         8NLTcr6EMOqoVhE3RkrKlrjO10flY0ENIzMd2EgZm5xOc1U3TKe2n08iywMUJwvvbU
         BHYB6Y/fUrOCjepPP37kdcJh7Q9sJTKf8t862nX0=
Date:   Wed, 14 Oct 2020 14:02:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        willy@infradead.org, yuzhao@google.com
Subject:  [merged]
 mm-move-call-to-compound_head-in-release_pages.patch removed from -mm tree
Message-ID: <20201014210258.g3FgScmN5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move call to compound_head() in release_pages()
has been removed from the -mm tree.  Its filename was
     mm-move-call-to-compound_head-in-release_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rcampbell@nvidia.com are


