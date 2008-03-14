From: akpm@linux-foundation.org
Subject: + memcgroup-fix-check-for-thread-being-a-group-leader-in-memcgroup.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:11:36 -0700
Message-ID: <200803142011.m2EKBaww017334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283AbYCNUL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:11:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     memcgroup: fix check for thread being a group leader in memcgroup
has been added to the -mm tree.  Its filename is
     memcgroup-fix-check-for-thread-being-a-group-leader-in-memcgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: fix check for thread being a group leader in memcgroup
From: Pavel Emelyanov <xemul@openvz.org>

The check t->pid == t->pid is not the blessed way to check whether a task is a
group leader.

This is not about the code beautifulness only, but about pid namespaces fixes
- both the tgid and the pid fields on the task_struct are (slowly :( )
becoming deprecated.

Besides, the thread_group_leader() macro makes only one dereference :)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcgroup-fix-check-for-thread-being-a-group-leader-in-memcgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-fix-check-for-thread-being-a-group-leader-in-memcgroup
+++ a/mm/memcontrol.c
@@ -1079,7 +1079,7 @@ static void mem_cgroup_move_task(struct 
 	 * Only thread group leaders are allowed to migrate, the mm_struct is
 	 * in effect owned by the leader
 	 */
-	if (p->tgid != p->pid)
+	if (!thread_group_leader(p))
 		goto out;
 
 	css_get(&mem->css);
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memcgroup-fix-check-for-thread-being-a-group-leader-in-memcgroup.patch
git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
binfmt_miscc-avoid-potential-kernel-stack-overflow.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
cgroups-add-the-trigger-callback-to-struct-cftype.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
memcgroup-implement-failcounter-reset.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

