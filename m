From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-vm_ops-map_pages-fix.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:03:13 -0700
Message-ID: <534320a1.zFjiL95HDk4JIXcw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbaDGWDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, kirill@shutemov.name

Subject: [folded-merged] mm-introduce-vm_ops-map_pages-fix.patch removed from -mm tree
To: kirill@shutemov.name,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:03:13 -0700


The patch titled
     Subject: mm: documentaton for do_set_pte()
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_ops-map_pages-fix.patch

This patch was dropped because it was folded into mm-introduce-vm_ops-map_pages.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm: documentaton for do_set_pte()

do_set_pte() now exported to other compilation unit. Let's document
interface.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-introduce-vm_ops-map_pages-fix mm/memory.c
--- a/mm/memory.c~mm-introduce-vm_ops-map_pages-fix
+++ a/mm/memory.c
@@ -3318,7 +3318,21 @@ static int __do_fault(struct vm_area_str
 	return ret;
 }
 
-
+/**
+ * do_set_pte - setup new PTE entry for given page and add reverse page mapping.
+ *
+ * @vma: virtual memory area
+ * @address: user virtual address
+ * @page: page to map
+ * @pte: pointer to target page table entry
+ * @write: true, if new entry is writable
+ * @anon: true, if it's anonymous page
+ *
+ * Caller must hold page table lock relevant for @pte.
+ *
+ * Target users are page handler itself and implementations of
+ * vm_ops->map_pages.
+ */
 void do_set_pte(struct vm_area_struct *vma, unsigned long address,
 		struct page *page, pte_t *pte, bool write, bool anon)
 {
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-shmem-tmpfs.patch

