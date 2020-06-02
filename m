From: akpm@linux-foundation.org
Subject: [merged]
 proc-pid-smaps-add-pmd-migration-entry-parsing.patch removed from -mm tree
Date: Tue, 02 Jun 2020 14:41:10 -0700
Message-ID: <20200602214110.J0tfj-gn4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgFBVlL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, adobriyan@gmail.com, jglisse@redhat.com, khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz, yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com


The patch titled
     Subject: /proc/PID/smaps: Add PMD migration entry parsing
has been removed from the -mm tree.  Its filename was
     proc-pid-smaps-add-pmd-migration-entry-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Huang Ying <ying.huang@intel.com>
Subject: /proc/PID/smaps: Add PMD migration entry parsing

Now, when reading /proc/PID/smaps, the PMD migration entry in page table
is simply ignored.  To improve the accuracy of /proc/PID/smaps, its
parsing and processing is added.

To test the patch, we run pmbench to eat 400 MB memory in background, then
run /usr/bin/migratepages and `cat /proc/PID/smaps` every second.  The
issue as follows can be reproduced within 60 seconds.

Before the patch, for the fully populated 400 MB anonymous VMA, some THP
pages under migration may be lost as below.

7f3f6a7e5000-7f3f837e5000 rw-p 00000000 00:00 0
Size:             409600 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:              407552 kB
Pss:              407552 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:    407552 kB
Referenced:       301056 kB
Anonymous:        407552 kB
LazyFree:              0 kB
AnonHugePages:    405504 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:        0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
Locked:                0 kB
THPeligible:		1
VmFlags: rd wr mr mw me ac

After the patch, it will be always,

7f3f6a7e5000-7f3f837e5000 rw-p 00000000 00:00 0
Size:             409600 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:              409600 kB
Pss:              409600 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:    409600 kB
Referenced:       294912 kB
Anonymous:        409600 kB
LazyFree:              0 kB
AnonHugePages:    407552 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:        0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
Locked:                0 kB
THPeligible:		1
VmFlags: rd wr mr mw me ac

Link: http://lkml.kernel.org/r/20200403123059.1846960-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/proc/task_mmu.c~proc-pid-smaps-add-pmd-migration-entry-parsing
+++ a/fs/proc/task_mmu.c
@@ -546,10 +546,17 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	struct mem_size_stats *mss =3D walk->private;
 	struct vm_area_struct *vma =3D walk->vma;
 	bool locked =3D !!(vma->vm_flags & VM_LOCKED);
-	struct page *page;
+	struct page *page =3D NULL;
=20
-	/* FOLL_DUMP will return -EFAULT on huge zero page */
-	page =3D follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+	if (pmd_present(*pmd)) {
+		/* FOLL_DUMP will return -EFAULT on huge zero page */
+		page =3D follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
+		swp_entry_t entry =3D pmd_to_swp_entry(*pmd);
+
+		if (is_migration_entry(entry))
+			page =3D migration_entry_to_page(entry);
+	}
 	if (IS_ERR_OR_NULL(page))
 		return;
 	if (PageAnon(page))
@@ -578,8 +585,7 @@ static int smaps_pte_range(pmd_t *pmd, u
=20
 	ptl =3D pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		if (pmd_present(*pmd))
-			smaps_pmd_entry(pmd, addr, walk);
+		smaps_pmd_entry(pmd, addr, walk);
 		spin_unlock(ptl);
 		goto out;
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are
