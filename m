Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303F6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B50E610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhKKCvm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhKKCvk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F0096103C;
        Thu, 11 Nov 2021 02:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598931;
        bh=cJIxVugzLOJbaOnPx9EC+oq32B4wJsdxUu1/gtXKMWw=;
        h=Date:From:To:Subject:From;
        b=DrV5rGver/ZVniG9VCFEqC8pNfT3fIUJVb6txQinhGYzhlC1H6Yze5q3L1ak4mk+Z
         zerNVgRKAomEHxZy0hym9yIqrilpDAmreu4waVTjwpdgwoFqW1UN3dfqKaBNWqkLsn
         BcYWco9TcUp9U3/C4H6Td8QWhM5x/ay4h0TDfoos=
Date:   Wed, 10 Nov 2021 18:48:51 -0800
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch removed from
 -mm tree
Message-ID: <20211111024851._5zx4WpDW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: nullify pointer ctx->kdamond with a NULL
has been removed from the -mm tree.  Its filename was
     mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/damon/core: nullify pointer ctx->kdamond with a NULL

Currently a plain integer is being used to nullify the pointer
ctx->kdamond.  Use NULL instead.  Cleans up sparse warning:

mm/damon/core.c:317:40: warning: Using plain integer as NULL pointer

Link: https://lkml.kernel.org/r/20210925215908.181226-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null
+++ a/mm/damon/core.c
@@ -314,7 +314,7 @@ static int __damon_start(struct damon_ct
 				nr_running_ctxs);
 		if (IS_ERR(ctx->kdamond)) {
 			err = PTR_ERR(ctx->kdamond);
-			ctx->kdamond = 0;
+			ctx->kdamond = NULL;
 		}
 	}
 	mutex_unlock(&ctx->kdamond_lock);
_

Patches currently in -mm which might be from colin.king@canonical.com are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch

