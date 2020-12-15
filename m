Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF2BC35270
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C89222D05
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgLOX7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgLOX0G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:06 -0500
Date:   Tue, 15 Dec 2020 15:23:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074612;
        bh=pXp6F5XnxTUdBfexjR2NClmqpEWuDRxGTKMhw0TCfs4=;
        h=From:To:Subject:From;
        b=tZW1uH5a8aiTeyqOgyEo/eflzN9EBVntxAR8cxqqoyOV86yscBXYCecbivCbWTSXT
         jnQlClQSVjxu9s8smiYF6sAOfhjyXMpRbMjcS5p7GcYwZ7HzFfFWjkumpF+B8inC4e
         lMJE2hbVnf7FcMOrqjmARCm8yNmyah//bkL+rRhY=
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-migrate-clean-up-migrate_prep_local.patch
 removed from -mm tree
Message-ID: <20201215232331.L0ydMH7ry%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: clean up migrate_prep{_local}
has been removed from the -mm tree.  Its filename was
     mm-migrate-clean-up-migrate_prep_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: migrate: clean up migrate_prep{_local}

The migrate_prep{_local} never fails, so it is pointless to have return
value and check the return value.

Link: https://lkml.kernel.org/r/20201113205359.556831-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++--
 mm/mempolicy.c          |    8 ++------
 mm/migrate.c            |    8 ++------
 3 files changed, 6 insertions(+), 14 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-clean-up-migrate_prep_local
+++ a/include/linux/migrate.h
@@ -45,8 +45,8 @@ extern struct page *alloc_migration_targ
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 extern void putback_movable_page(struct page *page);
 
-extern int migrate_prep(void);
-extern int migrate_prep_local(void);
+extern void migrate_prep(void);
+extern void migrate_prep_local(void);
 extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
--- a/mm/mempolicy.c~mm-migrate-clean-up-migrate_prep_local
+++ a/mm/mempolicy.c
@@ -1114,9 +1114,7 @@ int do_migrate_pages(struct mm_struct *m
 	int err;
 	nodemask_t tmp;
 
-	err = migrate_prep();
-	if (err)
-		return err;
+	migrate_prep();
 
 	mmap_read_lock(mm);
 
@@ -1315,9 +1313,7 @@ static long do_mbind(unsigned long start
 
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 
-		err = migrate_prep();
-		if (err)
-			goto mpol_out;
+		migrate_prep();
 	}
 	{
 		NODEMASK_SCRATCH(scratch);
--- a/mm/migrate.c~mm-migrate-clean-up-migrate_prep_local
+++ a/mm/migrate.c
@@ -62,7 +62,7 @@
  * to be migrated using isolate_lru_page(). If scheduling work on other CPUs is
  * undesirable, use migrate_prep_local()
  */
-int migrate_prep(void)
+void migrate_prep(void)
 {
 	/*
 	 * Clear the LRU lists so pages can be isolated.
@@ -71,16 +71,12 @@ int migrate_prep(void)
 	 * pages that may be busy.
 	 */
 	lru_add_drain_all();
-
-	return 0;
 }
 
 /* Do the necessary work of migrate_prep but not if it involves other CPUs */
-int migrate_prep_local(void)
+void migrate_prep_local(void)
 {
 	lru_add_drain();
-
-	return 0;
 }
 
 int isolate_movable_page(struct page *page, isolate_mode_t mode)
_

Patches currently in -mm which might be from shy828301@gmail.com are


