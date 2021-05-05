Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05496C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E09613BA
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhEEBBY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhEEBBY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B175661078;
        Wed,  5 May 2021 01:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176428;
        bh=n+hfH8LzHP4a/vMUDo+W+F8FzZDd42+oTLTjQ78IDI0=;
        h=Date:From:To:Subject:From;
        b=vypZSjEKfmVw4LE2eDDx5ymE4+83sb0/vYQ8pzs0zWzCuitZUWYdJ/1nDLuPPGLV4
         lfxkvg0dqKz3tGQv6IazEcFSrSJQJgyECegac/5hXRGD5iBKBgZ/OT3Zo5TLoTwFQ4
         KjY/WUWuI+e4Ub7OFTAKu0Y7RAEysxSvaXAPKxIU=
Date:   Tue, 04 May 2021 18:00:28 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-vmalloc-minor-coding-style-tweaks.patch removed from -mm tree
Message-ID: <20210505010028.cshKzJA9y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/vmalloc: minor coding style tweaks

Macros with complex values should be enclosed in parentheses.

Link: https://lkml.kernel.org/r/1613963379-15988-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-minor-coding-style-tweaks
+++ a/mm/vmalloc.c
@@ -3083,7 +3083,7 @@ EXPORT_SYMBOL(vzalloc_node);
  * 64b systems should always have either DMA or DMA32 zones. For others
  * GFP_DMA32 should do the right thing and use the normal zone.
  */
-#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL
+#define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)
 #endif
 
 /**
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

