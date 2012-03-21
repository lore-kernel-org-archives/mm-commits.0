From: akpm@linux-foundation.org
Subject: [folded] hugetlbfs-return-error-code-when-initializing-module-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:22:43 -0700
Message-ID: <20120321232243.9C411A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:49785 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2CUXWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:22:46 -0400
Received: by wejx9 with SMTP id x9so83122wej.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:22:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhillf@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs-return-error-code-when-initializing-module-fix
has been removed from the -mm tree.  Its filename was
     hugetlbfs-return-error-code-when-initializing-module-fix.patch

This patch was dropped because it was folded into hugetlbfs-return-error-code-when-initializing-module.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlbfs-return-error-code-when-initializing-module-fix

remove unneeded test of `error'

Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-return-error-code-when-initializing-module-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-return-error-code-when-initializing-module-fix
+++ a/fs/hugetlbfs/inode.c
@@ -1035,8 +1035,7 @@ static int __init init_hugetlbfs_fs(void
 	unregister_filesystem(&hugetlbfs_fs_type);
 
  out:
-	if (error)
-		kmem_cache_destroy(hugetlbfs_inode_cachep);
+	kmem_cache_destroy(hugetlbfs_inode_cachep);
  out2:
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 	return error;
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
hugetlbfs-return-error-code-when-initializing-module.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

