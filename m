From: akpm@linux-foundation.org
Subject: [to-be-updated]
 kernel-forkc-annotate-data-races-for-copy_process.patch removed from -mm tree
Date: Sat, 20 Jun 2020 19:04:18 -0700
Message-ID: <20200621020418.MVJ5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgFUCEU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 22:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, paulmck@kernel.org, oleg@redhat.com, lizefan@huawei.com, elver@google.com, christian.brauner@ubuntu.com, cai@lca.pw, chenweilong@huawei.com


The patch titled
     Subject: kernel/fork.c: annotate data races for copy_process
has been removed from the -mm tree.  Its filename was
     kernel-forkc-annotate-data-races-for-copy_process.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Weilong Chen <chenweilong@huawei.com>
Subject: kernel/fork.c: annotate data races for copy_process

The check is only there to stop root fork bombs.

BUG: KCSAN: data-race in copy_process / copy_process

write to 0xffffffff86f87d20 of 4 bytes by task 7121 on cpu 5:
 copy_process+0x2e1a/0x3af0 kernel/fork.c:2285
 _do_fork+0xf7/0x790 kernel/fork.c:2430
 __do_sys_clone+0xf9/0x130 kernel/fork.c:2585
 __se_sys_clone kernel/fork.c:2566 [inline]
 __x64_sys_clone+0x6c/0x80 kernel/fork.c:2566
 do_syscall_64+0xc7/0x3b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffffffff86f87d20 of 4 bytes by task 7125 on cpu 3:
 copy_process+0x9eb/0x3af0 kernel/fork.c:1967
 _do_fork+0xf7/0x790 kernel/fork.c:2430
 __do_sys_clone+0xf9/0x130 kernel/fork.c:2585
 __se_sys_clone kernel/fork.c:2566 [inline]
 __x64_sys_clone+0x6c/0x80 kernel/fork.c:2566
 do_syscall_64+0xc7/0x3b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: http://lkml.kernel.org/r/20200609030801.272704-1-chenweilong@huawei.com
Signed-off-by: Weilong Chen <chenweilong@huawei.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-forkc-annotate-data-races-for-copy_process
+++ a/kernel/fork.c
@@ -1976,7 +1976,7 @@ static __latent_entropy struct task_stru
 	 * to stop root fork bombs.
 	 */
 	retval = -EAGAIN;
-	if (nr_threads >= max_threads)
+	if (data_race(nr_threads >= max_threads))
 		goto bad_fork_cleanup_count;
 
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
_

Patches currently in -mm which might be from chenweilong@huawei.com are
