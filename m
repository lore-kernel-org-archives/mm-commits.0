Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23674C15500
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E385164EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243093AbhCDA7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388386AbhCDAML (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:12:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF9A464E56;
        Thu,  4 Mar 2021 00:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816690;
        bh=joqxziRSKououaVn5A5ydf/aMnYc+p0S/n51+o8Sf3I=;
        h=Date:From:To:Subject:From;
        b=Pmt+tsCdcZQ33Hy1fBrApj/bWj9gHpE7ExHt+awaVfRfaD6UDVj0ftfs2eopnGY5l
         FPDqRBVFXtxUcpdv9Po/wIM/Ar+8tfotFGPCRLavllbvlK4Q5Wq3lvYVOydoDGF3YM
         pJSHSeJBvZFnwJvkFTohRN8Lgl5kV81M1y8hOo5U=
Date:   Wed, 03 Mar 2021 16:11:30 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, ddstreet@ieee.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com
Subject:  + mm-zswap-switch-from-strlcpy-to-strscpy.patch added to
 -mm tree
Message-ID: <20210304001130.HeOO-qbXy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: switch from strlcpy to strscpy
has been added to the -mm tree.  Its filename is
     mm-zswap-switch-from-strlcpy-to-strscpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-switch-from-strlcpy-to-strscpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-switch-from-strlcpy-to-strscpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch

