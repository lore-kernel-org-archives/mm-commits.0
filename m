Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446F2C433E6
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8ABD64FCC
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhCDBT4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240839AbhCDBTP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:19:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1F206513A;
        Thu,  4 Mar 2021 01:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820713;
        bh=uDLq6vy7ex8Co4MpJ5WGyhyVXXf/RUWDz4KQ45jCMtk=;
        h=Date:From:To:Subject:From;
        b=0SgLiM6Xc38IgiJIDvBmA0eA1ft+vOkOymDP/ks0Om2Us82tx9kk43jbnNul1uMbJ
         NdhEDx4+Vltz2zcdzhnfgHh9qBN4dPWP0MeQHq4+51XdEwOKR6X8MgSUTNGbRzQTLh
         YfNjHvN+16mmDFIj6yzZWcYiLbN/IfthQcP1Nd0A=
Date:   Wed, 03 Mar 2021 17:18:33 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-dmapool-switch-from-strlcpy-to-strscpy.patch added
 to -mm tree
Message-ID: <20210304011833.MFCJxANHV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool: switch from strlcpy to strscpy
has been added to the -mm tree.  Its filename is
     mm-dmapool-switch-from-strlcpy-to-strscpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dmapool-switch-from-strlcpy-to-strscpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapool-switch-from-strlcpy-to-strscpy.patch

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
Subject: mm/dmapool: switch from strlcpy to strscpy

strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
and there is no functional difference when the caller expects truncation
(when not checking the return value). strscpy is relatively better as it
also avoids scanning the whole source string.

Link: https://lkml.kernel.org/r/1613962050-14188-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/dmapool.c~mm-dmapool-switch-from-strlcpy-to-strscpy
+++ a/mm/dmapool.c
@@ -157,7 +157,7 @@ struct dma_pool *dma_pool_create(const c
 	if (!retval)
 		return retval;
 
-	strlcpy(retval->name, name, sizeof(retval->name));
+	strscpy(retval->name, name, sizeof(retval->name));
 
 	retval->dev = dev;
 
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch
mm-mempool-minor-coding-style-tweaks.patch

