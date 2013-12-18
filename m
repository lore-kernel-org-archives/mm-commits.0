From: akpm@linux-foundation.org
Subject: +
 mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch added to
 -mm tree
Date: Wed, 18 Dec 2013 13:20:12 -0800
Message-ID: <52b2118c.QVkbDZbKq1rcSvQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab3LRVUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Dec 2013 16:20:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de, hughd@google.com, aarcange@redhat.com, vbabka@suse.cz

Subject: + mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch added to -mm tree
To: vbabka@suse.cz,aarcange@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 18 Dec 2013 13:20:12 -0800


The patch titled
     Subject: mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2
has been added to the -mm tree.  Its filename is
     mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch
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
linux-next.patch

