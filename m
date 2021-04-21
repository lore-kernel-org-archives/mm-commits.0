Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D4AC433B4
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 00:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEAB76141D
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 00:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhDUAmb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234276AbhDUAmb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 20:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4F1861409;
        Wed, 21 Apr 2021 00:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618965719;
        bh=LTJdV3eA556IP6DmcSBKM1CDPscUkmD5YvIXv0xi50M=;
        h=Date:From:To:Subject:From;
        b=xYsS4pnX/tEIPY9GtegDxlc88hKbcjFr9XA152pOoH6oLxAs1sGTE6hKOrvx1frAC
         S2JbYhbPaPXAZXEKOFvpPtPMKInFrCGW+pXbMGTiU1mSGTQ8LdTaEJX79MeCbQZINA
         DiMOHYMr5/3uDe32vTE7KHFlDUK2RJqxDLG7BynQ=
Date:   Tue, 20 Apr 2021 17:41:58 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.jiang@intel.com,
        jane.chu@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  + mm-memory-failure-unecessary-amount-of-unmapping.patch
 added to -mm tree
Message-ID: <20210421004158.6VnCZ5bEm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: unnecessary amount of unmapping
has been added to the -mm tree.  Its filename is
     mm-memory-failure-unecessary-amount-of-unmapping.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-unecessary-amount-of-unmapping.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-unecessary-amount-of-unmapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: unnecessary amount of unmapping

It appears that unmap_mapping_range() actually takes a 'size' as its third
argument rather than a location, the current calling fashion causes
unecessary amount of unmapping to occur.

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

mm-memory-failure-unecessary-amount-of-unmapping.patch

