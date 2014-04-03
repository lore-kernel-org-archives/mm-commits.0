From: akpm@linux-foundation.org
Subject: [folded-merged] mm-vmstat-fix-up-zone-state-accounting-fix.patch
 removed from -mm tree
Date: Thu, 03 Apr 2014 14:04:33 -0700
Message-ID: <533dcce1.m5WJXdQazSgTI0Re%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaDCVEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: [folded-merged] mm-vmstat-fix-up-zone-state-accounting-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:04:33 -0700


The patch titled
     Subject: mm-vmstat-fix-up-zone-state-accounting-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-up-zone-state-accounting-fix.patch

This patch was dropped because it was folded into mm-vmstat-fix-up-zone-state-accounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-fix-up-zone-state-accounting-fix

make it build

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstat-fix-up-zone-state-accounting-fix include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-fix-up-zone-state-accounting-fix
+++ a/include/linux/vmstat.h
@@ -222,6 +222,18 @@ static inline void __mod_zone_page_state
 	zone_page_state_add(delta, zone, item);
 }
 
+static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	atomic_long_inc(&zone->vm_stat[item]);
+	atomic_long_inc(&vm_stat[item]);
+}
+
+static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	atomic_long_dec(&zone->vm_stat[item]);
+	atomic_long_dec(&vm_stat[item]);
+}
+
 static inline void __inc_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
@@ -242,18 +254,6 @@ static inline void __dec_zone_page_state
 #define dec_zone_page_state __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
-static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	atomic_long_inc(&zone->vm_stat[item]);
-	atomic_long_inc(&vm_stat[item]);
-}
-
-static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	atomic_long_dec(&zone->vm_stat[item]);
-	atomic_long_dec(&vm_stat[item]);
-}
-
 #define inc_zone_state __inc_zone_state
 #define dec_zone_state __dec_zone_state
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-vmstat-fix-up-zone-state-accounting.patch
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

