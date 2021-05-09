Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C9DC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B05E861424
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhEIEO1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhEIEO1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:14:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA1016141D;
        Sun,  9 May 2021 04:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533604;
        bh=EI1WhBcPQa4z3m/xx8j8bahYs1rWlW5lOal+f9GhNmw=;
        h=Date:From:To:Subject:From;
        b=gRCq/LJkCsTv5ajrGGKIjoTj5WhKJvUSJzYjJI8fytm5LG65ZkyMHpck+OnbqT42x
         5q5Sz/8xlccpkpVkFotwgbeV19wWKFs2zqWOmR3Q8A3Pr8YYL+1C8+6QA+OA/r6lYQ
         e5zMtfCJ7FoqopbqnqFh/KHRluIAorhxTxZ4Jk4I=
Date:   Sat, 08 May 2021 21:13:23 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chenli@uniontech.com,
        mm-commits@vger.kernel.org
Subject:  +
 nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch added
 to -mm tree
Message-ID: <20210509041323.k6DtiMDiu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes

Cc: Chen Li <chenli@uniontech.com>

WARNING: please, no spaces at the start of a line
#37: FILE: mm/nommu.c:226:
+       return __vmalloc(size, GFP_KERNEL);$

total: 0 errors, 1 warnings, 16 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Chen Li <chenli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes
+++ a/mm/nommu.c
@@ -223,7 +223,7 @@ long vread(char *buf, char *addr, unsign
  */
 void *vmalloc(unsigned long size)
 {
-       return __vmalloc(size, GFP_KERNEL);
+	return __vmalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

