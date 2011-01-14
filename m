From: akpm@linux-foundation.org
Subject: [merged] thp-ksm-on-thp.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:49 -0800
Message-ID: <201101142251.p0EMpdWk005537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1ANWvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     thp: KSM on THP
has been removed from the -mm tree.  Its filename was
     thp-ksm-on-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: KSM on THP
From: Andrea Arcangeli <aarcange@redhat.com>

This makes KSM full operational with THP pages.  Subpages are scanned
while the hugepage is still in place and delivering max cpu performance,
and only if there's a match and we're going to deduplicate memory, the
single hugepages with the subpage match is split.

There will be no false sharing between ksmd and khugepaged.  khugepaged
won't collapse 2m virtual regions with KSM pages inside.  ksmd also should
only split pages when the checksum matches and we're likely to split an
hugepage for some long living ksm page (usual ksm heuristic to avoid
sharing pages that get de-cowed).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   67 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 9 deletions(-)

diff -puN mm/ksm.c~thp-ksm-on-thp mm/ksm.c
--- a/mm/ksm.c~thp-ksm-on-thp
+++ a/mm/ksm.c
@@ -412,6 +412,29 @@ out:
 	up_read(&mm->mmap_sem);
 }
 
+static struct page *page_trans_compound_anon(struct page *page)
+{
+	if (PageTransCompound(page)) {
+		struct page *head;
+		head = compound_head(page);
+		/*
+		 * head may be a dangling pointer.
+		 * __split_huge_page_refcount clears PageTail
+		 * before overwriting first_page, so if
+		 * PageTail is still there it means the head
+		 * pointer isn't dangling.
+		 */
+		if (head != page) {
+			smp_rmb();
+			if (!PageTransCompound(page))
+				return NULL;
+		}
+		if (PageAnon(head))
+			return head;
+	}
+	return NULL;
+}
+
 static struct page *get_mergeable_page(struct rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -431,7 +454,7 @@ static struct page *get_mergeable_page(s
 	page = follow_page(vma, addr, FOLL_GET);
 	if (IS_ERR_OR_NULL(page))
 		goto out;
-	if (PageAnon(page) && !PageTransCompound(page)) {
+	if (PageAnon(page) || page_trans_compound_anon(page)) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	} else {
@@ -709,6 +732,7 @@ static int write_protect_page(struct vm_
 	if (addr == -EFAULT)
 		goto out;
 
+	BUG_ON(PageTransCompound(page));
 	ptep = page_check_address(page, mm, addr, &ptl, 0);
 	if (!ptep)
 		goto out;
@@ -784,6 +808,7 @@ static int replace_page(struct vm_area_s
 		goto out;
 
 	pmd = pmd_offset(pud, addr);
+	BUG_ON(pmd_trans_huge(*pmd));
 	if (!pmd_present(*pmd))
 		goto out;
 
@@ -811,6 +836,33 @@ out:
 	return err;
 }
 
+static int page_trans_compound_anon_split(struct page *page)
+{
+	int ret = 0;
+	struct page *transhuge_head = page_trans_compound_anon(page);
+	if (transhuge_head) {
+		/* Get the reference on the head to split it. */
+		if (get_page_unless_zero(transhuge_head)) {
+			/*
+			 * Recheck we got the reference while the head
+			 * was still anonymous.
+			 */
+			if (PageAnon(transhuge_head))
+				ret = split_huge_page(transhuge_head);
+			else
+				/*
+				 * Retry later if split_huge_page run
+				 * from under us.
+				 */
+				ret = 1;
+			put_page(transhuge_head);
+		} else
+			/* Retry later if split_huge_page run from under us. */
+			ret = 1;
+	}
+	return ret;
+}
+
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
@@ -831,6 +883,9 @@ static int try_to_merge_one_page(struct 
 
 	if (!(vma->vm_flags & VM_MERGEABLE))
 		goto out;
+	if (PageTransCompound(page) && page_trans_compound_anon_split(page))
+		goto out;
+	BUG_ON(PageTransCompound(page));
 	if (!PageAnon(page))
 		goto out;
 
@@ -1285,14 +1340,8 @@ next_mm:
 				cond_resched();
 				continue;
 			}
-			if (PageTransCompound(*page)) {
-				put_page(*page);
-				ksm_scan.address &= HPAGE_PMD_MASK;
-				ksm_scan.address += HPAGE_PMD_SIZE;
-				cond_resched();
-				continue;
-			}
-			if (PageAnon(*page)) {
+			if (PageAnon(*page) ||
+			    page_trans_compound_anon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
 				rmap_item = get_next_rmap_item(slot,
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

