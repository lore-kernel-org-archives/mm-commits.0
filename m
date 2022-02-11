Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0033EC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353358AbiBKUt0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353355AbiBKUtY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB593CFE
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:49:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C3CBB82CFD
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04484C340E9;
        Fri, 11 Feb 2022 20:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612560;
        bh=MiHERMIw+jmwktb2VmSc+yuQKy6sUNoy9Q0apwS33IQ=;
        h=Date:To:From:Subject:From;
        b=J6/h8PNJYw0YFo2zPn+U9q/bKDNDsmJYF/D+R9VgBJv+cjoR4vmCRtq+9OeeQ0pXC
         cx/KJwwN8bbVrCHCN7KjhZ28b27PSv+dTvG2iP1IulcZhY6O6VVdLYXvr68TVvh8TJ
         t8hPKPuSYxZpjKKDMharlXwjLMnSDLpvFy+AFcxw=
Date:   Fri, 11 Feb 2022 12:49:19 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-check_and_migrate_movable_pages.patch added to -mm tree
Message-Id: <20220211204920.04484C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor check_and_migrate_movable_pages
has been added to the -mm tree.  Its filename is
     mm-refactor-check_and_migrate_movable_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-check_and_migrate_movable_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-check_and_migrate_movable_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: refactor check_and_migrate_movable_pages

Remove up to two levels of indentation by using continue statements
and move variables to local scope where possible.

Link: https://lkml.kernel.org/r/20220210072828.2930359-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-refactor-check_and_migrate_movable_pages
+++ a/mm/gup.c
@@ -1844,72 +1844,79 @@ static long check_and_migrate_movable_pa
 					    struct page **pages,
 					    unsigned int gup_flags)
 {
-	unsigned long i;
-	unsigned long isolation_error_count = 0;
-	bool drain_allow = true;
-	LIST_HEAD(movable_page_list);
-	long ret = 0;
+	unsigned long isolation_error_count = 0, i;
 	struct page *prev_head = NULL;
-	struct page *head;
-	struct migration_target_control mtc = {
-		.nid = NUMA_NO_NODE,
-		.gfp_mask = GFP_USER | __GFP_NOWARN,
-	};
+	LIST_HEAD(movable_page_list);
+	bool drain_allow = true;
+	int ret = 0;
 
 	for (i = 0; i < nr_pages; i++) {
-		head = compound_head(pages[i]);
+		struct page *head = compound_head(pages[i]);
+
 		if (head == prev_head)
 			continue;
 		prev_head = head;
+
+		if (is_pinnable_page(head))
+			continue;
+
 		/*
-		 * If we get a movable page, since we are going to be pinning
-		 * these entries, try to move them out if possible.
+		 * Try to move out any movable page before pinning the range.
 		 */
-		if (!is_pinnable_page(head)) {
-			if (PageHuge(head)) {
-				if (!isolate_huge_page(head, &movable_page_list))
-					isolation_error_count++;
-			} else {
-				if (!PageLRU(head) && drain_allow) {
-					lru_add_drain_all();
-					drain_allow = false;
-				}
-
-				if (isolate_lru_page(head)) {
-					isolation_error_count++;
-					continue;
-				}
-				list_add_tail(&head->lru, &movable_page_list);
-				mod_node_page_state(page_pgdat(head),
-						    NR_ISOLATED_ANON +
-						    page_is_file_lru(head),
-						    thp_nr_pages(head));
-			}
+		if (PageHuge(head)) {
+			if (!isolate_huge_page(head, &movable_page_list))
+				isolation_error_count++;
+			continue;
 		}
+
+		if (!PageLRU(head) && drain_allow) {
+			lru_add_drain_all();
+			drain_allow = false;
+		}
+
+		if (isolate_lru_page(head)) {
+			isolation_error_count++;
+			continue;
+		}
+		list_add_tail(&head->lru, &movable_page_list);
+		mod_node_page_state(page_pgdat(head),
+				    NR_ISOLATED_ANON + page_is_file_lru(head),
+				    thp_nr_pages(head));
 	}
 
+	if (!list_empty(&movable_page_list) || isolation_error_count)
+		goto unpin_pages;
+
 	/*
 	 * If list is empty, and no isolation errors, means that all pages are
 	 * in the correct zone.
 	 */
-	if (list_empty(&movable_page_list) && !isolation_error_count)
-		return nr_pages;
+	return nr_pages;
 
+unpin_pages:
 	if (gup_flags & FOLL_PIN) {
 		unpin_user_pages(pages, nr_pages);
 	} else {
 		for (i = 0; i < nr_pages; i++)
 			put_page(pages[i]);
 	}
+
 	if (!list_empty(&movable_page_list)) {
+		struct migration_target_control mtc = {
+			.nid = NUMA_NO_NODE,
+			.gfp_mask = GFP_USER | __GFP_NOWARN,
+		};
+
 		ret = migrate_pages(&movable_page_list, alloc_migration_target,
 				    NULL, (unsigned long)&mtc, MIGRATE_SYNC,
 				    MR_LONGTERM_PIN, NULL);
-		if (ret && !list_empty(&movable_page_list))
-			putback_movable_pages(&movable_page_list);
+		if (ret > 0) /* number of pages not migrated */
+			ret = -ENOMEM;
 	}
 
-	return ret > 0 ? -ENOMEM : ret;
+	if (ret && !list_empty(&movable_page_list))
+		putback_movable_pages(&movable_page_list);
+	return ret;
 }
 #else
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-page_init_poison.patch
mm-remove-a-pointless-config_zone_device-check-in-memremap_pages.patch
mm-remove-the-__kernel__-guard-from-linux-mmh.patch
mm-remove-pointless-includes-from-linux-hmmh.patch
mm-move-free_devmap_managed_page-to-memremapc.patch
mm-simplify-freeing-of-devmap-managed-pages.patch
mm-dont-include-linux-memremaph-in-linux-mmh.patch
mm-remove-the-extra-zone_device-struct-page-refcount.patch
fsdax-depend-on-zone_device-fs_dax_limited.patch
mm-generalize-the-pgmap-based-page_free-infrastructure.patch
mm-refactor-check_and_migrate_movable_pages.patch
mm-refactor-the-zone_device-handling-in-migrate_vma_insert_page.patch
mm-refactor-the-zone_device-handling-in-migrate_vma_pages.patch
mm-move-the-migrate_vma_-device-migration-code-into-its-own-file.patch
mm-build-migrate_vma_-for-all-configs-with-zone_device-support.patch
mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch

