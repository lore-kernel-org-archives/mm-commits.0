Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754C3C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DB961CA1
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhGFTXd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A11861CA0;
        Tue,  6 Jul 2021 19:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599254;
        bh=9FRQGFLcPMXOsuFH1VviIi+ouuIIPtXAoXywyDCroOk=;
        h=Date:From:To:Subject:From;
        b=o3hAe5OFUjeRj2behdHBBjaf575X6ea0A0+M1YDZZWtQtDlUFAX22RkOLEKTZBprC
         LSJlsxSj1Oe8VpLhRXQu3pMxq/1+ZZqZ80PScIfInl6XL5PEXiiwVdqT32ExTkJ1Dm
         IXDoncSWXkJs2E/DAxTBxq+Zxd7U417I1ASrwwnM=
Date:   Tue, 06 Jul 2021 12:20:54 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Falloc-make-should=5Ffail=5Falloc=5Fpage-a-static-?=
 =?US-ASCII?Q?function-should=5Ffail=5Falloc=5Fpage-static.patch?= removed
 from -mm tree
Message-ID: <20210706192054.-jQk9HP0J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make should_fail_alloc_page() static
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: make should_fail_alloc_page() static

make W=1 generates the following warning for mm/page_alloc.c

  mm/page_alloc.c:3651:15: warning: no previous prototype for `should_fail_alloc_page' [-Wmissing-prototypes]
   noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
                 ^~~~~~~~~~~~~~~~~~~~~~

This function is deliberately split out for BPF to allow errors to be
injected.  The function is not used anywhere else so it is local to the
file.  Make it static which should still allow error injection to be used
similar to how block/blk-core.c:should_fail_bio() works.

Link: https://lkml.kernel.org/r/20210520084809.8576-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static
+++ a/mm/page_alloc.c
@@ -3819,7 +3819,7 @@ static inline bool __should_fail_alloc_p
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
-noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+static noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return __should_fail_alloc_page(gfp_mask, order);
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


