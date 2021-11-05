Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A8DC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6279260E09
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhKEUo5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhKEUo4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C99760ED5;
        Fri,  5 Nov 2021 20:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144936;
        bh=seXuwMfGtoXC/UWxzkXUJ6Vlx9b8fDOck7LH0paQwVI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gl4ES7SEtcCvNzyFjHfuzPz9c6vK+Fq1gkgbDysXXuZ5URzCOAX7AT70xi/dOF978
         gOtdGiMDjWWSKsMJVNp4SB9/mMQQCOja0+rohaWJyG8XYi0IVZQW/nTNsADDIpvLuW
         NLRpiRy5f+eeb+wMo3/ekAMXzl4BVq6HvbxuHZww=
Date:   Fri, 05 Nov 2021 13:42:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 146/262] mm/page_isolation: fix potential missing
 call to unset_migratetype_isolate()
Message-ID: <20211105204216.y2EnaPqCQ%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
