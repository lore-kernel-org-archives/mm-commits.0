From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch removed from -mm tree
Date: Tue, 21 Aug 2012 16:11:32 -0700
Message-ID: <20120821231133.CF858100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:57969 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2HUXLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Aug 2012 19:11:35 -0400
Received: by ialo24 with SMTP id o24so92901ial.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Aug 2012 16:11:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@gibson.dropbear.id.au, dhillf@gmail.com, kenchen@google.com, lwoodman@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-correctly-populate-shared-pmd-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch

This patch was dropped because it was folded into mm-hugetlbfs-correctly-populate-shared-pmd.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlbfs-correctly-populate-shared-pmd-fix

attempt to make the huge_pmd_share() comment comprehensible, clean up coding style

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlbfs-correctly-populate-shared-pmd-fix arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlbfs-correctly-populate-shared-pmd-fix
+++ a/arch/x86/mm/hugetlbpage.c
@@ -56,15 +56,15 @@ static int vma_shareable(struct vm_area_
 }
 
 /*
- * search for a shareable pmd page for hugetlb. In any case calls
- * pmd_alloc and returns the corresponding pte. While this not necessary
- * for the !shared pmd case because we can allocate the pmd later as
- * well it makes the code much cleaner. pmd allocation is essential for
- * the shared case though because pud has to be populated inside the
- * same i_mmap_mutex section otherwise racing tasks could either miss
- * the sharing (see huge_pte_offset) or selected a bad pmd for sharing.
+ * Search for a shareable pmd page for hugetlb. In any case calls pmd_alloc()
+ * and returns the corresponding pte. While this is not necessary for the
+ * !shared pmd case because we can allocate the pmd later as well, it makes the
+ * code much cleaner. pmd allocation is essential for the shared case because
+ * pud has to be populated inside the same i_mmap_mutex section - otherwise
+ * racing tasks could either miss the sharing (see huge_pte_offset) or select a
+ * bad pmd for sharing.
  */
-static pte_t*
+static pte_t *
 huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 {
 	struct vm_area_struct *vma = find_vma(mm, addr);
@@ -154,7 +154,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 			if (pud_none(*pud))
 				pte = huge_pmd_share(mm, addr, pud);
 			else
-				pte = (pte_t *) pmd_alloc(mm, pud, addr);
+				pte = (pte_t *)pmd_alloc(mm, pud, addr);
 		}
 	}
 	BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
rbtree-performance-and-correctness-test-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

