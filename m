From: akpm@linux-foundation.org
Subject: [folded] thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:18:39 -0700
Message-ID: <20120321231839.75901A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38540 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2CUXSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:18:42 -0400
Received: by lbbgj3 with SMTP id gj3so82651lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:18:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into thp-optimize-away-unnecessary-page-table-locking.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes

Cc: Andi Kleen <andi@firstfloor.org>

ERROR: do not use assignment in if condition
#81: FILE: mm/huge_memory.c:1097:
+	if ((ret = __pmd_trans_huge_lock(old_pmd, vma)) == 1) {

total: 1 errors, 0 warnings, 85 lines checked

./patches/thp-optimize-away-unnecessary-page-table-locking-fix.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes mm/huge_memory.c
--- a/mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes
+++ a/mm/huge_memory.c
@@ -1095,7 +1095,8 @@ int move_huge_pmd(struct vm_area_struct 
 		goto out;
 	}
 
-	if ((ret = __pmd_trans_huge_lock(old_pmd, vma)) == 1) {
+	ret = __pmd_trans_huge_lock(old_pmd, vma);
+	if (ret == 1) {
 		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
vmscan-kswapd-carefully-call-compaction.patch
mm-compaction-make-compact_control-order-signed.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
thp-optimize-away-unnecessary-page-table-locking.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

