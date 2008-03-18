From: akpm@linux-foundation.org
Subject: + bsd_acct-plain-current-real_parent-access-is-not-always-safe.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:29:59 -0700
Message-ID: <200803180429.m2I4Txqq014154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbYCREa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, oleg@tv-sign.ru, paulmck@us.ibm.com


The patch titled
     bsd_acct: plain current->real_parent access is not always safe
has been added to the -mm tree.  Its filename is
     bsd_acct-plain-current-real_parent-access-is-not-always-safe.patch

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
Subject: bsd_acct: plain current->real_parent access is not always safe
From: Pavel Emelyanov <xemul@openvz.org>

This is minor, but dereferencing even current real_parent is not safe on debug
kernels, since the memory, this points to, can be unmapped - RCU protection is
required.

Besides, the tgid field is deprecated and is to be replaced with task_tgid_xxx
call (the 2nd patch), so RCU will be required anyway.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/acct.c~bsd_acct-plain-current-real_parent-access-is-not-always-safe kernel/acct.c
--- a/kernel/acct.c~bsd_acct-plain-current-real_parent-access-is-not-always-safe
+++ a/kernel/acct.c
@@ -482,7 +482,9 @@ static void do_acct_process(struct file 
 #endif
 #if ACCT_VERSION==3
 	ac.ac_pid = current->tgid;
-	ac.ac_ppid = current->real_parent->tgid;
+	rcu_read_lock();
+	ac.ac_ppid = rcu_dereference(current->real_parent)->tgid;
+	rcu_read_unlock();
 #endif
 
 	spin_lock_irq(&current->sighand->siglock);
_

Patches currently in -mm which might be from xemul@openvz.org are

memcgroup-fix-check-for-thread-being-a-group-leader-in-memcgroup.patch
git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
bsd_acct-plain-current-real_parent-access-is-not-always-safe.patch
bsd_acct-using-task_struct-tgid-is-not-right-in-pid-namespaces.patch
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
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
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

