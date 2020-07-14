Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E758C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D48421924
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689721;
	bh=XoJYpmzpUhUn1NBGOqvaEgeqrZn5Jmk+v6RHGYD5cjw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=L/O+bS46+nLEi3hdfv7bRiHSR1XZ8a/zJRDO3VtyfTQzJAjVaOprimT34hLnUe4Zt
	 MrMfdSKlIRW9ikM50cC4OhQPZXfw1ewGKMy2d9mKGpfZcY/NeJYtA2nJFU3AwbWUMW
	 V6ATo3IGd8QLgce4OuBHbkp3frGqrAx02bv321qU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGNBWB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBWA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:22:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFECE21548;
        Tue, 14 Jul 2020 01:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689720;
        bh=XoJYpmzpUhUn1NBGOqvaEgeqrZn5Jmk+v6RHGYD5cjw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X0j4FTXb5osP0eRsbuYxqlysn3gJK+l66pzKbxK2Ew2JU1MA9iMpmcLdBdAZvjSdf
         DrDEBjX/DJ6f0RtExVf4HKwJy2qbIDYnwjAfb5JB6xaYATdbd547KiPFZgMjnYt983
         AaVL1Ps7FXPwG3Th78id8YOeY3OBnzxAxXpPM6UA=
Date:   Mon, 13 Jul 2020 18:21:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch added
 to -mm tree
Message-ID: <20200714012159.eCEVbNsTS%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: remove a wrapper for alloc_migration_target()
has been added to the -mm tree.  Its filename is
     mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1677,16 +1677,6 @@ int unpoison_memory(unsigned long pfn)
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
@@ -1793,6 +1783,10 @@ static int __soft_offline_page(struct pa
 	const char *msg_page[] = {"page", "hugepage"};
 	bool huge = PageHuge(page);
 	LIST_HEAD(pagelist);
+	struct migration_target_control mtc = {
+		.nid = NUMA_NO_NODE,
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
 	/*
 	 * Check PageHWPoison again inside page lock because PageHWPoison
@@ -1829,8 +1823,8 @@ static int __soft_offline_page(struct pa
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

mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

