From: akpm@linux-foundation.org
Subject: [merged]
 mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:18:24 -0800
Message-ID: <20171130201824.6lPlpc7Bz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbdK3US1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:18:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@intel.com, jglisse@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace pte_write with pte_access_permitted in fault + gup paths
has been removed from the -mm tree.  Its filename was
     mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: replace pte_write with pte_access_permitted in fault + gup paths

The 'access_permitted' helper is used in the gup-fast path and goes beyond
the simple _PAGE_RW check to also:

* validate that the mapping is writable from a protection keys
  standpoint

* validate that the pte has _PAGE_USER set since all fault paths where
  pte_write is must be referencing user-memory.

Link: http://lkml.kernel.org/r/151043111604.2842.8051684481794973100.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c    |    2 +-
 mm/hmm.c    |    4 ++--
 mm/memory.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/gup.c~mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths mm/gup.c
--- a/mm/gup.c~mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths
+++ a/mm/gup.c
@@ -66,7 +66,7 @@ static int follow_pfn_pte(struct vm_area
  */
 static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
 {
-	return pte_write(pte) ||
+	return pte_access_permitted(pte, WRITE) ||
 		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
 }
 
diff -puN mm/hmm.c~mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths mm/hmm.c
--- a/mm/hmm.c~mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths
+++ a/mm/hmm.c
@@ -456,11 +456,11 @@ again:
 			continue;
 		}
 
-		if (write_fault && !pte_write(pte))
+		if (!pte_access_permitted(pte, write_fault))
 			goto fault;
 
 		pfns[i] = hmm_pfn_t_from_pfn(pte_pfn(pte)) | flag;
-		pfns[i] |= pte_write(pte) ? HMM_PFN_WRITE : 0;
+		pfns[i] |= pte_access_permitted(pte, WRITE) ? HMM_PFN_WRITE : 0;
 		continue;
 
 fault:
diff -puN mm/memory.c~mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths mm/memory.c
--- a/mm/memory.c~mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths
+++ a/mm/memory.c
@@ -3948,7 +3948,7 @@ static int handle_pte_fault(struct vm_fa
 	if (unlikely(!pte_same(*vmf->pte, entry)))
 		goto unlock;
 	if (vmf->flags & FAULT_FLAG_WRITE) {
-		if (!pte_write(entry))
+		if (!pte_access_permitted(entry, WRITE))
 			return do_wp_page(vmf);
 		entry = pte_mkdirty(entry);
 	}
@@ -4336,7 +4336,7 @@ int follow_phys(struct vm_area_struct *v
 		goto out;
 	pte = *ptep;
 
-	if ((flags & FOLL_WRITE) && !pte_write(pte))
+	if (!pte_access_permitted(pte, flags & FOLL_WRITE))
 		goto unlock;
 
 	*prot = pgprot_val(pte_pgprot(pte));
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


