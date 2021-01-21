Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FD2C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 21:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE872389B
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 21:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbhAUV5O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 16:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbhAUV5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 16:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0AA2389B;
        Thu, 21 Jan 2021 21:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611266193;
        bh=I7XhiKd/feAvnUuMQnlr029mEwJSMtqvwHLB8C6Qvy8=;
        h=Date:From:To:Subject:From;
        b=VqeJNiv5uGc4kr2A/AoXn2Tp6aCxucur5GDNWQ2z8+y5J4TaNGK+v+eP/JKTc9p7I
         LgInO8u9/wr8GtY3OmVy2yu3SfJGXXMvgJvVrumnO1OOfubMElUAF9KoUNH88v55nP
         WN3s2RZlWF9/zfHVyCMno5R45nnUivlnOwgb3s7Y=
Date:   Thu, 21 Jan 2021 13:56:32 -0800
From:   akpm@linux-foundation.org
To:     bot@kernelci.org, lkp@intel.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com
Subject:  + mm-zswap-add-the-flag-can_sleep_mapped-fix.patch added
 to -mm tree
Message-ID: <20210121215632.cy17_JBwz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: add return value in zswap_frontswap_load
has been added to the -mm tree.  Its filename is
     mm-zswap-add-the-flag-can_sleep_mapped-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-add-the-flag-can_sleep_mapped-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-add-the-flag-can_sleep_mapped-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: mm/zswap: add return value in zswap_frontswap_load

Clang warns:

mm/zswap.c:1271:6: warning: variable 'ret' is used uninitialized
whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (!entry->length) {
            ^~~~~~~~~~~~~~
mm/zswap.c:1322:9: note: uninitialized use occurs here
        return ret;
               ^~~
mm/zswap.c:1271:2: note: remove the 'if' if its condition is always
false
        if (!entry->length) {
        ^~~~~~~~~~~~~~~~~~~~~
mm/zswap.c:1259:9: note: initialize the variable 'ret' to silence this
warning
        int ret;
               ^
                = 0
1 warning generated.

Prior to "mm/zswap: add the flag can_sleep_mapped", this path always
returned 0. Restore that so we are not returning uninitialized memory.

Link: https://github.com/ClangBuiltLinux/linux/issues/1263
Link: https://lkml.kernel.org/r/20210121214804.926843-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-zswap-add-the-flag-can_sleep_mapped-fix
+++ a/mm/zswap.c
@@ -1272,6 +1272,7 @@ static int zswap_frontswap_load(unsigned
 		dst = kmap_atomic(page);
 		zswap_fill_page(dst, entry->value);
 		kunmap_atomic(dst);
+		ret = 0;
 		goto freeentry;
 	}
 
_

Patches currently in -mm which might be from natechancellor@gmail.com are

maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch
mm-zswap-add-the-flag-can_sleep_mapped-fix.patch

