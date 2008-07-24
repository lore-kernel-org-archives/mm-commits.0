From: akpm@linux-foundation.org
Subject: - vma-page-offset-has-no-callees-drop-it.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:40 -0700
Message-ID: <200807242322.m6ONMeNU010581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554AbYGXX2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, agl@us.ibm.com, ak@suse.de, apw@shadowen.org, hugh@veritas.com, nacc@us.ibm.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     vma_page_offset() has no callees: drop it
has been removed from the -mm tree.  Its filename was
     vma-page-offset-has-no-callees-drop-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vma_page_offset() has no callees: drop it
From: Johannes Weiner <hannes@saeurebad.de>

Hugh adds: vma_pagecache_offset() has a dangerously misleading name, since
it's using hugepage units: rename it to vma_hugecache_offset().

[apw@shadowen.org: restack onto fixed MAP_PRIVATE reservations]
[akpm@linux-foundation.org: vma_split conversion]
Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff -puN mm/hugetlb.c~vma-page-offset-has-no-callees-drop-it mm/hugetlb.c
--- a/mm/hugetlb.c~vma-page-offset-has-no-callees-drop-it
+++ a/mm/hugetlb.c
@@ -201,20 +201,9 @@ static long region_count(struct list_hea
 
 /*
  * Convert the address within this vma to the page offset within
- * the mapping, in base page units.
- */
-static pgoff_t vma_page_offset(struct vm_area_struct *vma,
-				unsigned long address)
-{
-	return ((address - vma->vm_start) >> PAGE_SHIFT) +
-					(vma->vm_pgoff >> PAGE_SHIFT);
-}
-
-/*
- * Convert the address within this vma to the page offset within
  * the mapping, in pagecache page units; huge pages here.
  */
-static pgoff_t vma_pagecache_offset(struct vm_area_struct *vma,
+static pgoff_t vma_hugecache_offset(struct vm_area_struct *vma,
 					unsigned long address)
 {
 	return ((address - vma->vm_start) >> HPAGE_SHIFT) +
@@ -806,7 +795,7 @@ static int vma_needs_reservation(struct 
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -815,7 +804,7 @@ static int vma_needs_reservation(struct 
 
 	} else  {
 		int err;
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		err = region_chg(&reservations->regions, idx, idx + 1);
@@ -831,11 +820,11 @@ static void vma_commit_reservation(struc
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
@@ -1153,8 +1142,8 @@ static void hugetlb_vm_op_close(struct v
 	unsigned long end;
 
 	if (reservations) {
-		start = vma_pagecache_offset(vma, vma->vm_start);
-		end = vma_pagecache_offset(vma, vma->vm_end);
+		start = vma_hugecache_offset(vma, vma->vm_start);
+		end = vma_hugecache_offset(vma, vma->vm_end);
 
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
@@ -1471,7 +1460,7 @@ static struct page *hugetlbfs_pagecache_
 	pgoff_t idx;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(vma, address);
+	idx = vma_hugecache_offset(vma, address);
 
 	return find_lock_page(mapping, idx);
 }
@@ -1499,7 +1488,7 @@ static int hugetlb_no_page(struct mm_str
 	}
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(vma, address);
+	idx = vma_hugecache_offset(vma, address);
 
 	/*
 	 * Use page lock to guard against racing truncation
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

