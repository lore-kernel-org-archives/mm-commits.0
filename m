From: akpm@linux-foundation.org
Subject: + memcg-handle-panic_on_oom=always-case-v2.patch added to -mm tree
Date: Mon, 22 Feb 2010 12:58:21 -0800
Message-ID: <201002222058.o1MKwLKB022724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707Ab0BVU6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 15:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp, npiggin@suse.de, rientjes@google.com


The patch titled
     memcg: handle panic_on_oom=always case
has been added to the -mm tree.  Its filename is
     memcg-handle-panic_on_oom=always-case-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: handle panic_on_oom=always case
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently, if panic_on_oom=2, the whole system panics even if the oom
happend in some special situation (as cpuset, mempolicy....).  Then,
panic_on_oom=2 means painc_on_oom_always.

Now, memcg doesn't check panic_on_oom flag. This patch adds a check.

BTW, how it's useful ?

kdump+panic_on_oom=2 is the last tool to investigate what happens in
oom-ed system.  When a task is killed, the sysytem recovers and there will
be few hint to know what happnes.  In mission critical system, oom should
never happen.  Then, panic_on_oom=2+kdump is useful to avoid next OOM by
knowing precise information via snapshot.

TODO:
 - For memcg, it's for isolate system's memory usage, oom-notiifer and
   freeze_at_oom (or rest_at_oom) should be implemented. Then, management
   daemon can do similar jobs (as kdump) or taking snapshot per cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    5 ++++-
 Documentation/sysctl/vm.txt      |    5 ++++-
 mm/oom_kill.c                    |    2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-handle-panic_on_oom=always-case-v2 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-handle-panic_on_oom=always-case-v2
+++ a/Documentation/cgroups/memory.txt
@@ -182,6 +182,8 @@ list.
 NOTE: Reclaim does not work for the root cgroup, since we cannot set any
 limits on the root cgroup.
 
+Note2: When panic_on_oom is set to "2", the whole system will panic.
+
 2. Locking
 
 The memory controller uses the following hierarchy
@@ -379,7 +381,8 @@ The feature can be disabled by
 NOTE1: Enabling/disabling will fail if the cgroup already has other
 cgroups created below it.
 
-NOTE2: This feature can be enabled/disabled per subtree.
+NOTE2: When panic_on_oom is set to "2", the whole system will panic in
+case of an oom event in any cgroup.
 
 7. Soft limits
 
diff -puN Documentation/sysctl/vm.txt~memcg-handle-panic_on_oom=always-case-v2 Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~memcg-handle-panic_on_oom=always-case-v2
+++ a/Documentation/sysctl/vm.txt
@@ -573,11 +573,14 @@ Because other nodes' memory may be free.
 may be not fatal yet.
 
 If this is set to 2, the kernel panics compulsorily even on the
-above-mentioned.
+above-mentioned. Even oom happens under memory cgroup, the whole
+system panics.
 
 The default value is 0.
 1 and 2 are for failover of clustering. Please select either
 according to your policy of failover.
+panic_on_oom=2+kdump gives you very strong tool to investigate
+why oom happens. You can get snapshot.
 
 =============================================================
 
diff -puN mm/oom_kill.c~memcg-handle-panic_on_oom=always-case-v2 mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-handle-panic_on_oom=always-case-v2
+++ a/mm/oom_kill.c
@@ -473,6 +473,8 @@ void mem_cgroup_out_of_memory(struct mem
 	unsigned long points = 0;
 	struct task_struct *p;
 
+	if (sysctl_panic_on_oom == 2)
+		panic("out of memory(memcg). panic_on_oom is selected.\n");
 	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, mem);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-oom-killing-a-child-process-in-an-other-cgroup.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
nodemaskh-remove-macro-any_online_node.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

