From: akpm@linux-foundation.org
Subject: [merged]
 futex-thp-remove-special-case-for-thp-in-get_futex_key.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:01:56 -0800
Message-ID: <569e9634.SuzwItJM7LeGBDe6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbcASUB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, artem.savkov@gmail.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: futex, thp: remove special case for THP in get_futex_key
has been removed from the -mm tree.  Its filename was
     futex-thp-remove-special-case-for-thp-in-get_futex_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: futex, thp: remove special case for THP in get_futex_key

With new THP refcounting, we don't need tricks to stabilize huge page.
If we've got reference to tail page, it can't split under us.

This patch effectively reverts a5b338f2b0b1 ("thp: update futex compound
knowledge").

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Tested-by: Artem Savkov <artem.savkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   63 ++++++++++-------------------------------------
 1 file changed, 14 insertions(+), 49 deletions(-)

diff -puN kernel/futex.c~futex-thp-remove-special-case-for-thp-in-get_futex_key kernel/futex.c
--- a/kernel/futex.c~futex-thp-remove-special-case-for-thp-in-get_futex_key
+++ a/kernel/futex.c
@@ -469,7 +469,8 @@ get_futex_key(u32 __user *uaddr, int fsh
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
-	struct page *page, *page_head;
+	struct page *page;
+	struct address_space *mapping;
 	int err, ro = 0;
 
 	/*
@@ -519,46 +520,9 @@ again:
 	else
 		err = 0;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	page_head = page;
-	if (unlikely(PageTail(page))) {
-		put_page(page);
-		/* serialize against __split_huge_page_splitting() */
-		local_irq_disable();
-		if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {
-			page_head = compound_head(page);
-			/*
-			 * page_head is valid pointer but we must pin
-			 * it before taking the PG_lock and/or
-			 * PG_compound_lock. The moment we re-enable
-			 * irqs __split_huge_page_splitting() can
-			 * return and the head page can be freed from
-			 * under us. We can't take the PG_lock and/or
-			 * PG_compound_lock on a page that could be
-			 * freed from under us.
-			 */
-			if (page != page_head) {
-				get_page(page_head);
-				put_page(page);
-			}
-			local_irq_enable();
-		} else {
-			local_irq_enable();
-			goto again;
-		}
-	}
-#else
-	page_head = compound_head(page);
-	if (page != page_head) {
-		get_page(page_head);
-		put_page(page);
-	}
-#endif
-
-	lock_page(page_head);
-
+	lock_page(page);
 	/*
-	 * If page_head->mapping is NULL, then it cannot be a PageAnon
+	 * If page->mapping is NULL, then it cannot be a PageAnon
 	 * page; but it might be the ZERO_PAGE or in the gate area or
 	 * in a special mapping (all cases which we are happy to fail);
 	 * or it may have been a good file page when get_user_pages_fast
@@ -570,12 +534,13 @@ again:
 	 *
 	 * The case we do have to guard against is when memory pressure made
 	 * shmem_writepage move it from filecache to swapcache beneath us:
-	 * an unlikely race, but we do need to retry for page_head->mapping.
+	 * an unlikely race, but we do need to retry for page->mapping.
 	 */
-	if (!page_head->mapping) {
-		int shmem_swizzled = PageSwapCache(page_head);
-		unlock_page(page_head);
-		put_page(page_head);
+	mapping = compound_head(page)->mapping;
+	if (!mapping) {
+		int shmem_swizzled = PageSwapCache(page);
+		unlock_page(page);
+		put_page(page);
 		if (shmem_swizzled)
 			goto again;
 		return -EFAULT;
@@ -588,7 +553,7 @@ again:
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
 	 */
-	if (PageAnon(page_head)) {
+	if (PageAnon(page)) {
 		/*
 		 * A RO anonymous page will never change and thus doesn't make
 		 * sense for futex operations.
@@ -603,15 +568,15 @@ again:
 		key->private.address = address;
 	} else {
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page_head->mapping->host;
+		key->shared.inode = mapping->host;
 		key->shared.pgoff = basepage_index(page);
 	}
 
 	get_futex_key_refs(key); /* implies MB (B) */
 
 out:
-	unlock_page(page_head);
-	put_page(page_head);
+	unlock_page(page);
+	put_page(page);
 	return err;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

