Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CA7C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432466187E
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhCaEzF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233575AbhCaEyd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1F946187E;
        Wed, 31 Mar 2021 04:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617166473;
        bh=Yx1EsC10HpPPooPYEjmf8W0v0gXZqJSovQg7oD5ZS+s=;
        h=Date:From:To:Subject:From;
        b=mIzeD9Pail0eZqi1oYhLvqywsfG7u36CcAcTuTc+lZhjawTKOSmTX4S6tYxc7Zhhv
         b1RcVreUIIMA+7Ca2OUNpeBGVMA8KbnaiIR+pXAIyAvW79j4OiWRcuHqhjGdnTw6i8
         i9GIaYEYnC9wsqbAq/Uf6A0kehxPYnlyrJ0z5vg8=
Date:   Tue, 30 Mar 2021 21:54:32 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org
Subject:  + mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch
 added to -mm tree
Message-ID: <20210331045432.jcl8HAcxP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: Add a bulk page allocator -fix -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: Add a bulk page allocator -fix -fix

Colin Ian King reported the following problem (slightly edited)

	Author: Mel Gorman <mgorman@techsingularity.net>
	Date:   Mon Mar 29 11:12:24 2021 +1100

	    mm/page_alloc: add a bulk page allocator

	...

	Static analysis on linux-next with Coverity has found a potential
	uninitialized variable issue in function __alloc_pages_bulk with
	the following commit:

	...

	    Uninitialized scalar variable (UNINIT)
	    15. uninit_use_in_call: Using uninitialized value alloc_flags when
	        calling prepare_alloc_pages.

	5056        if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask,
						&ac, &alloc_gfp, &alloc_flags))

The problem is that prepare_alloc_flags only updates alloc_flags
which must have a valid initial value. The appropriate initial value is
ALLOC_WMARK_LOW to avoid the bulk allocator pushing a zone below the low
watermark without waking kswapd assuming the GFP mask allows kswapd to
be woken.

This is a second fix to the mmotm patch
mm-page_alloc-add-a-bulk-page-allocator.patch . It will cause a mild conflict
with a later patch due to renaming of an adjacent variable that is trivially
resolved. I can post a full series with the fixes merged if that is preferred.

Link: https://lkml.kernel.org/r/20210330114847.GX3697@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-a-bulk-page-allocator-fix-fix
+++ a/mm/page_alloc.c
@@ -5031,7 +5031,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	struct list_head *pcp_list;
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
-	unsigned int alloc_flags;
+	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int allocated = 0;
 
 	if (WARN_ON_ONCE(nr_pages <= 0))
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-a-bulk-page-allocator-fix.patch
mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

