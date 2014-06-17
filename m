From: akpm@linux-foundation.org
Subject: + mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch added to -mm tree
Date: Tue, 17 Jun 2014 13:12:45 -0700
Message-ID: <53a0a13d.GEufTtCMLqmJPLG6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 16:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, kirill.shutemov@linux.intel.com, davej@redhat.com, aarcange@redhat.com, hughd@google.com


The patch titled
     Subject: mm: thp: fix DEBUG_PAGEALLOC oops in copy_page_rep()
has been added to the -mm tree.  Its filename is
     mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: thp: fix DEBUG_PAGEALLOC oops in copy_page_rep()

Trinity has for over a year been reporting a CONFIG_DEBUG_PAGEALLOC oops
in copy_page_rep() called from copy_user_huge_page() called from
do_huge_pmd_wp_page().

I believe this is a DEBUG_PAGEALLOC false positive, due to the source page
being split, and a tail page freed, while copy is in progress; and not a
problem without DEBUG_PAGEALLOC, since the pmd_same() check will prevent a
miscopy from being made visible.

Fix by adding get_user_huge_page() and put_user_huge_page(): reducing to
the usual get_page() and put_page() on head page in the usual config; but
get and put references to all of the tail pages when DEBUG_PAGEALLOC.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep
+++ a/mm/huge_memory.c
@@ -941,6 +941,33 @@ unlock:
 	spin_unlock(ptl);
 }
 
+/*
+ * Save CONFIG_DEBUG_PAGEALLOC from faulting falsely on tail pages
+ * during copy_user_huge_page()'s copy_page_rep(): in the case when
+ * the source page gets split and a tail freed before copy completes.
+ * Called under pmd_lock of checked pmd, so safe from splitting itself.
+ */
+static void get_user_huge_page(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
+		struct page *endpage = page + HPAGE_PMD_NR;
+		atomic_add(HPAGE_PMD_NR, &page->_count);
+		while (++page < endpage)
+			get_huge_page_tail(page);
+	} else
+		get_page(page);
+}
+
+static void put_user_huge_page(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
+		struct page *endpage = page + HPAGE_PMD_NR;
+		while (page < endpage)
+			put_page(page++);
+	} else
+		put_page(page);
+}
+
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -1074,7 +1101,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
-	get_page(page);
+	get_user_huge_page(page);
 	spin_unlock(ptl);
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
@@ -1095,7 +1122,7 @@ alloc:
 				split_huge_page(page);
 				ret |= VM_FAULT_FALLBACK;
 			}
-			put_page(page);
+			put_user_huge_page(page);
 		}
 		count_vm_event(THP_FAULT_FALLBACK);
 		goto out;
@@ -1105,7 +1132,7 @@ alloc:
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
-			put_page(page);
+			put_user_huge_page(page);
 		} else
 			split_huge_page_pmd(vma, address, pmd);
 		ret |= VM_FAULT_FALLBACK;
@@ -1127,7 +1154,7 @@ alloc:
 
 	spin_lock(ptl);
 	if (page)
-		put_page(page);
+		put_user_huge_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
 		spin_unlock(ptl);
 		mem_cgroup_uncharge_page(new_page);
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-zero_range-and-collapse_range-not-currently-supported.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

