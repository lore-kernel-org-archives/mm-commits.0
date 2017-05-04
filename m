From: akpm@linux-foundation.org
Subject: [merged]
 mm-softoffline-add-page-flag-description-in-error-paths.patch removed from
 -mm tree
Date: Thu, 04 May 2017 12:13:01 -0700
Message-ID: <20170504191301.mBw1cgJfJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756569AbdEDTND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm/memory-failure.c: add page flag description in error paths
has been removed from the -mm tree.  Its filename was
     mm-softoffline-add-page-flag-description-in-error-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/memory-failure.c: add page flag description in error paths

It helps to provide page flag description along with the raw value in
error paths during soft offline process.  From sample experiments

Before the patch:

[  132.317977] soft offline: 0x6100: migration failed 1, type 3ffff800008018
[  132.359057] soft offline: 0x7400: migration failed 1, type 3ffff800008018

After the patch:

[   87.694325] soft offline: 0x5900: migration failed 1, type 3ffff800008018 (uptodate|dirty|head)
[   87.736273] soft offline: 0x6c00: migration failed 1, type 3ffff800008018 (uptodate|dirty|head)

Link: http://lkml.kernel.org/r/20170409023829.10788-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memory-failure.c~mm-softoffline-add-page-flag-description-in-error-paths mm/memory-failure.c
--- a/mm/memory-failure.c~mm-softoffline-add-page-flag-description-in-error-paths
+++ a/mm/memory-failure.c
@@ -1541,8 +1541,8 @@ static int get_any_page(struct page *pag
 		if (ret == 1 && !PageLRU(page)) {
 			/* Drop page reference which is from __get_any_page() */
 			put_hwpoison_page(page);
-			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
-				pfn, page->flags);
+			pr_info("soft_offline: %#lx: unknown non LRU page type %lx (%pGp)\n",
+				pfn, page->flags, &page->flags);
 			return -EIO;
 		}
 	}
@@ -1583,8 +1583,8 @@ static int soft_offline_huge_page(struct
 	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
-		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
-			pfn, ret, page->flags);
+		pr_info("soft offline: %#lx: migration failed %d, type %lx (%pGp)\n",
+			pfn, ret, page->flags, &page->flags);
 		/*
 		 * We know that soft_offline_huge_page() tries to migrate
 		 * only one hugepage pointed to by hpage, so we need not
@@ -1675,14 +1675,14 @@ static int __soft_offline_page(struct pa
 			if (!list_empty(&pagelist))
 				putback_movable_pages(&pagelist);
 
-			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
-				pfn, ret, page->flags);
+			pr_info("soft offline: %#lx: migration failed %d, type %lx (%pGp)\n",
+				pfn, ret, page->flags, &page->flags);
 			if (ret > 0)
 				ret = -EIO;
 		}
 	} else {
-		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
-			pfn, ret, page_count(page), page->flags);
+		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx (%pGp)\n",
+			pfn, ret, page_count(page), page->flags, &page->flags);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

selftests-vm-add-a-test-for-virtual-address-range-mapping.patch

