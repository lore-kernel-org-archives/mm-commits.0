From: akpm@linux-foundation.org
Subject: + mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault.patch added to -mm tree
Date: Tue, 17 Jun 2014 13:32:52 -0700
Message-ID: <53a0a5f4.SemwRY2fZFW56FoI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833AbaFQUcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 16:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, mgorman@suse.de, koct9i@gmail.com, kirill.shutemov@linux.intel.com, davej@redhat.com, cl@gentwo.org, bob.liu@oracle.com, hughd@google.com


The patch titled
     Subject: mm: let mm_find_pmd fix buggy race with THP fault
has been added to the -mm tree.  Its filename is
     mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: let mm_find_pmd fix buggy race with THP fault

Trinity has reported:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
CPU: 6 PID: 16173 Comm: trinity-c364 Tainted: G        W
                        3.15.0-rc1-next-20140415-sasha-00020-gaa90d09 #398
lock_acquire (arch/x86/include/asm/current.h:14
              kernel/locking/lockdep.c:3602)
_raw_spin_lock (include/linux/spinlock_api_smp.h:143
                kernel/locking/spinlock.c:151)
remove_migration_pte (mm/migrate.c:137)
rmap_walk (mm/rmap.c:1628 mm/rmap.c:1699)
remove_migration_ptes (mm/migrate.c:224)
migrate_pages (mm/migrate.c:922 mm/migrate.c:960 mm/migrate.c:1126)
migrate_misplaced_page (mm/migrate.c:1733)
__handle_mm_fault (mm/memory.c:3762 mm/memory.c:3812 mm/memory.c:3925)
handle_mm_fault (mm/memory.c:3948)
__get_user_pages (mm/memory.c:1851)
__mlock_vma_pages_range (mm/mlock.c:255)
__mm_populate (mm/mlock.c:711)
SyS_mlockall (include/linux/mm.h:1799 mm/mlock.c:817 mm/mlock.c:791)

I believe this comes about because, whereas collapsing and splitting THP
functions take anon_vma lock in write mode (which excludes concurrent rmap
walks), faulting THP functions (write protection and misplaced NUMA) do
not - and mostly they do not need to.

But they do use a pmdp_clear_flush(), set_pmd_at() sequence which, for an
instant (indeed, for a long instant, given the inter-CPU TLB flush in
there), leaves *pmd neither present not trans_huge.

Which can confuse a concurrent rmap walk, as when removing migration ptes,
seen in the dumped trace.  Although that rmap walk has a 4k page to
insert, anon_vmas containing THPs are in no way segregated from 4k-page
anon_vmas, so the 4k-intent mm_find_pmd() does need to cope with that
instant when a trans_huge pmd is temporarily absent.

I don't think we need strengthen the locking at the THP end: it's easily
handled with an ACCESS_ONCE() before testing both conditions.

And since mm_find_pmd() had only one caller who wanted a THP rather than a
pmd, let's slightly repurpose it to fail when it hits a THP or non-present
pmd, and open code split_huge_page_address() again.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 ++++++++++++------
 mm/ksm.c         |    1 -
 mm/migrate.c     |    2 --
 mm/rmap.c        |   12 ++++++++----
 4 files changed, 20 insertions(+), 13 deletions(-)

diff -puN mm/huge_memory.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault
+++ a/mm/huge_memory.c
@@ -2423,8 +2423,6 @@ static void collapse_huge_page(struct mm
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd)
 		goto out;
-	if (pmd_trans_huge(*pmd))
-		goto out;
 
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -2523,8 +2521,6 @@ static int khugepaged_scan_pmd(struct mm
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd)
 		goto out;
-	if (pmd_trans_huge(*pmd))
-		goto out;
 
 	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
@@ -2877,12 +2873,22 @@ void split_huge_page_pmd_mm(struct mm_st
 static void split_huge_page_address(struct mm_struct *mm,
 				    unsigned long address)
 {
+	pgd_t *pgd;
+	pud_t *pud;
 	pmd_t *pmd;
 
 	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
 
-	pmd = mm_find_pmd(mm, address);
-	if (!pmd)
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
 		return;
 	/*
 	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
diff -puN mm/ksm.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault mm/ksm.c
--- a/mm/ksm.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault
+++ a/mm/ksm.c
@@ -945,7 +945,6 @@ static int replace_page(struct vm_area_s
 	pmd = mm_find_pmd(mm, addr);
 	if (!pmd)
 		goto out;
-	BUG_ON(pmd_trans_huge(*pmd));
 
 	mmun_start = addr;
 	mmun_end   = addr + PAGE_SIZE;
diff -puN mm/migrate.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault mm/migrate.c
--- a/mm/migrate.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault
+++ a/mm/migrate.c
@@ -120,8 +120,6 @@ static int remove_migration_pte(struct p
 		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
 			goto out;
-		if (pmd_trans_huge(*pmd))
-			goto out;
 
 		ptep = pte_offset_map(pmd, addr);
 
diff -puN mm/rmap.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault mm/rmap.c
--- a/mm/rmap.c~mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault
+++ a/mm/rmap.c
@@ -569,6 +569,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm,
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd = NULL;
+	pmd_t pmde;
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
@@ -579,7 +580,13 @@ pmd_t *mm_find_pmd(struct mm_struct *mm,
 		goto out;
 
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	/*
+	 * Some THP functions use the sequence pmdp_clear_flush(), set_pmd_at()
+	 * without holding anon_vma lock for write.  So when looking for a
+	 * genuine pmde (in which to find pte), test present and !THP together.
+	 */
+	pmde = ACCESS_ONCE(*pmd);
+	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 		pmd = NULL;
 out:
 	return pmd;
@@ -615,9 +622,6 @@ pte_t *__page_check_address(struct page
 	if (!pmd)
 		return NULL;
 
-	if (pmd_trans_huge(*pmd))
-		return NULL;
