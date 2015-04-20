From: akpm@linux-foundation.org
Subject: [merged] gcov-fix-softlockups.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:02 -0700
Message-ID: <55355162.7HF8qHU5+vt1cJkV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbbDTTNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, fengguang.wu@intel.com, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: fix softlockups
has been removed from the -mm tree.  Its filename was
     gcov-fix-softlockups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: gcov: fix softlockups

gcov profiling if enabled with other heavy compile-time instrumentation
like KASan could trigger following softlockups:

[   72.460059] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:1]
[   72.460068] Modules linked in:
[   72.460068] irq event stamp: 22823276
[   72.460068] hardirqs last  enabled at (22823275): [<ffffffff86e8d10d>] mutex_lock_nested+0x7d9/0x930
[   72.460068] hardirqs last disabled at (22823276): [<ffffffff86e9521d>] apic_timer_interrupt+0x6d/0x80
[   72.460068] softirqs last  enabled at (22823172): [<ffffffff811ed969>] __do_softirq+0x4db/0x729
[   72.460068] softirqs last disabled at (22823167): [<ffffffff811edfcf>] irq_exit+0x7d/0x15b
[   72.460068] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W       3.19.0-05245-gbb33326-dirty #3
[   72.460068] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5.1-0-g8936dbb-20141113_115728-nilsson.home.kraxel.org 04/01/2014
[   72.460068] task: ffff88006cba8000 ti: ffff88006cbb0000 task.ti: ffff88006cbb0000
[   72.460068] RIP: 0010:[<ffffffff8146822a>]  [<ffffffff8146822a>] kasan_mem_to_shadow+0x1e/0x1f
[   72.460068] RSP: 0000:ffff88006cbb3cb0  EFLAGS: 00000207
[   72.460068] RAX: fffffbfff1331380 RBX: ffffffff81468fc2 RCX: ffff88006d600006
[   72.460068] RDX: dffffc0000000000 RSI: ffffffff89989bfa RDI: 1ffffffff1331380
[   72.460068] RBP: ffff88006cbb3cf8 R08: 00000000037178af R09: 0000000003714ae1
[   72.460068] R10: ffffed000c8d0b1f R11: 00000000000000cf R12: ffffffff8d8c2ba0
[   72.460068] R13: ffff88006d640780 R14: ffffffff81269ad5 R15: ffff88006cbb3c58
[   72.460068] FS:  0000000000000000(0000) GS:ffff88006d600000(0000) knlGS:0000000000000000
[   72.460068] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   72.460068] CR2: 0000000000000000 CR3: 000000000a229000 CR4: 00000000000006f0
[   72.460068] Stack:
[   72.460068]  ffffffff81468a10 dffffc0000000000 ffffffff8abcfac0 ffff88006cbb3d28
[   72.460068]  ffffffff81468fc2 ffff88006cbb3d38 ffffffff81468fc2 dffffc0000000000
[   72.460068]  ffffffff89989c05 ffff88006cbb3d28 ffffffff8212fea0 ffff880063049398
[   72.460068] Call Trace:
[   72.460068]  [<ffffffff81468a10>] ? __asan_load1+0x66/0xbb
[   72.460068]  [<ffffffff81468fc2>] ? __asan_load8+0x6d/0x10c
[   72.460068]  [<ffffffff81468fc2>] ? __asan_load8+0x6d/0x10c
[   72.460068]  [<ffffffff8212fea0>] strcmp+0x28/0x70
[   72.460068]  [<ffffffff813228af>] get_node_by_name+0x66/0x99
[   72.460068]  [<ffffffff81323879>] gcov_event+0x4f/0x69e
[   72.460068]  [<ffffffff86e90477>] ? mutex_unlock+0x15/0x1e
[   72.460068]  [<ffffffff8ca18cb9>] ? gcov_persist_setup+0x77/0x77
[   72.460068]  [<ffffffff8ca18cb9>] ? gcov_persist_setup+0x77/0x77
[   72.460068]  [<ffffffff813227a6>] gcov_enable_events+0x54/0x7b
[   72.460068]  [<ffffffff8ca18db1>] gcov_fs_init+0xf8/0x134
[   72.460068]  [<ffffffff810022ca>] do_one_initcall+0x1b2/0x288
[   72.460068]  [<ffffffff81468fc2>] ? __asan_load8+0x6d/0x10c
[   72.460068]  [<ffffffff8c9c8f02>] kernel_init_freeable+0x467/0x580
[   72.460068]  [<ffffffff86dd9a48>] ? rest_init+0x23b/0x23b
[   72.460068]  [<ffffffff86dd9a5d>] kernel_init+0x15/0x18b
[   72.460068]  [<ffffffff86e93f3c>] ret_from_fork+0x7c/0xb0
[   72.460068]  [<ffffffff86dd9a48>] ? rest_init+0x23b/0x23b
[   72.460068] Code: ff 48 ff 05 61 ec c2 0c 48 89 e5 5d c3 55 48 c1 ef 03 48 ba 00 00 00 00 00 fc ff df 48 8d 04 17 48 ff 05 da f5 c2 0c 48 89 e5 5d <c3> 55 48 ff 05 f5 fe c2 0c 48 89 e5 5d c3 55 48 ff 05 f0 fe c2
[   72.460068] Kernel panic - not syncing: softlockup: hung tasks

Fix this by sticking cond_resched() in gcov_enable_events().

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/gcov/base.c~gcov-fix-softlockups kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-fix-softlockups
+++ a/kernel/gcov/base.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include "gcov.h"
 
 static int gcov_events_enabled;
@@ -107,8 +108,10 @@ void gcov_enable_events(void)
 	gcov_events_enabled = 1;
 
 	/* Perform event callback for previously registered entries. */
-	while ((info = gcov_info_next(info)))
+	while ((info = gcov_info_next(info))) {
 		gcov_event(GCOV_ADD, info);
+		cond_resched();
+	}
 
 	mutex_unlock(&gcov_lock);
 }
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
linux-next.patch

