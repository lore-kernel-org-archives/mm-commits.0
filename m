From: akpm@linux-foundation.org
Subject: - mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:47 -0700
Message-ID: <200810202033.m9KKXlIV010705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617AbYJTUe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     mm: hugetlb.c make functions static, use NULL rather than 0
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb.c make functions static, use NULL rather than 0
From: Harvey Harrison <harvey.harrison@gmail.com>

mm/hugetlb.c:265:17: warning: symbol 'resv_map_alloc' was not declared. Should it be static?
mm/hugetlb.c:277:6: warning: symbol 'resv_map_release' was not declared. Should it be static?
mm/hugetlb.c:292:9: warning: Using plain integer as NULL pointer
mm/hugetlb.c:1750:5: warning: symbol 'unmap_ref_private' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

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
@@ -1747,10 +1747,8 @@ void unmap_hugepage_range(struct vm_area
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-int unmap_ref_private(struct mm_struct *mm,
-					struct vm_area_struct *vma,
-					struct page *page,
-					unsigned long address)
+static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
+				struct page *page, unsigned long address)
 {
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

