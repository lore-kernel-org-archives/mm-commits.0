From: akpm@linux-foundation.org
Subject: [nacked]
 ksm-set-anon_vma-of-first-rmap_item-of-ksm-page-to-pages-anon_vma-other-than-vmas-anon_vma.patch removed from -mm tree
Date: Wed, 20 Jul 2016 14:32:52 -0700
Message-ID: <578fee04.NHJZxtAOWy9PRL2h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbcGTVcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2016 17:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: z00281421@notesmail.huawei.com, aarcange@redhat.com, dave.hansen@linux.intel.com, geliangtang@163.com, hughd@google.com, kirill.shutemov@linux.intel.com, zhouchengming1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: set anon_vma of first rmap_item of ksm page to page's anon_vma other than vma's anon_vma
has been removed from the -mm tree.  Its filename was
     ksm-set-anon_vma-of-first-rmap_item-of-ksm-page-to-pages-anon_vma-other-than-vmas-anon_vma.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: z00281421 <z00281421@notesmail.huawei.com>
Subject: ksm: set anon_vma of first rmap_item of ksm page to page's anon_vma other than vma's anon_vma

Set anon_vma of first rmap_item of ksm page to page's anon_vma other than
vma's anon_vma so that we can lookup all the forked vma of kpage via
reserve map.  thus we can try_to_unmap ksm page completely and reclaim or
migrate the ksm page successfully and need not to merg other forked vma
addresses of ksm page with building a rmap_item for it ever after.

A forked more mapcount ksm page with partially merged vma addresses and a
ksm page mapped into non-VM_MERGEABLE vma due to setting MADV_MERGEABLE on
one of the forked vma can be unmapped completely by try_to_unmap.

Link: http://lkml.kernel.org/r/1466688834-127613-1-git-send-email-zhouxianrong@huawei.com
Signed-off-by: z00281421 <z00281421@notesmail.huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zhou Chengming <zhouchengming1@huawei.com>
Cc: Geliang Tang <geliangtang@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~ksm-set-anon_vma-of-first-rmap_item-of-ksm-page-to-pages-anon_vma-other-than-vmas-anon_vma mm/ksm.c
--- a/mm/ksm.c~ksm-set-anon_vma-of-first-rmap_item-of-ksm-page-to-pages-anon_vma-other-than-vmas-anon_vma
+++ a/mm/ksm.c
@@ -970,11 +970,13 @@ out:
  * @page: the PageAnon page that we want to replace with kpage
  * @kpage: the PageKsm page that we want to map instead of page,
  *         or NULL the first time when we want to use page as kpage.
+ * @anon_vma: output the anon_vma of page used as kpage
  *
  * This function returns 0 if the pages were merged, -EFAULT otherwise.
  */
 static int try_to_merge_one_page(struct vm_area_struct *vma,
-				 struct page *page, struct page *kpage)
+				 struct page *page, struct page *kpage,
+				 struct anon_vma **anon_vma)
 {
 	pte_t orig_pte = __pte(0);
 	int err = -EFAULT;
@@ -1014,6 +1016,8 @@ static int try_to_merge_one_page(struct
 			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
 			 * stable_tree_insert() will update stable_node.
 			 */
+			if (anon_vma != NULL)
+				*anon_vma = page_anon_vma(page);
 			set_page_stable_node(page, NULL);
 			mark_page_accessed(page);
 			/*
@@ -1054,6 +1058,7 @@ static int try_to_merge_with_ksm_page(st
 {
 	struct mm_struct *mm = rmap_item->mm;
 	struct vm_area_struct *vma;
+	struct anon_vma *anon_vma = NULL;
 	int err = -EFAULT;
 
 	down_read(&mm->mmap_sem);
@@ -1061,7 +1066,7 @@ static int try_to_merge_with_ksm_page(st
 	if (!vma)
 		goto out;
 
-	err = try_to_merge_one_page(vma, page, kpage);
+	err = try_to_merge_one_page(vma, page, kpage, &anon_vma);
 	if (err)
 		goto out;
 
@@ -1069,7 +1074,10 @@ static int try_to_merge_with_ksm_page(st
 	remove_rmap_item_from_tree(rmap_item);
 
 	/* Must get reference to anon_vma while still holding mmap_sem */
-	rmap_item->anon_vma = vma->anon_vma;
+	if (anon_vma != NULL)
+		rmap_item->anon_vma = anon_vma;
+	else
+		rmap_item->anon_vma = vma->anon_vma;
 	get_anon_vma(vma->anon_vma);
 out:
 	up_read(&mm->mmap_sem);
@@ -1434,6 +1442,11 @@ static void cmp_and_merge_page(struct pa
 
 	remove_rmap_item_from_tree(rmap_item);
 
+	if (kpage == page) {
+		put_page(kpage);
+		return;
+	}
+
 	if (kpage) {
 		err = try_to_merge_with_ksm_page(rmap_item, page, kpage);
 		if (!err) {
_

Patches currently in -mm which might be from z00281421@notesmail.huawei.com are


