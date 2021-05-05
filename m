Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F48BC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4955761029
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhEEBky (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhEEBky (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CF1061182;
        Wed,  5 May 2021 01:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178798;
        bh=UWtYmk8i1FK+CY3fBZZbLyQU+cJg2atXqEO3K62TUEw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0ToPjshYNSF/jSUtytEcmfkBZIkPT0Yjzhe8/1VpIB0Kf5z4EnboI8vTIa7b3+cTF
         tDjdyr4ecW5OUxTZG1QNsECiuZT6Ku5b4gt/xr4+2wkNZ5n0GVpMGUPB4sP4CrQe9S
         kp0EDKknMFmo3QehdmrZTU/jSlPbtRGvDw1GrscI=
Date:   Tue, 04 May 2021 18:39:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        ddstreet@ieee.org, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        sjenning@redhat.com, torvalds@linux-foundation.org,
        vitaly.wool@konsulko.com
Subject:  [patch 133/143] mm/zswap.c: switch from strlcpy to
 strscpy
Message-ID: <20210505013957.ED1LdWv2q%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
