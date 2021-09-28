Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE285C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 02:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A326861266
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 02:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhI1Cqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238590AbhI1Cqs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 22:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9603F60F58;
        Tue, 28 Sep 2021 02:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632797109;
        bh=VaEHCKXvnI26AqeKcCNFcPJTofpiJkcz9M2V6AqZAFc=;
        h=Date:From:To:Subject:From;
        b=NTUWqbLigw7DWSwduoN6oG9LM4gQHG/5yCHp3erbrnn4P3PAUjc7s6xDOsganSeRK
         KaFiBB/aa+w+FX2kYeoRmfCSZISlNTCQwD521lMXf71YQC+XuuTz9uowqaPWgRq3aw
         3TSfXa5mHky9Hzi58f+5Eum8stACh66lXzbKWZTg=
Date:   Mon, 27 Sep 2021 19:45:09 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch added to -mm
 tree
Message-ID: <20210928024509.twMQysA73%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: nullify pointer ctx->kdamond with a NULL
has been added to the -mm tree.  Its filename is
     mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch

