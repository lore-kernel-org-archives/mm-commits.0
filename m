From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 18:57:57 -0700
Message-ID: <20200408015757.hdOERQlEW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgDHB57 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, xemul@openvz.org


The patch titled
     Subject: userfaultfd: wp: drop _PAGE_UFFD_WP properly when fork
has been removed from the -mm tree.  Its filename was
     userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd: wp: drop _PAGE_UFFD_WP properly when fork

UFFD_EVENT_FORK support for uffd-wp should be already there, except that
we should clean the uffd-wp bit if uffd fork event is not enabled.  Detect
that to avoid _PAGE_UFFD_WP being set even if the VMA is not being tracked
by VM_UFFD_WP.  Do this for both small PTEs and huge PMDs.

Link: http://lkml.kernel.org/r/20200220163112.11409-9-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++++++
 mm/memory.c      |    8 ++++++++
 2 files changed, 16 insertions(+)

--- a/mm/huge_memory.c~userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork
+++ a/mm/huge_memory.c
@@ -1044,6 +1044,14 @@ int copy_huge_pmd(struct mm_struct *dst_
 	ret = -EAGAIN;
 	pmd = *src_pmd;
 
+	/*
+	 * Make sure the _PAGE_UFFD_WP bit is cleared if the new VMA
+	 * does not have the VM_UFFD_WP, which means that the uffd
+	 * fork event is not enabled.
+	 */
+	if (!(vma->vm_flags & VM_UFFD_WP))
+		pmd = pmd_clear_uffd_wp(pmd);
+
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
--- a/mm/memory.c~userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork
+++ a/mm/memory.c
@@ -785,6 +785,14 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
+	/*
+	 * Make sure the _PAGE_UFFD_WP bit is cleared if the new VMA
+	 * does not have the VM_UFFD_WP, which means that the uffd
+	 * fork event is not enabled.
+	 */
+	if (!(vm_flags & VM_UFFD_WP))
+		pte = pte_clear_uffd_wp(pte);
+
 	page = vm_normal_page(vma, addr, pte);
 	if (page) {
 		get_page(page);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch
mm-gup-mark-lock-taken-only-after-a-successful-retake.patch
