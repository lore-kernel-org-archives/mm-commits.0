Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7A0C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiAWXzP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiAWXzP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:55:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1963C06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 338AE611E0
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3ABC340E3;
        Sun, 23 Jan 2022 23:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982113;
        bh=yExVkcotSPA8l5MX5t8y0X2r4k8pLT2BDbAsUYtSCnE=;
        h=Date:From:To:Subject:From;
        b=h29qaeELwoZRtCx5MAOMNWtSMSu1E3MTKg+iA1y5XYUTt0hFjrY9OhqfKOy4kFXWs
         r9hMk1tbfnwQ+nbqnMn1wrLze8oMzarT4qe9hsJPLIJCvyqf5Vxe393SJ0wg5TEkU8
         7oC/l9gmaRE/7CFtyhb4fpWq3AhNPl9YYkAmHi1k=
Date:   Sun, 23 Jan 2022 15:55:12 -0800
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, david@redhat.com, dhowells@redhat.com,
        hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  [merged]
 mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch removed
 from -mm tree
Message-ID: <20220123235512.aO_H3ki37%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: rework migration_entry_wait() to not take a pageref
has been removed from the -mm tree.  Its filename was
     mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate.c: rework migration_entry_wait() to not take a pageref

This fixes the FIXME in migrate_vma_check_page().

Before migrating a page migration code will take a reference and check
there are no unexpected page references, failing the migration if there
are.  When a thread faults on a migration entry it will take a temporary
reference to the page to wait for the page to become unlocked signifying
the migration entry has been removed.

This reference is dropped just prior to waiting on the page lock, however
the extra reference can cause migration failures so it is desirable to
avoid taking it.

As migration code already has a reference to the migrating page an extra
reference to wait on PG_locked is unnecessary so long as the reference
can't be dropped whilst setting up the wait.

When faulting on a migration entry the ptl is taken to check the migration
entry.  Removing a migration entry also requires the ptl, and migration
code won't drop its page reference until after the migration entry has
been removed.  Therefore retaining the ptl of a migration entry is
sufficient to ensure the page has a reference.  Reworking
migration_entry_wait() to hold the ptl until the wait setup is complete
means the extra page reference is no longer needed.

[apopple@nvidia.com: v5]
  Link: https://lkml.kernel.org/r/20211213033848.1973946-1-apopple@nvidia.com
Link: https://lkml.kernel.org/r/20211118020754.954425-1-apopple@nvidia.com
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

 include/linux/migrate.h |    2 
 mm/filemap.c            |   91 ++++++++++++++++++++++++++++++++++++++
 mm/migrate.c            |   38 +--------------
 3 files changed, 97 insertions(+), 34 deletions(-)

--- a/include/linux/migrate.h~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref
+++ a/include/linux/migrate.h
@@ -40,6 +40,8 @@ extern int migrate_huge_page_move_mappin
 				  struct page *newpage, struct page *page);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
+void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
+				spinlock_t *ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
--- a/mm/filemap.c~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref
+++ a/mm/filemap.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/swapops.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
@@ -41,6 +42,7 @@
 #include <linux/psi.h>
 #include <linux/ramfs.h>
 #include <linux/page_idle.h>
+#include <linux/migrate.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -1388,6 +1390,95 @@ repeat:
 	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
 }
 
+#ifdef CONFIG_MIGRATION
+/**
+ * migration_entry_wait_on_locked - Wait for a migration entry to be removed
+ * @entry: migration swap entry.
+ * @ptep: mapped pte pointer. Will return with the ptep unmapped. Only required
+ *        for pte entries, pass NULL for pmd entries.
+ * @ptl: already locked ptl. This function will drop the lock.
+ *
+ * Wait for a migration entry referencing the given page to be removed. This is
+ * equivalent to put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE) except
+ * this can be called without taking a reference on the page. Instead this
+ * should be called while holding the ptl for the migration entry referencing
+ * the page.
+ *
+ * Returns after unmapping and unlocking the pte/ptl with pte_unmap_unlock().
+ *
+ * This follows the same logic as folio_wait_bit_common() so see the comments
+ * there.
+ */
+void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
+				spinlock_t *ptl)
+{
+	struct wait_page_queue wait_page;
+	wait_queue_entry_t *wait = &wait_page.wait;
+	bool thrashing = false;
+	bool delayacct = false;
+	unsigned long pflags;
+	wait_queue_head_t *q;
+	struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
+
+	q = folio_waitqueue(folio);
+	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
+		if (!folio_test_swapbacked(folio)) {
+			delayacct_thrashing_start();
+			delayacct = true;
+		}
+		psi_memstall_enter(&pflags);
+		thrashing = true;
+	}
+
+	init_wait(wait);
+	wait->func = wake_page_function;
+	wait_page.folio = folio;
+	wait_page.bit_nr = PG_locked;
+	wait->flags = 0;
+
+	spin_lock_irq(&q->lock);
+	folio_set_waiters(folio);
+	if (!folio_trylock_flag(folio, PG_locked, wait))
+		__add_wait_queue_entry_tail(q, wait);
+	spin_unlock_irq(&q->lock);
+
+	/*
+	 * If a migration entry exists for the page the migration path must hold
+	 * a valid reference to the page, and it must take the ptl to remove the
+	 * migration entry. So the page is valid until the ptl is dropped.
+	 */
+	if (ptep)
+		pte_unmap_unlock(ptep, ptl);
+	else
+		spin_unlock(ptl);
+
+	for (;;) {
+		unsigned int flags;
+
+		set_current_state(TASK_UNINTERRUPTIBLE);
+
+		/* Loop until we've been woken or interrupted */
+		flags = smp_load_acquire(&wait->flags);
+		if (!(flags & WQ_FLAG_WOKEN)) {
+			if (signal_pending_state(TASK_UNINTERRUPTIBLE, current))
+				break;
+
+			io_schedule();
+			continue;
+		}
+		break;
+	}
+
+	finish_wait(q, wait);
+
+	if (thrashing) {
+		if (delayacct)
+			delayacct_thrashing_end();
+		psi_memstall_leave(&pflags);
+	}
+}
+#endif
+
 void folio_wait_bit(struct folio *folio, int bit_nr)
 {
 	folio_wait_bit_common(folio, bit_nr, TASK_UNINTERRUPTIBLE, SHARED);
--- a/mm/migrate.c~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref
+++ a/mm/migrate.c
@@ -291,7 +291,6 @@ void __migration_entry_wait(struct mm_st
 {
 	pte_t pte;
 	swp_entry_t entry;
-	struct folio *folio;
 
 	spin_lock(ptl);
 	pte = *ptep;
@@ -302,17 +301,7 @@ void __migration_entry_wait(struct mm_st
 	if (!is_migration_entry(entry))
 		goto out;
 
-	folio = page_folio(pfn_swap_entry_to_page(entry));
-
-	/*
-	 * Once page cache replacement of page migration started, page_count
-	 * is zero; but we must not call folio_put_wait_locked() without
-	 * a ref. Use folio_try_get(), and just fault again if it fails.
-	 */
-	if (!folio_try_get(folio))
-		goto out;
-	pte_unmap_unlock(ptep, ptl);
-	folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE);
+	migration_entry_wait_on_locked(entry, ptep, ptl);
 	return;
 out:
 	pte_unmap_unlock(ptep, ptl);
@@ -337,16 +326,11 @@ void migration_entry_wait_huge(struct vm
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl;
-	struct folio *folio;
 
 	ptl = pmd_lock(mm, pmd);
 	if (!is_pmd_migration_entry(*pmd))
 		goto unlock;
-	folio = page_folio(pfn_swap_entry_to_page(pmd_to_swp_entry(*pmd)));
-	if (!folio_try_get(folio))
-		goto unlock;
-	spin_unlock(ptl);
-	folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE);
+	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), NULL, ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
@@ -2431,22 +2415,8 @@ static bool migrate_vma_check_page(struc
 		return false;
 
 	/* Page from ZONE_DEVICE have one extra reference */
-	if (is_zone_device_page(page)) {
-		/*
-		 * Private page can never be pin as they have no valid pte and
-		 * GUP will fail for those. Yet if there is a pending migration
-		 * a thread might try to wait on the pte migration entry and
-		 * will bump the page reference count. Sadly there is no way to
-		 * differentiate a regular pin from migration wait. Hence to
-		 * avoid 2 racing thread trying to migrate back to CPU to enter
-		 * infinite loop (one stopping migration because the other is
-		 * waiting on pte migration entry). We always return true here.
-		 *
-		 * FIXME proper solution is to rework migration_entry_wait() so
-		 * it does not need to take a reference on page.
-		 */
-		return is_device_private_page(page);
-	}
+	if (is_zone_device_page(page))
+		extra++;
 
 	/* For file back page */
 	if (page_mapping(page))
_

Patches currently in -mm which might be from apopple@nvidia.com are


