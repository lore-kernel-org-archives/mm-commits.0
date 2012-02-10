From: akpm@linux-foundation.org
Subject: + mm-introduce-pmd_to_pte_t.patch added to -mm tree
Date: Thu, 09 Feb 2012 16:28:10 -0800
Message-ID: <20120210002811.027D7A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36215 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BJA2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 19:28:11 -0500
Received: by mail-yw0-f74.google.com with SMTP id m50so265152yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 16:28:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: mm: introduce pmd_to_pte_t()
has been added to the -mm tree.  Its filename is
     mm-introduce-pmd_to_pte_t.patch

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
Subject: Subject: mm: introduce pmd_to_pte_t()

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
mm-introduce-pmd_to_pte_t.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

