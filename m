From: akpm@linux-foundation.org
Subject: + mm-adjust-address_space_operationsmigratepage-return-code.patch added to -mm tree
Date: Wed, 07 Nov 2012 12:01:02 -0800
Message-ID: <20121107200103.02EFF5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:54398 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2KGUBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 15:01:05 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so231241yen.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 12:01:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au


The patch titled
     Subject: mm: adjust address_space_operations.migratepage() return code
has been added to the -mm tree.  Its filename is
     mm-adjust-address_space_operationsmigratepage-return-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: adjust address_space_operations.migratepage() return code

Memory fragmentation introduced by ballooning might reduce significantly
the number of 2MB contiguous memory blocks that can be used within a
guest, thus imposing performance penalties associated with the reduced
number of transparent huge pages that could be used by the guest workload.

This patchset follows the main idea discussed at 2012 LSFMMS session:
"Ballooning for transparent huge pages" -- http://lwn.net/Articles/490114/
to introduce the required changes to the virtio_balloon driver, as well as
the changes to the core compaction & migration bits, in order to make
those subsystems aware of ballooned pages and allow memory balloon pages
become movable within a guest, thus avoiding the aforementioned
fragmentation issue

Following are numbers that prove this patch benefits on allowing
compaction to be more effective at memory ballooned guests.

Results for STRESS-HIGHALLOC benchmark, from Mel Gorman's mmtests suite,
running on a 4gB RAM KVM guest which was ballooning 512mB RAM in 64mB
chunks, at every minute (inflating/deflating), while test was running:

===BEGIN stress-highalloc

STRESS-HIGHALLOC
                 highalloc-3.7     highalloc-3.7
                     rc4-clean         rc4-patch
Pass 1          55.00 ( 0.00%)    62.00 ( 7.00%)
Pass 2          54.00 ( 0.00%)    62.00 ( 8.00%)
while Rested    75.00 ( 0.00%)    80.00 ( 5.00%)

MMTests Statistics: duration
                 3.7         3.7
           rc4-clean   rc4-patch
User         1207.59     1207.46
System       1300.55     1299.61
Elapsed      2273.72     2157.06

MMTests Statistics: vmstat
                                3.7         3.7
                          rc4-clean   rc4-patch
Page Ins                    3581516     2374368
Page Outs                  11148692    10410332
Swap Ins                         80          47
Swap Outs                      3641         476
Direct pages scanned          37978       33826
Kswapd pages scanned        1828245     1342869
Kswapd pages reclaimed      1710236     1304099
Direct pages reclaimed        32207       31005
Kswapd efficiency               93%         97%
Kswapd velocity             804.077     622.546
Direct efficiency               84%         91%
Direct velocity              16.703      15.682
Percentage direct scans          2%          2%
Page writes by reclaim        79252        9704
Page writes file              75611        9228
Page writes anon               3641         476
Page reclaim immediate        16764       11014
Page rescued immediate            0           0
Slabs scanned               2171904     2152448
Direct inode steals             385        2261
Kswapd inode steals          659137      609670
Kswapd skipped wait               1          69
THP fault alloc                 546         631
THP collapse alloc              361         339
THP splits                      259         263
THP fault fallback               98          50
THP collapse fail                20          17
Compaction stalls               747         499
Compaction success              244         145
Compaction failures             503         354
Compaction pages moved       370888      474837
Compaction move failure       77378       65259

===END stress-highalloc



This patch:

Introduce MIGRATEPAGE_SUCCESS as the default return code for
address_space_operations.migratepage() method and documents the expected
return code for the same method in failure cases.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    4 ++--
 include/linux/migrate.h |    7 +++++++
 mm/migrate.c            |   26 +++++++++++++-------------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-adjust-address_space_operationsmigratepage-return-code fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-adjust-address_space_operationsmigratepage-return-code
+++ a/fs/hugetlbfs/inode.c
@@ -582,11 +582,11 @@ static int hugetlbfs_migrate_page(struct
 	int rc;
 
 	rc = migrate_huge_page_move_mapping(mapping, newpage, page);
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 	migrate_page_copy(newpage, page);
 
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 
 static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
diff -puN include/linux/migrate.h~mm-adjust-address_space_operationsmigratepage-return-code include/linux/migrate.h
--- a/include/linux/migrate.h~mm-adjust-address_space_operationsmigratepage-return-code
+++ a/include/linux/migrate.h
@@ -7,6 +7,13 @@
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
+/*
+ * Return values from addresss_space_operations.migratepage():
+ * - negative errno on page migration failure;
+ * - zero on page migration success;
+ */
+#define MIGRATEPAGE_SUCCESS		0
+
 #ifdef CONFIG_MIGRATION
 
 extern void putback_lru_pages(struct list_head *l);
diff -puN mm/migrate.c~mm-adjust-address_space_operationsmigratepage-return-code mm/migrate.c
--- a/mm/migrate.c~mm-adjust-address_space_operationsmigratepage-return-code
+++ a/mm/migrate.c
@@ -286,7 +286,7 @@ static int migrate_page_move_mapping(str
 		expected_count += 1;
 		if (page_count(page) != expected_count)
 			return -EAGAIN;
-		return 0;
+		return MIGRATEPAGE_SUCCESS;
 	}
 
 	spin_lock_irq(&mapping->tree_lock);
@@ -356,7 +356,7 @@ static int migrate_page_move_mapping(str
 	}
 	spin_unlock_irq(&mapping->tree_lock);
 
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 
 /*
@@ -372,7 +372,7 @@ int migrate_huge_page_move_mapping(struc
 	if (!mapping) {
 		if (page_count(page) != 1)
 			return -EAGAIN;
-		return 0;
+		return MIGRATEPAGE_SUCCESS;
 	}
 
 	spin_lock_irq(&mapping->tree_lock);
@@ -399,7 +399,7 @@ int migrate_huge_page_move_mapping(struc
 	page_unfreeze_refs(page, expected_count - 1);
 
 	spin_unlock_irq(&mapping->tree_lock);
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 
 /*
@@ -486,11 +486,11 @@ int migrate_page(struct address_space *m
 
 	rc = migrate_page_move_mapping(mapping, newpage, page, NULL, mode);
 
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
 	migrate_page_copy(newpage, page);
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 EXPORT_SYMBOL(migrate_page);
 
@@ -513,7 +513,7 @@ int buffer_migrate_page(struct address_s
 
 	rc = migrate_page_move_mapping(mapping, newpage, page, head, mode);
 
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
 	/*
@@ -549,7 +549,7 @@ int buffer_migrate_page(struct address_s
 
 	} while (bh != head);
 
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 EXPORT_SYMBOL(buffer_migrate_page);
 #endif
@@ -665,7 +665,7 @@ static int move_to_new_page(struct page 
 	else
 		rc = fallback_migrate_page(mapping, newpage, page, mode);
 
-	if (rc) {
+	if (rc != MIGRATEPAGE_SUCCESS) {
 		newpage->mapping = NULL;
 	} else {
 		if (remap_swapcache)
@@ -814,7 +814,7 @@ skip_unmap:
 		put_anon_vma(anon_vma);
 
 uncharge:
-	mem_cgroup_end_migration(mem, page, newpage, rc == 0);
+	mem_cgroup_end_migration(mem, page, newpage, rc == MIGRATEPAGE_SUCCESS);
 unlock:
 	unlock_page(page);
 out:
@@ -987,7 +987,7 @@ int migrate_pages(struct list_head *from
 			case -EAGAIN:
 				retry++;
 				break;
-			case 0:
+			case MIGRATEPAGE_SUCCESS:
 				break;
 			default:
 				/* Permanent failure */
@@ -1001,7 +1001,7 @@ out:
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
 
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
 	return nr_failed + retry;
@@ -1024,7 +1024,7 @@ int migrate_huge_page(struct page *hpage
 			/* try again */
 			cond_resched();
 			break;
-		case 0:
+		case MIGRATEPAGE_SUCCESS:
 			goto out;
 		default:
 			rc = -EIO;
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-adjust-address_space_operationsmigratepage-return-code.patch
mm-redefine-address_spaceassoc_mapping.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
mm-introduce-compaction-and-migration-for-ballooned-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
mm-introduce-putback_movable_pages.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

