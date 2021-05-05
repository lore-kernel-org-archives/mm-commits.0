Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF67C43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A33761421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhEEBiA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhEEBiA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83840610A1;
        Wed,  5 May 2021 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178624;
        bh=fh/s492CJDc1SnceORyhuREHnvus5ti0Np1gu//mlYM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0Yo2A5Ly3TcTlXIbV6Z5UM0pTEl9ZcqyUva5oSh2C6XMRquovVv12oftkVBZQyixl
         TURw/7HqglkRNw61jGtJwix8A4TqLcl7KIJxG4gFd8ujXYh3kXr/NmVaMA9bAFyqel
         PRbJuq7dPgDthIeC0b3r6HomlnB60yS4M/IEatHk=
Date:   Tue, 04 May 2021 18:37:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, aquini@redhat.com,
        david@redhat.com, jglisse@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 080/143] mm/migrate.c: make putback_movable_page()
 static
Message-ID: <20210505013704.HLPvEmFky%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
