From: akpm@linux-foundation.org
Subject: + mm-migrate-add-comment-about-permanent-failure-path.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:53 -0800
Message-ID: <52af5ac9.Is+H4BrDZ2xIjuUt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3LPTzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, cl@linux.com, aquini@redhat.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-migrate-add-comment-about-permanent-failure-path.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aquini@redhat.com,cl@linux.com,iamjoonsoo.kim@lge.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:53 -0800


The patch titled
     Subject: mm/migrate: add comment about permanent failure path
has been added to the -mm tree.  Its filename is
     mm-migrate-add-comment-about-permanent-failure-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-add-comment-about-permanent-failure-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-add-comment-about-permanent-failure-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/migrate: add comment about permanent failure path

Let's add a comment about where the failed page goes to, which makes code
more readable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-add-comment-about-permanent-failure-path mm/migrate.c
--- a/mm/migrate.c~mm-migrate-add-comment-about-permanent-failure-path
+++ a/mm/migrate.c
@@ -1124,7 +1124,12 @@ int migrate_pages(struct list_head *from
 				nr_succeeded++;
 				break;
 			default:
-				/* Permanent failure */
+				/*
+				 * Permanent failure (-EBUSY, -ENOSYS, etc.):
+				 * unlike -EAGAIN case, the failed page is
+				 * removed from migration page list and not
+				 * retried in the next outer loop.
+				 */
 				nr_failed++;
 				break;
 			}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
thp-move-preallocated-pte-page-table-on-move_huge_pmd.patch
mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-hwpoison-add-to-hwpoison_inject.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

