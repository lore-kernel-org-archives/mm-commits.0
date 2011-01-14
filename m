From: akpm@linux-foundation.org
Subject: [merged] thp-add-compound_trans_head-helper.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:51 -0800
Message-ID: <201101142251.p0EMpfmm005540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1ANWvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, avi@redhat.com, hughd@google.com, jweiner@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add compound_trans_head() helper
has been removed from the -mm tree.  Its filename was
     thp-add-compound_trans_head-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add compound_trans_head() helper
From: Andrea Arcangeli <aarcange@redhat.com>

Cleanup some code with common compound_trans_head helper.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   18 ++++++++++++++++++
 mm/ksm.c                |   15 +++------------
 virt/kvm/kvm_main.c     |   38 ++++++++++++++------------------------
 3 files changed, 35 insertions(+), 36 deletions(-)

diff -puN include/linux/huge_mm.h~thp-add-compound_trans_head-helper include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-add-compound_trans_head-helper
+++ a/include/linux/huge_mm.h
@@ -126,6 +126,23 @@ static inline int hpage_nr_pages(struct 
 		return HPAGE_PMD_NR;
 	return 1;
 }
+static inline struct page *compound_trans_head(struct page *page)
+{
+	if (PageTail(page)) {
+		struct page *head;
+		head = page->first_page;
+		smp_rmb();
+		/*
+		 * head may be a dangling pointer.
+		 * __split_huge_page_refcount clears PageTail before
+		 * overwriting first_page, so if PageTail is still
+		 * there it means the head pointer isn't dangling.
+		 */
+		if (PageTail(page))
+			return head;
+	}
+	return page;
+}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUG(); 0; })
@@ -144,6 +161,7 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
+#define compound_trans_head(page) compound_head(page)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
diff -puN mm/ksm.c~thp-add-compound_trans_head-helper mm/ksm.c
--- a/mm/ksm.c~thp-add-compound_trans_head-helper
+++ a/mm/ksm.c
@@ -415,20 +415,11 @@ out:
 static struct page *page_trans_compound_anon(struct page *page)
 {
 	if (PageTransCompound(page)) {
-		struct page *head;
-		head = compound_head(page);
+		struct page *head = compound_trans_head(page);
 		/*
-		 * head may be a dangling pointer.
-		 * __split_huge_page_refcount clears PageTail
-		 * before overwriting first_page, so if
-		 * PageTail is still there it means the head
-		 * pointer isn't dangling.
+		 * head may actually be splitted and freed from under
+		 * us but it's ok here.
 		 */
-		if (head != page) {
-			smp_rmb();
-			if (!PageTransCompound(page))
-				return NULL;
-		}
 		if (PageAnon(head))
 			return head;
 	}
diff -puN virt/kvm/kvm_main.c~thp-add-compound_trans_head-helper virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~thp-add-compound_trans_head-helper
+++ a/virt/kvm/kvm_main.c
@@ -104,34 +104,24 @@ static pfn_t fault_pfn;
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
 	if (pfn_valid(pfn)) {
-		struct page *head;
+		int reserved;
 		struct page *tail = pfn_to_page(pfn);
-		head = compound_head(tail);
+		struct page *head = compound_trans_head(tail);
+		reserved = PageReserved(head);
 		if (head != tail) {
-			smp_rmb();
 			/*
-			 * head may be a dangling pointer.
-			 * __split_huge_page_refcount clears PageTail
-			 * before overwriting first_page, so if
-			 * PageTail is still there it means the head
-			 * pointer isn't dangling.
+			 * "head" is not a dangling pointer
+			 * (compound_trans_head takes care of that)
+			 * but the hugepage may have been splitted
+			 * from under us (and we may not hold a
+			 * reference count on the head page so it can
+			 * be reused before we run PageReferenced), so
+			 * we've to check PageTail before returning
+			 * what we just read.
 			 */
-			if (PageTail(tail)) {
-				/*
-				 * the "head" is not a dangling
-				 * pointer but the hugepage may have
-				 * been splitted from under us (and we
-				 * may not hold a reference count on
-				 * the head page so it can be reused
-				 * before we run PageReferenced), so
-				 * we've to recheck PageTail before
-				 * returning what we just read.
-				 */
-				int reserved = PageReserved(head);
-				smp_rmb();
-				if (PageTail(tail))
-					return reserved;
-			}
+			smp_rmb();
+			if (PageTail(tail))
+				return reserved;
 		}
 		return PageReserved(tail);
 	}
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

