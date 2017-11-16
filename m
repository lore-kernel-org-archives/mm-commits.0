From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-sysctl-make-numa-stats-configurable-v5-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:10:14 -0800
Message-ID: <5a0ce576.G/5spNoZi6iZrVM8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932695AbdKPBKQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:10:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, brouer@redhat.com, dave.hansen@intel.com, mhocko@suse.com, vbabka@suse.cz, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: Make sure mutex is a global static
has been removed from the -mm tree.  Its filename was
     mm-sysctl-make-numa-stats-configurable-v5-fix.patch

This patch was dropped because it was folded into mm-sysctl-make-numa-stats-configurable-v5.patch

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm, vmstat: Make sure mutex is a global static

The mutex in sysctl_vm_numa_stat_handler() needs to be a global static,
not a stack variable, otherwise it doesn't serve any purpose.  Also,
reading the file with CONFIG_LOCKDEP=y will complain:

[   63.258593] INFO: trying to register non-static key.
[   63.259113] the code is fine but needs lockdep annotation.
[   63.259596] turning off the locking correctness validator.
[   63.260073] CPU: 1 PID: 4102 Comm: perl Not tainted 4.14.0-rc8-next-20171107+ #419
[   63.260769] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[   63.261570] Call Trace:
[   63.261783]  dump_stack+0x5f/0x86
[   63.262062]  register_lock_class+0xe4/0x550
[   63.262408]  ? __lock_acquire+0x308/0x1170
[   63.262746]  __lock_acquire+0x7e/0x1170
[   63.263063]  lock_acquire+0x9d/0x1d0
[   63.263363]  ? sysctl_vm_numa_stat_handler+0x8f/0x2d0
[   63.263777]  ? sysctl_vm_numa_stat_handler+0x8f/0x2d0
[   63.264192]  __mutex_lock+0xb8/0x9a0
[   63.264488]  ? sysctl_vm_numa_stat_handler+0x8f/0x2d0
[   63.264942]  ? sysctl_vm_numa_stat_handler+0x8f/0x2d0
[   63.265398]  ? sysctl_vm_numa_stat_handler+0x8f/0x2d0
[   63.265840]  sysctl_vm_numa_stat_handler+0x8f/0x2d0
[   63.266270]  proc_sys_call_handler+0xe3/0x100
[   63.266655]  __vfs_read+0x33/0x1b0
[   63.266957]  vfs_read+0xa6/0x150
[   63.267244]  SyS_read+0x55/0xc0
[   63.267525]  do_syscall_64+0x56/0x140
[   63.267850]  entry_SYSCALL64_slow_path+0x25/0x25

Link: http://lkml.kernel.org/r/20171107213809.GA4314@beast
Fixes: 920d5f77d1a25 ("mm, sysctl: make NUMA stats configurable")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ying Huang <ying.huang@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-sysctl-make-numa-stats-configurable-v5-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-sysctl-make-numa-stats-configurable-v5-fix
+++ a/mm/vmstat.c
@@ -72,11 +72,12 @@ static void invalid_numa_statistics(void
 	zero_global_numa_counters();
 }
 
+static DEFINE_MUTEX(vm_numa_stat_lock);
+
 int sysctl_vm_numa_stat_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int ret, oldval;
-	DEFINE_MUTEX(vm_numa_stat_lock);
 
 	mutex_lock(&vm_numa_stat_lock);
 	if (write)
_

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
mm-sysctl-make-numa-stats-configurable-v5.patch

