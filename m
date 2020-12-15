Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B449C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5595C224BD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgLODNQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgLODNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:06 -0500
Date:   Mon, 14 Dec 2020 19:12:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001932;
        bh=TfADuCDw0ywavoLx0jSKEcKmz+bNhKi+uzTwudZG5hk=;
        h=From:To:Subject:In-Reply-To:From;
        b=Isp/0twZFa/YGu/l5B5IZEIpHMb/lY4KKEQ801cgXsPPgt/z9+waAv0zLC3wvMj6c
         yYmUkE/6keQ72MU7WWen9VYcuv5grVklBda6Jzg2fUwXRKZ50pTiwfC/Nq9enopI5v
         4gnnKW3kJiPfOus7la3rVLMWmPmbcukxRsbqD680=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        dan.carpenter@oracle.com, david@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org
Subject:  [patch 151/200] hugetlb: fix an error code in
 hugetlb_reserve_pages()
Message-ID: <20201215031211.IOpXNQQEn%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: hugetlb: fix an error code in hugetlb_reserve_pages()

Preserve the error code from region_add() instead of returning success.

Link: https://lkml.kernel.org/r/X9NGZWnZl5/Mt99R@mwanda
Fixes: 0db9d74ed884 ("hugetlb: disable region_add file_region coalescing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~hugetlb-fix-an-error-code-in-hugetlb_reserve_pages
+++ a/mm/hugetlb.c
@@ -5113,6 +5113,7 @@ int hugetlb_reserve_pages(struct inode *
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
+			ret = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
_
