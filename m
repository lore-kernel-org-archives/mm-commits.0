From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch
 removed from -mm tree
Date: Tue, 07 Jul 2020 13:11:25 -0700
Message-ID: <20200707201125.79CrcAii6%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgGGUL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 16:11:26 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch

This patch was dropped because it was folded into mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix

Fix 5.7-rc6-mm1 page migration crash in unmap_and_move(): when the
page to be migrated has been freed from under us, that is considered
a MIGRATEPAGE_SUCCESS, but no newpage has been allocated (and I don't
think it would ever need to be counted as a successful THP migration).

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005210643340.482@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix
+++ a/mm/migrate.c
@@ -1245,7 +1245,7 @@ out:
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (PageTransHuge(newpage))
+		if (newpage && PageTransHuge(newpage))
 			thp_migration_success(true);
 		put_page(page);
 		if (reason == MR_MEMORY_FAILURE) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
