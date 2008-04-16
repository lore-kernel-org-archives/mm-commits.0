From: akpm@linux-foundation.org
Subject: - memcg-fix-oops-in-oom-handling.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:54:58 -0700
Message-ID: <200804162254.m3GMswDA011069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759558AbYDPXB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.comlizf@cn.fujitsu, menage@google.com, oleg@tv-sign.ru, rientjes@cs.washington.edu, xemul@openvz.org, mm-c


The patch titled
     memcg: fix oops in oom handling
has been removed from the -mm tree.  Its filename was
     memcg-fix-oops-in-oom-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix oops in oom handling
From: Li Zefan <lizf@cn.fujitsu.com>

When I used a test program to fork mass processes and immediately move them to
a cgroup where the memory limit is low enough to trigger oom kill, I got oops:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000808
IP: [<ffffffff8045c47f>] _spin_lock_irqsave+0x8/0x18
PGD 4c95f067 PUD 4406c067 PMD 0
Oops: 0002 [1] SMP
CPU 2
Modules linked in:

Pid: 11973, comm: a.out Not tainted 2.6.25-rc7 #5
RIP: 0010:[<ffffffff8045c47f>]  [<ffffffff8045c47f>] _spin_lock_irqsave+0x8/0x18
RSP: 0018:ffff8100448c7c30  EFLAGS: 00010002
RAX: 0000000000000202 RBX: 0000000000000009 RCX: 000000000001c9f3
RDX: 0000000000000100 RSI: 0000000000000001 RDI: 0000000000000808
RBP: ffff81007e444080 R08: 0000000000000000 R09: ffff8100448c7900
R10: ffff81000105f480 R11: 00000100ffffffff R12: ffff810067c84140
R13: 0000000000000001 R14: ffff8100441d0018 R15: ffff81007da56200
FS:  00007f70eb1856f0(0000) GS:ffff81007fbad3c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000808 CR3: 000000004498a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process a.out (pid: 11973, threadinfo ffff8100448c6000, task ffff81007da533e0)
Stack:  ffffffff8023ef5a 00000000000000d0 ffffffff80548dc0 00000000000000d0
 ffff810067c84140 ffff81007e444080 ffffffff8026cef9 00000000000000d0
 ffff8100441d0000 00000000000000d0 ffff8100441d0000 ffff8100505445c0
Call Trace:
 [<ffffffff8023ef5a>] ? force_sig_info+0x25/0xb9
 [<ffffffff8026cef9>] ? oom_kill_task+0x77/0xe2
 [<ffffffff8026d696>] ? mem_cgroup_out_of_memory+0x55/0x67
 [<ffffffff802910ad>] ? mem_cgroup_charge_common+0xec/0x202
 [<ffffffff8027997b>] ? handle_mm_fault+0x24e/0x77f
 [<ffffffff8022c4af>] ? default_wake_function+0x0/0xe
 [<ffffffff8027a17a>] ? get_user_pages+0x2ce/0x3af
 [<ffffffff80290fee>] ? mem_cgroup_charge_common+0x2d/0x202
 [<ffffffff8027a441>] ? make_pages_present+0x8e/0xa4
 [<ffffffff8027d1ab>] ? mmap_region+0x373/0x429
 [<ffffffff8027d7eb>] ? do_mmap_pgoff+0x2ff/0x364
 [<ffffffff80210471>] ? sys_mmap+0xe5/0x111
 [<ffffffff8020bfc9>] ? tracesys+0xdc/0xe1

Code: 00 00 01 48 8b 3c 24 e9 46 d4 dd ff f0 ff 07 48 8b 3c 24 e9 3a d4 dd ff fe 07 48 8b 3c 24 e9 2f d4 dd ff 9c 58 fa ba 00 01 00 00 <f0> 66 0f c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c3 fa b8 00 01 00
RIP  [<ffffffff8045c47f>] _spin_lock_irqsave+0x8/0x18
 RSP <ffff8100448c7c30>
CR2: 0000000000000808
---[ end trace c3702fa668021ea4 ]---

It's reproducable in a x86_64 box, but doesn't happen in x86_32.

This is because tsk->sighand is not guarded by RCU, so we have to
hold tasklist_lock, just as what out_of_memory() does.

Signed-off-by: Li Zefan <lizf@cn.fujitsu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Rientjes <rientjes@cs.washington.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~memcg-fix-oops-in-oom-handling mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-fix-oops-in-oom-handling
+++ a/mm/oom_kill.c
@@ -423,7 +423,7 @@ void mem_cgroup_out_of_memory(struct mem
 	struct task_struct *p;
 
 	cgroup_lock();
-	rcu_read_lock();
+	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, mem);
 	if (PTR_ERR(p) == -1UL)
@@ -436,7 +436,7 @@ retry:
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
-	rcu_read_unlock();
+	read_unlock(&tasklist_lock);
 	cgroup_unlock();
 }
 #endif
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
git-ia64.patch
git-net.patch
oom_kill-remove-unused-parameter-in-badness.patch
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

