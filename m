From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
 removed from -mm tree
Date: Thu, 19 Dec 2013 11:53:57 -0800
Message-ID: <52b34ed5.houV401SaZGIFcEJ%akpm__37884.7582302571$1387482856$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3LSTx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vbabka@suse.cz, stable@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, cl@linux.com, aquini@redhat.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aquini@redhat.com,cl@linux.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,stable@vger.kernel.org,vbabka@suse.cz,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:57 -0800


The patch titled
     Subject: mm/mempolicy: correct putback method for isolate pages if failed
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/mempolicy: correct putback method for isolate pages if failed

queue_pages_range() isolates hugetlbfs pages and putback_lru_pages() can't
handle these.  We should change it to putback_movable_pages().

Naoya said that it is worth going into stable, because it can break in-use
hugepage list.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: <stable@vger.kernel.org>	[3.12.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed
+++ a/mm/mempolicy.c
@@ -1318,7 +1318,7 @@ static long do_mbind(unsigned long start
 		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else
-		putback_lru_pages(&pagelist);
+		putback_movable_pages(&pagelist);
 
 	up_write(&mm->mmap_sem);
  mpol_out:
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
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

