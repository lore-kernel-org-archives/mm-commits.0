Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9B1C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6997D61474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbhGABxC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABxB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 140BA61468;
        Thu,  1 Jul 2021 01:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104231;
        bh=bMZghlfwKOQnCH7xwNfRdzA6t6/oFT5kgSFzQsMvzLU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h70G1lb7JeJ6TBPZyfMTFkVEsiQ5fC8NEni3BBtOjpm+A7KMHmmPnPWSDJqXEg7wf
         IpFWWcDSqUD+NdSq5+bW2HyztgBYAKisFbfTk8LCq4OPar7lV7wEm9TRlIX66APfu2
         Xhyfmb7EBkctktQyyplQblvNp/Sg6IJVQ0zpVrRo=
Date:   Wed, 30 Jun 2021 18:50:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 062/192] mm/z3fold: remove magic number in
 z3fold_create_pool()
Message-ID: <20210701015030.igMLYc0-G%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: remove magic number in z3fold_create_pool()

It's meaningless to pass a magic number 2 to __alloc_percpu() as there is
a minimum alignment size of PCPU_MIN_ALLOC_SIZE (> 2) in it.  Also there
is no special alignment requirement for unbuddied.  So we could replace
this magic number with nature alignment, i.e.  __alignof__(struct
list_head), to improve readability.

Link: https://lkml.kernel.org/r/20210619093151.1492174-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-remove-magic-number-in-z3fold_create_pool
+++ a/mm/z3fold.c
@@ -998,7 +998,8 @@ static struct z3fold_pool *z3fold_create
 		goto out_c;
 	spin_lock_init(&pool->lock);
 	spin_lock_init(&pool->stale_lock);
-	pool->unbuddied = __alloc_percpu(sizeof(struct list_head)*NCHUNKS, 2);
+	pool->unbuddied = __alloc_percpu(sizeof(struct list_head) * NCHUNKS,
+					 __alignof__(struct list_head));
 	if (!pool->unbuddied)
 		goto out_pool;
 	for_each_possible_cpu(cpu) {
_
