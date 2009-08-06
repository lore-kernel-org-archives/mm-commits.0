From: akpm@linux-foundation.org
Subject: [merged] posix-timers-fix-oops-in-clock_nanosleep-with-clock_monotonic_raw.patch removed from -mm tree
Date: Thu, 06 Aug 2009 13:31:47 -0700
Message-ID: <200908062031.n76KVltW005365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbZHFUmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 16:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW
has been removed from the -mm tree.  Its filename was
     posix-timers-fix-oops-in-clock_nanosleep-with-clock_monotonic_raw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Prevent calling do_nanosleep() with clockid CLOCK_MONOTONIC_RAW, it may
cause oops, such as NULL pointer dereference.

Userspace program is like this;

#include <time.h>

int main(void)
{
	struct timespec ts;

	ts.tv_sec = 1;
	ts.tv_nsec = 0;

	return clock_nanosleep(4, 0, &ts, NULL);
}

and it will cause oops;

BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
IP: [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
PGD 3dc6c067 PUD 3b519067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/irq
CPU 0 
Modules linked in: sco bnep l2cap bluetooth sunrpc bridge stp llc ipv6 p4_clockmod speedstep_lib freq_table dm_multipath uinput iTCO_wdt iTCO_vendor_support tg3 i2c_i801 snd_intel8x0 snd_ac97_codec ac97_bus ppdev snd_pcm parport_pc snd_timer floppy parport snd soundcore snd_page_alloc pcspkr ata_generic pata_acpi nouveau drm i2c_algo_bit i2c_core [last unloaded: freq_table]
Pid: 20114, comm: a.out Not tainted 2.6.29.6-213.fc11.x86_64 #1 PC-MY32EXZE78SG
RIP: 0010:[<ffffffff81029eb5>]  [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
RSP: 0018:ffff88003e08bd88  EFLAGS: 00010046
RAX: 0000000000000100 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 000000000000c350 RSI: 0000000000000286 RDI: 0000000000000001
RBP: ffff88003e08bd88 R08: 0000000000000001 R09: 0000003ec680eec0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000286
R13: ffff88003e08be20 R14: 000000000000c350 R15: 000000000000c350
FS:  00007fb6cd3996f0(0000) GS:ffffffff817b7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000001 CR3: 000000003a5c0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process a.out (pid: 20114, threadinfo ffff88003e08a000, task ffff8800399e1700)
Stack:
 ffff88003e08bd98 ffffffff81029f7f ffff88003e08bdb8 ffffffff813ac07c
 ffff880001011178 ffff88003e08be98 ffff88003e08bde8 ffffffff8105f3a1
 ffff88003e08bdd8 ffff88003e08be98 0000000000000001 000000003b9aca00
Call Trace:
 [<ffffffff81029f7f>] default_spin_lock_flags+0x9/0xe
 [<ffffffff813ac07c>] _spin_lock_irqsave+0x32/0x3b
 [<ffffffff8105f3a1>] lock_hrtimer_base+0x2a/0x50
 [<ffffffff8105f527>] __hrtimer_start_range_ns+0x2f/0x238
 [<ffffffff8105f75e>] hrtimer_start_range_ns+0x14/0x16
 [<ffffffff813aac8b>] do_nanosleep+0x4e/0xae
 [<ffffffff8105f813>] hrtimer_nanosleep+0xb3/0x123
 [<ffffffff8105edea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8105b4ed>] sys_clock_nanosleep+0xc9/0xdf
 [<ffffffff8101133a>] system_call_fastpath+0x16/0x1b
Code: 9c 02 81 44 89 c6 48 89 c7 e8 0a fb ff ff eb 0f 0f b7 f6 40 0f b6 ff 48 89 c2 e8 1c fb ff ff c9 c3 90 55 b8 00 01 00 00 48 89 e5 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 55 48 89 e5 
RIP  [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
 RSP <ffff88003e08bd88>
CR2: 0000000000000001

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/posix-timers.c~posix-timers-fix-oops-in-clock_nanosleep-with-clock_monotonic_raw kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-fix-oops-in-clock_nanosleep-with-clock_monotonic_raw
+++ a/kernel/posix-timers.c
@@ -202,6 +202,12 @@ static int no_timer_create(struct k_itim
 	return -EOPNOTSUPP;
 }
 
+static int no_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsave, struct timespec __user *rmtp)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -254,6 +260,7 @@ static __init int init_posix_timers(void
 		.clock_get = posix_get_monotonic_raw,
 		.clock_set = do_posix_clock_nosettime,
 		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

origin.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

