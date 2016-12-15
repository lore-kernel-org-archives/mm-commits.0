From: akpm@linux-foundation.org
Subject: [merged] mm-export-follow_pte.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:53 -0800
Message-ID: <5852e559.n8VJmWMqobVj8dsz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756409AbcLOSry (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export follow_pte()
has been removed from the -mm tree.  Its filename was
     mm-export-follow_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: export follow_pte()

DAX will need to implement its own version of page_check_address().  To
avoid duplicating page table walking code, export follow_pte() which does
what we need.

Link: http://lkml.kernel.org/r/1479460644-25076-18-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-export-follow_pte include/linux/mm.h
--- a/include/linux/mm.h~mm-export-follow_pte
+++ a/include/linux/mm.h
@@ -1210,6 +1210,8 @@ int copy_page_range(struct mm_struct *ds
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+int follow_pte(struct mm_struct *mm, unsigned long address, pte_t **ptepp,
+	       spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
diff -puN mm/memory.c~mm-export-follow_pte mm/memory.c
--- a/mm/memory.c~mm-export-follow_pte
+++ a/mm/memory.c
@@ -3817,8 +3817,8 @@ out:
 	return -EINVAL;
 }
 
-static inline int follow_pte(struct mm_struct *mm, unsigned long address,
-			     pte_t **ptepp, spinlock_t **ptlp)
+int follow_pte(struct mm_struct *mm, unsigned long address, pte_t **ptepp,
+	       spinlock_t **ptlp)
 {
 	int res;
 
_

Patches currently in -mm which might be from jack@suse.cz are


