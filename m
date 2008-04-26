From: akpm@linux-foundation.org
Subject: - cgroup-fix-a-race-condition-in-manipulating-tsk-cg_list.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:03 -0700
Message-ID: <200804261640.m3QGe30j030997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894AbYDZQlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, pj@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cgroup: fix a race condition in manipulating tsk->cg_list
has been removed from the -mm tree.  Its filename was
     cgroup-fix-a-race-condition-in-manipulating-tsk-cg_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix a race condition in manipulating tsk->cg_list
From: Li Zefan <lizf@cn.fujitsu.com>

When I ran a test program to fork mass processes and at the same time 'cat
/cgroup/tasks', I got the following oops:

------------[ cut here ]------------
kernel BUG at lib/list_debug.c:72!
invalid opcode: 0000 [#1] SMP
Pid: 4178, comm: a.out Not tainted (2.6.25-rc9 #72)
...
Call Trace:
 [<c044a5f9>] ? cgroup_exit+0x55/0x94
 [<c0427acf>] ? do_exit+0x217/0x5ba
 [<c0427ed7>] ? do_group_exit+0.65/0x7c
 [<c0427efd>] ? sys_exit_group+0xf/0x11
 [<c0404842>] ? syscall_call+0x7/0xb
 [<c05e0000>] ? init_cyrix+0x2fa/0x479
...
EIP: [<c04df671>] list_del+0x35/0x53 SS:ESP 0068:ebc7df4
---[ end trace caffb7332252612b ]---
Fixing recursive fault but reboot is needed!

After digging into the code and debugging, I finlly found out a race
situation:
				do_exit()
				  ->cgroup_exit()
				    ->if (!list_empty(&tsk->cg_list))
				        list_del(&tsk->cg_list);

cgroup_iter_start()
  ->cgroup_enable_task_cg_list()
    ->list_add(&tsk->cg_list, ..);

In this case the list won't be deleted though the process has exited.

We got two bug reports in the past, which seem to be the same bug as
this one:
	http://lkml.org/lkml/2008/3/5/332
	http://lkml.org/lkml/2007/10/17/224

Actually sometimes I got oops on list_del, sometimes oops on list_add.
And I can change my test program a bit to trigger other oops.

The patch has been tested both on x86_32 and x86_64.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-fix-a-race-condition-in-manipulating-tsk-cg_list kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-a-race-condition-in-manipulating-tsk-cg_list
+++ a/kernel/cgroup.c
@@ -1722,7 +1722,12 @@ void cgroup_enable_task_cg_lists(void)
 	use_task_css_set_links = 1;
 	do_each_thread(g, p) {
 		task_lock(p);
-		if (list_empty(&p->cg_list))
+		/*
+		 * We should check if the process is exiting, otherwise
+		 * it will race with cgroup_exit() in that the list
+		 * entry won't be deleted though the process has exited.
+		 */
+		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
 			list_add(&p->cg_list, &p->cgroups->tasks);
 		task_unlock(p);
 	} while_each_thread(g, p);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
oom_kill-remove-unused-parameter-in-badness.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

