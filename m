From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:04:29 -0700
Message-ID: <573f7bdd.zPSMtdqQ2msys+fk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcETVEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: is_vmalloc_addr() can return bool
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -447,14 +447,14 @@ unsigned long vmalloc_to_pfn(const void
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


