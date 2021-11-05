Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23394C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136C36136F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhKEUs5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhKEUs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 348D261288;
        Fri,  5 Nov 2021 20:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145176;
        bh=zlvH2jY7naVEqZ/kfzMKr2KBE+X/tSwBozn9f+5T/R0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wLTEs5XeCgXNx5pzdy5f6hxbKsDlP9iO698eXSHWF7TKFGe1HgsfoF83+vJSqwyqX
         GMzrgCnDIHLSu4Txd+JrAnOCFgzCtgO/P3nefiSJviIZoC0HgHDOcmmYIzQmX/nSMK
         Rxf+o3+JstepaeO//p/8yFWWf84eszINy3NP5qm8=
Date:   Fri, 05 Nov 2021 13:46:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 222/262] mm/damon/core: nullify pointer
 ctx->kdamond with a NULL
Message-ID: <20211105204615.IkBgRaxHP%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
