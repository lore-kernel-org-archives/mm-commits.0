Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB18BC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80EB72313F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgLPEoP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgLPEoP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:15 -0500
Date:   Tue, 15 Dec 2020 20:43:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093788;
        bh=1k7VqyyUZbR3M+tfaIAckOATam0jAq+vTTRRI3L3bzQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=R6arNDs2vZvId+IgwAAUAy5XNuBb8BixaXobiTEyEIaRzrPveWl53nIuTDr6UdHra
         YxkBxsOhkdwVAXwue7zjy4crJN4nakwZrkYVAtD4TT/U+JRvkr92OSKKSd9aiCTvuI
         dJ3BMbq9xCGt3HPDMnFA7bSR0br9RPkM5wbiIw1o=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gustavoars@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 15/95] lib/stackdepot.c: use flex_array_size()
 helper in memcpy()
Message-ID: <20201216044307.Qzi6xASDs%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: lib/stackdepot.c: use flex_array_size() helper in memcpy()

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer overflows,
while at the same time makes it explicitly clear that we are dealing with
a flexible array member.

Link: https://lkml.kernel.org/r/186e37fe07196ee41a0e562fa8a8cb7a01112ec5.1601565471.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepotc-use-flex_array_size-helper-in-memcpy
+++ a/lib/stackdepot.c
@@ -135,7 +135,7 @@ static struct stack_record *depot_alloc_
 	stack->handle.slabindex = depot_index;
 	stack->handle.offset = depot_offset >> STACK_ALLOC_ALIGN;
 	stack->handle.valid = 1;
-	memcpy(stack->entries, entries, size * sizeof(unsigned long));
+	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
 	depot_offset += required_size;
 
 	return stack;
_
