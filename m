Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D850EC55ABD
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 865282225D
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wsyqDZjA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgKMXmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 18:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgKMXmj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 18:42:39 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F0122261;
        Fri, 13 Nov 2020 23:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310958;
        bh=IzHvyzkuywsY/FlUEvUfq4wVqpfO/PcUZJiylRj7Mz8=;
        h=Date:From:To:Subject:From;
        b=wsyqDZjANV3k9R0sJ1LEfXhBk9B+wdugCjw4rGQgvFn2EjKZcgA9eLPvl73lzhYo5
         Op31K20yd40kN7q7i6wsZbKd0xaQJrd/wUUZAKNqYbm18xGBmr5+DI2/PpX8iCpCZP
         o0CvWnnDqR9XOjnqVHCW4OSbBQOYIV1wb4UNcITw=
Date:   Fri, 13 Nov 2020 15:42:37 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-migrate-clean-up-migrate_prep_local.patch added to
 -mm tree
Message-ID: <20201113234237.A0wD8MqkB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: clean up migrate_prep{_local}
has been added to the -mm tree.  Its filename is
     mm-migrate-clean-up-migrate_prep_local.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-clean-up-migrate_prep_local.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-clean-up-migrate_prep_local.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-truncate_complete_page-is-not-existed-anymore.patch
mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch
mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
mm-migrate-clean-up-migrate_prep_local.patch
mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

