From: akpm@linux-foundation.org
Subject: + hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:57:35 -0700
Message-ID: <200708272257.l7RMvZNX000414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbXH0W61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@gibson.dropbear.id.au, agl@us.ibm.com, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net


The patch titled
     hugepage: fix broken check for offset alignment in hugepage mappings
has been added to the -mm tree.  Its filename is
     hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugepage: fix broken check for offset alignment in hugepage mappings
From: David Gibson <david@gibson.dropbear.id.au>

For hugepage mappings, the file offset, like the address and size, needs to
be aligned to the size of a hugepage.

In commit 68589bc353037f233fe510ad9ff432338c95db66, the check for this was
moved into prepare_hugepage_range() along with the address and size checks.
 But since BenH's rework of the get_unmapped_area() paths leading up to
commit 4b1d89290b62bb2db476c94c82cf7442aab440c8, prepare_hugepage_range()
is only called for MAP_FIXED mappings, not for other mappings.  This means
we're no longer ever checking for an aligned offset - I've confirmed that
mmap() will (apparently) succeed with a misaligned offset on both powerpc
and i386 at least.

This patch restores the check, removing it from prepare_hugepage_range()
and putting it back into hugetlbfs_file_mmap().  I'm putting it there,
rather than in the get_unmapped_area() path so it only needs to go in one
place, than separately in the half-dozen or so arch-specific
implementations of hugetlb_get_unmapped_area().

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/hugetlbpage.c    |    2 +-
 arch/ia64/mm/hugetlbpage.c    |    6 ++----
 arch/sparc64/mm/hugetlbpage.c |    2 +-
 fs/hugetlbfs/inode.c          |   15 ++++++++++-----
 include/linux/hugetlb.h       |   10 +++-------
 5 files changed, 17 insertions(+), 18 deletions(-)

diff -puN arch/i386/mm/hugetlbpage.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings arch/i386/mm/hugetlbpage.c
--- a/arch/i386/mm/hugetlbpage.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings
+++ a/arch/i386/mm/hugetlbpage.c
@@ -367,7 +367,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}
diff -puN arch/ia64/mm/hugetlbpage.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -75,10 +75,8 @@ int huge_pmd_unshare(struct mm_struct *m
  * Don't actually need to do any preparation, but need to make sure
  * the address is in the right region.
  */
-int prepare_hugepage_range(unsigned long addr, unsigned long len, pgoff_t pgoff)
+int prepare_hugepage_range(unsigned long addr, unsigned long len)
 {
-	if (pgoff & (~HPAGE_MASK >> PAGE_SHIFT))
-		return -EINVAL;
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
 	if (addr & ~HPAGE_MASK)
@@ -151,7 +149,7 @@ unsigned long hugetlb_get_unmapped_area(
 
 	/* Handle MAP_FIXED */
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}
diff -puN arch/sparc64/mm/hugetlbpage.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings arch/sparc64/mm/hugetlbpage.c
--- a/arch/sparc64/mm/hugetlbpage.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings
+++ a/arch/sparc64/mm/hugetlbpage.c
@@ -175,7 +175,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}
diff -puN fs/hugetlbfs/inode.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings
+++ a/fs/hugetlbfs/inode.c
@@ -82,14 +82,19 @@ static int hugetlbfs_file_mmap(struct fi
 	int ret;
 
 	/*
-	 * vma alignment has already been checked by prepare_hugepage_range.
-	 * If you add any error returns here, do so after setting VM_HUGETLB,
-	 * so is_vm_hugetlb_page tests below unmap_region go the right way
-	 * when do_mmap_pgoff unwinds (may be important on powerpc and ia64).
+	 * vma address alignment (but not the pgoff alignment) has
+	 * already been checked by prepare_hugepage_range.  If you add
+	 * any error returns here, do so after setting VM_HUGETLB, so
+	 * is_vm_hugetlb_page tests below unmap_region go the right
+	 * way when do_mmap_pgoff unwinds (may be important on powerpc
+	 * and ia64).
 	 */
 	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
 	vma->vm_ops = &hugetlb_vm_ops;
 
+	if (vma->vm_pgoff & ~(HPAGE_MASK >> PAGE_SHIFT))
+		return -EINVAL;
+
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
 
 	mutex_lock(&inode->i_mutex);
@@ -132,7 +137,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}
diff -puN include/linux/hugetlb.h~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings
+++ a/include/linux/hugetlb.h
@@ -66,11 +66,8 @@ void hugetlb_free_pgd_range(struct mmu_g
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
-static inline int prepare_hugepage_range(unsigned long addr, unsigned long len,
-						pgoff_t pgoff)
+static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
 {
-	if (pgoff & (~HPAGE_MASK >> PAGE_SHIFT))
-		return -EINVAL;
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
 	if (addr & ~HPAGE_MASK)
@@ -78,8 +75,7 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 #else
-int prepare_hugepage_range(unsigned long addr, unsigned long len,
-						pgoff_t pgoff);
+int prepare_hugepage_range(unsigned long addr, unsigned long len);
 #endif
 
 #ifndef ARCH_HAS_SETCLEAR_HUGE_PTE
@@ -117,7 +113,7 @@ static inline unsigned long hugetlb_tota
 #define hugetlb_report_meminfo(buf)		0
 #define hugetlb_report_node_meminfo(n, buf)	0
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
-#define prepare_hugepage_range(addr,len,pgoff)	(-EINVAL)
+#define prepare_hugepage_range(addr,len)	(-EINVAL)
 #define pmd_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

origin.patch
hugepage-fix-broken-check-for-offset-alignment-in-hugepage-mappings.patch
git-powerpc.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
