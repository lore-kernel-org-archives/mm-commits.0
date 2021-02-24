Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0D4C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 787E264F1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbhBXULF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234906AbhBXUKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16BCB64E20;
        Wed, 24 Feb 2021 20:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197363;
        bh=cbWVhJb2ikl9MPOfzpsd3ykSmD86J00qxvIHN0u7wzY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LK3mBFc5d+lEAOnttoR9xNMFXxpPVEmmiyG9jv3Z0b+4uef/moQizfMf58c6n6/cG
         gOv/c+xUejgEILcPS7Uzi6tYXXSiep6ZZGplNC/+3fh6KWfQh0mTladuS6/dSHmllK
         85pWuisGmufqy7Rj3EZk1b7uz55hYfIVyI/dAMV4=
Date:   Wed, 24 Feb 2021 12:09:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 154/173] z3fold: simplify the zhdr initialization
 code in init_z3fold_page()
Message-ID: <20210224200922.1vIVbQDbU%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: z3fold: simplify the zhdr initialization code in init_z3fold_page()

We can simplify the zhdr initialization by memset() the zhdr first instead
of set struct member to zero one by one.  This would also make code more
compact and clear.

Link: https://lkml.kernel.org/r/20210120085851.16159-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/z3fold.c~z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page
+++ a/mm/z3fold.c
@@ -413,16 +413,10 @@ static struct z3fold_header *init_z3fold
 	if (!slots)
 		return NULL;
 
+	memset(zhdr, 0, sizeof(*zhdr));
 	spin_lock_init(&zhdr->page_lock);
 	kref_init(&zhdr->refcount);
-	zhdr->first_chunks = 0;
-	zhdr->middle_chunks = 0;
-	zhdr->last_chunks = 0;
-	zhdr->first_num = 0;
-	zhdr->start_middle = 0;
 	zhdr->cpu = -1;
-	zhdr->foreign_handles = 0;
-	zhdr->mapped_count = 0;
 	zhdr->slots = slots;
 	zhdr->pool = pool;
 	INIT_LIST_HEAD(&zhdr->buddy);
_
