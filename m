From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:04:25 -0700
Message-ID: <573f7bd9.klNbChhFLhY5tsXt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: is_vm_hugetlb_page() can return bool
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/hugetlb: is_vm_hugetlb_page() can return bool

Make is_vm_hugetlb_page() return bool to improve readability due to this
particular function only using either one or zero as its return value.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_inline.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/hugetlb_inline.h~mm-hugetlb-is_vm_hugetlb_page-can-be-boolean include/linux/hugetlb_inline.h
--- a/include/linux/hugetlb_inline.h~mm-hugetlb-is_vm_hugetlb_page-can-be-boolean
+++ a/include/linux/hugetlb_inline.h
@@ -5,16 +5,16 @@
 
 #include <linux/mm.h>
 
-static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
+static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
 	return !!(vma->vm_flags & VM_HUGETLB);
 }
 
 #else
 
-static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
+static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
-	return 0;
+	return false;
 }
 
 #endif
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are


