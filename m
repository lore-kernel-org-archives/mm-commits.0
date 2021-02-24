Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6904CC4332D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4432D60202
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhBXUKv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234908AbhBXUKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96CD64F28;
        Wed, 24 Feb 2021 20:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197388;
        bh=kELzXRgMWhr84yS6vpamNA1MvvVXg1cqUXHnFSv7dMU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yi+9/Lh803MgLnPbL/joOHOTrqSX+H+eJDNgbCwdJf4HOQDC4WQgSl3GPpH4penhv
         3jPzFhqUZIQt0aW0cdM1OmwkgoH8YKNkXlBMNO9VDSBX5nBEzzV35faZHfqod8pWMe
         l3/yRu7m/Lqm3WgqGw2Zt2b+zXaOJx9cpGUw5bZo=
Date:   Wed, 24 Feb 2021 12:09:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 161/173] mm/mempolicy: use helper range_in_vma()
 in queue_pages_test_walk()
Message-ID: <20210224200947.1hilApkHE%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempolicy: use helper range_in_vma() in queue_pages_test_walk()

The helper range_in_vma() is introduced via commit 017b1660df89 ("mm:
migration: fix migration of huge PMD shared pages"). But we forgot to
use it in queue_pages_test_walk().

Link: https://lkml.kernel.org/r/20210130091352.20220-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk
+++ a/mm/mempolicy.c
@@ -677,7 +677,7 @@ static int queue_pages_test_walk(unsigne
 	unsigned long flags = qp->flags;
 
 	/* range check first */
-	VM_BUG_ON_VMA((vma->vm_start > start) || (vma->vm_end < end), vma);
+	VM_BUG_ON_VMA(!range_in_vma(vma, start, end), vma);
 
 	if (!qp->first) {
 		qp->first = vma;
_
