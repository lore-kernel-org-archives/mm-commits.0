From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-improve-page-fault-scalability-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:04:04 -0700
Message-ID: <533dccc4.Bwkuh3pez6hCYcdy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaDCVEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-hugetlb-improve-page-fault-scalability-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,iamjoonsoo.kim@lge.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:04:04 -0700


The patch titled
     Subject: mm-hugetlb-improve-page-fault-scalability-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-improve-page-fault-scalability-fix.patch

This patch was dropped because it was folded into mm-hugetlb-improve-page-fault-scalability.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-improve-page-fault-scalability-fix

remove stray + characters, go BUG if hugetlb_init() kmalloc fails

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability-fix
+++ a/mm/hugetlb.c
@@ -55,9 +55,9 @@ static unsigned long __initdata default_
 DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
-+ * Serializes faults on the same logical page.  This is used to
-+ * prevent spurious OOMs when the hugepage pool is fully utilized.
-+ */
+ * Serializes faults on the same logical page.  This is used to
+ * prevent spurious OOMs when the hugepage pool is fully utilized.
+ */
 static int num_fault_mutexes;
 static struct mutex *htlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
@@ -2008,8 +2008,7 @@ static int __init hugetlb_init(void)
 #endif
 	htlb_fault_mutex_table =
 		kmalloc(sizeof(struct mutex) * num_fault_mutexes, GFP_KERNEL);
-	if (!htlb_fault_mutex_table)
-		return -ENOMEM;
+	BUG_ON(!htlb_fault_mutex_table);
 
 	for (i = 0; i < num_fault_mutexes; i++)
 		mutex_init(&htlb_fault_mutex_table[i]);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
mm-hugetlb-improve-page-fault-scalability.patch
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

