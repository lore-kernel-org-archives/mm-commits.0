From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 034/166] userfaultfd: wp: hook userfault handler
 to write protection fault
Date: Mon, 06 Apr 2020 20:05:29 -0700
Message-ID: <20200407030529.LNaWlZqz4%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:05:33 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, torvalds@linux-foundation.org, xemul@openvz.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: wp: hook userfault handler to write protection fault

There are several cases write protection fault happens.  It could be a
write to zero page, swaped page or userfault write protected page.  When
the fault happens, there is no way to know if userfault write protect the
page before.  Here we just blindly issue a userfault notification for vma
with VM_UFFD_WP regardless if app write protects it yet.  Application
should be ready to handle such wp fault.

In the swapin case, always swapin as readonly.  This will cause false
positive userfaults.  We need to decide later if to eliminate them with a
flag like soft-dirty in the swap entry (see _PAGE_SWP_SOFT_DIRTY).

hugetlbfs wouldn't need to worry about swapouts but and tmpfs would be
handled by a swap entry bit like anonymous memory.

The main problem with no easy solution to eliminate the false positives,
will be if/when userfaultfd is extended to real filesystem pagecache. 
When the pagecache is freed by reclaim we can't leave the radix tree
pinned if the inode and in turn the radix tree is reclaimed as well.

The estimation is that full accuracy and lack of false positives could be
easily provided only to anonymous memory (as long as there's no fork or as
long as MADV_DONTFORK is used on the userfaultfd anonymous range) tmpfs
and hugetlbfs, it's most certainly worth to achieve it but in a later
incremental patch.

[peterx@redhat.com: don't conditionally drop FAULT_FLAG_WRITE in do_swap_page]
Link: http://lkml.kernel.org/r/20200220163112.11409-3-peterx@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/memory.c~userfaultfd-wp-hook-userfault-handler-to-write-protection-fault
+++ a/mm/memory.c
@@ -2752,6 +2752,11 @@ static vm_fault_t do_wp_page(struct vm_f
 {
 	struct vm_area_struct *vma = vmf->vma;
 
+	if (userfaultfd_wp(vma)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return handle_userfault(vmf, VM_UFFD_WP);
+	}
+
 	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
 	if (!vmf->page) {
 		/*
@@ -3948,8 +3953,11 @@ static inline vm_fault_t create_huge_pmd
 /* `inline' is required to avoid gcc 4.1.2 build error */
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
 {
-	if (vma_is_anonymous(vmf->vma))
+	if (vma_is_anonymous(vmf->vma)) {
+		if (userfaultfd_wp(vmf->vma))
+			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
+	}
 	if (vmf->vma->vm_ops->huge_fault) {
 		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 
_
