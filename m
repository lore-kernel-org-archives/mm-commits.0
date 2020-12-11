Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E534DC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 21:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01A92405A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 21:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgLKTnj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 14:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgLKTnA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 14:43:00 -0500
Date:   Fri, 11 Dec 2020 11:42:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607715740;
        bh=u98fueZKX6l1f/GBjP0aJq6B0ok1Q4pGFXHNYapxBlc=;
        h=From:To:Subject:From;
        b=OTFKH+gC+B2yAbtrmP9rkFppfEJSXBw9M9ilfjCPQiRO/+SY1X4OqzOcj8XJd3Hyq
         VplDLRgr8O+v3AMQKM1n/et1PowJMyCaqsFR29xFuTWp52w7jB2J8iZRYL+tV9JGyC
         ajgVE13wsd4p3rbTAPvV+Q7xTFXOvqFc+zUC0fBA=
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, dan.carpenter@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  +
 hugetlb-fix-an-error-code-in-hugetlb_reserve_pages.patch added to -mm tree
Message-ID: <20201211194219.XDX7Vic5a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: Fix an error code in hugetlb_reserve_pages()
has been added to the -mm tree.  Its filename is
     hugetlb-fix-an-error-code-in-hugetlb_reserve_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-an-error-code-in-hugetlb_reserve_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-an-error-code-in-hugetlb_reserve_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: hugetlb: Fix an error code in hugetlb_reserve_pages()

Preserve the error code from region_add() instead of returning success.

Link: https://lkml.kernel.org/r/X9NGZWnZl5/Mt99R@mwanda
Fixes: 0db9d74ed884 ("hugetlb: disable region_add file_region coalescing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

Patches currently in -mm which might be from dan.carpenter@oracle.com are

hugetlb-fix-an-error-code-in-hugetlb_reserve_pages.patch

