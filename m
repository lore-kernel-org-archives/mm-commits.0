From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 041/166] userfaultfd: wp: add pmd_swp_*uffd_wp()
 helpers
Date: Mon, 06 Apr 2020 20:05:57 -0700
Message-ID: <20200407030557.6WWJg0G2K%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgDGDF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:05:59 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, torvalds@linux-foundation.org, xemul@openvz.org

From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd: wp: add pmd_swp_*uffd_wp() helpers

Adding these missing helpers for uffd-wp operations with pmd
swap/migration entries.

Link: http://lkml.kernel.org/r/20200220163112.11409-10-peterx@redhat.com
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

 arch/x86/include/asm/pgtable.h     |   15 +++++++++++++++
 include/asm-generic/pgtable_uffd.h |   15 +++++++++++++++
 2 files changed, 30 insertions(+)

--- a/arch/x86/include/asm/pgtable.h~userfaultfd-wp-add-pmd_swp_uffd_wp-helpers
+++ a/arch/x86/include/asm/pgtable.h
@@ -1424,6 +1424,21 @@ static inline pte_t pte_swp_clear_uffd_w
 {
 	return pte_clear_flags(pte, _PAGE_SWP_UFFD_WP);
 }
+
+static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SWP_UFFD_WP);
+}
+
+static inline int pmd_swp_uffd_wp(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SWP_UFFD_WP;
+}
+
+static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_SWP_UFFD_WP);
+}
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 #define PKRU_AD_BIT 0x1
--- a/include/asm-generic/pgtable_uffd.h~userfaultfd-wp-add-pmd_swp_uffd_wp-helpers
+++ a/include/asm-generic/pgtable_uffd.h
@@ -46,6 +46,21 @@ static __always_inline pte_t pte_swp_cle
 {
 	return pte;
 }
+
+static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline int pmd_swp_uffd_wp(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
+{
+	return pmd;
+}
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 #endif /* _ASM_GENERIC_PGTABLE_UFFD_H */
_
