From: akpm@linux-foundation.org
Subject: + memcg-fix-oom-killing-a-child-process-in-an-other-cgroup.patch added to -mm tree
Date: Fri, 12 Feb 2010 11:41:56 -0800
Message-ID: <201002121941.o1CJfuTQ022818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634Ab0BLTnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, stable@kernel.org


The patch titled
     memcg: fix oom killing a child process in an other cgroup
has been added to the -mm tree.  Its filename is
     memcg-fix-oom-killing-a-child-process-in-an-other-cgroup.patch

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
Subject: memcg: fix oom killing a child process in an other cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently the oom-killer is memcg aware and it finds the worst process from
processes under memcg(s) in oom. Then, it kills victim's child first.

It may kill a child in another cgroup and may not be any help for
recovery.  And it will break the assumption users have.

This patch fixes it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~memcg-fix-oom-killing-a-child-process-in-an-other-cgroup mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-fix-oom-killing-a-child-process-in-an-other-cgroup
+++ a/mm/oom_kill.c
@@ -459,6 +459,8 @@ static int oom_kill_process(struct task_
 	list_for_each_entry(c, &p->children, sibling) {
 		if (c->mm == p->mm)
 			continue;
+		if (mem && !task_in_mem_cgroup(c, mem))
+			continue;
 		if (!oom_kill_task(c))
 			return 0;
 	}
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
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

