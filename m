Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6703AC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5220161C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhGFTVR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231865AbhGFTVR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EEF61C87;
        Tue,  6 Jul 2021 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599118;
        bh=r+QxuJqOqMvY3jESwSE9G/lkMnnFhP5CLLnTXWQsldA=;
        h=Date:From:To:Subject:From;
        b=r8e8Xwn6Ldfk3tHauaeElYaDWDF5amrdEeWcOwJftwePpPjW11okZsQ6duC49GfW1
         TVo498ZRjKD5YyooO2yYBvW5F4qAtICCuPWlLwN7Rv5NmhOy66uhPIqwU5WDvWKpKu
         ZdppZQ9onauioKXUlKcXv/q3kofSjHyD9UtHC4H0=
Date:   Tue, 06 Jul 2021 12:18:38 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-z3fold-remove-magic-number-in-z3fold_create_pool.patch removed from -mm
 tree
Message-ID: <20210706191838.RTukmbjWQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: remove magic number in z3fold_create_pool()
has been removed from the -mm tree.  Its filename was
     mm-z3fold-remove-magic-number-in-z3fold_create_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

