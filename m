From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch removed
 from -mm tree
Date: Thu, 02 Jan 2014 12:56:10 -0800
Message-ID: <52c5d26a.8c3Mlav/VuIBsGj7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaABU4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jan 2014 15:56:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de, hughd@google.com, aarcange@redhat.com, vbabka@suse.cz

Subject: [folded-merged] mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch removed from -mm tree
To: vbabka@suse.cz,aarcange@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 02 Jan 2014 12:56:10 -0800


The patch titled
     Subject: mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2
has been removed from the -mm tree.  Its filename was
     mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch

This patch was dropped because it was folded into mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2 mm/mlock.c
--- a/mm/mlock.c~mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2
+++ a/mm/mlock.c
@@ -133,7 +133,10 @@ static void __munlock_isolation_failed(s
 
 /**
  * munlock_vma_page - munlock a vma page
- * @page - page to be unlocked
+ * @page - page to be unlocked, either a normal page or THP page head
+ *
+ * returns the size of the page as a page mask (0 for normal page,
+ *         HPAGE_PMD_NR - 1 for THP head page)
  *
  * called from munlock()/munmap() path with page supposedly on the LRU.
  * When we munlock a page, because the vma where we found the page is being
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-documentation-remove-hopelessly-out-of-date-locking-doc.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-remove-bug_on-from-mlock_vma_page.patch
linux-next.patch

