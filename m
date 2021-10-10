Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5880BC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D09560F24
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhJJV3D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhJJV3C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:29:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3BFE60F22;
        Sun, 10 Oct 2021 21:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633901223;
        bh=1SuVVmm1MxLrWmjzJm4cHmuZHzM/n5yUwCp7Jgf2MpY=;
        h=Date:From:To:Subject:From;
        b=0MQVPvwiFKo9RSF3Hd7jbe0LzvrSTxcgLO16jn6CoIaFW6F4KA890NYRjKDneY6PY
         ao61Z401pYTFs89OhqTzIMy3qHIgKhAHiRzTo4Ou5bQcYmdHYL3PQCQ60cz7e+C/Df
         bvjATFkxt1bmpba5DKiu1Wg2H2DNhefXIkvA2PXQ=
Date:   Sun, 10 Oct 2021 14:27:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        zhangyinan2019@email.szu.edu.cn
Subject:  + mm-fix-a-comment.patch added to -mm tree
Message-ID: <20211010212703.FDQiUjNkc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext.c: fix a comment
has been added to the -mm tree.  Its filename is
     mm-fix-a-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-a-comment.patch

