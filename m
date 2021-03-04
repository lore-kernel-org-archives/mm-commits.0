Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC600C433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F7665250
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhCDBVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:21:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236327AbhCDBUq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:20:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A38D464F7E;
        Thu,  4 Mar 2021 01:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820805;
        bh=JGe2TZr6iw6TC51V93y4pAtElxu1FJMj2Z4+5wyGsW8=;
        h=Date:From:To:Subject:From;
        b=zDCBqMJpLWXer9rjgtEHqV6dFhENJiAjRvw2DG6dgzmQtC9hORhElE0ejC4PQhXct
         7oDKqGoAnFdrxZGVHBHHtEcOHrKizdFpA4T8+95TL4e1rqjFyYIXh4AcIEIVyxdXzA
         vOeJfeout+cCVWsSO7WWl/Asvh3bjmk4Us4Gl8fw=
Date:   Wed, 03 Mar 2021 17:20:05 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, daizhiyuan@phytium.com.cn, glider@google.com,
        mm-commits@vger.kernel.org
Subject:  + mm-kasan-switch-from-strlcpy-to-strscpy.patch added to
 -mm tree
Message-ID: <20210304012005.OeZ73_PzO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: switch from strlcpy to strscpy
has been added to the -mm tree.  Its filename is
     mm-kasan-switch-from-strlcpy-to-strscpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-switch-from-strlcpy-to-strscpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-switch-from-strlcpy-to-strscpy.patch

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
Subject: mm/kasan: switch from strlcpy to strscpy

strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
and there is no functional difference when the caller expects truncation
(when not checking the return value).  strscpy is relatively better as it
also avoids scanning the whole source string.

Link: https://lkml.kernel.org/r/1613970647-23272-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Acked-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report_generic.c~mm-kasan-switch-from-strlcpy-to-strscpy
+++ a/mm/kasan/report_generic.c
@@ -148,7 +148,7 @@ static bool __must_check tokenize_frame_
 		}
 
 		/* Copy token (+ 1 byte for '\0'). */
-		strlcpy(token, *frame_descr, tok_len + 1);
+		strscpy(token, *frame_descr, tok_len + 1);
 	}
 
 	/* Advance frame_descr past separator. */
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
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

