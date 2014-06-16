From: akpm@linux-foundation.org
Subject: [nacked]
 arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch removed
 from -mm tree
Date: Mon, 16 Jun 2014 16:32:40 -0700
Message-ID: <539f7e98.2+JuevRrQxPkFI0H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaFPXcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: arch/powerpc/mm/subpage-prot.c: cleanup subpage_walk_pmd_entry()
has been removed from the -mm tree.  Its filename was
     arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: arch/powerpc/mm/subpage-prot.c: cleanup subpage_walk_pmd_entry()

Currently subpage_mark_vma_nohuge() uses page table walker to find thps
and then split them.  But this can be done by page table walker itself, so
let's rewrite it in more suitable way.  No functional change.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/subpage-prot.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/mm/subpage-prot.c~arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry arch/powerpc/mm/subpage-prot.c
--- a/arch/powerpc/mm/subpage-prot.c~arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry
+++ a/arch/powerpc/mm/subpage-prot.c
@@ -131,11 +131,10 @@ static void subpage_prot_clear(unsigned
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static int subpage_walk_pmd_entry(pmd_t *pmd, unsigned long addr,
+static int subpage_walk_pte(pte_t *pte, unsigned long addr,
 				  unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->vma;
-	split_huge_page_pmd(vma, addr, pmd);
+	walk->control = PTWALK_BREAK;
 	return 0;
 }
 
@@ -143,9 +142,14 @@ static void subpage_mark_vma_nohuge(stru
 				    unsigned long len)
 {
 	struct vm_area_struct *vma;
+	/*
+	 * What this walking expects is to split all thps under this mm.
+	 * Page table walker internally splits thps just before we try to
+	 * call .pte_entry() on them, so let's utilize it.
+	 */
 	struct mm_walk subpage_proto_walk = {
 		.mm = mm,
-		.pmd_entry = subpage_walk_pmd_entry,
+		.pte_entry = subpage_walk_pte,
 	};
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

