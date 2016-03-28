From: akpm@linux-foundation.org
Subject: + mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch added to -mm
 tree
Date: Mon, 28 Mar 2016 16:08:24 -0700
Message-ID: <56f9b968.suGdsjeBeoSl/jCE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcC1XIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 19:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: is_vmalloc_addr() can return bool
has been added to the -mm tree.  Its filename is
     mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch

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
Subject: mm/vmalloc.c: is_vmalloc_addr() can return bool

Make is_vmalloc_addr() return bool to improve readability due to this
particular function only using either one or zero as its return value.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-vmalloc-is_vmalloc_addr-can-be-boolean include/linux/mm.h
--- a/include/linux/mm.h~mm-vmalloc-is_vmalloc_addr-can-be-boolean
+++ a/include/linux/mm.h
@@ -443,14 +443,14 @@ unsigned long vmalloc_to_pfn(const void
  * On nommu, vmalloc/vfree wrap through kmalloc/kfree directly, so there
  * is no special casing required.
  */
-static inline int is_vmalloc_addr(const void *x)
+static inline bool is_vmalloc_addr(const void *x)
 {
 #ifdef CONFIG_MMU
 	unsigned long addr = (unsigned long)x;
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 #else
-	return 0;
+	return false;
 #endif
 }
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch
mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch
mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch
mm-mempolicy-vma_migratable-can-be-boolean.patch

