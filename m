Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EACC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EAFC61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhKKCsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234384AbhKKCsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E7B56103C;
        Thu, 11 Nov 2021 02:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598731;
        bh=bzD0ejISrSdwA+D23qIOto5RUXbmXWP2QsASN1fxjLQ=;
        h=Date:From:To:Subject:From;
        b=vMiGWqWgf8D8VK61HX3xP3YnSKERpZVV4mRxDk8qYPPzizoNltf3TxzFP2Cpq6KHZ
         iT7hmHHT9oe9bZaBdGjLCBkcV4FWkr9qe8bSnawdJ5PivBuvbrckdcg29Pnof88fAn
         me+OY1AgpUE4vWqRLFeCQkcz+V7lsPa6+jMBxmts=
Date:   Wed, 10 Nov 2021 18:45:31 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Fisolation-fix-potential-missing-call-to-unset=5Fm?=
 =?US-ASCII?Q?igratetype=5Fisolate.patch?= removed from -mm tree
Message-ID: <20211111024531.hWU7M7OSR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix potential missing call to unset_migratetype_isolate()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -183,7 +183,6 @@ int start_isolate_page_range(unsigned lo
 			     unsigned migratetype, int flags)
 {
 	unsigned long pfn;
-	unsigned long undo_pfn;
 	struct page *page;
 
 	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
@@ -193,25 +192,12 @@ int start_isolate_page_range(unsigned lo
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


