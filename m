From: akpm@linux-foundation.org
Subject: [merged] mm-fix-pfn_t-to-page-conversion-in-vm_insert_mixed.patch removed from -mm tree
Date: Tue, 02 Feb 2016 12:28:33 -0800
Message-ID: <56b11171.BO7CAoBK8mhIV8nj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbcBBU2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 15:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, airlied@linux.ie, dave@sr71.net, runaway@candw.ms, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix pfn_t to page conversion in vm_insert_mixed
has been removed from the -mm tree.  Its filename was
     mm-fix-pfn_t-to-page-conversion-in-vm_insert_mixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix pfn_t to page conversion in vm_insert_mixed

pfn_t_to_page() honors the flags in the pfn_t value to determine if a pfn
is backed by a page.  However, vm_insert_mixed() was originally written to
use pfn_valid() to make this determination.  To restore the old/correct
behavior, ignore the pfn_t flags in the !pfn_t_devmap() case and fallback
to trusting pfn_valid().

Fixes: 01c8f1c44b83 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Julian Margetson <runaway@candw.ms>
Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-fix-pfn_t-to-page-conversion-in-vm_insert_mixed mm/memory.c
--- a/mm/memory.c~mm-fix-pfn_t-to-page-conversion-in-vm_insert_mixed
+++ a/mm/memory.c
@@ -1591,10 +1591,15 @@ int vm_insert_mixed(struct vm_area_struc
 	 * than insert_pfn).  If a zero_pfn were inserted into a VM_MIXEDMAP
 	 * without pte special, it would there be refcounted as a normal page.
 	 */
-	if (!HAVE_PTE_SPECIAL && pfn_t_valid(pfn)) {
+	if (!HAVE_PTE_SPECIAL && !pfn_t_devmap(pfn) && pfn_t_valid(pfn)) {
 		struct page *page;
 
-		page = pfn_t_to_page(pfn);
+		/*
+		 * At this point we are committed to insert_page()
+		 * regardless of whether the caller specified flags that
+		 * result in pfn_t_has_page() == false.
+		 */
+		page = pfn_to_page(pfn_t_to_pfn(pfn));
 		return insert_page(vma, addr, page, vma->vm_page_prot);
 	}
 	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


