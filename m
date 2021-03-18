Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7247FC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C43CE64EEE
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhCRAz7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhCRAz3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 20:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22030600CC;
        Thu, 18 Mar 2021 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616028929;
        bh=OTrY7piPTPN9x36roJVy00KfOfcKrlXZBFyzFn8sPsU=;
        h=Date:From:To:Subject:From;
        b=c8ypujV0FjMbUTyztAk3b0U3uyZ76TNiNo3JB1GctvJFmpPlNfDByXvJ9W9sFLlHJ
         QE4lSBmFt+cC2YigKwshILX2/vqvcxY/dR70HDKLrKEhxEDlAE5ww/fzDCdzH79o/Y
         zjSYs+is2+PIghOIwircl5n5LEqcCHgzbdP1Pd38=
Date:   Wed, 17 Mar 2021 17:55:28 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, jhubbard@nvidia.com, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  + mm-cma-support-sysfs-fix.patch added to -mm tree
Message-ID: <20210318005528.EUpoW2Zb8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix potential null dereference on pointer cma
has been added to the -mm tree.  Its filename is
     mm-cma-support-sysfs-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-support-sysfs-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-support-sysfs-fix.patch

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
Subject: mm: cma: fix potential null dereference on pointer cma

At the start of the function there is a null pointer check on cma and then
branch to error handling label 'out'.  The subsequent call to
cma_sysfs_fail_pages_count dereferences cma, hence there is a potential
null pointer deference issue.  Fix this by only calling
cma_sysfs_fail_pages_count if cma is not null.

Addresses-Coverity: ("Dereference after null check")

Link: https://lkml.kernel.org/r/20210316100433.17665-1-colin.king@canonical.com
Fixes: dc4764f7e9ac ("mm: cma: support sysfs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-support-sysfs-fix
+++ a/mm/cma.c
@@ -512,7 +512,8 @@ out:
 		cma_sysfs_alloc_pages_count(cma, count);
 	} else {
 		count_vm_event(CMA_ALLOC_FAIL);
-		cma_sysfs_fail_pages_count(cma, count);
+		if (cma)
+			cma_sysfs_fail_pages_count(cma, count);
 	}
 
 	return page;
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-slab-fix-spelling-mistake-disired-desired.patch
mm-cma-support-sysfs-fix.patch

