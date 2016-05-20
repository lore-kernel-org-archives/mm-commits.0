From: akpm@linux-foundation.org
Subject: [patch 052/117] mm/mempolicy.c: vma_migratable() can return bool
Date: Thu, 19 May 2016 17:11:32 -0700
Message-ID: <573e5634.Y/SS3tjt5tMuUtsa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETALd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com

From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/mempolicy.c: vma_migratable() can return bool

Make vma_migratable() return bool due to this particular function only
using either one or zero as its return value.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-vma_migratable-can-be-boolean include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-vma_migratable-can-be-boolean
+++ a/include/linux/mempolicy.h
@@ -172,14 +172,14 @@ extern int mpol_parse_str(char *str, str
 extern void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
 
 /* Check if a vma is migratable */
-static inline int vma_migratable(struct vm_area_struct *vma)
+static inline bool vma_migratable(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
-		return 0;
+		return false;
 
 #ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	if (vma->vm_flags & VM_HUGETLB)
-		return 0;
+		return false;
 #endif
 
 	/*
@@ -190,8 +190,8 @@ static inline int vma_migratable(struct
 	if (vma->vm_file &&
 		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
 								< policy_zone)
-			return 0;
-	return 1;
+			return false;
+	return true;
 }
 
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
_
