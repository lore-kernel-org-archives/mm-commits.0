From: akpm@linux-foundation.org
Subject: + mm-mempolicy-vma_migratable-can-be-boolean.patch added to -mm
 tree
Date: Mon, 28 Mar 2016 16:08:26 -0700
Message-ID: <56f9b96a.XytVQACxl/mlLBfi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbcC1XI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 19:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: vma_migratable() can return bool
has been added to the -mm tree.  Its filename is
     mm-mempolicy-vma_migratable-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-vma_migratable-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-vma_migratable-can-be-boolean.patch

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

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch
mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch
mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch
mm-mempolicy-vma_migratable-can-be-boolean.patch

