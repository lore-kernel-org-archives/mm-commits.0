From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:03:38 -0700
Message-ID: <533dccaa.RqIkDHtyCF6CEesT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaDCVDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liucn@gmail.com, mfasheh@suse.de, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,mfasheh@suse.de,younger.liucn@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:03:38 -0700


The patch titled
     Subject: ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes.patch

This patch was dropped because it was folded into ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes

WARNING: line over 80 characters
#52: FILE: fs/ocfs2/suballoc.c:1617:
+	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &di->id2.i_chain;

total: 0 errors, 1 warnings, 71 lines checked

./patches/ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Younger Liu <younger.liucn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes
+++ a/fs/ocfs2/suballoc.c
@@ -1614,8 +1614,9 @@ void ocfs2_rollback_alloc_dinode_counts(
 {
 	u32 tmp_used;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
-	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &di->id2.i_chain;
+	struct ocfs2_chain_list *cl;
 
+	cl = (struct ocfs2_chain_list *)&di->id2.i_chain;
 	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
 	di->id1.bitmap1.i_used = cpu_to_le32(tmp_used - num_bits);
 	le32_add_cpu(&cl->cl_recs[chain].c_free, num_bits);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

