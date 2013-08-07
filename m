From: akpm@linux-foundation.org
Subject: +
 vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch added to -mm tree
Date: Wed, 07 Aug 2013 14:41:47 -0700
Message-ID: <5202bf1b.Tx7d2dEUhfIDOloC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3HGVls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 17:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, js1304@gmail.com, cl@linux.com, adobriyan@gmail.com, akpm@linux-foundation.org

Subject: + vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch added to -mm tree
To: akpm@linux-foundation.org,adobriyan@gmail.com,cl@linux.com,js1304@gmail.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 14:41:47 -0700


The patch titled
     Subject: vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix
has been added to the -mm tree.  Its filename is
     vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix

fix UP build

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/vmstat.h~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix
+++ a/include/linux/vmstat.h
@@ -198,7 +198,7 @@ extern void __inc_zone_state(struct zone
 extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
-void cpu_vm_stats_fold(int);
+void cpu_vm_stats_fold(int cpu);
 void refresh_zone_stat_thresholds(void);
 
 void drain_zonestat(struct zone *zone, struct per_cpu_pageset *);
@@ -255,6 +255,7 @@ static inline void __dec_zone_page_state
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
 static inline void refresh_zone_stat_thresholds(void) { }
+static inline void cpu_vm_stats_fold(int cpu) { }
 
 static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_pageset *pset) { }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition-fix.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
memcg-trivial-cleanups.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

