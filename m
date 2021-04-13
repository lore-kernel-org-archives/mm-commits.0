Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30870C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF465613B7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhDMRkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhDMRkv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 13:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B758561004;
        Tue, 13 Apr 2021 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618335631;
        bh=BTYlirU8UzOzt8qHRfO4D35qfzPDzqDqSRRfM9bFF54=;
        h=Date:From:To:Subject:From;
        b=wcCx7daP5lOV1K3NzaJaghhWI5odlORJo4jCMpQJx0IYstpgRWWB7OE1JQI/o1fsA
         3QHpcaLhGF6rF+YFEVj6rs0iHNyi/XdU1U1wxCUro7e0Iqi5l7CWx4cHldN89CI+J5
         E0ytbcw71ZYG33aD+G5qvs+TK1JnpthEi5x/qSUk=
Date:   Tue, 13 Apr 2021 10:40:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net
Subject:  + mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch
 added to -mm tree
Message-ID: <20210413174031.w5Cc8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add a bulk page allocator -fix -fix -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch

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
Subject: mm/page_alloc: add a bulk page allocator -fix -fix -fix

Vlastimil Babka noted that a comment is wrong, fix it.  This is the third
fix to the mmotm patch mm-page_alloc-add-a-bulk-page-allocator.patch.

Link: https://lkml.kernel.org/r/20210412110255.GV3697@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix
+++ a/mm/page_alloc.c
@@ -5048,7 +5048,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		return 0;
 	gfp = alloc_gfp;
 
-	/* Find an allowed local zone that meets the high watermark. */
+	/* Find an allowed local zone that meets the low watermark. */
 	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-a-bulk-page-allocator-fix.patch
mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch
mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

