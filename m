Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A131C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 20:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3806C21D1B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 20:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgL2Uz7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 15:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgL2Uz7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 15:55:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB62321D1B;
        Tue, 29 Dec 2020 20:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609275318;
        bh=r+G6p430ADM8KDQqJjj6oFA3CAlaIvG2lykl4puOyEg=;
        h=Date:From:To:Subject:From;
        b=AWyMdR3lw710HRA8k/x9Z9bF9f6xkrdS139XfH5MzTmX+VRIWlHOBNel28iLyGivq
         +4IZ6WVZvV1W7Gd31jg4VA5xyq86THpbENNhmy52DmjyBdcJtB8I/9p6tl0fMqB/Rz
         7itdQJBYI5GJa2f3U8Iol23vhOFRUIraWBcFoOjk=
Date:   Tue, 29 Dec 2020 12:55:18 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        liu.hailong6@zte.com.cn
Subject:  +
 mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch added
 to -mm tree
Message-ID: <20201229205518.9RY3m%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc:add a missing mm_page_alloc_zone_locked tracepoint
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hailong liu <liu.hailong6@zte.com.cn>
Subject: mm/page_alloc:add a missing mm_page_alloc_zone_locked tracepoint

The trace point *trace_mm_page_alloc_zone_locked()* in __rmqueue() does
not currently cover all branches.  Add the missing tracepoint and check
the page before do that.

Link: https://lkml.kernel.org/r/20201228132901.41523-1-carver4lio@163.com
Signed-off-by: Hailong liu <liu.hailong6@zte.com.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint
+++ a/mm/page_alloc.c
@@ -2871,7 +2871,7 @@ __rmqueue(struct zone *zone, unsigned in
 	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
 		page = __rmqueue_cma_fallback(zone, order);
 		if (page)
-			return page;
+			goto out;
 	}
 #endif
 retry:
@@ -2884,8 +2884,9 @@ retry:
 								alloc_flags))
 			goto retry;
 	}
-
-	trace_mm_page_alloc_zone_locked(page, order, migratetype);
+out:
+	if (page)
+		trace_mm_page_alloc_zone_locked(page, order, migratetype);
 	return page;
 }
 
_

Patches currently in -mm which might be from liu.hailong6@zte.com.cn are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch

