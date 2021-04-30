Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFF7C43600
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FD661464
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhD3Fzm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhD3Fzm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB6C061459;
        Fri, 30 Apr 2021 05:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762095;
        bh=8l9rraAsolFYQBjxNTitVuOxLX/yq/q2OLLff4intL4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LWjwCy9ZsrOdfStDJfBjRQveSH8CGkGRW4K0EhHPe6Mw+NpJ1HOYrwBywe+s4uqAI
         0VDBiaWOxo6V7kiYnBlI9pxhcOA2Dxb21DDE6t8EUi/eeGNbWJBw4rQRcmwuTXbi1I
         ZDNKXC0NuQa/hF0wqezidC6rvnWa1tJG1bVkct9Q=
Date:   Thu, 29 Apr 2021 22:54:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 033/178] mm/kmemleak.c: fix a typo
Message-ID: <20210430055454.NY1Q8i5Sl%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: mm/kmemleak.c: fix a typo

s/interruptable/interruptible/

Link: https://lkml.kernel.org/r/20210319214140.23304-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-a-typo
+++ a/mm/kmemleak.c
@@ -1203,7 +1203,7 @@ static void update_refs(struct kmemleak_
 }
 
 /*
- * Memory scanning is a long process and it needs to be interruptable. This
+ * Memory scanning is a long process and it needs to be interruptible. This
  * function checks whether such interrupt condition occurred.
  */
 static int scan_should_stop(void)
_
