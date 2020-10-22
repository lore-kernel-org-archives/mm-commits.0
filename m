Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6780BC388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158F1223BF
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408170;
	bh=Y59hH1kjuYaSjDBMSL4e7kXwQjz7UHAurNgD7qbKkJg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=l4QcsOAJNTAWnLFqbhX/4HxflYgcYvrm3fRzCC0wfzYZscZ8mPU9MlBoLazI18Iao
	 cjMXOxn0DsSqFP5ZsHTaTbq8Wp1ZMV/CuuBnHA2Aw7rQ/piQQp984wIQy1JdpH4Sr5
	 g5hdFfjpV7PxOvPRx6ygYzl5Ev9NbCkj2q+Ajs3I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373230AbgJVXJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE18F20756;
        Thu, 22 Oct 2020 23:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408168;
        bh=Y59hH1kjuYaSjDBMSL4e7kXwQjz7UHAurNgD7qbKkJg=;
        h=Date:From:To:Subject:From;
        b=JLLebj5irqu7d+LoXyR3QyWQAqlKUKLaxefBzBnDYfRaypkQWc4dppyhjXBi0UWgF
         7Ji97CsstS6hqFKrdTUooNOicquGpFSd1Bb9Vkei0Vu4BfhqskZ/469mCJIKX9jqwB
         7QFCp93mQ/ZwthQTGA7fTlYjyWAeR2Cl6T470Mng=
Date:   Thu, 22 Oct 2020 16:09:27 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch removed
 from -mm tree
Message-ID: <20201022230927.FArEnId6B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove a wrapper for alloc_migration_target()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/memory_hotplug: remove a wrapper for alloc_migration_target()

To calculate the correct node to migrate the page for hotplug, we need to
check node id of the page.  Wrapper for alloc_migration_target() exists
for this purpose.

However, Vlastimil informs that all migration source pages come from a
single node.  In this case, we don't need to check the node id for each
page and we don't need to re-set the target nodemask for each page by
using the wrapper.  Set up the migration_target_control once and use it
for all pages.

Link: http://lkml.kernel.org/r/1594622517-20681-10-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   46 ++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target
+++ a/mm/memory_hotplug.c
@@ -1290,27 +1290,6 @@ found:
 	return 0;
 }
 
-static struct page *new_node_page(struct page *page, unsigned long private)
-{
-	nodemask_t nmask = node_states[N_MEMORY];
-	struct migration_target_control mtc = {
-		.nid = page_to_nid(page),
-		.nmask = &nmask,
-		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
-	};
-
-	/*
-	 * try to allocate from a different node but reuse this node if there
-	 * are no other online nodes to be used (e.g. we are offlining a part
-	 * of the only existing node)
-	 */
-	node_clear(mtc.nid, nmask);
-	if (nodes_empty(nmask))
-		node_set(mtc.nid, nmask);
-
-	return alloc_migration_target(page, (unsigned long)&mtc);
-}
-
 static int
 do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -1370,9 +1349,28 @@ do_migrate_range(unsigned long start_pfn
 		put_page(page);
 	}
 	if (!list_empty(&source)) {
-		/* Allocate a new page from the nearest neighbor node */
-		ret = migrate_pages(&source, new_node_page, NULL, 0,
-					MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
+		nodemask_t nmask = node_states[N_MEMORY];
+		struct migration_target_control mtc = {
+			.nmask = &nmask,
+			.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+		};
+
+		/*
+		 * We have checked that migration range is on a single zone so
+		 * we can use the nid of the first page to all the others.
+		 */
+		mtc.nid = page_to_nid(list_first_entry(&source, struct page, lru));
+
+		/*
+		 * try to allocate from a different node but reuse this node
+		 * if there are no other online nodes to be used (e.g. we are
+		 * offlining a part of the only existing node)
+		 */
+		node_clear(mtc.nid, nmask);
+		if (nodes_empty(nmask))
+			node_set(mtc.nid, nmask);
+		ret = migrate_pages(&source, alloc_migration_target, NULL,
+			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret) {
 			list_for_each_entry(page, &source, lru) {
 				pr_warn("migrating pfn %lx failed ret:%d ",
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


