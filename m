Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F95C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B919864FB7
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhBECej (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhBECdx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B1564FBE;
        Fri,  5 Feb 2021 02:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492381;
        bh=b1DxOcOqwfE5+Jwl+Bfd1Px9tLz4gowrSr/e+e0TsdQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q9AjBvrANEtR8x74nTbno+zIAGwrRnDCQ9TRa8n+1Ds4hb9TqC0iJgpbSXfzzgNHZ
         9yuhazaXDzVsM0sF+TUmTNXS2h4mnpQP6+84mdBsn+Mpot//0GirEZC2bcE1a8mFDH
         YAgZUT04hJk3i1YbVFaTnqvdtUNxXYIkqGEZq4qw=
Date:   Thu, 04 Feb 2021 18:33:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 17/18] mm: hugetlb: fix missing put_page in
 gather_surplus_pages()
Message-ID: <20210205023300.kuRDAAZIZ%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: fix missing put_page in gather_surplus_pages()

The VM_BUG_ON_PAGE avoids the generation of any code, even if that
expression has side-effects when !CONFIG_DEBUG_VM.

Link: https://lkml.kernel.org/r/20210126031009.96266-1-songmuchun@bytedance.com
Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -2047,13 +2047,16 @@ retry:
 
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		int zeroed;
+
 		if ((--needed) < 0)
 			break;
 		/*
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
+		zeroed = put_page_testzero(page);
+		VM_BUG_ON_PAGE(!zeroed, page);
 		enqueue_huge_page(h, page);
 	}
 free:
_
