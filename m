From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:24 -0700
Message-ID: <51db11ac.VJLXA5syah2QucRt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3GHTXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liu@huawei.com, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, akpm@linux-foundation.org

Subject: [merged] ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com,younger.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:24 -0700


The patch titled
     Subject: ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix

remove duplicated mlog_errno()

Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Younger Liu <younger.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix
+++ a/fs/ocfs2/suballoc.c
@@ -1443,44 +1443,38 @@ static int ocfs2_relink_block_group(hand
 	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
 					 prev_bg_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
+	if (status < 0)
 		goto out;
-	}
 
 	prev_bg->bg_next_group = bg->bg_next_group;
 	ocfs2_journal_dirty(handle, prev_bg_bh);
 
 	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
 					 bg_bh, OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
+	if (status < 0)
 		goto out_rollback_prev_bg;
-	}
 
 	bg->bg_next_group = fe->id2.i_chain.cl_recs[chain].c_blkno;
 	ocfs2_journal_dirty(handle, bg_bh);
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
 					 fe_bh, OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
+	if (status < 0)
 		goto out_rollback_bg;
-	}
 
 	fe->id2.i_chain.cl_recs[chain].c_blkno = bg->bg_blkno;
 	ocfs2_journal_dirty(handle, fe_bh);
 
 out:
+	if (status < 0)
+		mlog_errno(status);
 	return status;
 
 out_rollback_bg:
 	bg->bg_next_group = cpu_to_le64(bg_ptr);
 out_rollback_prev_bg:
 	prev_bg->bg_next_group = cpu_to_le64(prev_bg_ptr);
-
-	mlog_errno(status);
-	return status;
+	goto out;
 }
 
 static inline int ocfs2_block_group_reasonably_empty(struct ocfs2_group_desc *bg,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

