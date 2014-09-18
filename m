From: akpm@linux-foundation.org
Subject: + mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch added
 to -mm tree
Date: Thu, 18 Sep 2014 16:02:05 -0700
Message-ID: <541b646d.5fYedIIV5Nbh2nzp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaIRXCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 19:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hughd@google.com, james.hogan@imgtec.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: take page table lock in follow_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: take page table lock in follow_huge_pmd()

We have a race condition between move_pages() and freeing hugepages, where
move_pages() calls follow_page(FOLL_GET) for hugepages internally and
tries to get its refcount without preventing concurrent freeing.  This
race crashes the kernel, so this patch fixes it by moving FOLL_GET code
for hugepages into follow_huge_pmd() with taking the page table lock.

This patch intentionally removes page==NULL check after pte_page.  This is
justified because pte_page() never returns NULL for any architectures or
configurations.

This patch changes the behavior of follow_huge_pmd() for tail pages and
then tail pages can be pinned/returned.  So the caller must be changed to
properly handle the returned tail pages.

We could have a choice to add the similar locking to
follow_huge_(addr|pud) for consistency, but it's not necessary because
currently these functions don't support FOLL_GET flag, so let's leave it
for future development.

Here is the reproducer:

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

Fixes: e632a938d914 ("mm: migrate: add hugepage migration code to move_pages()")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 ++++----
 mm/gup.c                |   25 ++++---------------------
 mm/hugetlb.c            |   30 +++++++++++++++++++-----------
 mm/migrate.c            |    3 ++-
 4 files changed, 29 insertions(+), 37 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd
+++ a/include/linux/hugetlb.h
@@ -99,9 +99,9 @@ int huge_pmd_unshare(struct mm_struct *m
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
 			      int write);
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-				pmd_t *pmd, int write);
+				pmd_t *pmd, int flags);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
-				pud_t *pud, int write);
+				pud_t *pud, int flags);
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pmd);
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
@@ -133,8 +133,8 @@ static inline void hugetlb_report_meminf
 static inline void hugetlb_show_meminfo(void)
 {
 }
-#define follow_huge_pmd(mm, addr, pmd, write)	NULL
-#define follow_huge_pud(mm, addr, pud, write)	NULL
+#define follow_huge_pmd(mm, addr, pmd, flags)	NULL
+#define follow_huge_pud(mm, addr, pud, flags)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
 #define pmd_huge(x)	0
 #define pud_huge(x)	0
diff -puN mm/gup.c~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd mm/gup.c
--- a/mm/gup.c~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd
+++ a/mm/gup.c
@@ -162,33 +162,16 @@ struct page *follow_page_mask(struct vm_
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud))
 		return no_page_table(vma, flags);
-	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
-		if (flags & FOLL_GET)
-			return NULL;
-		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
-		return page;
-	}
+	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB)
+		return follow_huge_pud(mm, address, pud, flags);
 	if (unlikely(pud_bad(*pud)))
 		return no_page_table(vma, flags);
 
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
+		return follow_huge_pmd(mm, address, pmd, flags);
 	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
 		return no_page_table(vma, flags);
 	if (pmd_trans_huge(*pmd)) {
diff -puN mm/hugetlb.c~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd
+++ a/mm/hugetlb.c
@@ -3668,26 +3668,34 @@ follow_huge_addr(struct mm_struct *mm, u
 
 struct page * __weak
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
+		pmd_t *pmd, int flags)
 {
-	struct page *page;
+	struct page *page = NULL;
+	spinlock_t *ptl;
 
-	page = pte_page(*(pte_t *)pmd);
-	if (page)
-		page += ((address & ~PMD_MASK) >> PAGE_SHIFT);
+	ptl = pmd_lockptr(mm, pmd);
+	spin_lock(ptl);
+
+	if (!pmd_huge(*pmd))
+		goto out;
+
+	page = pte_page(*(pte_t *)pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
+
+	if (flags & FOLL_GET)
+		get_page(page);
+out:
+	spin_unlock(ptl);
 	return page;
 }
 
 struct page * __weak
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
-		pud_t *pud, int write)
+		pud_t *pud, int flags)
 {
-	struct page *page;
+	if (flags & FOLL_GET)
+		return NULL;
 
-	page = pte_page(*(pte_t *)pud);
-	if (page)
-		page += ((address & ~PUD_MASK) >> PAGE_SHIFT);
-	return page;
+	return pte_page(*(pte_t *)pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
 }
 
 #ifdef CONFIG_MEMORY_FAILURE
diff -puN mm/migrate.c~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd mm/migrate.c
--- a/mm/migrate.c~mm-hugetlb-take-page-table-lock-in-follow_huge_pmd
+++ a/mm/migrate.c
@@ -1246,7 +1246,8 @@ static int do_move_page_to_node_array(st
 			goto put_and_set;
 
 		if (PageHuge(page)) {
-			isolate_huge_page(page, &pagelist);
+			if (PageHead(page))
+				isolate_huge_page(page, &pagelist);
 			goto put_and_set;
 		}
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

