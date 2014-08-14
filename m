From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
 removed from -mm tree
Date: Thu, 14 Aug 2014 14:32:31 -0700
Message-ID: <53ed2aef.Swg2AnRRxHp/qxoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:42278 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaHNVcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:32:32 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so482030pde.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:32:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, cl@linux.com, hughd@google.com, mel@csn.ul.ie, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: take refcount under page table lock in follow_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: take refcount under page table lock in follow_huge_pmd()

We have a race condition between move_pages() and freeing hugepages, where
move_pages() calls follow_page(FOLL_GET) for hugepages internally and
tries to get its refcount without preventing concurrent freeing.  This
race crashes the kernel, so this patch fixes it by moving FOLL_GET code
for hugepages into follow_huge_pmd() with taking the page table lock.

This patch passes the following test. And libhugetlbfs test shows no
regression.

  $ cat movepages.c
  #include <stdio.h>
  #include <stdlib.h>
  #include <numaif.h>

  #define ADDR_INPUT      0x700000000000UL
  #define HPS             0x200000
  #define PS              0x1000

  int main(int argc, char *argv[]) {
          int i;
          int nr_hp = strtol(argv[1], NULL, 0);
          int nr_p  = nr_hp * HPS / PS;
          int ret;
          void **addrs;
          int *status;
          int *nodes;
          pid_t pid;

          pid = strtol(argv[2], NULL, 0);
          addrs  = malloc(sizeof(char *) * nr_p + 1);
          status = malloc(sizeof(char *) * nr_p + 1);
          nodes  = malloc(sizeof(char *) * nr_p + 1);

          while (1) {
                  for (i = 0; i < nr_p; i++) {
                          addrs[i] = (void *)ADDR_INPUT + i * PS;
                          nodes[i] = 1;
                          status[i] = 0;
                  }
                  ret = numa_move_pages(pid, nr_p, addrs, nodes, status,
                                        MPOL_MF_MOVE_ALL);
                  if (ret == -1)
                          err("move_pages");

                  for (i = 0; i < nr_p; i++) {
                          addrs[i] = (void *)ADDR_INPUT + i * PS;
                          nodes[i] = 0;
                          status[i] = 0;
                  }
                  ret = numa_move_pages(pid, nr_p, addrs, nodes, status,
                                        MPOL_MF_MOVE_ALL);
                  if (ret == -1)
                          err("move_pages");
          }
          return 0;
  }

  $ cat hugepage.c
  #include <stdio.h>
  #include <sys/mman.h>
  #include <string.h>

  #define ADDR_INPUT      0x700000000000UL
  #define HPS             0x200000

  int main(int argc, char *argv[]) {
          int nr_hp = strtol(argv[1], NULL, 0);
          char *p;

          while (1) {
                  p = mmap((void *)ADDR_INPUT, nr_hp * HPS, PROT_READ | PROT_WRITE,
                           MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
                  if (p != (void *)ADDR_INPUT) {
                          perror("mmap");
                          break;
                  }
                  memset(p, 0, nr_hp * HPS);
                  munmap(p, nr_hp * HPS);
          }
  }

  $ sysctl vm.nr_hugepages=40
  $ ./hugepage 10 &
  $ ./movepages 10 $(pgrep -f hugepage)

Note for stable inclusion:
  This patch fixes e632a938d914 ("mm: migrate: add hugepage migration code
  to move_pages()"), so is applicable to -stable kernels which includes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 mm/gup.c                |   17 ++---------------
 mm/hugetlb.c            |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 15 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd
+++ a/include/linux/hugetlb.h
@@ -102,6 +102,8 @@ struct page *follow_huge_pmd(struct mm_s
 				pmd_t *pmd, int write);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
 				pud_t *pud, int write);
+struct page *follow_huge_pmd_lock(struct vm_area_struct *vma,
+				unsigned long address, pmd_t *pmd, int flags);
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pmd);
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
@@ -135,6 +137,7 @@ static inline void hugetlb_show_meminfo(
 }
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
 #define follow_huge_pud(mm, addr, pud, write)	NULL
+#define follow_huge_pmd_lock(vma, addr, pmd, flags)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
 #define pmd_huge(x)	0
 #define pud_huge(x)	0
diff -puN mm/gup.c~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd mm/gup.c
--- a/mm/gup.c~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd
+++ a/mm/gup.c
@@ -174,21 +174,8 @@ struct page *follow_page_mask(struct vm_
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		return no_page_table(vma, flags);
-	if (pmd_huge(*pmd) && vma->vm_flags & VM_HUGETLB) {
-		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
-		if (flags & FOLL_GET) {
-			/*
-			 * Refcount on tail pages are not well-defined and
-			 * shouldn't be taken. The caller should handle a NULL
-			 * return when trying to follow tail pages.
-			 */
-			if (PageHead(page))
-				get_page(page);
-			else
-				page = NULL;
-		}
-		return page;
-	}
+	if (pmd_huge(*pmd) && vma->vm_flags & VM_HUGETLB)
+		return follow_huge_pmd_lock(vma, address, pmd, flags);
 	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
 		return no_page_table(vma, flags);
 	if (pmd_trans_huge(*pmd)) {
diff -puN mm/hugetlb.c~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd
+++ a/mm/hugetlb.c
@@ -3690,6 +3690,41 @@ follow_huge_pud(struct mm_struct *mm, un
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
+/*
+ * This function calls the architecture dependent variant follow_huge_pmd()
+ * with holding page table lock depending on FOLL_GET.
+ * Whether hugepage migration is supported or not, follow() can be called
+ * with FOLL_GET from do_move_page_to_node_array(), so we need do this in
+ * common code.
+ * Should be called under read mmap_sem.
+ */
+struct page *follow_huge_pmd_lock(struct vm_area_struct *vma,
+				unsigned long address, pmd_t *pmd, int flags)
+{
+	struct page *page;
+	spinlock_t *ptl;
+
+	if (flags & FOLL_GET)
+		ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, (pte_t *)pmd);
+
+	page = follow_huge_pmd(vma->vm_mm, address, pmd, flags & FOLL_WRITE);
+
+	if (flags & FOLL_GET) {
+		/*
+		 * Refcount on tail pages are not well-defined and
+		 * shouldn't be taken. The caller should handle a NULL
+		 * return when trying to follow tail pages.
+		 */
+		if (PageHead(page))
+			get_page(page);
+		else
+			page = NULL;
+		spin_unlock(ptl);
+	}
+
+	return page;
+}
+
 #ifdef CONFIG_MEMORY_FAILURE
 
 /* Should be called in hugetlb_lock */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

