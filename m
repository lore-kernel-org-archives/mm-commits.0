Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F169C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E8D61C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhGFTVP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231742AbhGFTVP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8199261C7F;
        Tue,  6 Jul 2021 19:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599116;
        bh=tyKPg5FRmSEDdjavOZjKor+AWoKKW6NO+6SG/kv8C9M=;
        h=Date:From:To:Subject:From;
        b=rJZd0/dZXiCiqeigk9uuHUJN1kobMo1YXVJ13KwxAiWUL05lEspALIX3bujs38dWo
         8R7FQTdQiy7eSGE+bk8qt5SmLHpwlFirbauQsTieiu3QKJ5YVwNaNHSQ9fz7XjI33/
         8gucPkbOWI9nuTmUl6Iof0eXaxNXHzQD97OLxL1k=
Date:   Tue, 06 Jul 2021 12:18:36 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch removed from -mm
 tree
Message-ID: <20210706191836.pcueQPU71%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: avoid possible underflow in z3fold_alloc()
has been removed from the -mm tree.  Its filename was
     mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: avoid possible underflow in z3fold_alloc()

It is not enough to just make sure the z3fold header is not larger than
the page size.  When z3fold header is equal to PAGE_SIZE, we would
underflow when check alloc size against PAGE_SIZE - ZHDR_SIZE_ALIGNED -
CHUNK_SIZE in z3fold_alloc().  Make sure there has remaining spaces for
its buddy to fix this theoretical issue.

Link: https://lkml.kernel.org/r/20210619093151.1492174-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-avoid-possible-underflow-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -1803,8 +1803,11 @@ static int __init init_z3fold(void)
 {
 	int ret;
 
-	/* Make sure the z3fold header is not larger than the page size */
-	BUILD_BUG_ON(ZHDR_SIZE_ALIGNED > PAGE_SIZE);
+	/*
+	 * Make sure the z3fold header is not larger than the page size and
+	 * there has remaining spaces for its buddy.
+	 */
+	BUILD_BUG_ON(ZHDR_SIZE_ALIGNED > PAGE_SIZE - CHUNK_SIZE);
 	ret = z3fold_mount();
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

