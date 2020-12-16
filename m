Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56639C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1160E23403
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgLPRJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgLPRJn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:43 -0500
Date:   Wed, 16 Dec 2020 09:08:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138530;
        bh=PmX2O3Kz74nFp6w3uNEkEoAtYlQu7oaNaPwTsVTh2pM=;
        h=From:To:Subject:From;
        b=zI2x159tNDkXPmxDuc/TsoCxpsC1vtUzDyvkVvb6TGj3eebME5AHaIkQEJBIHI+Nk
         BhUKQaKFWNq46FBMmZmqHMjM5Pzc/TdcKlcU98qOhscBBpqgSf9FrNe8uLSq6BOqjc
         BPLuz5pIx4IPrmQ9AMt2+N1i8VaUinf6on4Iktrs=
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 lib-stackdepotc-use-flex_array_size-helper-in-memcpy.patch removed from -mm
 tree
Message-ID: <20201216170850.J-0O8J1Wa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: use flex_array_size() helper in memcpy()
has been removed from the -mm tree.  Its filename was
     lib-stackdepotc-use-flex_array_size-helper-in-memcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from gustavoars@kernel.org are


