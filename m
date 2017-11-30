From: akpm@linux-foundation.org
Subject: [merged]
 mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:18:18 -0800
Message-ID: <20171130201818.3nfWuC6UE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdK3USY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:18:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@intel.com, davem@davemloft.net, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, schwidefsky@de.ibm.com


The patch titled
     Subject: mm: replace pud_write with pud_access_permitted in fault + gup paths
has been removed from the -mm tree.  Its filename was
     mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: replace pud_write with pud_access_permitted in fault + gup paths

The 'access_permitted' helper is used in the gup-fast path and goes beyond
the simple _PAGE_RW check to also:

* validate that the mapping is writable from a protection keys
  standpoint

* validate that the pte has _PAGE_USER set since all fault paths where
  pud_write is must be referencing user-memory.

[dan.j.williams@intel.com: fix powerpc compile error]
  Link: http://lkml.kernel.org/r/151129127237.37405.16073414520854722485.stgit@dwillia2-desk3.amr.corp.intel.com
Link: http://lkml.kernel.org/r/151043110453.2842.2166049702068628177.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    6 ++++++
 arch/sparc/mm/gup.c             |    2 +-
 mm/huge_memory.c                |    2 +-
 mm/memory.c                     |    2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths
+++ a/arch/s390/include/asm/pgtable.h
@@ -1264,6 +1264,12 @@ static inline pud_t pud_mkwrite(pud_t pu
 	return pud;
 }
 
+#define pud_write pud_write
+static inline int pud_write(pud_t pud)
+{
+	return (pud_val(pud) & _REGION3_ENTRY_WRITE) != 0;
+}
+
 static inline pud_t pud_mkclean(pud_t pud)
 {
 	if (pud_large(pud)) {
diff -puN arch/sparc/mm/gup.c~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths
+++ a/arch/sparc/mm/gup.c
@@ -114,7 +114,7 @@ static int gup_huge_pud(pud_t *pudp, pud
 	if (!(pud_val(pud) & _PAGE_VALID))
 		return 0;
 
-	if (write && !pud_write(pud))
+	if (!pud_access_permitted(pud, write))
 		return 0;
 
 	refs = 0;
diff -puN mm/huge_memory.c~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths mm/huge_memory.c
--- a/mm/huge_memory.c~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths
+++ a/mm/huge_memory.c
@@ -1019,7 +1019,7 @@ struct page *follow_devmap_pud(struct vm
 
 	assert_spin_locked(pud_lockptr(mm, pud));
 
-	if (flags & FOLL_WRITE && !pud_write(*pud))
+	if (!pud_access_permitted(*pud, flags & FOLL_WRITE))
 		return NULL;
 
 	if (pud_present(*pud) && pud_devmap(*pud))
diff -puN mm/memory.c~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths mm/memory.c
--- a/mm/memory.c~mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths
+++ a/mm/memory.c
@@ -4013,7 +4013,7 @@ static int __handle_mm_fault(struct vm_a
 
 			/* NUMA case for anonymous PUDs would go here */
 
-			if (dirty && !pud_write(orig_pud)) {
+			if (dirty && !pud_access_permitted(orig_pud, WRITE)) {
 				ret = wp_huge_pud(&vmf, orig_pud);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


