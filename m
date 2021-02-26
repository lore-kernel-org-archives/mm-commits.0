Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA98C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13A564F2C
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBZBTD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhBZBSr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BFBC64F27;
        Fri, 26 Feb 2021 01:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302287;
        bh=o6FBAWVWSbku31OQl5AYFKq5xoM0tAOVECW09qXUk+8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LpmFE1iWvF6EfkgB4dHWY213BjDTkDIUUAPyaoEY7LKguY0w4aEa50gQ5tgzQYgGN
         YghF0IkssN9e/EVOeMu3uGWQ0NnNx7QqmzweX5BeqH1z4rU37BUFfUvPIDqf6sahqZ
         e28oqFJhlRXXEsWOVZCFssazbOmSiXZt5astB758=
Date:   Thu, 25 Feb 2021 17:18:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 044/118] mm/rmap: correct obsolete comment of
 page_get_anon_vma()
Message-ID: <20210226011806.4im9na6_G%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: correct obsolete comment of page_get_anon_vma()

Since commit 746b18d421da ("mm: use refcounts for page_lock_anon_vma()"),
page_lock_anon_vma() is renamed to page_get_anon_vma() and converted to
return a refcount increased anon_vma.  But it forgot to change the
relevant comment.

Link: https://lkml.kernel.org/r/20210203093215.31990-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-correct-obsolete-comment-of-page_get_anon_vma
+++ a/mm/rmap.c
@@ -462,8 +462,8 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
  *
  * Since there is no serialization what so ever against page_remove_rmap()
- * the best this function can do is return a locked anon_vma that might
- * have been relevant to this page.
+ * the best this function can do is return a refcount increased anon_vma
+ * that might have been relevant to this page.
  *
  * The page might have been remapped to a different anon_vma or the anon_vma
  * returned may already be freed (and even reused).
_
