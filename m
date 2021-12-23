Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9101EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Dec 2021 00:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhLWA0Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Dec 2021 19:26:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhLWA0Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Dec 2021 19:26:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34E24B81F2B
        for <mm-commits@vger.kernel.org>; Thu, 23 Dec 2021 00:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9167BC36AE5;
        Thu, 23 Dec 2021 00:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640219182;
        bh=zyFMjX4oPdNCAnzNu9rIdN3DrSRFgHPNeNmnpVHrrM4=;
        h=Date:From:To:Subject:From;
        b=tLEsxOH3aGH1VoK261Nv6XRLvBtb8WgKLdxlbXqGJjZWPU0kEf654cqPXJBOP5sKw
         wkNOWrMK800XdQgkka8+wLxh6fX5JOCK4Zb+23DmVhS/l2yVDEUoxqeEOEQ2pTlBly
         tg8dzUM7eCjoV659/Vpn8RbgeP/XgmSnzxO+sBH8=
Date:   Wed, 22 Dec 2021 16:26:21 -0800
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, david@redhat.com, dhowells@redhat.com,
        hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  [folded-merged]
 mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5.patch
 removed from -mm tree
Message-ID: <20211223002621.kNH3R4fLb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: Rework migration_entry_wait() to not take a pageref
has been removed from the -mm tree.  Its filename was
     mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5.patch

This patch was dropped because it was folded into mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate.c: Rework migration_entry_wait() to not take a pageref

 - Documentation/comment fixes from David H
 - Added David's Acked-by
 - Changed functions to take swap entries instead of struct pages as
   suggested by Matthew W

Link: https://lkml.kernel.org/r/20211213033848.1973946-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +-
 mm/filemap.c            |   11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/migrate.h~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5
+++ a/include/linux/migrate.h
@@ -40,7 +40,7 @@ extern int migrate_huge_page_move_mappin
 				  struct page *newpage, struct page *page);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
-void migration_entry_wait_on_locked(struct folio *folio, pte_t *ptep,
+void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
 				spinlock_t *ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
--- a/mm/filemap.c~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5
+++ a/mm/filemap.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/swapops.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
@@ -1392,8 +1393,9 @@ repeat:
 #ifdef CONFIG_MIGRATION
 /**
  * migration_entry_wait_on_locked - Wait for a migration entry to be removed
- * @folio: folio referenced by the migration entry.
- * @ptep: mapped pte pointer. This function will return with the ptep unmapped.
+ * @entry: migration swap entry.
+ * @ptep: mapped pte pointer. Will return with the ptep unmapped. Only required
+ *        for pte entries, pass NULL for pmd entries.
  * @ptl: already locked ptl. This function will drop the lock.
  *
  * Wait for a migration entry referencing the given page to be removed. This is
@@ -1404,10 +1406,10 @@ repeat:
  *
  * Returns after unmapping and unlocking the pte/ptl with pte_unmap_unlock().
  *
- * This follows the same logic as wait_on_page_bit_common() so see the comments
+ * This follows the same logic as folio_wait_bit_common() so see the comments
  * there.
  */
-void migration_entry_wait_on_locked(struct folio *folio, pte_t *ptep,
+void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
 				spinlock_t *ptl)
 {
 	struct wait_page_queue wait_page;
@@ -1416,6 +1418,7 @@ void migration_entry_wait_on_locked(stru
 	bool delayacct = false;
 	unsigned long pflags;
 	wait_queue_head_t *q;
+	struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
 
 	q = folio_waitqueue(folio);
 	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch
mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch

