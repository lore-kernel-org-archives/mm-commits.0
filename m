Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BC1C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD7FA208B3
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408166;
	bh=vgWLtHL6529LzSZpSSBxzEaj4bDm6Okg/QlV6kgf0MU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uarvCfqKVrnJ1XfqP/Y4dNY/SVXjbLKH4E7G9qjJ3+0EWW5MQUMYqjAZ79ZbZBIBt
	 l0/g6s+XsBUyAOqdErx950x3Ci0PsuN7Ald2BumtGpE7FwBW8YY2JNjdTVbS/ApLcK
	 apoM/OTeUG4wxhJnK0CZHapRsb+Y7ehC+p8Jwj3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373226AbgJVXJ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7A7A207EA;
        Thu, 22 Oct 2020 23:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408165;
        bh=vgWLtHL6529LzSZpSSBxzEaj4bDm6Okg/QlV6kgf0MU=;
        h=Date:From:To:Subject:From;
        b=IqsFoApnXKVzSiQ+WltFf3+4unZAeByjDhrr7f14vr7jYvz5/1jyzoM24P2EPsL+w
         A9UEaeQpKYE3+IHk3Br4L6s8BnPQuAsvEY3oQ1XZ2kaZ4h+vE4fbTS9Ukjl0ZL8Vt8
         hhbMQ39D4pgf2nWyFQan1qCRUaWw2Gn5H/xkO6SY=
Date:   Thu, 22 Oct 2020 16:09:24 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch removed
 from -mm tree
Message-ID: <20201022230924.av36gKv1o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: remove a wrapper for alloc_migration_target()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


