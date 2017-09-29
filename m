From: akpm@linux-foundation.org
Subject: + ratelimit-use-deferred-printk-version.patch added to -mm tree
Date: Fri, 29 Sep 2017 15:03:15 -0700
Message-ID: <59cec323.HKv9PGx/4llBEfZm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752157AbdI2WDR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2017 18:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, bp@suse.de, levinsasha928@gmail.com, mingo@elte.hu, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ratelimit.c: use deferred printk() version
has been added to the -mm tree.  Its filename is
     ratelimit-use-deferred-printk-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ratelimit-use-deferred-printk-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ratelimit-use-deferred-printk-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: lib/ratelimit.c: use deferred printk() version

printk_ratelimit() invokes ___ratelimit() which may invoke a normal
printk() (pr_warn() in this particular case) to warn about suppressed
output.  Given that printk_ratelimit() may be called from anywhere, that
pr_warn() is dangerous - it may end up deadlocking the system.  Fix
___ratelimit() by using deferred printk().

Sasha reported the following lockdep error:

 : Unregister pv shared memory for cpu 8
 : select_fallback_rq: 3 callbacks suppressed
 : process 8583 (trinity-c78) no longer affine to cpu8
 :
 : ======================================================
 : WARNING: possible circular locking dependency detected
 : 4.14.0-rc2-next-20170927+ #252 Not tainted
 : ------------------------------------------------------
 : migration/8/62 is trying to acquire lock:
 : (&port_lock_key){-.-.}, at: serial8250_console_write()
 :
 : but task is already holding lock:
 : (&rq->lock){-.-.}, at: sched_cpu_dying()
 :
 : which lock already depends on the new lock.
 :
 :
 : the existing dependency chain (in reverse order) is:
 :
 : -> #3 (&rq->lock){-.-.}:
 : __lock_acquire()
 : lock_acquire()
 : _raw_spin_lock()
 : task_fork_fair()
 : sched_fork()
 : copy_process.part.31()
 : _do_fork()
 : kernel_thread()
 : rest_init()
 : start_kernel()
 : x86_64_start_reservations()
 : x86_64_start_kernel()
 : verify_cpu()
 :
 : -> #2 (&p->pi_lock){-.-.}:
 : __lock_acquire()
 : lock_acquire()
 : _raw_spin_lock_irqsave()
 : try_to_wake_up()
 : default_wake_function()
 : woken_wake_function()
 : __wake_up_common()
 : __wake_up_common_lock()
 : __wake_up()
 : tty_wakeup()
 : tty_port_default_wakeup()
 : tty_port_tty_wakeup()
 : uart_write_wakeup()
 : serial8250_tx_chars()
 : serial8250_handle_irq.part.25()
 : serial8250_default_handle_irq()
 : serial8250_interrupt()
 : __handle_irq_event_percpu()
 : handle_irq_event_percpu()
 : handle_irq_event()
 : handle_level_irq()
 : handle_irq()
 : do_IRQ()
 : ret_from_intr()
 : native_safe_halt()
 : default_idle()
 : arch_cpu_idle()
 : default_idle_call()
 : do_idle()
 : cpu_startup_entry()
 : rest_init()
 : start_kernel()
 : x86_64_start_reservations()
 : x86_64_start_kernel()
 : verify_cpu()
 :
 : -> #1 (&tty->write_wait){-.-.}:
 : __lock_acquire()
 : lock_acquire()
 : _raw_spin_lock_irqsave()
 : __wake_up_common_lock()
 : __wake_up()
 : tty_wakeup()
 : tty_port_default_wakeup()
 : tty_port_tty_wakeup()
 : uart_write_wakeup()
 : serial8250_tx_chars()
 : serial8250_handle_irq.part.25()
 : serial8250_default_handle_irq()
 : serial8250_interrupt()
 : __handle_irq_event_percpu()
 : handle_irq_event_percpu()
 : handle_irq_event()
 : handle_level_irq()
 : handle_irq()
 : do_IRQ()
 : ret_from_intr()
 : native_safe_halt()
 : default_idle()
 : arch_cpu_idle()
 : default_idle_call()
 : do_idle()
 : cpu_startup_entry()
 : rest_init()
 : start_kernel()
 : x86_64_start_reservations()
 : x86_64_start_kernel()
 : verify_cpu()
 :
 : -> #0 (&port_lock_key){-.-.}:
 : check_prev_add()
 : __lock_acquire()
 : lock_acquire()
 : _raw_spin_lock_irqsave()
 : serial8250_console_write()
 : univ8250_console_write()
 : console_unlock()
 : vprintk_emit()
 : vprintk_default()
 : vprintk_func()
 : printk()
 : ___ratelimit()
 : __printk_ratelimit()
 : select_fallback_rq()
 : sched_cpu_dying()
 : cpuhp_invoke_callback()
 : take_cpu_down()
 : multi_cpu_stop()
 : cpu_stopper_thread()
 : smpboot_thread_fn()
 : kthread()
 : ret_from_fork()
 :
 : other info that might help us debug this:
 :
 : Chain exists of:
 :   &port_lock_key --> &p->pi_lock --> &rq->lock
 :
 :  Possible unsafe locking scenario:
 :
 :        CPU0                    CPU1
 :        ----                    ----
 :   lock(&rq->lock);
 :                                lock(&p->pi_lock);
 :                                lock(&rq->lock);
 :   lock(&port_lock_key);
 :
 :  *** DEADLOCK ***
 :
 : 4 locks held by migration/8/62:
 : #0: (&p->pi_lock){-.-.}, at: sched_cpu_dying()
 : #1: (&rq->lock){-.-.}, at: sched_cpu_dying()
 : #2: (printk_ratelimit_state.lock){....}, at: ___ratelimit()
 : #3: (console_lock){+.+.}, at: vprintk_emit()
 :
 : stack backtrace:
 : CPU: 8 PID: 62 Comm: migration/8 Not tainted 4.14.0-rc2-next-20170927+ #252
 : Call Trace:
 : dump_stack()
 : print_circular_bug()
 : check_prev_add()
 : ? add_lock_to_list.isra.26()
 : ? check_usage()
 : ? kvm_clock_read()
 : ? kvm_sched_clock_read()
 : ? sched_clock()
 : ? check_preemption_disabled()
 : __lock_acquire()
 : ? __lock_acquire()
 : ? add_lock_to_list.isra.26()
 : ? debug_check_no_locks_freed()
 : ? memcpy()
 : lock_acquire()
 : ? serial8250_console_write()
 : _raw_spin_lock_irqsave()
 : ? serial8250_console_write()
 : serial8250_console_write()
 : ? serial8250_start_tx()
 : ? lock_acquire()
 : ? memcpy()
 : univ8250_console_write()
 : console_unlock()
 : ? __down_trylock_console_sem()
 : vprintk_emit()
 : vprintk_default()
 : vprintk_func()
 : printk()
 : ? show_regs_print_info()
 : ? lock_acquire()
 : ___ratelimit()
 : __printk_ratelimit()
 : select_fallback_rq()
 : sched_cpu_dying()
 : ? sched_cpu_starting()
 : ? rcutree_dying_cpu()
 : ? sched_cpu_starting()
 : cpuhp_invoke_callback()
 : ? cpu_disable_common()
 : take_cpu_down()
 : ? trace_hardirqs_off_caller()
 : ? cpuhp_invoke_callback()
 : multi_cpu_stop()
 : ? __this_cpu_preempt_check()
 : ? cpu_stop_queue_work()
 : cpu_stopper_thread()
 : ? cpu_stop_create()
 : smpboot_thread_fn()
 : ? sort_range()
 : ? schedule()
 : ? __kthread_parkme()
 : kthread()
 : ? sort_range()
 : ? kthread_create_on_node()
 : ret_from_fork()
 : process 9121 (trinity-c78) no longer affine to cpu8
 : smpboot: CPU 8 is now offline

Link: http://lkml.kernel.org/r/20170928120405.18273-1-sergey.senozhatsky@gmail.com
Fixes: 6b1d174b0c27b ("ratelimit: extend to print suppressed messages on release")
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ratelimit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN lib/ratelimit.c~ratelimit-use-deferred-printk-version lib/ratelimit.c
--- a/lib/ratelimit.c~ratelimit-use-deferred-printk-version
+++ a/lib/ratelimit.c
@@ -48,7 +48,9 @@ int ___ratelimit(struct ratelimit_state
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
 		if (rs->missed) {
 			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
-				pr_warn("%s: %d callbacks suppressed\n", func, rs->missed);
+				printk_deferred(KERN_WARNING
+						"%s: %d callbacks suppressed\n",
+						func, rs->missed);
 				rs->missed = 0;
 			}
 		}
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

ratelimit-use-deferred-printk-version.patch
zram-add-zstd-to-the-supported-algorithms-list.patch
zram-remove-zlib-from-the-list-of-recommended-algorithms.patch

