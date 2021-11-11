Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2A8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BDF61884
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhKKCoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhKKCoD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76DE361284;
        Thu, 11 Nov 2021 02:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598475;
        bh=pnGCEs5/RRTOhz64jL7GhlqHkHISHXY9rCaTyUd9V4M=;
        h=Date:From:To:Subject:From;
        b=KxAXTPKXjMJH7q2HDp9caIQpBp/lSOzU+IkcL+SvtKHS77KExdaBlKEHYQLtfVBvy
         ransO5F5yFD81Im4J/1ZRL9jg+EwrElpIsdvrFIYbHeUsx5lNgyMfvnYzKgxptd/0y
         ybedx3/zEs4udeGJCy5386UORd41WgVeo9tDH5EA=
Date:   Wed, 10 Nov 2021 18:41:15 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        zhangyinan2019@email.szu.edu.cn
Subject:  [merged] mm-fix-a-comment.patch removed from -mm tree
Message-ID: <20211111024115.eG9BTlO0S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext.c: fix a comment
has been removed from the -mm tree.  Its filename was
     mm-fix-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Subject: mm/page_ext.c: fix a comment

I have noticed that the previous macro is #ifndef CONFIG_SPARSEMEM.  I
think the comment of #else should be CONFIG_SPARSEMEM.

Link: https://lkml.kernel.org/r/20211008140312.6492-1-zhangyinan2019@email.szu.edu.cn
Signed-off-by: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_ext.c~mm-fix-a-comment
+++ a/mm/page_ext.c
@@ -201,7 +201,7 @@ fail:
 	panic("Out of memory");
 }
 
-#else /* CONFIG_FLATMEM */
+#else /* CONFIG_SPARSEMEM */
 
 struct page_ext *lookup_page_ext(const struct page *page)
 {
_

Patches currently in -mm which might be from zhangyinan2019@email.szu.edu.cn are


