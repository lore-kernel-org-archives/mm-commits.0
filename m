Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED57C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A8E6146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbhGABwz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 539BE61241;
        Thu,  1 Jul 2021 01:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104225;
        bh=f+6Qn2B22xd5M7NPCeDNlxnSj2n14tkoCR1HN9n0za8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e13PMWw4TLg7xS/nuJ6/O1nMtRt2MItASwTkLS1S4LwQxMqQJX3/fO/wpyW3tYgCT
         xBThqp+mzD7Mu1ecRxHqerbEZBKeksYH85LWqgCUOJ4w3uYV6dKRXqcbH6Y6jZcEx6
         uaxq2yw3AU17D3EQgtIQawHTJeAOiY83/ont+roo=
Date:   Wed, 30 Jun 2021 18:50:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 060/192] mm/z3fold: define macro NCHUNKS as
 TOTAL_CHUNKS - ZHDR_CHUNKS
Message-ID: <20210701015024.4W8zL1V8o%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: define macro NCHUNKS as TOTAL_CHUNKS - ZHDR_CHUNKS

Patch series "Cleanup and fixup for z3fold".

This series contains cleanups to remove unused function, redefine macro to
improve readability and so on.  Also this fixes several bugs in z3fold,
such as memory leak in z3fold_destroy_pool().  More details can be found
in the respective changelogs.


This patch (of 6):

To improve code readability, we could define macro NCHUNKS as TOTAL_CHUNKS
- ZHDR_CHUNKS.  No functional change intended.

Link: https://lkml.kernel.org/r/20210619093151.1492174-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210619093151.1492174-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks
+++ a/mm/z3fold.c
@@ -62,7 +62,7 @@
 #define ZHDR_SIZE_ALIGNED round_up(sizeof(struct z3fold_header), CHUNK_SIZE)
 #define ZHDR_CHUNKS	(ZHDR_SIZE_ALIGNED >> CHUNK_SHIFT)
 #define TOTAL_CHUNKS	(PAGE_SIZE >> CHUNK_SHIFT)
-#define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
+#define NCHUNKS		(TOTAL_CHUNKS - ZHDR_CHUNKS)
 
 #define BUDDY_MASK	(0x3)
 #define BUDDY_SHIFT	2
_
