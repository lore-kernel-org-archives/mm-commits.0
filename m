From: akpm@linux-foundation.org
Subject: [failures] mm-introduce-pmd_to_pte_t.patch removed from -mm tree
Date: Wed, 15 Feb 2012 16:11:33 -0800
Message-ID: <20120216005440.3A2A820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38289 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2BPAyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 19:54:43 -0500
Received: by faaa19 with SMTP id a19so69381faa.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 16:54:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce pmd_to_pte_t()
has been removed from the -mm tree.  Its filename was
     mm-introduce-pmd_to_pte_t.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: introduce pmd_to_pte_t()

Casting pmd into pte_t to handle thp is strongly architecture dependent. 
This patch introduces a new function to separate this dependency from
independent part.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    5 +++++
 fs/proc/task_mmu.c             |    4 ++--
 include/asm-generic/pgtable.h  |    4 ++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-introduce-pmd_to_pte_t arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-introduce-pmd_to_pte_t
+++ a/arch/x86/include/asm/pgtable.h
@@ -165,6 +165,11 @@ static inline int has_transparent_hugepa
 {
 	return cpu_has_pse;
 }
+/* Caller must confirm that a given pmd points to a hugepage. */
+static inline pte_t pmd_to_pte_t(pmd_t *pmd)
+{
+	return *(pte_t *)pmd;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
diff -puN fs/proc/task_mmu.c~mm-introduce-pmd_to_pte_t fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-introduce-pmd_to_pte_t
+++ a/fs/proc/task_mmu.c
@@ -395,7 +395,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	spinlock_t *ptl;
 
 	if (pmd_trans_huge_lock(pmd, vma)) {
-		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
+		smaps_pte_entry(pmd_to_pte_t(pmd), addr, HPAGE_PMD_SIZE, walk);
 		spin_unlock(&walk->mm->page_table_lock);
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
 		return 0;
@@ -967,7 +967,7 @@ static int gather_pte_stats(pmd_t *pmd, 
 	md = walk->private;
 
 	if (pmd_trans_huge_lock(pmd, md->vma)) {
-		pte_t huge_pte = *(pte_t *)pmd;
+		pte_t huge_pte = pmd_to_pte_t(pmd);
 		struct page *page;
 
 		page = can_gather_numa_stats(huge_pte, md->vma, addr);
diff -puN include/asm-generic/pgtable.h~mm-introduce-pmd_to_pte_t include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-introduce-pmd_to_pte_t
+++ a/include/asm-generic/pgtable.h
@@ -434,6 +434,10 @@ static inline int pmd_trans_splitting(pm
 {
 	return 0;
 }
+static inline pte_t pmd_to_pte_t(pmd_t *pmd)
+{
+	return 0;
+}
 #ifndef __HAVE_ARCH_PMD_WRITE
 static inline int pmd_write(pmd_t pmd)
 {
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

