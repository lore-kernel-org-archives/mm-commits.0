Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8CDC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 02:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B9B61184
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 02:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhIOCOq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 22:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhIOCOp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 22:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BDA56113E;
        Wed, 15 Sep 2021 02:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631672007;
        bh=wJGGYNropNCA0v2qT/9JRJLfcyToMo6fUsCQw68ktdI=;
        h=Date:From:To:Subject:From;
        b=2Hek6vxUvYXMbc7Uj9ueXkrQv6IqNLAXZKHX6dLUOusxo0Hb38BLVJIX6fY6Sm3TB
         KWFPJCqGh+UyZNFOLs8jl1ROioQHaZE7Uo/1+1LGz57r6ffSl2eoilQSqPhB5Cp1Yx
         rVsdqfEmnrIsKlsa5wp0m1snz1PiUcn97wS3n3M8=
Date:   Tue, 14 Sep 2021 19:13:27 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Fisolation-fix-potential-missing-call-to-unset=5Fm?=
 =?US-ASCII?Q?igratetype=5Fisolate.patch?= added to -mm tree
Message-ID: <20210915021327.RceTc0Vaw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix potential missing call to unset_migratetype_isolate()
has been added to the -mm tree.  Its filename is
     mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_isolation: fix potential missing call to unset_migratetype_isolate()

In start_isolate_page_range() undo path, pfn_to_online_page() just checks
the first pfn in a pageblock while __first_valid_page() will traverse the
pageblock until the first online pfn is found.  So we may miss the call to
unset_migratetype_isolate() in undo path and pages will remain isolated
unexpectedly.  Fix this by calling undo_isolate_page_range() and this will
also help to simplify the code further.  Note we shouldn't ever trigger it
because MAX_ORDER-1 aligned pfn ranges shouldn't contain memory holes now.

Link: https://lkml.kernel.org/r/20210914114348.15569-1-linmiaohe@huawei.com
Fixes: 2ce13640b3f4 ("mm: __first_valid_page skip over offline pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -188,7 +188,6 @@ int start_isolate_page_range(unsigned lo
 			     unsigned migratetype, int flags)
 {
 	unsigned long pfn;
-	unsigned long undo_pfn;
 	struct page *page;
 
 	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
@@ -198,25 +197,12 @@ int start_isolate_page_range(unsigned lo
 	     pfn < end_pfn;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (page) {
-			if (set_migratetype_isolate(page, migratetype, flags)) {
-				undo_pfn = pfn;
-				goto undo;
-			}
+		if (page && set_migratetype_isolate(page, migratetype, flags)) {
+			undo_isolate_page_range(start_pfn, pfn, migratetype);
+			return -EBUSY;
 		}
 	}
 	return 0;
-undo:
-	for (pfn = start_pfn;
-	     pfn < undo_pfn;
-	     pfn += pageblock_nr_pages) {
-		struct page *page = pfn_to_online_page(pfn);
-		if (!page)
-			continue;
-		unset_migratetype_isolate(page, migratetype);
-	}
-
-	return -EBUSY;
 }
 
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

