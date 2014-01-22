From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:15:06 -0800
Message-ID: <52e026ca.1tApOht6PCtpt4qy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaAVUPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:15:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vbabka@suse.cz, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, cl@linux.com, aquini@redhat.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aquini@redhat.com,cl@linux.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,vbabka@suse.cz,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:15:06 -0800


The patch titled
     Subject: mm/migrate: correct failure handling if !hugepage_migration_support()
has been removed from the -mm tree.  Its filename was
     mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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
@@ -1013,7 +1013,7 @@ static int unmap_and_move_huge_page(new_
 {
 	int rc = 0;
 	int *result = NULL;
-	struct page *new_hpage = get_new_page(hpage, private, &result);
+	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
 
 	/*
@@ -1023,9 +1023,12 @@ static int unmap_and_move_huge_page(new_
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

origin.patch
mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch

