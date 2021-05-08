Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24ACC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B528261402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhEHWuM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHWuM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 750386101D;
        Sat,  8 May 2021 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514150;
        bh=ywxp5bkRymOoGK8PdaozTbzfSvHrQDTMrIa0h6ODN3Q=;
        h=Date:From:To:Subject:From;
        b=H4XNfkZpLAqEH8AvpMsIOz2Tnrzno5xrPeXxSsL4rR16J2sG4BV/Ftb64dqNyafRN
         lme2ga9JaiVsCmram/lE5/igmQIobucO3y6OlroBCjTJ1Tzz/OEoZFt/MDbhAdKQXf
         OtzmgJUkCcp97lZlcEmZXLm7ZskLhzFcvDdFpVDo=
Date:   Sat, 08 May 2021 15:49:10 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, aquini@redhat.com, david@redhat.com,
        jglisse@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  [merged]
 mm-migratec-make-putback_movable_page-static.patch removed from -mm tree
Message-ID: <20210508224910.CoLxzhiNS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: make putback_movable_page() static
has been removed from the -mm tree.  Its filename was
     mm-migratec-make-putback_movable_page-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migrate.c: make putback_movable_page() static

Patch series "Cleanup and fixup for mm/migrate.c", v3.

This series contains cleanups to remove unnecessary VM_BUG_ON_PAGE and rc
!= MIGRATEPAGE_SUCCESS check.  Also use helper function to remove some
duplicated codes.  What's more, this fixes potential deadlock in NUMA
balancing shared exec THP case and so on.  More details can be found in
the respective changelogs.


This patch (of 5):

The putback_movable_page() is just called by putback_movable_pages() and
we know the page is locked and both PageMovable() and PageIsolated() is
checked right before calling putback_movable_page().  So we make it static
and remove all the 3 VM_BUG_ON_PAGE().

Link: https://lkml.kernel.org/r/20210325131524.48181-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210325131524.48181-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    1 -
 mm/migrate.c            |    7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/include/linux/migrate.h~mm-migratec-make-putback_movable_page-static
+++ a/include/linux/migrate.h
@@ -43,7 +43,6 @@ extern int migrate_pages(struct list_hea
 		unsigned long private, enum migrate_mode mode, int reason);
 extern struct page *alloc_migration_target(struct page *page, unsigned long private);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
-extern void putback_movable_page(struct page *page);
 
 extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
--- a/mm/migrate.c~mm-migratec-make-putback_movable_page-static
+++ a/mm/migrate.c
@@ -118,15 +118,10 @@ out:
 	return -EBUSY;
 }
 
-/* It should be called on page which is PG_movable */
-void putback_movable_page(struct page *page)
+static void putback_movable_page(struct page *page)
 {
 	struct address_space *mapping;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageMovable(page), page);
-	VM_BUG_ON_PAGE(!PageIsolated(page), page);
-
 	mapping = page_mapping(page);
 	mapping->a_ops->putback_page(page);
 	__ClearPageIsolated(page);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


