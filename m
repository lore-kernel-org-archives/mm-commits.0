Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC21DC433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839F520897
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976440;
	bh=jcP/Kw8FmZ0zKkpo4EW4E6OO3YfOWpZaxtg6HSyqCmA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=UQFxajHNIoKjEKEAwnzDtkqVhMzl0wa+3LkX1iE14788wpTanf4xPXaqaTl2RUn87
	 HB/x6znjRR5g6HtQb2bWzAQWcP775IYd6oP8U+8sNPxX75P6ydW1fQ5z+q0bzPxRjk
	 vL3qJ5BjHxeUtG58nVkf4RYVlDt2ZlrNg6CqI25Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439886AbgJQXOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXN7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F50208E4;
        Sat, 17 Oct 2020 23:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976437;
        bh=jcP/Kw8FmZ0zKkpo4EW4E6OO3YfOWpZaxtg6HSyqCmA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aW6j9K8BEWTCK6TVlG3TGnHhBb+EOigOVv5KbPvLOCRCDtRY9DgxMdXO/mbiCVktf
         RGKX4l7XfjuJwU0lVzHwQ2H1JC6qj0ZTApjufbDr755nqfO8F2ATZj/+GykbSjsYds
         brWEaHeiYiePUKOzXnB7HK7byzvG3bzrfcIXZ8Xo=
Date:   Sat, 17 Oct 2020 16:13:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 07/40] mm/memory-failure: remove a wrapper for
 alloc_migration_target()
Message-ID: <20201017231357.LjnfaMDj_%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/memory-failure: remove a wrapper for alloc_migration_target()

There is a well-defined standard migration target callback.  Use it
directly.

Link: http://lkml.kernel.org/r/1594622517-20681-9-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-a-wrapper-for-alloc_migration_target
+++ a/mm/memory-failure.c
@@ -1673,16 +1673,6 @@ int unpoison_memory(unsigned long pfn)
 }
 EXPORT_SYMBOL(unpoison_memory);
 
-static struct page *new_page(struct page *p, unsigned long private)
-{
-	struct migration_target_control mtc = {
-		.nid = page_to_nid(p),
-		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
-	};
-
-	return alloc_migration_target(p, (unsigned long)&mtc);
-}
-
 /*
  * Safely get reference count of an arbitrary page.
  * Returns 0 for a free page, -EIO for a zero refcount page
@@ -1797,6 +1787,10 @@ static int __soft_offline_page(struct pa
 	char const *msg_page[] = {"page", "hugepage"};
 	bool huge = PageHuge(page);
 	LIST_HEAD(pagelist);
+	struct migration_target_control mtc = {
+		.nid = NUMA_NO_NODE,
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
 	/*
 	 * Check PageHWPoison again inside page lock because PageHWPoison
@@ -1833,8 +1827,8 @@ static int __soft_offline_page(struct pa
 	}
 
 	if (isolate_page(hpage, &pagelist)) {
-		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
-					MIGRATE_SYNC, MR_MEMORY_FAILURE);
+		ret = migrate_pages(&pagelist, alloc_migration_target, NULL,
+			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (!ret) {
 			bool release = !huge;
 
_
