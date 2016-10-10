From: akpm@linux-foundation.org
Subject: [merged] mm-fix-cache-mode-tracking-in-vm_insert_mixed.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:12 -0700
Message-ID: <57fc19f8.LreUudWF+3O7SDVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37021 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcJJWpP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, airlied@linux.ie, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix cache mode tracking in vm_insert_mixed()
has been removed from the -mm tree.  Its filename was
     mm-fix-cache-mode-tracking-in-vm_insert_mixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix cache mode tracking in vm_insert_mixed()

vm_insert_mixed() unlike vm_insert_pfn_prot() and vmf_insert_pfn_pmd(),
fails to check the pgprot_t it uses for the mapping against the one
recorded in the memtype tracking tree.  Add the missing call to
track_pfn_insert() to preclude cases where incompatible aliased mappings
are established for a given physical address range.

Link: http://lkml.kernel.org/r/147328717909.35069.14256589123570653697.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-fix-cache-mode-tracking-in-vm_insert_mixed mm/memory.c
--- a/mm/memory.c~mm-fix-cache-mode-tracking-in-vm_insert_mixed
+++ a/mm/memory.c
@@ -1649,10 +1649,14 @@ EXPORT_SYMBOL(vm_insert_pfn_prot);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn)
 {
+	pgprot_t pgprot = vma->vm_page_prot;
+
 	BUG_ON(!(vma->vm_flags & VM_MIXEDMAP));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
+	if (track_pfn_insert(vma, &pgprot, pfn))
+		return -EINVAL;
 
 	/*
 	 * If we don't have pte special, then we have to use the pfn_valid()
@@ -1670,9 +1674,9 @@ int vm_insert_mixed(struct vm_area_struc
 		 * result in pfn_t_has_page() == false.
 		 */
 		page = pfn_to_page(pfn_t_to_pfn(pfn));
-		return insert_page(vma, addr, page, vma->vm_page_prot);
+		return insert_page(vma, addr, page, pgprot);
 	}
-	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


