From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-mempolicy-checking-hugepage-migration-is-supported-by-?=
 =?US-ASCII?Q?arch-in-vma=5Fmigratable.patch?= removed from -mm tree
Date: Fri, 03 Apr 2020 13:40:17 -0700
Message-ID: <20200403204017.chYtR2n7t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgDCUkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, lixinhai.lxh@gmail.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm/mempolicy: check hugepage migration is supported by arch in vma_migratable()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-checking-hugepage-migration-is-supported-by-arch-in-vma_migratable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/mempolicy: check hugepage migration is supported by arch in vma_migratable()

vma_migratable() is called to check if pages in vma can be migrated before
go ahead to further actions.  Currently it is used in below code path:

- task_numa_work
- mbind
- move_pages

For hugetlb mapping, whether vma is migratable or not is determined by:
- CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
- arch_hugetlb_migration_supported

Issue: current code only checks for CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
alone, and no code should use it directly.  (note that current code in
vma_migratable don't cause failure or bug because
unmap_and_move_huge_page() will catch unsupported hugepage and handle it
properly)

This patch checks the two factors by hugepage_migration_supported for
impoving code logic and robustness.  It will enable early bail out of
hugepage migration procedure, but because currently all architecture
supporting hugepage migration is able to support all page size, we would
not see performance gain with this patch applied.

vma_migratable() is moved to mm/mempolicy.c, because of the circular
reference of mempolicy.h and hugetlb.h cause defining it as inline not
feasible.

Link: http://lkml.kernel.org/r/1579786179-30633-1-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   29 +----------------------------
 mm/mempolicy.c            |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 28 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-checking-hugepage-migration-is-supported-by-arch-in-vma_migratable
+++ a/include/linux/mempolicy.h
@@ -173,34 +173,7 @@ extern int mpol_parse_str(char *str, str
 extern void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
 
 /* Check if a vma is migratable */
-static inline bool vma_migratable(struct vm_area_struct *vma)
-{
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
-		return false;
-
-	/*
-	 * DAX device mappings require predictable access latency, so avoid
-	 * incurring periodic faults.
-	 */
-	if (vma_is_dax(vma))
-		return false;
-
-#ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
-	if (vma->vm_flags & VM_HUGETLB)
-		return false;
-#endif
-
-	/*
-	 * Migration allocates pages in the highest zone. If we cannot
-	 * do so then migration (at least from node to node) is not
-	 * possible.
-	 */
-	if (vma->vm_file &&
-		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
-								< policy_zone)
-			return false;
-	return true;
-}
+extern bool vma_migratable(struct vm_area_struct *vma);
 
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 extern void mpol_put_task_policy(struct task_struct *);
--- a/mm/mempolicy.c~mm-mempolicy-checking-hugepage-migration-is-supported-by-arch-in-vma_migratable
+++ a/mm/mempolicy.c
@@ -1743,6 +1743,34 @@ COMPAT_SYSCALL_DEFINE4(migrate_pages, co
 
 #endif /* CONFIG_COMPAT */
 
+bool vma_migratable(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		return false;
+
+	/*
+	 * DAX device mappings require predictable access latency, so avoid
+	 * incurring periodic faults.
+	 */
+	if (vma_is_dax(vma))
+		return false;
+
+	if (is_vm_hugetlb_page(vma) &&
+		!hugepage_migration_supported(hstate_vma(vma)))
+		return false;
+
+	/*
+	 * Migration allocates pages in the highest zone. If we cannot
+	 * do so then migration (at least from node to node) is not
+	 * possible.
+	 */
+	if (vma->vm_file &&
+		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
+			< policy_zone)
+		return false;
+	return true;
+}
+
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 						unsigned long addr)
 {
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork.patch
revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch
mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch
