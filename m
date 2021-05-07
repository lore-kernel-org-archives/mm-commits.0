Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18C2C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5C30613C8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhEGBHW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhEGBHV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4726A613C9;
        Fri,  7 May 2021 01:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349582;
        bh=ecEPBwejH5YZrUkruoIQeeO9WUG/n1Wn7P0DjMaxW80=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sJT/nL6fdTcV5uUpcuR8dEft6lF3wrTwjjX6e1lWWC5X1GU/VIf/E4FpIqaj0Lofe
         fE09DC6zy7FlWoiiVOi4CKGxW/+8Xo/I45QqpivzjguxoQ1XygyePM/yaW8m28b5Cd
         OEnKO6gnVPG8xcarBA4ZyxFQ1t56BzXVuM8m/cog=
Date:   Thu, 06 May 2021 18:06:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 81/91] mm/slab.c: fix spelling mistake "disired"
 -> "desired"
Message-ID: <20210507010621.bO-Q-6syk%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Subject: mm/slab.c: fix spelling mistake "disired" -> "desired"

There is a spelling mistake in a comment. Fix it.

Link: https://lkml.kernel.org/r/20210317094158.5762-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c~mm-slab-fix-spelling-mistake-disired-desired
+++ a/mm/slab.c
@@ -2284,7 +2284,7 @@ void __kmem_cache_release(struct kmem_ca
  * Because if it is the case, that means we defer the creation of
  * the kmalloc_{dma,}_cache of size sizeof(slab descriptor) to this point.
  * And we eventually call down to __kmem_cache_create(), which
- * in turn looks up in the kmalloc_{dma,}_caches for the disired-size one.
+ * in turn looks up in the kmalloc_{dma,}_caches for the desired-size one.
  * This is a "chicken-and-egg" problem.
  *
  * So the off-slab slab descriptor shall come from the kmalloc_{dma,}_caches,
_
