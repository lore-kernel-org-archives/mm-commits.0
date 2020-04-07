From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 036/166] userfaultfd: wp:
 userfaultfd_pte/huge_pmd_wp() helpers
Date: Mon, 06 Apr 2020 20:05:37 -0700
Message-ID: <20200407030537.t3i5M-fCj%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:05:39 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, torvalds@linux-foundation.org, xemul@openvz.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: wp: userfaultfd_pte/huge_pmd_wp() helpers

Implement helpers methods to invoke userfaultfd wp faults more
selectively: not only when a wp fault triggers on a vma with vma->vm_flags
VM_UFFD_WP set, but only if the _PAGE_UFFD_WP bit is set in the pagetable
too.

Link: http://lkml.kernel.org/r/20200220163112.11409-5-peterx@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
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

 include/linux/userfaultfd_k.h |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/include/linux/userfaultfd_k.h~userfaultfd-wp-userfaultfd_pte-huge_pmd_wp-helpers
+++ a/include/linux/userfaultfd_k.h
@@ -14,6 +14,8 @@
 #include <linux/userfaultfd.h> /* linux/include/uapi/linux/userfaultfd.h */
 
 #include <linux/fcntl.h>
+#include <linux/mm.h>
+#include <asm-generic/pgtable_uffd.h>
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -57,6 +59,18 @@ static inline bool userfaultfd_wp(struct
 	return vma->vm_flags & VM_UFFD_WP;
 }
 
+static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
+				      pte_t pte)
+{
+	return userfaultfd_wp(vma) && pte_uffd_wp(pte);
+}
+
+static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
+					   pmd_t pmd)
+{
+	return userfaultfd_wp(vma) && pmd_uffd_wp(pmd);
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP);
@@ -106,6 +120,19 @@ static inline bool userfaultfd_wp(struct
 	return false;
 }
 
+static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
+				      pte_t pte)
+{
+	return false;
+}
+
+static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
+					   pmd_t pmd)
+{
+	return false;
+}
+
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
_
