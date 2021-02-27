Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182B5C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3E064F3A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhB0Ca5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230140AbhB0Cah (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8696764F3E;
        Sat, 27 Feb 2021 02:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392998;
        bh=bFrk+kjF3Nyv2TahOqzj6ShETjeqf9HmYIBFpgt5kiQ=;
        h=Date:From:To:Subject:From;
        b=KO9ai0TreW2yR1vzX791Tw6RSZBZj6haHXb3816GLfAdVL5uqy6eQWfhbO5vTt1uJ
         hjnGTmOriT3LCHqKWxQEmjzaPc60OM9lCNtK68oaffVL5ovlDqKd962dr1cgP9yKwL
         c7UasqLzXAbKoebQy7PqC1U/T7OuPycg4VtVEIXk=
Date:   Fri, 26 Feb 2021 18:29:58 -0800
From:   akpm@linux-foundation.org
To:     a.p.zijlstra@chello.nl, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch removed from
 -mm tree
Message-ID: <20210227022958.PA4nlEnLB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: correct obsolete comment of page_get_anon_vma()
has been removed from the -mm tree.  Its filename was
     mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


