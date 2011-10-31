From: akpm@linux-foundation.org
Subject: [folded] thp-mremap-support-and-tlb-optimization-fix-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:43:45 -0700
Message-ID: <201110312343.p9VNhjXQ014569@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1JaXny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:43:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-mremap-support-and-tlb-optimization-fix-fix
has been removed from the -mm tree.  Its filename was
     thp-mremap-support-and-tlb-optimization-fix-fix.patch

This patch was dropped because it was folded into thp-mremap-support-and-tlb-optimization.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-mremap-support-and-tlb-optimization-fix-fix

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix-fix
+++ a/mm/huge_memory.c
@@ -1072,7 +1072,7 @@ int move_huge_pmd(struct vm_area_struct 
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have release it.
 	 */
-	if (!WARN_ON(pmd_none(*new_pmd))) {
+	if (WARN_ON(!pmd_none(*new_pmd))) {
 		VM_BUG_ON(pmd_trans_huge(*new_pmd));
 		goto out;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

