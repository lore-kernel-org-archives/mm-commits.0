From: akpm@linux-foundation.org
Subject: [patch 06/28] mm: replace pud_write with pud_access_permitted in
 fault + gup paths
Date: Wed, 29 Nov 2017 16:10:14 -0800
Message-ID: <5a1f4c66.MkhEAo/+KMyo/UEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753359AbdK3AKQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:10:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.j.williams@intel.com, dave.hansen@intel.com, davem@davemloft.net, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, schwidefsky@de.ibm.com

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
