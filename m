From: akpm@linux-foundation.org
Subject: +
 printk-fix-one-circular-lockdep-warning-about-console_lock.patch added to
 -mm tree
Date: Thu, 20 Mar 2014 16:35:24 -0700
Message-ID: <532b7b3c.TpBzsKNB744HsrQQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759652AbaCTXfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 19:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, jiel@marvell.com

Subject: + printk-fix-one-circular-lockdep-warning-about-console_lock.patch added to -mm tree
To: jiel@marvell.com,jack@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 16:35:24 -0700


The patch titled
     Subject: printk: fix one circular lockdep warning about console_lock
has been added to the -mm tree.  Its filename is
     printk-fix-one-circular-lockdep-warning-about-console_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-fix-one-circular-lockdep-warning-about-console_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-fix-one-circular-lockdep-warning-about-console_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jane Li <jiel@marvell.com>
Subject: printk: fix one circular lockdep warning about console_lock

Fix a warning about possible circular locking dependency.

If do in following sequence:
    enter suspend ->  resume ->  plug-out CPUx (echo 0 > cpux/online)
lockdep will show warning as following:

======================================================
[ INFO: possible circular locking dependency detected ]
3.10.0 #2 Tainted: G           O
-------------------------------------------------------
sh/1271 is trying to acquire lock:
(console_lock){+.+.+.}, at: [<c06ebf7c>] console_cpu_notify+0x20/0x2c
but task is already holding lock:
(cpu_hotplug.lock){+.+.+.}, at: [<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:
-> #2 (cpu_hotplug.lock){+.+.+.}:
[<c017bb7c>] lock_acquire+0x98/0x12c
[<c06f5014>] mutex_lock_nested+0x50/0x3d8
[<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
[<c06ebfac>] _cpu_up+0x24/0x154
[<c06ec140>] cpu_up+0x64/0x84
[<c0981834>] smp_init+0x9c/0xd4
[<c0973880>] kernel_init_freeable+0x78/0x1c8
[<c06e7f40>] kernel_init+0x8/0xe4
[<c010eec8>] ret_from_fork+0x14/0x2c

-> #1 (cpu_add_remove_lock){+.+.+.}:
[<c017bb7c>] lock_acquire+0x98/0x12c
[<c06f5014>] mutex_lock_nested+0x50/0x3d8
[<c012b758>] disable_nonboot_cpus+0x8/0xe8
[<c016b83c>] suspend_devices_and_enter+0x214/0x448
[<c016bc54>] pm_suspend+0x1e4/0x284
[<c016bdcc>] try_to_suspend+0xa4/0xbc
[<c0143848>] process_one_work+0x1c4/0x4fc
[<c0143f80>] worker_thread+0x138/0x37c
[<c014aaf8>] kthread+0xa4/0xb0
[<c010eec8>] ret_from_fork+0x14/0x2c

-> #0 (console_lock){+.+.+.}:
[<c017b5d0>] __lock_acquire+0x1b38/0x1b80
[<c017bb7c>] lock_acquire+0x98/0x12c
[<c01288c4>] console_lock+0x54/0x68
[<c06ebf7c>] console_cpu_notify+0x20/0x2c
[<c01501d4>] notifier_call_chain+0x44/0x84
[<c012b448>] __cpu_notify+0x2c/0x48
[<c012b5b0>] cpu_notify_nofail+0x8/0x14
[<c06e81bc>] _cpu_down+0xf4/0x258
[<c06e8344>] cpu_down+0x24/0x40
[<c06e921c>] store_online+0x30/0x74
[<c03b7298>] dev_attr_store+0x18/0x24
[<c025fc5c>] sysfs_write_file+0x16c/0x19c
[<c0207a98>] vfs_write+0xb4/0x190
[<c0207e58>] SyS_write+0x3c/0x70
[<c010ee00>] ret_fast_syscall+0x0/0x48

Chain exists of:
   console_lock --> cpu_add_remove_lock --> cpu_hotplug.lock

Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
lock(cpu_hotplug.lock);
                               lock(cpu_add_remove_lock);
                               lock(cpu_hotplug.lock);
lock(console_lock);
  *** DEADLOCK ***

There are three locks involved in two sequence:
a) pm suspend:
	console_lock (@suspend_console())
	cpu_add_remove_lock (@disable_nonboot_cpus())
	cpu_hotplug.lock (@_cpu_down())
b) Plug-out CPUx:
	cpu_add_remove_lock (@(cpu_down())
	cpu_hotplug.lock (@_cpu_down())
	console_lock (@console_cpu_notify()) => Lockdeps prints warning log.

There should be not real deadlock, as flag of console_suspended can
protect this.

Although console_suspend() releases console_sem, it doesn't tell lockdep
about it.  That results in the lockdep warning about circular locking when
doing the following: enter suspend -> resume -> plug-out CPUx (echo 0 >
cpux/online)

Fix the problem by telling lockdep we actually released the semaphore in
console_suspend() and acquired it again in console_resume().

Signed-off-by: Jane Li <jiel@marvell.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/printk/printk.c~printk-fix-one-circular-lockdep-warning-about-console_lock kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-fix-one-circular-lockdep-warning-about-console_lock
+++ a/kernel/printk/printk.c
@@ -1883,6 +1883,7 @@ void suspend_console(void)
 	console_lock();
 	console_suspended = 1;
 	up(&console_sem);
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 }
 
 void resume_console(void)
@@ -1890,6 +1891,7 @@ void resume_console(void)
 	if (!console_suspend_enabled)
 		return;
 	down(&console_sem);
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 	console_suspended = 0;
 	console_unlock();
 }
_

Patches currently in -mm which might be from jiel@marvell.com are

printk-fix-one-circular-lockdep-warning-about-console_lock.patch

