From: akpm@linux-foundation.org
Subject: + mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch added to -mm tree
Date: Mon, 28 Mar 2016 16:08:20 -0700
Message-ID: <56f9b964.iq3jRrlx1RJ2riUi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcC1XIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 19:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: is_vm_hugetlb_page() can return bool
has been added to the -mm tree.  Its filename is
     mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch
mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch
mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch
mm-mempolicy-vma_migratable-can-be-boolean.patch

