From: akpm@linux-foundation.org
Subject: [merged] ksm-remove-redundancies-when-merging-page.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:15 -0800
Message-ID: <200912152153.nBFLrFsa015258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761350AbZLOWNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:13:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: remove redundancies when merging page
has been removed from the -mm tree.  Its filename was
     ksm-remove-redundancies-when-merging-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: remove redundancies when merging page
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

There is no need for replace_page() to calculate a write-protected prot
vm_page_prot must already be write-protected for an anonymous page (see
mm/memory.c do_anonymous_page() for similar reliance on vm_page_prot).

There is no need for try_to_merge_one_page() to get_page and put_page on
newpage and oldpage: in every case we already hold a reference to each of
them.

But some instinct makes me move try_to_merge_one_page()'s unlock_page of
oldpage down after replace_page(): that doesn't increase contention on the
ksm page, and makes thinking about the transition easier.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff -puN mm/ksm.c~ksm-remove-redundancies-when-merging-page mm/ksm.c
--- a/mm/ksm.c~ksm-remove-redundancies-when-merging-page
+++ a/mm/ksm.c
@@ -647,7 +647,7 @@ static int write_protect_page(struct vm_
 		 * Check that no O_DIRECT or similar I/O is in progress on the
 		 * page
 		 */
-		if ((page_mapcount(page) + 2 + swapped) != page_count(page)) {
+		if (page_mapcount(page) + 1 + swapped != page_count(page)) {
 			set_pte_at_notify(mm, addr, ptep, entry);
 			goto out_unlock;
 		}
@@ -682,11 +682,8 @@ static int replace_page(struct vm_area_s
 	pte_t *ptep;
 	spinlock_t *ptl;
 	unsigned long addr;
-	pgprot_t prot;
 	int err = -EFAULT;
 
-	prot = vm_get_page_prot(vma->vm_flags & ~VM_WRITE);
-
 	addr = page_address_in_vma(oldpage, vma);
 	if (addr == -EFAULT)
 		goto out;
@@ -714,7 +711,7 @@ static int replace_page(struct vm_area_s
 
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush(vma, addr, ptep);
-	set_pte_at_notify(mm, addr, ptep, mk_pte(newpage, prot));
+	set_pte_at_notify(mm, addr, ptep, mk_pte(newpage, vma->vm_page_prot));
 
 	page_remove_rmap(oldpage);
 	put_page(oldpage);
@@ -746,13 +743,9 @@ static int try_to_merge_one_page(struct 
 
 	if (!(vma->vm_flags & VM_MERGEABLE))
 		goto out;
-
 	if (!PageAnon(oldpage))
 		goto out;
 
-	get_page(newpage);
-	get_page(oldpage);
-
 	/*
 	 * We need the page lock to read a stable PageSwapCache in
 	 * write_protect_page().  We use trylock_page() instead of
@@ -761,25 +754,18 @@ static int try_to_merge_one_page(struct 
 	 * then come back to this page when it is unlocked.
 	 */
 	if (!trylock_page(oldpage))
-		goto out_putpage;
+		goto out;
 	/*
 	 * If this anonymous page is mapped only here, its pte may need
 	 * to be write-protected.  If it's mapped elsewhere, all of its
 	 * ptes are necessarily already write-protected.  But in either
 	 * case, we need to lock and check page_count is not raised.
 	 */
-	if (write_protect_page(vma, oldpage, &orig_pte)) {
-		unlock_page(oldpage);
-		goto out_putpage;
-	}
-	unlock_page(oldpage);
