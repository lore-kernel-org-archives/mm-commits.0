From: akpm@linux-foundation.org
Subject: [patch 049/117] mm/hugetlb: is_vm_hugetlb_page() can return bool
Date: Thu, 19 May 2016 17:11:23 -0700
Message-ID: <573e562b.QKK6WcYworWyFHJg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbcETALY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com

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
