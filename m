From: akpm@linux-foundation.org
Subject: +
 pid-handle-failure-to-allocate-the-first-pid-in-a-pid-namespace.patch added to -mm tree
Date: Thu, 28 Dec 2017 15:26:03 -0800
Message-ID: <5a457d8b.j2F1Dq0Rv6WuTvdm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754505AbdL1X0F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 18:26:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, davej@codemonkey.org.uk, gs051095@gmail.com, oleg@redhat.com, riel@redhat.com, viro@zeniv.linux.org.uk, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pid: handle failure to allocate the first pid in a pid namespace
has been added to the -mm tree.  Its filename is
     pid-handle-failure-to-allocate-the-first-pid-in-a-pid-namespace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-handle-failure-to-allocate-the-first-pid-in-a-pid-namespace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-handle-failure-to-allocate-the-first-pid-in-a-pid-namespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ebiederm@xmission.com (Eric W. Biederman)
Subject: pid: handle failure to allocate the first pid in a pid namespace

With the replacement of the pid bitmap and hashtable with an idr in
alloc_pid started occassionally failing when allocating the first pid in a
pid namespace.  Things were not completely reset resulting in the first
allocated pid getting the number 2 (not 1).  Which further resulted in
ns->proc_mnt not getting set and eventually causing an oops in
proc_flush_task.

Oops: 0000 [#1] SMP
CPU: 2 PID: 6743 Comm: trinity-c117 Not tainted 4.15.0-rc4-think+ #2
RIP: 0010:proc_flush_task+0x8e/0x1b0
RSP: 0018:ffffc9000bbffc40 EFLAGS: 00010286
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 00000000fffffffb
RDX: 0000000000000000 RSI: ffffc9000bbffc50 RDI: 0000000000000000
RBP: ffffc9000bbffc63 R08: 0000000000000000 R09: 0000000000000002
R10: ffffc9000bbffb70 R11: ffffc9000bbffc64 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000000000003 R15: ffff8804c10d7840
FS:  00007f7cb8965700(0000) GS:ffff88050a200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000003e21ae003 CR4: 00000000001606e0
DR0: 00007fb1d6c22000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 ? release_task+0xaf/0x680
 release_task+0xd2/0x680
 ? wait_consider_task+0xb82/0xce0
 wait_consider_task+0xbe9/0xce0
 ? do_wait+0xe1/0x330
 do_wait+0x151/0x330
 kernel_wait4+0x8d/0x150
 ? task_stopped_code+0x50/0x50
 SYSC_wait4+0x95/0xa0
 ? rcu_read_lock_sched_held+0x6c/0x80
 ? syscall_trace_enter+0x2d7/0x340
 ? do_syscall_64+0x60/0x210
 do_syscall_64+0x60/0x210
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f7cb82603aa
RSP: 002b:00007ffd60770bc8 EFLAGS: 00000246
 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 00007f7cb6cd4000 RCX: 00007f7cb82603aa
RDX: 000000000000000b RSI: 00007ffd60770bd0 RDI: 0000000000007cca
RBP: 0000000000007cca R08: 00007f7cb8965700 R09: 00007ffd607c7080
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd60770bd0 R14: 00007f7cb6cd4058 R15: 00000000cccccccd
Code: c1 e2 04 44 8b 60 30 48 8b 40 38 44 8b 34 11 48 c7 c2 60 3a f5 81 44 89 e1 4c 8b 68 58 e8 4b b4 77 00 89 44 24 14 48 8d 74 24 10 <49> 8b 7d 00 e8 b9 6a f9 ff 48 85 c0 74 1a 48 89 c7 48 89 44 24
RIP: proc_flush_task+0x8e/0x1b0 RSP: ffffc9000bbffc40
CR2: 0000000000000000
---[ end trace 53d67a6481059862 ]---

Improve the quality of the implementation by resetting the place to start
allocating pids on failure to allocate the first pid.

As improving the quality of the implementation is the goal remove the now
unnecesarry disable_pid_allocations call when we fail to mount proc.

Link: http://lkml.kernel.org/r/87efnkdde4.fsf_-_@xmission.com
Fixes: 95846ecf9dac ("pid: replace pid bitmap implementation with IDR API")
Fixes: 8ef047aaaeb8 ("pid namespaces: make alloc_pid(), free_pid() and put_pid() work with struct upid")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Cc: Gargi Sharma <gs051095@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/pid.c~pid-handle-failure-to-allocate-the-first-pid-in-a-pid-namespace kernel/pid.c
--- a/kernel/pid.c~pid-handle-failure-to-allocate-the-first-pid-in-a-pid-namespace
+++ a/kernel/pid.c
@@ -193,10 +193,8 @@ struct pid *alloc_pid(struct pid_namespa
 	}
 
 	if (unlikely(is_child_reaper(pid))) {
-		if (pid_ns_prepare_proc(ns)) {
-			disable_pid_allocation(ns);
+		if (pid_ns_prepare_proc(ns))
 			goto out_free;
-		}
 	}
 
 	get_pid_ns(ns);
@@ -226,6 +224,10 @@ out_free:
 	while (++i <= ns->level)
 		idr_remove(&ns->idr, (pid->numbers + i)->nr);
 
+	/* On failure to allocate the first pid, reset the state */
+	if (ns->pid_allocated == PIDNS_ADDING)
+		idr_set_cursor(&ns->idr, 0);
+
 	spin_unlock_irq(&pidmap_lock);
 
 	kmem_cache_free(ns->pid_cachep, pid);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

pid-handle-failure-to-allocate-the-first-pid-in-a-pid-namespace.patch

