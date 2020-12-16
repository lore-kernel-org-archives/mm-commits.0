Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DE3C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EA3223406
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgLPRJr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59887 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgLPRJr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:47 -0500
Date:   Wed, 16 Dec 2020 09:08:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138532;
        bh=TtxnTwM6ZxMUAN9fXaIm9Aed9NBXQA1twkwhs5ag8mU=;
        h=From:To:Subject:From;
        b=Nz2yZj+iLTJgUEyaWfynTTkf29wjSpA5GurzfUkZdahLKlJsFTmT+P33qSf5s/VEg
         Y9T1Rh7au3RrSYUna4G0n4vFc/8DLhnTq7FTso2tccXVqqQxXBXehRwGQbNxcCYTyZ
         4cqZqvPCRYa0mHhpRoAbdYfSpZuxn1tUpOfXKH3k=
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 lib-stackdepotc-use-array_size-helper-in-jhash2.patch removed from -mm tree
Message-ID: <20201216170852.9KYOf0WYs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: use array_size() helper in jhash2()
has been removed from the -mm tree.  Its filename was
     lib-stackdepotc-use-array_size-helper-in-jhash2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: lib/stackdepot.c: use array_size() helper in jhash2()

Use array_size() helper instead of the open-coded version in jhash2(). 
These sorts of multiplication factors need to be wrapped in array_size().

Also, use the preferred form for passing the size of an object type.

Link: https://lkml.kernel.org/r/cb8a682e4bba4dbddd2bd8aca7f8c02fea89639b.1601565471.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepotc-use-array_size-helper-in-jhash2
+++ a/lib/stackdepot.c
@@ -154,8 +154,8 @@ static struct stack_record *stack_table[
 static inline u32 hash_stack(unsigned long *entries, unsigned int size)
 {
 	return jhash2((u32 *)entries,
-			       size * sizeof(unsigned long) / sizeof(u32),
-			       STACK_HASH_SEED);
+		      array_size(size,  sizeof(*entries)) / sizeof(u32),
+		      STACK_HASH_SEED);
 }
 
 /* Use our own, non-instrumented version of memcmp().
_

Patches currently in -mm which might be from gustavoars@kernel.org are


