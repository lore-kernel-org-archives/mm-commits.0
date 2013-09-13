From: akpm@linux-foundation.org
Subject: [merged] thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:58 -0700
Message-ID: <52336f72.02SL6Qe0l+XPDTzp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,viro@zeniv.linux.org.uk,willy@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:58 -0700


The patch titled
     Subject: thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()
has been removed from the -mm tree.  Its filename was
     thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()

It's confusing that mk_huge_pmd() has semantics different from mk_pte() or
mk_pmd().  I spent some time on debugging issue cased by this
inconsistency.

Let's move maybe_pmd_mkwrite() out of mk_huge_pmd() and adjust prototype
to match mk_pte().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd
+++ a/mm/huge_memory.c
@@ -690,11 +690,10 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 	return pmd;
 }
 
-static inline pmd_t mk_huge_pmd(struct page *page, struct vm_area_struct *vma)
+static inline pmd_t mk_huge_pmd(struct page *page, pgprot_t prot)
 {
 	pmd_t entry;
-	entry = mk_pmd(page, vma->vm_page_prot);
-	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	entry = mk_pmd(page, prot);
 	entry = pmd_mkhuge(entry);
 	return entry;
 }
@@ -727,7 +726,8 @@ static int __do_huge_pmd_anonymous_page(
 		pte_free(mm, pgtable);
 	} else {
 		pmd_t entry;
-		entry = mk_huge_pmd(page, vma);
+		entry = mk_huge_pmd(page, vma->vm_page_prot);
+		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		page_add_new_anon_rmap(page, vma, haddr);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -1210,7 +1210,8 @@ alloc:
 		goto out_mn;
 	} else {
 		pmd_t entry;
-		entry = mk_huge_pmd(new_page, vma);
+		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
+		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -2358,7 +2359,8 @@ static void collapse_huge_page(struct mm
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = mk_huge_pmd(new_page, vma);
+	_pmd = mk_huge_pmd(new_page, vma->vm_page_prot);
+	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
 	/*
 	 * spin_lock() below is not the equivalent of smp_wmb(), so
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-mm-locking-tail-page-is-a-bug.patch
thp-mm-locking-tail-page-is-a-bug-fix.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

