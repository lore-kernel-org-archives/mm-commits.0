Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D02FC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F14B61A8E
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhKRV53 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 16:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhKRV52 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 16:57:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDA6261361;
        Thu, 18 Nov 2021 21:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637272468;
        bh=ql6D4B+T92yN4qH5RjDYGy3DZOUOU5yJBpm2MiHnQCM=;
        h=Date:From:To:Subject:From;
        b=xwpG0T8ax+pEPacd4xQmvNSHxUAKhkXu/6gm8ze2NQDd2eKlzBfY7k4AeKiyPnY29
         D+Sn1s4mnxeGMf+RUgksvQB1cDce0l2NLTflBx/4DgUlvMRUl6+Xz1qNx3c93xLOHq
         Rehzjecd5j/JNwH7LN8J5PkOZhpX8JjMe8FFArU0=
Date:   Thu, 18 Nov 2021 13:54:27 -0800
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, dhowells@redhat.com, hughd@google.com,
        jgg@nvidia.com, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        willy@infradead.org
Subject:  +
 mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch added
 to -mm tree
Message-ID: <20211118215427.csLE2tPWS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: rework migration_entry_wait() to not take a pageref
has been added to the -mm tree.  Its filename is
     mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch

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
Subject: mm/migrate.c: rework migration_entry_wait() to not take a pageref

This fixes the FIXME in migrate_vma_check_page().

Before migrating a page migration code will take a reference and check
there are no unexpected page references, failing the migration if there
are. When a thread faults on a migration entry it will take a temporary
reference to the page to wait for the page to become unlocked signifying
the migration entry has been removed.

This reference is dropped just prior to waiting on the page lock,
however the extra reference can cause migration failures so it is
desirable to avoid taking it.

As migration code already has a reference to the migrating page an extra
reference to wait on PG_locked is unnecessary so long as the reference
can't be dropped whilst setting up the wait.

When faulting on a migration entry the ptl is taken to check the
migration entry. Removing a migration entry also requires the ptl, and
migration code won't drop its page reference until after the migration
entry has been removed. Therefore retaining the ptl of a migration entry
is sufficient to ensure the page has a reference. Reworking
migration_entry_wait() to hold the ptl until the wait setup is complete
means the extra page reference is no longer needed.

Link: https://lkml.kernel.org/r/20211118020754.954425-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
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
 mm/filemap.c            |   88 ++++++++++++++++++++++++++++++++++++++
 mm/migrate.c            |   33 +-------------
 3 files changed, 94 insertions(+), 29 deletions(-)

--- a/include/linux/migrate.h~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref
+++ a/include/linux/migrate.h
@@ -40,6 +40,8 @@ extern int migrate_huge_page_move_mappin
 				  struct page *newpage, struct page *page);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
+void migration_entry_wait_on_locked(struct folio *folio, pte_t *ptep,
+				spinlock_t *ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
--- a/mm/filemap.c~mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref
+++ a/mm/filemap.c
@@ -41,6 +41,7 @@
 #include <linux/psi.h>
 #include <linux/ramfs.h>
 #include <linux/page_idle.h>
+#include <linux/migrate.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -1426,6 +1427,93 @@ repeat:
 	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
 }
 
+#ifdef CONFIG_MIGRATION
+/**
+ * migration_entry_wait_on_locked - Wait for a migration entry to be removed
+ * @folio: folio referenced by the migration entry.
+ * @ptep: mapped pte pointer. This function will return with the ptep unmapped.
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
+ * This follows the same logic as wait_on_page_bit_common() so see the comments
+ * there.
+ */
+void migration_entry_wait_on_locked(struct folio *folio, pte_t *ptep,
+				spinlock_t *ptl)
+{
+	struct wait_page_queue wait_page;
+	wait_queue_entry_t *wait = &wait_page.wait;
+	bool thrashing = false;
+	bool delayacct = false;
+	unsigned long pflags;
+	wait_queue_head_t *q;
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
@@ -305,15 +305,7 @@ void __migration_entry_wait(struct mm_st
 	page = pfn_swap_entry_to_page(entry);
 	page = compound_head(page);
 
-	/*
-	 * Once page cache replacement of page migration started, page_count
-	 * is zero; but we must not call put_and_wait_on_page_locked() without
-	 * a ref. Use get_page_unless_zero(), and just fault again if it fails.
-	 */
-	if (!get_page_unless_zero(page))
-		goto out;
-	pte_unmap_unlock(ptep, ptl);
-	put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
+	migration_entry_wait_on_locked(page_folio(page), ptep, ptl);
 	return;
 out:
 	pte_unmap_unlock(ptep, ptl);
@@ -344,10 +336,7 @@ void pmd_migration_entry_wait(struct mm_
 	if (!is_pmd_migration_entry(*pmd))
 		goto unlock;
 	page = pfn_swap_entry_to_page(pmd_to_swp_entry(*pmd));
-	if (!get_page_unless_zero(page))
-		goto unlock;
-	spin_unlock(ptl);
-	put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
+	migration_entry_wait_on_locked(page_folio(page), NULL, ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
@@ -2514,22 +2503,8 @@ static bool migrate_vma_check_page(struc
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

mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch
mm-hmmc-allow-vm_mixedmap-to-work-with-hmm_range_fault.patch

