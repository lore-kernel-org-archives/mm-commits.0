From: akpm@linux-foundation.org
Subject: + mm-remove-unevictable_migrate_page-function.patch added to -mm tree
Date: Wed, 02 Dec 2009 17:05:29 -0800
Message-ID: <200912030105.nB315TIU019280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbZLCBF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 20:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, cl@linux-foundation.org, lee.schermerhorn@hp.com


The patch titled
     mm: remove unevictable_migrate_page function
has been added to the -mm tree.  Its filename is
     mm-remove-unevictable_migrate_page-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unevictable_migrate_page function
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

unevictable_migrate_page() in mm/internal.h is a relic of the since
removed UNEVICTABLE_LRU Kconfig option.  This patch removes the function
and open codes the test in migrate_page_copy().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   12 ------------
 mm/migrate.c  |    4 ++--
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN mm/internal.h~mm-remove-unevictable_migrate_page-function mm/internal.h
--- a/mm/internal.h~mm-remove-unevictable_migrate_page-function
+++ a/mm/internal.h
@@ -63,18 +63,6 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
-/*
- * unevictable_migrate_page() called only from migrate_page_copy() to
- * migrate unevictable flag to new page.
- * Note that the old page has been isolated from the LRU lists at this
- * point so we don't need to worry about LRU statistics.
- */
-static inline void unevictable_migrate_page(struct page *new, struct page *old)
-{
-	if (TestClearPageUnevictable(old))
-		SetPageUnevictable(new);
-}
-
 #ifdef CONFIG_MMU
 extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
diff -puN mm/migrate.c~mm-remove-unevictable_migrate_page-function mm/migrate.c
--- a/mm/migrate.c~mm-remove-unevictable_migrate_page-function
+++ a/mm/migrate.c
@@ -288,8 +288,8 @@ static void migrate_page_copy(struct pag
 	if (TestClearPageActive(page)) {
 		VM_BUG_ON(PageUnevictable(page));
 		SetPageActive(newpage);
-	} else
-		unevictable_migrate_page(newpage, page);
+	} else if (TestClearPageUnevictable(page))
+		SetPageUnevictable(newpage);
 	if (PageChecked(page))
 		SetPageChecked(newpage);
 	if (PageMappedToDisk(page))
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

acpi-remove-nid_inval.patch
hugetlb-offload-per-node-attribute-registrations-fix.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-remove-unevictable_migrate_page-function.patch

