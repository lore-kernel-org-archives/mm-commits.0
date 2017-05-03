From: akpm@linux-foundation.org
Subject: [patch 051/102] mm: make try_to_munlock() return void
Date: Wed, 03 May 2017 14:54:10 -0700
Message-ID: <20170503215410.875E0gBi0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdECVzZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.levin@verizon.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: make try_to_munlock() return void

try_to_munlock returns SWAP_MLOCK if the one of VMAs mapped the page has
VM_LOCKED flag.  In that time, VM set PG_mlocked to the page if the page
is not pte-mapped THP which cannot be mlocked, either.

With that, __munlock_isolated_page can use PageMlocked to check whether
try_to_munlock is successful or not without relying on try_to_munlock's
retval.  It helps to make try_to_unmap/try_to_unmap_one simple with
upcoming patches.

[minchan@kernel.org: remove PG_Mlocked VM_BUG_ON check]
  Link: http://lkml.kernel.org/r/20170411025615.GA6545@bbox
Link: http://lkml.kernel.org/r/1489555493-14659-5-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <alexander.levin@verizon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/mlock.c           |    6 ++----
 mm/rmap.c            |   16 ++++------------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff -puN include/linux/rmap.h~mm-make-the-try_to_munlock-void-function include/linux/rmap.h
--- a/include/linux/rmap.h~mm-make-the-try_to_munlock-void-function
+++ a/include/linux/rmap.h
@@ -235,7 +235,7 @@ int page_mkclean(struct page *);
  * called in munlock()/munmap() path to check for other vmas holding
  * the page mlocked.
  */
-int try_to_munlock(struct page *);
+void try_to_munlock(struct page *);
 
 void remove_migration_ptes(struct page *old, struct page *new, bool locked);
 
diff -puN mm/mlock.c~mm-make-the-try_to_munlock-void-function mm/mlock.c
--- a/mm/mlock.c~mm-make-the-try_to_munlock-void-function
+++ a/mm/mlock.c
@@ -123,17 +123,15 @@ static bool __munlock_isolate_lru_page(s
  */
 static void __munlock_isolated_page(struct page *page)
 {
-	int ret = SWAP_AGAIN;
-
 	/*
 	 * Optimization: if the page was mapped just once, that's our mapping
 	 * and we don't need to check all the other vmas.
 	 */
 	if (page_mapcount(page) > 1)
-		ret = try_to_munlock(page);
+		try_to_munlock(page);
 
 	/* Did try_to_unlock() succeed or punt? */
-	if (ret != SWAP_MLOCK)
+	if (!PageMlocked(page))
 		count_vm_event(UNEVICTABLE_PGMUNLOCKED);
 
 	putback_lru_page(page);
diff -puN mm/rmap.c~mm-make-the-try_to_munlock-void-function mm/rmap.c
--- a/mm/rmap.c~mm-make-the-try_to_munlock-void-function
+++ a/mm/rmap.c
@@ -1552,18 +1552,10 @@ static int page_not_mapped(struct page *
  * Called from munlock code.  Checks all of the VMAs mapping the page
  * to make sure nobody else has this page mlocked. The page will be
  * returned with PG_mlocked cleared if no other vmas have it mlocked.
- *
- * Return values are:
- *
- * SWAP_AGAIN	- no vma is holding page mlocked, or,
- * SWAP_AGAIN	- page mapped in mlocked vma -- couldn't acquire mmap sem
- * SWAP_FAIL	- page cannot be located at present
- * SWAP_MLOCK	- page is now mlocked.
  */
-int try_to_munlock(struct page *page)
-{
-	int ret;
 
+void try_to_munlock(struct page *page)
+{
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)TTU_MUNLOCK,
@@ -1573,9 +1565,9 @@ int try_to_munlock(struct page *page)
 	};
 
 	VM_BUG_ON_PAGE(!PageLocked(page) || PageLRU(page), page);
+	VM_BUG_ON_PAGE(PageCompound(page) && PageDoubleMap(page), page);
 
-	ret = rmap_walk(page, &rwc);
-	return ret;
+	rmap_walk(page, &rwc);
 }
 
 void __put_anon_vma(struct anon_vma *anon_vma)
_
