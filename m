From: akpm@linux-foundation.org
Subject: [folded] hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:17:59 -0700
Message-ID: <20120321231759.80AA7A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58159 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2CUXSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:18:00 -0400
Received: by ghbz15 with SMTP id z15so272900ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:18:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-try-to-search-again-if-it-is-really-needed-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch

This patch was dropped because it was folded into hugetlb-try-to-search-again-if-it-is-really-needed.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-try-to-search-again-if-it-is-really-needed-fix

clean up crazy compound definition

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-try-to-search-again-if-it-is-really-needed-fix arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-try-to-search-again-if-it-is-really-needed-fix
+++ a/arch/x86/mm/hugetlbpage.c
@@ -309,7 +309,8 @@ static unsigned long hugetlb_get_unmappe
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev_vma;
-	unsigned long base = mm->mmap_base, addr = addr0, start_addr;
+	unsigned long base = mm->mmap_base;
+	unsigned long addr = addr0;
 	unsigned long largest_hole = mm->cached_hole_size;
 	unsigned long start_addr;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
vmscan-kswapd-carefully-call-compaction.patch
mm-compaction-make-compact_control-order-signed.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
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

