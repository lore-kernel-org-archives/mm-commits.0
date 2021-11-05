Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA05C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69BEB6125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhKEUj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhKEUj0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A965561262;
        Fri,  5 Nov 2021 20:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144606;
        bh=K30jLwJu2H2IwN4Vev+J4MYWEvdqbHjCEuX/VAadIw4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sZ86veP/gmd7mV3YY8JLyGqeM2FrNJHKbYhAXDwGwWRROuns0MQXzqLo2FgN/jZ2R
         TIZ1CL+hRtEmSZR0mMxfJ01MhNJp7wP32kJfRTNnSINOozELZNPhzcFs9mqzNcQcKK
         780vQJTFjw/gqajIGMtRWAiBLPckZfX5xdBmhI0U=
Date:   Fri, 05 Nov 2021 13:36:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, zhangyinan2019@email.szu.edu.cn
Subject:  [patch 040/262] mm/page_ext.c: fix a comment
Message-ID: <20211105203646.2UGG_XIty%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
