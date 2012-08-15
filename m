From: akpm@linux-foundation.org
Subject: + mm-hugetlbfs-correctly-populate-shared-pmd.patch added to -mm tree
Date: Wed, 15 Aug 2012 14:56:42 -0700
Message-ID: <20120815215642.AE14F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:46497 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2HOV4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 17:56:44 -0400
Received: by obbwc20 with SMTP id wc20so1494188obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 14:56:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, david@gibson.dropbear.id.au, dhillf@gmail.com, kenchen@google.com, lwoodman@redhat.com, mgorman@suse.de, riel@redhat.com, stable@vger.kernel.org, xiyou.wangcong@gmail.com


The patch titled
     Subject: mm: hugetlbfs: correctly populate shared pmd
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-correctly-populate-shared-pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: hugetlbfs: correctly populate shared pmd

Each page mapped in a process's address space must be correctly accounted
for in _mapcount.  Normally the rules for this are straightforward but
hugetlbfs page table sharing is different.  The page table pages at the
PMD level are reference counted while the mapcount remains the same.  If
this accounting is wrong, it causes bugs like this one reported by Larry
Woodman

[ 1106.156569] ------------[ cut here ]------------
[ 1106.161731] kernel BUG at mm/filemap.c:135!
[ 1106.166395] invalid opcode: 0000 [#1] SMP
[ 1106.170975] CPU 22
[ 1106.173115] Modules linked in: bridge stp llc sunrpc binfmt_misc dcdbas microcode pcspkr acpi_pad acpi]
[ 1106.201770]
[ 1106.203426] Pid: 18001, comm: mpitest Tainted: G        W    3.3.0+ #4 Dell Inc. PowerEdge R620/07NDJ2
[ 1106.213822] RIP: 0010:[<ffffffff8112cfed>]  [<ffffffff8112cfed>] __delete_from_page_cache+0x15d/0x170
[ 1106.224117] RSP: 0018:ffff880428973b88  EFLAGS: 00010002
[ 1106.230032] RAX: 0000000000000001 RBX: ffffea0006b80000 RCX: 00000000ffffffb0
[ 1106.237979] RDX: 0000000000016df1 RSI: 0000000000000009 RDI: ffff88043ffd9e00
[ 1106.245927] RBP: ffff880428973b98 R08: 0000000000000050 R09: 0000000000000003
[ 1106.253876] R10: 000000000000000d R11: 0000000000000000 R12: ffff880428708150
[ 1106.261826] R13: ffff880428708150 R14: 0000000000000000 R15: ffffea0006b80000
[ 1106.269780] FS:  0000000000000000(0000) GS:ffff88042fd60000(0000) knlGS:0000000000000000
[ 1106.278794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1106.285193] CR2: 0000003a1d38c4a8 CR3: 000000000187d000 CR4: 00000000000406e0
[ 1106.293149] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1106.301097] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1106.309046] Process mpitest (pid: 18001, threadinfo ffff880428972000, task ffff880428b5cc20)
[ 1106.318447] Stack:
[ 1106.320690]  ffffea0006b80000 0000000000000000 ffff880428973bc8 ffffffff8112d040
[ 1106.328958]  ffff880428973bc8 00000000000002ab 00000000000002a0 ffff880428973c18
[ 1106.337234]  ffff880428973cc8 ffffffff8125b405 ffff880400000001 0000000000000000
[ 1106.345513] Call Trace:
[ 1106.348235]  [<ffffffff8112d040>] delete_from_page_cache+0x40/0x80
[ 1106.355128]  [<ffffffff8125b405>] truncate_hugepages+0x115/0x1f0
[ 1106.361826]  [<ffffffff8125b4f8>] hugetlbfs_evict_inode+0x18/0x30
[ 1106.368615]  [<ffffffff811ab1af>] evict+0x9f/0x1b0
[ 1106.373951]  [<ffffffff811ab3a3>] iput_final+0xe3/0x1e0
[ 1106.379773]  [<ffffffff811ab4de>] iput+0x3e/0x50
[ 1106.384922]  [<ffffffff811a8e18>] d_kill+0xf8/0x110
[ 1106.390356]  [<ffffffff811a8f12>] dput+0xe2/0x1b0
[ 1106.395595]  [<ffffffff81193612>] __fput+0x162/0x240

During fork(), copy_hugetlb_page_range() detects if huge_pte_alloc()
shared page tables with the check dst_pte == src_pte.  The logic is if the
PMD page is the same, they must be shared.  This assumes that the sharing
is between the parent and child.  However, if the sharing is with a
different process entirely then this check fails as in this diagram.

parent
  |
  ------------>pmd
               src_pte----------> data page
                                      ^
other--------->pmd--------------------|
                ^
child-----------|
               dst_pte

For this situation to occur, it must be possible for Parent and Other to
have faulted and failed to share page tables with each other.  This is
possible due to the following style of race.

PROC A                                          PROC B
copy_hugetlb_page_range                         copy_hugetlb_page_range
  src_pte == huge_pte_offset                      src_pte == huge_pte_offset
  !src_pte so no sharing                          !src_pte so no sharing

(time passes)

hugetlb_fault                                   hugetlb_fault
  huge_pte_alloc                                  huge_pte_alloc
    huge_pmd_share                                 huge_pmd_share
      LOCK(i_mmap_mutex)
      find nothing, no sharing
      UNLOCK(i_mmap_mutex)
                                                    LOCK(i_mmap_mutex)
                                                    find nothing, no sharing
                                                    UNLOCK(i_mmap_mutex)
    pmd_alloc                                       pmd_alloc
    LOCK(instantiation_mutex)
    fault
    UNLOCK(instantiation_mutex)
                                                LOCK(instantiation_mutex)
                                                fault
                                                UNLOCK(instantiation_mutex)

These two processes are not poing to the same data page but are not
sharing page tables because the opportunity was missed.  When either
process later forks, the src_pte == dst pte is potentially insufficient. 
As the check falls through, the wrong PTE information is copied in
(harmless but wrong) and the mapcount is bumped for a page mapped by a
shared page table leading to the BUG_ON.

This patch addresses the issue by moving pmd_alloc into huge_pmd_share
which guarantees that the shared pud is populated in the same critical
section as pmd.  This also means that huge_pte_offset test in
huge_pmd_share is serialized correctly now which in turn means that the
success of the sharing will be higher as the racing tasks see the pud and
pmd populated together.

Race identified and changelog written mostly by Mel Gorman.

Reported-by: Larry Woodman <lwoodman@redhat.com>
Tested-by: Larry Woodman <lwoodman@redhat.com>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Ken Chen <kenchen@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlbfs-correctly-populate-shared-pmd arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlbfs-correctly-populate-shared-pmd
+++ a/arch/x86/mm/hugetlbpage.c
@@ -56,9 +56,16 @@ static int vma_shareable(struct vm_area_
 }
 
 /*
- * search for a shareable pmd page for hugetlb.
+ * search for a shareable pmd page for hugetlb. In any case calls
+ * pmd_alloc and returns the corresponding pte. While this not necessary
+ * for the !shared pmd case because we can allocate the pmd later as
+ * well it makes the code much cleaner. pmd allocation is essential for
+ * the shared case though because pud has to be populated inside the
+ * same i_mmap_mutex section otherwise racing tasks could either miss
+ * the sharing (see huge_pte_offset) or selected a bad pmd for sharing.
  */
-static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
+static pte_t*
+huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 {
 	struct vm_area_struct *vma = find_vma(mm, addr);
 	struct address_space *mapping = vma->vm_file->f_mapping;
@@ -68,9 +75,10 @@ static void huge_pmd_share(struct mm_str
 	struct vm_area_struct *svma;
 	unsigned long saddr;
 	pte_t *spte = NULL;
+	pte_t *pte;
 
 	if (!vma_shareable(vma, addr))
-		return;
+		return (pte_t *)pmd_alloc(mm, pud, addr);
 
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
@@ -97,7 +105,9 @@ static void huge_pmd_share(struct mm_str
 		put_page(virt_to_page(spte));
 	spin_unlock(&mm->page_table_lock);
 out:
+	pte = (pte_t *)pmd_alloc(mm, pud, addr);
 	mutex_unlock(&mapping->i_mmap_mutex);
+	return pte;
 }
 
 /*
@@ -142,8 +152,9 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		} else {
 			BUG_ON(sz != PMD_SIZE);
 			if (pud_none(*pud))
-				huge_pmd_share(mm, addr, pud);
-			pte = (pte_t *) pmd_alloc(mm, pud, addr);
+				pte = huge_pmd_share(mm, addr, pud);
+			else
+				pte = (pte_t *) pmd_alloc(mm, pud, addr);
 		}
 	}
 	BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch

