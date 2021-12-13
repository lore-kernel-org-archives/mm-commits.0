Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852B3C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 21:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbhLMVN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 16:13:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60370 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237803AbhLMVNZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 16:13:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B828261204
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 21:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD0DC34600;
        Mon, 13 Dec 2021 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639430004;
        bh=HkcSnk0tNgm0HPS7SX8oiE6IOCdMBGrwmKQ/uSDI2f8=;
        h=Date:From:To:Subject:From;
        b=jFJIT5BFTnMX3F4YtXCnO0u47aP06MuEd64eI9j6+q9EV+1rG6ZxbXyJODlP/O5qN
         p1Rc1+4wx50WjlzoLVEHuRDJgG1B/mlcIKaIujhdMZ7OiE5YauYnygEdNs8URjtEQ1
         DxKa/h6rXETkPhl23oBetLsW0gDNsr4EJECX0/2E=
Date:   Mon, 13 Dec 2021 13:13:23 -0800
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, david@redhat.com, dhowells@redhat.com,
        hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  +
 mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5.patch
 added to -mm tree
Message-ID: <20211213211323.uEy-cys1R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: Rework migration_entry_wait() to not take a pageref
has been added to the -mm tree.  Its filename is
     mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 mm/migrate.c            |   10 ++--------
 3 files changed, 10 insertions(+), 13 deletions(-)

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
@@ -1430,8 +1431,9 @@ repeat:
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
@@ -1442,10 +1444,10 @@ repeat:
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
@@ -1454,6 +1456,7 @@ void migration_entry_wait_on_locked(stru
 	bool delayacct = false;
 	unsigned long pflags;
 	wait_queue_head_t *q;
+	struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
 
 	q = folio_waitqueue(folio);
 	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
--- a/mm/migrate.c~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5
+++ a/mm/migrate.c
@@ -291,7 +291,6 @@ void __migration_entry_wait(struct mm_st
 {
 	pte_t pte;
 	swp_entry_t entry;
-	struct page *page;
 
 	spin_lock(ptl);
 	pte = *ptep;
@@ -302,10 +301,7 @@ void __migration_entry_wait(struct mm_st
 	if (!is_migration_entry(entry))
 		goto out;
 
-	page = pfn_swap_entry_to_page(entry);
-	page = compound_head(page);
-
-	migration_entry_wait_on_locked(page_folio(page), ptep, ptl);
+	migration_entry_wait_on_locked(entry, ptep, ptl);
 	return;
 out:
 	pte_unmap_unlock(ptep, ptl);
@@ -330,13 +326,11 @@ void migration_entry_wait_huge(struct vm
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl;
-	struct page *page;
 
 	ptl = pmd_lock(mm, pmd);
 	if (!is_pmd_migration_entry(*pmd))
 		goto unlock;
-	page = pfn_swap_entry_to_page(pmd_to_swp_entry(*pmd));
-	migration_entry_wait_on_locked(page_folio(page), NULL, ptl);
+	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), NULL, ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch
mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref-v5.patch
mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch

