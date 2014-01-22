From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-add-comment-about-permanent-failure-path.patch removed from -mm
 tree
Date: Wed, 22 Jan 2014 12:15:04 -0800
Message-ID: <52e026c8.m6abKGL55ppZyK2H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbaAVUPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:15:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, cl@linux.com, aquini@redhat.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-migrate-add-comment-about-permanent-failure-path.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,aquini@redhat.com,cl@linux.com,iamjoonsoo.kim@lge.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:15:04 -0800


The patch titled
     Subject: mm/migrate: add comment about permanent failure path
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-comment-about-permanent-failure-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/migrate: add comment about permanent failure path

Let's add a comment about where the failed page goes to, which makes code
more readable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
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
@@ -1125,7 +1125,12 @@ int migrate_pages(struct list_head *from
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

origin.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
mm-memory-failurec-shift-page-lock-from-head-page-to-tail-page-after-thp-split.patch
mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
mm-do_mincore-cleanup.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

