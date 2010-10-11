From: akpm@linux-foundation.org
Subject: + hrtimers-fix-a-complex-race.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:43:55 -0700
Message-ID: <201010112243.o9BMhtuD022537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756942Ab0JKWoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 18:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sqazi@google.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimers: fix a complex race
has been added to the -mm tree.  Its filename is
     hrtimers-fix-a-complex-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimers: fix a complex race
From: Salman Qazi <sqazi@google.com>

The race is described as follows:

CPU X                                 CPU Y
remove_hrtimer
// state & QUEUED == 0
timer->state = CALLBACK
unlock timer base
timer->f(n) //very long
                                  hrtimer_start
                                    lock timer base
                                    remove_hrtimer // no effect
                                    hrtimer_enqueue
                                    timer->state = CALLBACK |
                                                   QUEUED
                                    unlock timer base
                                  hrtimer_start
                                    lock timer base
                                    remove_hrtimer
                                        mode = INACTIVE
                                        // CALLBACK bit lost!
                                    switch_hrtimer_base
                                            CALLBACK bit not set:
                                                    timer->base
                                                    changes to a
                                                    different CPU.
lock this CPU's timer base

Bug reproducible and fix testable using a kernel module that hrtimer_start()s
a timer with a very long running callback from multiple CPUs:

MODULE_LICENSE("GPL");

static long timer_func_time = 1000;
module_param(timer_func_time, long, 0600);
static long timer_starts = 2500;
module_param(timer_starts, long, 0600);
static long timer_expire = 1000;
module_param(timer_expire, long, 0600);

DEFINE_PER_CPU(struct task_struct *, hrtimer_thread);

/* There are other issues, like deadlocks between multiple hrtimer_start observed
 * calls, at least in 2.6.34 that this lock works around.  Will look into
 * those later.
 */
static DEFINE_SPINLOCK(blah_lock);

static ktime_t mytime;
static struct hrtimer timer;

static enum hrtimer_restart timer_restart(struct hrtimer *timer)
{
        unsigned long i;
        /* We have to make the callback longer to improve the
         * probability of having a race.
         */
        for (i = 0; i < timer_func_time / 100; i++) {
                touch_nmi_watchdog();
                touch_softlockup_watchdog();
                udelay(100);
        }

        return HRTIMER_NORESTART;
}

static int restart_hrtimer_repeatedly(void *input)
{
        int i;
        unsigned long range;
        while (!kthread_should_stop()) {
                for (i = 0; i < timer_starts; i++) {
                        /* Avoid deadlocks for now */
                        spin_lock(&blah_lock);
                        hrtimer_start(&timer, mytime, HRTIMER_MODE_REL);
                        spin_unlock(&blah_lock);
                        touch_nmi_watchdog();
                        touch_softlockup_watchdog();
                }
                cond_resched();
        }
        hrtimer_cancel(&timer);
        return 0;
}

static int hrtimer_unit_test_init(void)
{
        int cpu;
        mytime = ktime_set(0, 0);
        mytime = ktime_add_ns(mytime, timer_expire);
        hrtimer_init(&timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
        timer.function = timer_restart;
        for_each_online_cpu(cpu) {
                per_cpu(hrtimer_thread, cpu) = kthread_create(
                        restart_hrtimer_repeatedly, NULL, "hrtimer_test/%d",
                        cpu);
                if (IS_ERR(per_cpu(hrtimer_thread, cpu))) {
                       printk(KERN_ERR
                                "Failed to create hrtimer test thread\n");
                        BUG();
                }
                kthread_bind(per_cpu(hrtimer_thread, cpu), cpu);
                wake_up_process(per_cpu(hrtimer_thread, cpu));
        }
        return 0;
}

static void hrtimer_unit_test_exit(void)
{
        int cpu;
        for_each_online_cpu(cpu) {
                (void)kthread_stop(per_cpu(hrtimer_thread, cpu));
        }
}

module_init(hrtimer_unit_test_init);
module_exit(hrtimer_unit_test_exit);



These are crash dumps that we can produce in less than a minute without
this patch by enabling NMI watchdog.

Basically, we get rb_tree corruption that results an in infinite loop in
rb_insert_color.  I am not sure about the exact sequence of events from
the original loss of CALLBACK bit to this corruption in 2.6.36 (as I first
debugged it in 2.6.26 *twenty six*), however having the patch makes it go
away, just like it does for similar corruption in 2.6.26:

cim7:~# [  143.712006] BUG: NMI Watchdog detected LOCKUP on CPU1, ip
ffffffff8120b09a, registers:
[  143.712006] CPU 1
[  143.712006] Modules linked in: hrtimer_unit_test ipv6 sata_sil tg3
msr cpuid eeprom genrtc
[  143.712006]
[  143.712006] Pid: 4925, comm: hrtimer_test/1 Not tainted
2.6.36-smp-DEV #4 Unicorn_QCS_00  /E7320,6300ESB
[  143.712006] RIP: 0010:[<ffffffff8120b09a>]  [<ffffffff8120b09a>]
rb_insert_color+0x6a/0xe5
[  143.712006] RSP: 0018:ffff880013e83dd8  EFLAGS: 00000082
[  143.712006] RAX: 0000000000000000 RBX: ffffffffa000d680 RCX: ffffffffa000d680
[  143.712006] RDX: ffffffffa000d680 RSI: ffff88001440f298 RDI: ffffffffa000d680
[  143.712006] RBP: ffff880013e83e00 R08: 0000000000000000 R09: ffffffff818e7178
[  143.712006] R10: ffff8800081a2000 R11: ffff88000bc65d70 R12: ffffffffa000d680
[  143.712006] R13: ffffffffa000d680 R14: ffff88001440f298 R15: ffffffffa000d680
[  143.712006] FS:  0000000000000000(0000) GS:ffff88000c400000(0000)
knlGS:0000000000000000
[  143.712006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  143.712006] CR2: 00000000f686a000 CR3: 00000000080db000 CR4: 00000000000006e0
[  143.712006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  143.712006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  143.712006] Process hrtimer_test/1 (pid: 4925, threadinfo
ffff880013e82000, task ffff88000bd69740)
[  143.712006] Stack:
[  143.712006]  ffffffffa000d680 0000000000000000 ffffffffa000d688
ffff88001440f288
[  143.712006] <0> ffff88001440f288 ffff880013e83e30 ffffffff81085645
ffffffffa000d680
[  143.712006] <0> 000000203856036c 0000000000000000 0000000000000001
ffff880013e83eb0
[  143.712006] Call Trace:
[  143.712006]  [<ffffffff81085645>] enqueue_hrtimer+0x9d/0xae
[  143.712006]  [<ffffffff81086092>] __hrtimer_start_range_ns+0x1a8/0x2a6
[  143.712006]  [<ffffffffa000d155>] ?
restart_hrtimer_repeatedly+0x0/0x84 [hrtimer_unit_test]
[  143.712006]  [<ffffffff810861a8>] hrtimer_start+0x18/0x1a
[  143.712006]  [<ffffffffa000d189>]
restart_hrtimer_repeatedly+0x34/0x84 [hrtimer_unit_test]
[  143.712006]  [<ffffffffa000d155>] ?
restart_hrtimer_repeatedly+0x0/0x84 [hrtimer_unit_test]
[  143.712006]  [<ffffffff81082223>] kthread+0x82/0x8a
[  143.712006]  [<ffffffff81031994>] kernel_thread_helper+0x4/0x10
[  143.712006]  [<ffffffff810821a1>] ? kthread+0x0/0x8a
[  143.712006]  [<ffffffff81031990>] ? kernel_thread_helper+0x0/0x10
[  143.712006] Code: 74 05 49 89 df eb 0e 4c 89 f6 48 89 df 49 89 dd
e8 ec fe ff ff 49 83 0f 01 4c 89 f6 4c 89 e7 49 83 24 24 fe e8 38 ff
ff ff eb 52 <48> 85 c0 74 1d 48 8b 10 f6 c2 01 75 15 48 83 ca 01 4d 89
e5 48
[  143.712006] ---[ end trace a701d1f011c8230f ]---

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/hrtimer.c~hrtimers-fix-a-complex-race kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-fix-a-complex-race
+++ a/kernel/hrtimer.c
@@ -944,8 +944,8 @@ remove_hrtimer(struct hrtimer *timer, st
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
-		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
-				 reprogram);
+		__remove_hrtimer(timer, base,
+				 (timer->state & HRTIMER_STATE_CALLBACK), reprogram);
 		return 1;
 	}
 	return 0;
@@ -1231,6 +1231,9 @@ static void __run_hrtimer(struct hrtimer
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
 	}
+
+	BUG_ON(!(timer->state & HRTIMER_STATE_CALLBACK));
+
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 
_

Patches currently in -mm which might be from sqazi@google.com are

hrtimers-fix-a-complex-race.patch

