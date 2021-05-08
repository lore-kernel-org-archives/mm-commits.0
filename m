Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55174C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 330BB61426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhEHWwS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhEHWwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 835546100C;
        Sat,  8 May 2021 22:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514274;
        bh=vEzqUZr84xJK9GPYBs720tvAlGXC89vx0usFpzFepig=;
        h=Date:From:To:Subject:From;
        b=w6BAocc9qYq350TmMWUS6c9UInOdwUfYCLZJhVj+suo1QPRR3cfcLf23xiTd0c+L9
         F9YDrJTTb1bpg0Acam2RdfCraLuC9GzBgovZatdqJzCsDJ52Q9kqaSkuq62JhE5+9B
         uHiKO8SESX2zncNQnqJUq1/T1FNfWqneS6NuxLJ8=
Date:   Sat, 08 May 2021 15:51:14 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, ddstreet@ieee.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com
Subject:  [merged] mm-zswap-switch-from-strlcpy-to-strscpy.patch
 removed from -mm tree
Message-ID: <20210508225114.u7onXFSih%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: switch from strlcpy to strscpy
has been removed from the -mm tree.  Its filename was
     mm-zswap-switch-from-strlcpy-to-strscpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/zswap.c: switch from strlcpy to strscpy

strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
and there is no functional difference when the caller expects truncation
(when not checking the return value).  strscpy is relatively better as it
also avoids scanning the whole source string.

Link: https://lkml.kernel.org/r/1614227981-20367-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-switch-from-strlcpy-to-strscpy
+++ a/mm/zswap.c
@@ -614,7 +614,7 @@ static struct zswap_pool *zswap_pool_cre
 	}
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
-	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
+	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
 	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
 	if (!pool->acomp_ctx) {
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are


