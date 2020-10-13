Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418D5C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A4282222E
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633142;
	bh=EyxQQam85xm4eDY5X89SSBclFJsSYqiJRA9cKSNIEqE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=yqg2yIxinZ34Aef6w16EpCkIZC8TD52vAYC6mSukYgEY8rEXwr6TBKLnlF/7McPtg
	 U5v98ocKoTkUK0q3CBckgEpxRsZXHnF48oeE8l7qjvDmZ2T5pE2rF0YLfyOcBaN1CG
	 JRjsL/6rICYMTzuQPv3y0CrFSZfQg+9757VQ0Ad4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgJMXwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgJMXwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7592C22202;
        Tue, 13 Oct 2020 23:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633135;
        bh=EyxQQam85xm4eDY5X89SSBclFJsSYqiJRA9cKSNIEqE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wLNiyzI/9YfHvIKXGbbZF6b4OP+4DFS4u0/p9X2NpQzp3MS+y4yhI9w7z8ZwhcSBf
         VvtukVyWD4MG2Jzd1U7MP/e8ljhMsi7nbEskeSntS/pMfOPAaHIm34/7YUwbU0hCvC
         wcW7+3jpKjtNyxbdG53rHnHw9eSxk3ZBzW/5Ei9o=
Date:   Tue, 13 Oct 2020 16:52:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 071/181] mm/swap.c: fix confusing comment in
 release_pages()
Message-ID: <20201013235215.3jh7qlg9J%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap.c: fix confusing comment in release_pages()

Since commit 07d802699528 ("mm: devmap: refactor 1-based refcounting for
ZONE_DEVICE pages"), we have renamed the func put_devmap_managed_page() to
page_is_devmap_managed().

Link: https://lkml.kernel.org/r/20200905084453.19353-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-confusing-comment-in-release_pages
+++ a/mm/swap.c
@@ -902,7 +902,7 @@ void release_pages(struct page **pages,
 			}
 			/*
 			 * ZONE_DEVICE pages that return 'false' from
-			 * put_devmap_managed_page() do not require special
+			 * page_is_devmap_managed() do not require special
 			 * processing, and instead, expect a call to
 			 * put_page_testzero().
 			 */
_
