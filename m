From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-add-cond_resched-in-exit_sme.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:25:51 -0700
Message-ID: <57fe8e3f.KwY11VtZP3j8oDON%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33473 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934014AbcJLTZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kyup.com, dave@stgolabs.net, fabf@skynet.be, herton@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: add cond_resched in exit_sme
has been removed from the -mm tree.  Its filename was
     ipc-semc-add-cond_resched-in-exit_sme.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nikolay Borisov <kernel@kyup.com>
Subject: ipc/sem.c: add cond_resched in exit_sme

In CONFIG_PREEMPT=n kernel a softlockup was observed while the for loop in
exit_sem.  Apparently it's possible for the loop to take quite a long time
and it doesn't have a scheduling point in it.  Since the codes is
executing under an rcu read section this may also cause rcu stalls, which
in turn block synchronize_rcu operations, which more or less de-stabilises
the whole system.

Fix this by introducing a cond_resched() at the beginning of the loop.

So this patch fixes the following:

NMI watchdog: BUG: soft lockup - CPU#10 stuck for 23s! [httpd:18119]
CPU: 10 PID: 18119 Comm: httpd Tainted: G           O    4.4.20-clouder2 #6
Hardware name: Supermicro X10DRi/X10DRi, BIOS 1.1 04/14/2015
task: ffff88348d695280 ti: ffff881c95550000 task.ti: ffff881c95550000
RIP: 0010:[<ffffffff81614bc7>]  [<ffffffff81614bc7>] _raw_spin_lock+0x17/0x30
RSP: 0018:ffff881c95553e40  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff883161b1eea8 RCX: 000000000000000d
RDX: 0000000000000001 RSI: 000000000000000e RDI: ffff883161b1eea4
RBP: ffff881c95553ea0 R08: ffff881c95553e68 R09: ffff883fef376f88
R10: ffff881fffb58c20 R11: ffffea0072556600 R12: ffff883161b1eea0
R13: ffff88348d695280 R14: ffff883dec427000 R15: ffff8831621672a0
FS:  0000000000000000(0000) GS:ffff881fffb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3b3723e020 CR3: 0000000001c0a000 CR4: 00000000001406e0
Stack:
 ffffffff8129717c ffff88348d695280 ffff883161b1eea4 ffffea000f2359c0
 000480094089b340 ffff881c95553e68 ffff881c95553e68 ffff88348d695280
 0000000000000000 00007ffe01ca0170 ffff883217c74280 ffff883217c742e8
Call Trace:
 [<ffffffff8129717c>] ? exit_sem+0x7c/0x280
 [<ffffffff81055548>] do_exit+0x338/0xb40
 [<ffffffff81055dd3>] do_group_exit+0x43/0xd0
 [<ffffffff81055e74>] SyS_exit_group+0x14/0x20
 [<ffffffff81614f5b>] entry_SYSCALL_64_fastpath+0x16/0x6e

Link: http://lkml.kernel.org/r/1475154992-6363-1-git-send-email-kernel@kyup.com
Signed-off-by: Nikolay Borisov <kernel@kyup.com>
Cc: Herton R. Krzesinski <herton@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN ipc/sem.c~ipc-semc-add-cond_resched-in-exit_sme ipc/sem.c
--- a/ipc/sem.c~ipc-semc-add-cond_resched-in-exit_sme
+++ a/ipc/sem.c
@@ -2105,6 +2105,8 @@ void exit_sem(struct task_struct *tsk)
 		struct list_head tasks;
 		int semid, i;
 
+		cond_resched();
+
 		rcu_read_lock();
 		un = list_entry_rcu(ulp->list_proc.next,
 				    struct sem_undo, list_proc);
_

Patches currently in -mm which might be from kernel@kyup.com are


