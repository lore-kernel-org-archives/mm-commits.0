From: akpm@linux-foundation.org
Subject: [merged] mm-prevent-divide-error-for-small-values-of-vm_dirty_bytes.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:41 -0700
Message-ID: <200905042013.n44KDfKL022721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbZEDUR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, cl@linux-foundation.org, david@fromorbit.com, peterz@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: prevent divide error for small values of vm_dirty_bytes
has been removed from the -mm tree.  Its filename was
     mm-prevent-divide-error-for-small-values-of-vm_dirty_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: prevent divide error for small values of vm_dirty_bytes
From: Andrea Righi <righi.andrea@gmail.com>

Avoid setting less than two pages for vm_dirty_bytes: this is necessary to
avoid potential division by 0 (like the following) in get_dirty_limits().

[   49.951610] divide error: 0000 [#1] PREEMPT SMP
[   49.952195] last sysfs file: /sys/devices/pci0000:00/0000:00:01.1/host0/target0:0:0/0:0:0:0/block/sda/uevent
[   49.952195] CPU 1
[   49.952195] Modules linked in: pcspkr
[   49.952195] Pid: 3064, comm: dd Not tainted 2.6.30-rc3 #1
[   49.952195] RIP: 0010:[<ffffffff802d39a9>]  [<ffffffff802d39a9>] get_dirty_limits+0xe9/0x2c0
[   49.952195] RSP: 0018:ffff88001de03a98  EFLAGS: 00010202
[   49.952195] RAX: 00000000000000c0 RBX: ffff88001de03b80 RCX: 28f5c28f5c28f5c3
[   49.952195] RDX: 0000000000000000 RSI: 00000000000000c0 RDI: 0000000000000000
[   49.952195] RBP: ffff88001de03ae8 R08: 0000000000000000 R09: 0000000000000000
[   49.952195] R10: ffff88001ddda9a0 R11: 0000000000000001 R12: 0000000000000001
[   49.952195] R13: ffff88001fbc8218 R14: ffff88001de03b70 R15: ffff88001de03b78
[   49.952195] FS:  00007fe9a435b6f0(0000) GS:ffff8800025d9000(0000) knlGS:0000000000000000
[   49.952195] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   49.952195] CR2: 00007fe9a39ab000 CR3: 000000001de38000 CR4: 00000000000006e0
[   49.952195] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   49.952195] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   49.952195] Process dd (pid: 3064, threadinfo ffff88001de02000, task ffff88001ddda250)
[   49.952195] Stack:
[   49.952195]  ffff88001fa0de00 ffff88001f2dbd70 ffff88001f9fe800 000080b900000000
[   49.952195]  00000000000000c0 ffff8800027a6100 0000000000000400 ffff88001fbc8218
[   49.952195]  0000000000000000 0000000000000600 ffff88001de03bb8 ffffffff802d3ed7
[   49.952195] Call Trace:
[   49.952195]  [<ffffffff802d3ed7>] balance_dirty_pages_ratelimited_nr+0x1d7/0x3f0
[   49.952195]  [<ffffffff80368f8e>] ? ext3_writeback_write_end+0x9e/0x120
[   49.952195]  [<ffffffff802cc7df>] generic_file_buffered_write+0x12f/0x330
[   49.952195]  [<ffffffff802cce8d>] __generic_file_aio_write_nolock+0x26d/0x460
[   49.952195]  [<ffffffff802cda32>] ? generic_file_aio_write+0x52/0xd0
[   49.952195]  [<ffffffff802cda49>] generic_file_aio_write+0x69/0xd0
[   49.952195]  [<ffffffff80365fa6>] ext3_file_write+0x26/0xc0
[   49.952195]  [<ffffffff803034d1>] do_sync_write+0xf1/0x140
[   49.952195]  [<ffffffff80290d1a>] ? get_lock_stats+0x2a/0x60
[   49.952195]  [<ffffffff80280730>] ? autoremove_wake_function+0x0/0x40
[   49.952195]  [<ffffffff8030411b>] vfs_write+0xcb/0x190
[   49.952195]  [<ffffffff803042d0>] sys_write+0x50/0x90
[   49.952195]  [<ffffffff8022ff6b>] system_call_fastpath+0x16/0x1b
[   49.952195] Code: 00 00 00 2b 05 09 1c 17 01 48 89 c6 49 0f af f4 48 c1 ee 02 48 89 f0 48 f7 e1 48 89 d6 31 d2 48 c1 ee 02 48 0f af 75 d0 48 89 f0 <48> f7 f7 41 8b 95 ac 01 00 00 48 89 c7 49 0f af d4 48 c1 ea 02
[   49.952195] RIP  [<ffffffff802d39a9>] get_dirty_limits+0xe9/0x2c0
[   49.952195]  RSP <ffff88001de03a98>
[   50.096523] ---[ end trace 008d7aa02f244d7b ]---

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 ++++
 kernel/sysctl.c             |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-prevent-divide-error-for-small-values-of-vm_dirty_bytes Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-prevent-divide-error-for-small-values-of-vm_dirty_bytes
+++ a/Documentation/sysctl/vm.txt
@@ -90,6 +90,10 @@ will itself start writeback.
 If dirty_bytes is written, dirty_ratio becomes a function of its value
 (dirty_bytes / the amount of dirtyable system memory).
 
+Note: the minimum value allowed for dirty_bytes is two pages (in bytes); any
+value lower than this limit will be ignored and the old configuration will be
+retained.
+
 ==============================================================
 
 dirty_expire_centisecs
diff -puN kernel/sysctl.c~mm-prevent-divide-error-for-small-values-of-vm_dirty_bytes kernel/sysctl.c
--- a/kernel/sysctl.c~mm-prevent-divide-error-for-small-values-of-vm_dirty_bytes
+++ a/kernel/sysctl.c
@@ -103,6 +103,9 @@ static unsigned long one_ul = 1;
 static int one_hundred = 100;
 static int one_thousand = 1000;
 
+/* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
+static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
+
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
@@ -1006,7 +1009,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one_ul,
+		.extra1		= &dirty_bytes_min,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

origin.patch

