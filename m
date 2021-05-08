Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5BFC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F36A561402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhEHWq6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWq5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B797613EA;
        Sat,  8 May 2021 22:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513955;
        bh=8dkZjlEm7um6+R2AiMtZ/XwW+w+GOA0138sntJRvMEk=;
        h=Date:From:To:Subject:From;
        b=vPZuds2deZbniU8bp2+guZS3SqIGMFETQmPTsT4crqfF1wu6AT3Bx+XY1ca/Og71d
         FHggQnTazpe1yVaOWss856MV0dcUMMuAgbhGd9t2daCES5KzeRJq5qRt+89YFE1CxZ
         xBTN5Sm3YPkpO1BDgUtg1beehMLGmcn5DeKbkh2o=
Date:   Sat, 08 May 2021 15:45:55 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.jiang@intel.com,
        jane.chu@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [merged]
 mm-memory-failure-unecessary-amount-of-unmapping.patch removed from -mm
 tree
Message-ID: <20210508224555.ym4MLW2WY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: unnecessary amount of unmapping
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-unecessary-amount-of-unmapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: unnecessary amount of unmapping

It appears that unmap_mapping_range() actually takes a 'size' as its third
argument rather than a location, the current calling fashion causes
unnecessary amount of unmapping to occur.

Link: https://lkml.kernel.org/r/20210420002821.2749748-1-jane.chu@oracle.com
Fixes: 6100e34b2526e ("mm, memory_failure: Teach memory_failure() about dev_pagemap pages")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-unecessary-amount-of-unmapping
+++ a/mm/memory-failure.c
@@ -1368,7 +1368,7 @@ static int memory_failure_dev_pagemap(un
 		 * communicated in siginfo, see kill_proc()
 		 */
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
-		unmap_mapping_range(page->mapping, start, start + size, 0);
+		unmap_mapping_range(page->mapping, start, size, 0);
 	}
 	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
 	rc = 0;
_

Patches currently in -mm which might be from jane.chu@oracle.com are


