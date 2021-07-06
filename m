Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A71C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A9C61C87
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhGFTVN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhGFTVN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 711F861C7C;
        Tue,  6 Jul 2021 19:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599114;
        bh=etdHzkJWmuUrWc37YM+77c4KLag8S+iynNk/82j+Fog=;
        h=Date:From:To:Subject:From;
        b=ctqDBEYuBHnSszW5X2RxJ/939Tv07+U9TjROl27nOpX9idJK3aAcNIulzlJ9ajkqz
         kQcNpe/wvgsfKnURQ+pS0667N7gC8acY1yG0NOW8E2Sp5r8EHKORjBTpNlVnqKEVZ3
         hTWuWZHrt/eG7RWD9GXjzu8IK+yh48gfd0qYOwFY=
Date:   Tue, 06 Jul 2021 12:18:34 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch removed
 from -mm tree
Message-ID: <20210706191834.cwOEKPxp1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: define macro NCHUNKS as TOTAL_CHUNKS - ZHDR_CHUNKS
has been removed from the -mm tree.  Its filename was
     mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

