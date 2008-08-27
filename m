From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch added to -mm tree
Date: Wed, 27 Aug 2008 13:21:24 -0700
Message-ID: <200808272021.m7RKLOWK020382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbYH0UV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 16:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     mm: hugetlb.c make functions static, use NULL rather than 0
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb.c make functions static, use NULL rather than 0
From: Harvey Harrison <harvey.harrison@gmail.com>

mm/hugetlb.c:265:17: warning: symbol 'resv_map_alloc' was not declared. Should it be static?
mm/hugetlb.c:277:6: warning: symbol 'resv_map_release' was not declared. Should it be static?
mm/hugetlb.c:292:9: warning: Using plain integer as NULL pointer
mm/hugetlb.c:1750:5: warning: symbol 'unmap_ref_private' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-make-functions-static-use-null-rather-than-0 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-make-functions-static-use-null-rather-than-0
+++ a/mm/hugetlb.c
@@ -262,7 +262,7 @@ struct resv_map {
 	struct list_head regions;
 };
 
-struct resv_map *resv_map_alloc(void)
+static struct resv_map *resv_map_alloc(void)
 {
 	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
 	if (!resv_map)
@@ -274,7 +274,7 @@ struct resv_map *resv_map_alloc(void)
 	return resv_map;
 }
 
-void resv_map_release(struct kref *ref)
+static void resv_map_release(struct kref *ref)
 {
 	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
 
@@ -289,7 +289,7 @@ static struct resv_map *vma_resv_map(str
 	if (!(vma->vm_flags & VM_SHARED))
 		return (struct resv_map *)(get_vma_private_data(vma) &
 							~HPAGE_RESV_MASK);
-	return 0;
+	return NULL;
 }
 
 static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
@@ -1747,7 +1747,7 @@ void unmap_hugepage_range(struct vm_area
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-int unmap_ref_private(struct mm_struct *mm,
+static int unmap_ref_private(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					struct page *page,
 					unsigned long address)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

