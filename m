Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C161C47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F4836135A
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhEaVwv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhEaVwv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B393961186;
        Mon, 31 May 2021 21:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622497870;
        bh=jXld9hvOSgGfV9zkw+cLuWmBTF1VoRumd4HnSm/YG2Y=;
        h=Date:From:To:Subject:From;
        b=Ye92sCJQ6omdTSiaZ7b342tP1AT0HHCWZxr7E2lADOSYFiSkCxLp+B8tZA5KEjpQ8
         8j0O55s3Wn4ZdGu8cVPJN1IkII7EGL0EXTkTNjbNuAhs+eZggb76CG/byPx+14tNlU
         uXmAvYliTRSzs3+vdXNHkhMgl5lEddykGb95Qjxw=
Date:   Mon, 31 May 2021 14:51:10 -0700
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, andreyknvl@gmail.com,
        catalin.marinas@arm.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  + mm-drop-section_shift-in-code-comments.patch added to
 -mm tree
Message-ID: <20210531215110.NMvehY7iY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop SECTION_SHIFT in code comments
has been added to the -mm tree.  Its filename is
     mm-drop-section_shift-in-code-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-drop-section_shift-in-code-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-section_shift-in-code-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dong Aisheng <aisheng.dong@nxp.com>
Subject: mm: drop SECTION_SHIFT in code comments

Actually SECTIONS_SHIFT is used in the kernel code, so the code comments
is strictly incorrect.  And since commit bbeae5b05ef6 ("mm: move page
flags layout to separate header"), SECTIONS_SHIFT definition has been
moved to include/linux/page-flags-layout.h, since code itself looks quite
straighforward, instead of moving the code comment into the new place as
well, we just simply remove it.

This also fixed a checkpatch complain derived from the original code:
WARNING: please, no space before tabs
+ * SECTIONS_SHIFT    ^I^I#bits space required to store a section #$

Link: https://lkml.kernel.org/r/20210531091908.1738465-2-aisheng.dong@nxp.com
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/mmzone.h~mm-drop-section_shift-in-code-comments
+++ a/include/linux/mmzone.h
@@ -1200,8 +1200,6 @@ static inline struct zoneref *first_zone
 #ifdef CONFIG_SPARSEMEM
 
 /*
- * SECTION_SHIFT    		#bits space required to store a section #
- *
  * PA_SECTION_SHIFT		physical address to/from section number
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
_

Patches currently in -mm which might be from aisheng.dong@nxp.com are

mm-drop-section_shift-in-code-comments.patch

