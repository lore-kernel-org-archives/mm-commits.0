From: akpm@linux-foundation.org
Subject: +
 mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 11:55:53 -0800
Message-ID: <52af5ac9.ESS6lTxHDAXKfrQR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3LPTzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vbabka@suse.cz, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, cl@linux.com, aquini@redhat.com, iamjoonsoo.kim@lge.com

Subject: + mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aquini@redhat.com,cl@linux.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,vbabka@suse.cz,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:53 -0800


The patch titled
     Subject: mm/migrate: correct failure handling if !hugepage_migration_support()
has been added to the -mm tree.  Its filename is
     mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/migrate: correct failure handling if !hugepage_migration_support()

We should remove the page from the list if we fail with ENOSYS, since
migrate_pages() consider error cases except -ENOMEM and -EAGAIN as
permanent failure and it assumes that the page would be removed from the
list.  Without this patch, we could overcount number of failure.

In addition, we should put back the new hugepage if
!hugepage_migration_support().  If not, we would leak hugepage memory.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-migrate-correct-failure-handling-if-hugepage_migration_support mm/migrate.c
--- a/mm/migrate.c~mm-migrate-correct-failure-handling-if-hugepage_migration_support
+++ a/mm/migrate.c
@@ -1012,7 +1012,7 @@ static int unmap_and_move_huge_page(new_
 {
 	int rc = 0;
 	int *result = NULL;
-	struct page *new_hpage = get_new_page(hpage, private, &result);
+	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
 
 	/*
@@ -1022,9 +1022,12 @@ static int unmap_and_move_huge_page(new_
 	 * tables or check whether the hugepage is pmd-based or not before
 	 * kicking migration.
 	 */
-	if (!hugepage_migration_support(page_hstate(hpage)))
+	if (!hugepage_migration_support(page_hstate(hpage))) {
+		putback_active_hugepage(hpage);
 		return -ENOSYS;
+	}
 
+	new_hpage = get_new_page(hpage, private, &result);
 	if (!new_hpage)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
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

