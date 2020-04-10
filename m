From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-vm_insert_pages-2-fix.patch
 removed from -mm tree
Date: Fri, 10 Apr 2020 11:58:57 -0700
Message-ID: <20200410185857.58QMwIjEU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJS66 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 14:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com, willy@infradead.org


The patch titled
     Subject: mm: vm_insert_pages() checks if pte_index defined
has been removed from the -mm tree.  Its filename was
     mm-add-vm_insert_pages-2-fix.patch

This patch was dropped because it was folded into mm-add-vm_insert_pages.patch

------------------------------------------------------
From: Arjun Roy <arjunroy@google.com>
Subject: mm: vm_insert_pages() checks if pte_index defined.

pte_index() is either defined as a macro (e.g.  sparc64) or as an inlined
function (e.g.  x86).  vm_insert_pages() depends on pte_index but it is
not defined on all platforms (e.g.  m68k).

To fix compilation of vm_insert_pages() on architectures not providing
pte_index(), we perform the following fix:

0. For platforms where it is meaningful, and defined as a macro, no
   change is needed.
1. For platforms where it is meaningful and defined as an inlined
   function, and we want to use it with vm_insert_pages(), we define
   a degenerate macro of the form:  #define pte_index pte_index
2. vm_insert_pages() checks for the existence of a pte_index macro
   definition. If found, it implements a batched insert. If not found,
   it devolves to calling vm_insert_page() in a loop.

This patch implements step 2.

v3 of this patch fixes a compilation warning for an unused method.
v2 of this patch moved a macro definition to a more readable location.

Link: http://lkml.kernel.org/r/20200228054714.204424-2-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

--- a/mm/memory.c~mm-add-vm_insert_pages-2-fix
+++ a/mm/memory.c
@@ -1472,18 +1472,6 @@ static int insert_page_into_pte_locked(s
 	return 0;
 }
 
-static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
-			unsigned long addr, struct page *page, pgprot_t prot)
-{
-	int err;
-
-	if (!page_count(page))
-		return -EINVAL;
-	err = validate_page_before_insert(page);
-	return err ? err : insert_page_into_pte_locked(
-		mm, pte_offset_map(pmd, addr), addr, page, prot);
-}
-
 /*
  * This is the old fallback for page remapping.
  *
@@ -1512,8 +1500,21 @@ out:
 	return retval;
 }
 
+#ifdef pte_index
+static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, struct page *page, pgprot_t prot)
+{
+	int err;
+
+	if (!page_count(page))
+		return -EINVAL;
+	err = validate_page_before_insert(page);
+	return err ? err : insert_page_into_pte_locked(
+		mm, pte_offset_map(pmd, addr), addr, page, prot);
+}
+
 /* insert_pages() amortizes the cost of spinlock operations
- * when inserting pages in a loop.
+ * when inserting pages in a loop. Arch *must* define pte_index.
  */
 static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num, pgprot_t prot)
@@ -1568,6 +1569,7 @@ out:
 	*num = remaining_pages_total;
 	return ret;
 }
+#endif  /* ifdef pte_index */
 
 /**
  * vm_insert_pages - insert multiple pages into user vma, batching the pmd lock.
@@ -1587,6 +1589,7 @@ out:
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num)
 {
+#ifdef pte_index
 	const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
 
 	if (addr < vma->vm_start || end_addr >= vma->vm_end)
@@ -1598,6 +1601,18 @@ int vm_insert_pages(struct vm_area_struc
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
+#else
+	unsigned long idx = 0, pgcount = *num;
+	int err;
+
+	for (; idx < pgcount; ++idx) {
+		err = vm_insert_page(vma, addr + (PAGE_SIZE * idx), pages[idx]);
+		if (err)
+			break;
+	}
+	*num = pgcount - idx;
+	return err;
+#endif  /* ifdef pte_index */
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
_

Patches currently in -mm which might be from arjunroy@google.com are

mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch
mm-bring-sparc-pte_index-semantics-inline-with-other-platforms.patch
mm-define-pte_index-as-macro-for-x86.patch
mm-add-vm_insert_pages.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
