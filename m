Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93372C56201
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54894206D9
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFjIvNPs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgKYW0i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387474AbgKYW0i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 17:26:38 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E138D206D9;
        Wed, 25 Nov 2020 22:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606343188;
        bh=elhHr3mrwVIxF0BjnUcPoi52H9B8TLMklkjgcoFvss8=;
        h=Date:From:To:Subject:From;
        b=lFjIvNPsRv99m30RHHKJniPG8AOgBcz0vPoX/GtoUnNl2qyzH5WmTX4xeYovacaNB
         k2dESifiu9jfLohSiQnGVkd31SfsAq6yjDg2+iB0nchLuMDCFkcmvf82gLMvSejT3S
         nzreynUu6TEpNGXOgR3cbaC/dLAepLb0r/335xLY=
Date:   Wed, 25 Nov 2020 14:26:27 -0800
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, david@redhat.com, iamjoonsoo.kim@lge.com,
        jrdr.linux@gmail.com, mm-commits@vger.kernel.org,
        vinmenon@codeaurora.org
Subject:  + mm-cma-improve-pr_debug-log-in-cma_release.patch added
 to -mm tree
Message-ID: <20201125222627.l4fpVG5Qq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: improve pr_debug log in cma_release()
has been added to the -mm tree.  Its filename is
     mm-cma-improve-pr_debug-log-in-cma_release.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-improve-pr_debug-log-in-cma_release.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-improve-pr_debug-log-in-cma_release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm: cma: improve pr_debug log in cma_release()

It is required to print 'count' of pages, along with the pages, passed to
cma_release to debug the cases of mismatched count value passed between
cma_alloc() and cma_release() from a code path.

As an example, consider the below scenario:

1) CMA pool size is 4MB and

2) User doing the erroneous step of allocating 2 pages but freeing 1
   page in a loop from this CMA pool.  The step 2 causes cma_alloc() to
   return NULL at one point of time because of -ENOMEM condition.

And the current pr_debug logs is not giving the info about these types of
allocation patterns because of count value not being printed in
cma_release().

We are printing the count value in the trace logs, just extend the same to
pr_debug logs too.

Link: https://lkml.kernel.org/r/1606318341-29521-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Reviewed-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-improve-pr_debug-log-in-cma_release
+++ a/mm/cma.c
@@ -510,7 +510,7 @@ bool cma_release(struct cma *cma, const
 	if (!cma || !pages)
 		return false;
 
-	pr_debug("%s(page %p)\n", __func__, (void *)pages);
+	pr_debug("%s(page %p, count %zu)\n", __func__, (void *)pages, count);
 
 	pfn = page_to_pfn(pages);
 
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-cma-improve-pr_debug-log-in-cma_release.patch

