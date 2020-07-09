From: akpm@linux-foundation.org
Subject: +
 mm-vmstat-add-events-for-thp-migration-without-split-fix.patch added to -mm
 tree
Date: Wed, 08 Jul 2020 19:27:00 -0700
Message-ID: <20200709022700.-fdpk6Rb7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgGIC1B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 22:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, daniel.m.jordan@oracle.com, hughd@google.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, willy@infradead.org, ziy@nvidia.com


The patch titled
     Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-thp-migration-without-split-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix

s/hpage_nr_pages/thp_nr_pages/ due to "mm: replace hpage_nr_pages with
thp_nr_pages".

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split-fix
+++ a/mm/migrate.c
@@ -1425,7 +1425,7 @@ int migrate_pages(struct list_head *from
 	struct page *page;
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
-	int rc, thp_nr_pages;
+	int rc, thp_n_pages;
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
@@ -1442,7 +1442,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			thp_nr_pages = hpage_nr_pages(page);
+			thp_n_pages = thp_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1479,7 +1479,7 @@ retry:
 				}
 				if (is_thp) {
 					nr_thp_failed++;
-					nr_failed += thp_nr_pages;
+					nr_failed += thp_n_pages;
 					goto out;
 				}
 				nr_failed++;
@@ -1494,7 +1494,7 @@ retry:
 			case MIGRATEPAGE_SUCCESS:
 				if (is_thp) {
 					nr_thp_succeeded++;
-					nr_succeeded += thp_nr_pages;
+					nr_succeeded += thp_n_pages;
 					break;
 				}
 				nr_succeeded++;
@@ -1508,7 +1508,7 @@ retry:
 				 */
 				if (is_thp) {
 					nr_thp_failed++;
-					nr_failed += thp_nr_pages;
+					nr_failed += thp_n_pages;
 					break;
 				}
 				nr_failed++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch
