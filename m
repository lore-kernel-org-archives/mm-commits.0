From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-remove-unused-function-fail_migrate_page.patch removed from -mm
 tree
Date: Wed, 22 Jan 2014 12:15:10 -0800
Message-ID: <52e026ce.JqbWW+1IxcQHC+uD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaAVUPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:15:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vbabka@suse.cz, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, cl@linux.com, aquini@redhat.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-migrate-remove-unused-function-fail_migrate_page.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aquini@redhat.com,cl@linux.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,vbabka@suse.cz,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:15:10 -0800


The patch titled
     Subject: mm/migrate: remove unused function, fail_migrate_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-unused-function-fail_migrate_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/migrate: remove unused function, fail_migrate_page()

fail_migrate_page() isn't used anywhere, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ----
 mm/migrate.c            |    8 --------
 2 files changed, 12 deletions(-)

diff -puN include/linux/migrate.h~mm-migrate-remove-unused-function-fail_migrate_page include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-remove-unused-function-fail_migrate_page
+++ a/include/linux/migrate.h
@@ -41,9 +41,6 @@ extern int migrate_page(struct address_s
 extern int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, enum migrate_mode mode, int reason);
 
-extern int fail_migrate_page(struct address_space *,
-			struct page *, struct page *);
-
 extern int migrate_prep(void);
 extern int migrate_prep_local(void);
 extern int migrate_vmas(struct mm_struct *mm,
@@ -84,7 +81,6 @@ static inline int migrate_huge_page_move
 
 /* Possible settings for the migrate_page() method in address_operations */
 #define migrate_page NULL
-#define fail_migrate_page NULL
 
 #endif /* CONFIG_MIGRATION */
 
diff -puN mm/migrate.c~mm-migrate-remove-unused-function-fail_migrate_page mm/migrate.c
--- a/mm/migrate.c~mm-migrate-remove-unused-function-fail_migrate_page
+++ a/mm/migrate.c
@@ -552,14 +552,6 @@ void migrate_page_copy(struct page *newp
  *                    Migration functions
  ***********************************************************/
 
-/* Always fail migration. Used for mappings that are not movable */
-int fail_migrate_page(struct address_space *mapping,
-			struct page *newpage, struct page *page)
-{
-	return -EIO;
-}
-EXPORT_SYMBOL(fail_migrate_page);
