From: akpm@linux-foundation.org
Subject: + mm-hugetlbfs-fix-hugetlbfs-optimization.patch added to -mm tree
Date: Tue, 19 Nov 2013 15:14:34 -0800
Message-ID: <528bf0da.MCWsi4r/KZhfJaVx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3KSXOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: + mm-hugetlbfs-fix-hugetlbfs-optimization.patch added to -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:14:34 -0800


The patch titled
     Subject: mm: hugetlbfs: fix hugetlbfs optimization
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-fix-hugetlbfs-optimization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-fix-hugetlbfs-optimization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-fix-hugetlbfs-optimization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: hugetlbfs: fix hugetlbfs optimization

7cb2ef56e6a ("mm: fix aio performance regression for database caused by
THP") can cause dereference of a dangling pointer if split_huge_page runs
during PageHuge() if there are updates to the tail_page->private field.

Also it is repeating compound_head twice for hugetlbfs and it is running
compound_head+compound_trans_head for THP when a single one is needed in
both cases.

The new code within the PageSlab() check doesn't need to verify that the
THP page size is never bigger than the smallest hugetlbfs page size, to
avoid memory corruption.

A longstanding theoretical race condition was found while fixing the above
(see the change right after the skip_unlock label, that is relevant for
the compound_lock path too).

By re-establishing the _mapcount tail refcounting for all compound pages,
this also fixes the below problem:

echo 0 >/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

BUG: Bad page state in process bash  pfn:59a01
page:ffffea000139b038 count:0 mapcount:10 mapping:          (null) index:0x0
page flags: 0x1c00000000008000(tail)
Modules linked in:
CPU: 6 PID: 2018 Comm: bash Not tainted 3.12.0+ #25
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 0000000000000009 ffff880079cb5cc8 ffffffff81640e8b 0000000000000006
 ffffea000139b038 ffff880079cb5ce8 ffffffff8115bb15 00000000000002c1
 ffffea000139b038 ffff880079cb5d48 ffffffff8115bd83 ffff880079cb5de8
Call Trace:
 [<ffffffff81640e8b>] dump_stack+0x55/0x76
 [<ffffffff8115bb15>] bad_page+0xd5/0x130
 [<ffffffff8115bd83>] free_pages_prepare+0x213/0x280
 [<ffffffff8115df16>] __free_pages+0x36/0x80
 [<ffffffff8119b011>] update_and_free_page+0xc1/0xd0
 [<ffffffff8119b512>] free_pool_huge_page+0xc2/0xe0
 [<ffffffff8119b8cc>] set_max_huge_pages.part.58+0x14c/0x220
 [<ffffffff81308a8c>] ? _kstrtoull+0x2c/0x90
 [<ffffffff8119ba70>] nr_hugepages_store_common.isra.60+0xd0/0xf0
 [<ffffffff8119bac3>] nr_hugepages_store+0x13/0x20
 [<ffffffff812f763f>] kobj_attr_store+0xf/0x20
 [<ffffffff812354e9>] sysfs_write_file+0x189/0x1e0
 [<ffffffff811baff5>] vfs_write+0xc5/0x1f0
 [<ffffffff811bb505>] SyS_write+0x55/0xb0
 [<ffffffff81651712>] system_call_fastpath+0x16/0x1b

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +
 mm/hugetlb.c            |   17 ++++
 mm/swap.c               |  143 ++++++++++++++++++++++----------------
 3 files changed, 106 insertions(+), 60 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlbfs-fix-hugetlbfs-optimization include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-fix-hugetlbfs-optimization
+++ a/include/linux/hugetlb.h
@@ -31,6 +31,7 @@ struct hugepage_subpool *hugepage_new_su
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 int PageHuge(struct page *page);
+int PageHeadHuge(struct page *page_head);
 
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
@@ -102,6 +103,11 @@ static inline int PageHuge(struct page *
 {
 	return 0;
 }
+
+static inline int PageHeadHuge(struct page *page_head)
+{
+	return 0;
+}
 
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
diff -puN mm/hugetlb.c~mm-hugetlbfs-fix-hugetlbfs-optimization mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-fix-hugetlbfs-optimization
+++ a/mm/hugetlb.c
@@ -702,6 +702,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
+/*
+ * PageHeadHuge() only returns true for hugetlbfs head page, but not for
+ * normal or transparent huge pages.
+ */
+int PageHeadHuge(struct page *page_head)
+{
+	compound_page_dtor *dtor;
+
+	if (!PageHead(page_head))
+		return 0;
+
+	dtor = get_compound_page_dtor(page_head);
+
+	return dtor == free_huge_page;
+}
+EXPORT_SYMBOL_GPL(PageHeadHuge);
+
 pgoff_t __basepage_index(struct page *page)
 {
 	struct page *page_head = compound_head(page);
diff -puN mm/swap.c~mm-hugetlbfs-fix-hugetlbfs-optimization mm/swap.c
--- a/mm/swap.c~mm-hugetlbfs-fix-hugetlbfs-optimization
+++ a/mm/swap.c
@@ -82,19 +82,6 @@ static void __put_compound_page(struct p
 
 static void put_compound_page(struct page *page)
 {
-	/*
-	 * hugetlbfs pages cannot be split from under us.  If this is a
-	 * hugetlbfs page, check refcount on head page and release the page if
-	 * the refcount becomes zero.
-	 */
-	if (PageHuge(page)) {
-		page = compound_head(page);
-		if (put_page_testzero(page))
-			__put_compound_page(page);
-
-		return;
-	}
-
 	if (unlikely(PageTail(page))) {
 		/* __split_huge_page_refcount can run under us */
 		struct page *page_head = compound_trans_head(page);
@@ -111,14 +98,31 @@ static void put_compound_page(struct pag
 			 * still hot on arches that do not support
 			 * this_cpu_cmpxchg_double().
 			 */
-			if (PageSlab(page_head)) {
-				if (PageTail(page)) {
+			if (PageSlab(page_head) || PageHeadHuge(page_head)) {
+				if (likely(PageTail(page))) {
+					/*
+					 * __split_huge_page_refcount
+					 * cannot race here.
+					 */
+					VM_BUG_ON(!PageHead(page_head));
+					atomic_dec(&page->_mapcount);
 					if (put_page_testzero(page_head))
 						VM_BUG_ON(1);
-
-					atomic_dec(&page->_mapcount);
-					goto skip_lock_tail;
+					if (put_page_testzero(page_head))
+						__put_compound_page(page_head);
+					return;
 				} else
+					/*
+					 * __split_huge_page_refcount
+					 * run before us, "page" was a
+					 * THP tail. The split
+					 * page_head has been freed
+					 * and reallocated as slab or
+					 * hugetlbfs page of smaller
+					 * order (only possible if
+					 * reallocated as slab on
+					 * x86).
+					 */
 					goto skip_lock;
 			}
 			/*
@@ -132,8 +136,27 @@ static void put_compound_page(struct pag
 				/* __split_huge_page_refcount run before us */
 				compound_unlock_irqrestore(page_head, flags);
 skip_lock:
-				if (put_page_testzero(page_head))
-					__put_single_page(page_head);
+				if (put_page_testzero(page_head)) {
+					/*
+					 * The head page may have been
+					 * freed and reallocated as a
+					 * compound page of smaller
+					 * order and then freed again.
+					 * All we know is that it
+					 * cannot have become: a THP
+					 * page, a compound page of
+					 * higher order, a tail page.
+					 * That is because we still
+					 * hold the refcount of the
+					 * split THP tail and
+					 * page_head was the THP head
+					 * before the split.
+					 */
+					if (PageHead(page_head))
+						__put_compound_page(page_head);
+					else
+						__put_single_page(page_head);
+				}
 out_put_single:
 				if (put_page_testzero(page))
 					__put_single_page(page);
@@ -155,7 +178,6 @@ out_put_single:
 			VM_BUG_ON(atomic_read(&page->_count) != 0);
 			compound_unlock_irqrestore(page_head, flags);
 
-skip_lock_tail:
 			if (put_page_testzero(page_head)) {
 				if (PageHead(page_head))
 					__put_compound_page(page_head);
@@ -198,51 +220,52 @@ bool __get_page_tail(struct page *page)
 	 * proper PT lock that already serializes against
 	 * split_huge_page().
 	 */
+	unsigned long flags;
 	bool got = false;
-	struct page *page_head;
-
-	/*
-	 * If this is a hugetlbfs page it cannot be split under us.  Simply
-	 * increment refcount for the head page.
-	 */
-	if (PageHuge(page)) {
-		page_head = compound_head(page);
-		atomic_inc(&page_head->_count);
-		got = true;
-	} else {
-		unsigned long flags;
-
-		page_head = compound_trans_head(page);
-		if (likely(page != page_head &&
-					get_page_unless_zero(page_head))) {
-
-			/* Ref to put_compound_page() comment. */
-			if (PageSlab(page_head)) {
-				if (likely(PageTail(page))) {
-					__get_page_tail_foll(page, false);
-					return true;
-				} else {
-					put_page(page_head);
-					return false;
-				}
-			}
+	struct page *page_head = compound_trans_head(page);
 
-			/*
-			 * page_head wasn't a dangling pointer but it
-			 * may not be a head page anymore by the time
-			 * we obtain the lock. That is ok as long as it
-			 * can't be freed from under us.
-			 */
-			flags = compound_lock_irqsave(page_head);
-			/* here __split_huge_page_refcount won't run anymore */
+	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+		/* Ref to put_compound_page() comment. */
+		if (PageSlab(page_head) || PageHeadHuge(page_head)) {
 			if (likely(PageTail(page))) {
+				/*
+				 * This is a hugetlbfs page or a slab
+				 * page. __split_huge_page_refcount
+				 * cannot race here.
+				 */
+				VM_BUG_ON(!PageHead(page_head));
 				__get_page_tail_foll(page, false);
-				got = true;
-			}
-			compound_unlock_irqrestore(page_head, flags);
-			if (unlikely(!got))
+				return true;
+			} else {
+				/*
+				 * __split_huge_page_refcount run
+				 * before us, "page" was a THP
+				 * tail. The split page_head has been
+				 * freed and reallocated as slab or
+				 * hugetlbfs page of smaller order
+				 * (only possible if reallocated as
+				 * slab on x86).
+				 */
 				put_page(page_head);
+				return false;
+			}
+		}
+
+		/*
+		 * page_head wasn't a dangling pointer but it
+		 * may not be a head page anymore by the time
+		 * we obtain the lock. That is ok as long as it
+		 * can't be freed from under us.
+		 */
+		flags = compound_lock_irqsave(page_head);
+		/* here __split_huge_page_refcount won't run anymore */
+		if (likely(PageTail(page))) {
+			__get_page_tail_foll(page, false);
+			got = true;
 		}
+		compound_unlock_irqrestore(page_head, flags);
+		if (unlikely(!got))
+			put_page(page_head);
 	}
 	return got;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
mm-hugetlbfs-fix-hugetlbfs-optimization.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch

