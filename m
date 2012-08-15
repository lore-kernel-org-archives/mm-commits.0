From: akpm@linux-foundation.org
Subject: + mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch added to -mm tree
Date: Wed, 15 Aug 2012 14:56:46 -0700
Message-ID: <20120815215647.3E498100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:63525 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2HOV4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 17:56:48 -0400
Received: by ialo24 with SMTP id o24so160418ial.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 14:56:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david@gibson.dropbear.id.au, dhillf@gmail.com, kenchen@google.com, lwoodman@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, xiyou.wangcong@gmail.com


The patch titled
     Subject: mm-hugetlbfs-correctly-populate-shared-pmd-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

