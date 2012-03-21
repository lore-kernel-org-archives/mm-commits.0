From: akpm@linux-foundation.org
Subject: [folded] hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:22:13 -0700
Message-ID: <20120321232213.B34C8A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:34454 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2CUXWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:22:14 -0400
Received: by ghbz15 with SMTP id z15so273657ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:22:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, steven.truelove@utoronto.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs-fix-alignment-of-huge-page-requests-fix
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch

This patch was dropped because it was folded into hugetlbfs-fix-alignment-of-huge-page-requests.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlbfs-fix-alignment-of-huge-page-requests-fix

x86_64 allnoconfig:

mm/mmap.c: In function 'sys_mmap_pgoff':
mm/mmap.c:1127: warning: passing argument 4 of 'hugetlb_file_setup' makes pointer from integer without a cast
include/linux/hugetlb.h:172: note: expected 'struct user_struct **' but argument is of type 'int'
mm/mmap.c:1127: warning: passing argument 5 of 'hugetlb_file_setup' makes integer from pointer without a cast
include/linux/hugetlb.h:172: note: expected 'int' but argument is of type 'struct user_struct **'
mm/mmap.c:1127: error: too many arguments to function 'hugetlb_file_setup'


Cc: Hugh Dickins <hughd@google.com>
Cc: Steven Truelove <steven.truelove@utoronto.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-fix-alignment-of-huge-page-requests-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-fix-alignment-of-huge-page-requests-fix
+++ a/include/linux/hugetlb.h
@@ -169,7 +169,8 @@ static inline int is_file_hugepages(stru
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-static inline struct file *hugetlb_file_setup(const char *name, size_t size,
+static inline struct file *
+hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
 	return ERR_PTR(-ENOSYS);
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
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch
hugetlbfs-fix-alignment-of-huge-page-requests.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

