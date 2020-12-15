Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12376C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8F7223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgLODPa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgLODMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:54 -0500
Date:   Mon, 14 Dec 2020 19:11:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001915;
        bh=m1Z/gO14a9ggIZdpukgQG2MyYBHP6VRD+9kbBGQP3dg=;
        h=From:To:Subject:In-Reply-To:From;
        b=L8/p42pegZCHy3A26E4+jgspSTlZUVvK16FvSFNJRvll9aeXaYAMdv70mevusVSev
         wOGsg3aALHT63M79C3ZGOEUZJwlzIAyLA7s8GrH+YRA/v8IrfbrWdw9+EOmlSvh5Wc
         l6Nss1OWSc4UWjOFkbggqQ7PRlUdNhoScSL1Ia/k=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        sh_def@163.com, torvalds@linux-foundation.org
Subject:  [patch 146/200] mm/hugetlb.c: just use
 put_page_testzero() instead of page_count()
Message-ID: <20201215031155.1ITdUWoDy%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/hugetlb.c: just use put_page_testzero() instead of page_count()

We test the page reference count is zero or not here, it can be a bug here
if page refercence count is not zero.  So we can just use
put_page_testzero() instead of page_count().

Link: https://lkml.kernel.org/r/20201007170949.GA6416@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count
+++ a/mm/hugetlb.c
@@ -2014,8 +2014,7 @@ retry:
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		put_page_testzero(page);
-		VM_BUG_ON_PAGE(page_count(page), page);
+		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
 		enqueue_huge_page(h, page);
 	}
 free:
_
