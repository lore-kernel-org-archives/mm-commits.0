From: akpm@linux-foundation.org
Subject: +
 hrtimer-one-more-expiry-time-overflow-check-in-hrtimer_interrupt.patch
 added to -mm tree
Date: Tue, 11 Jun 2013 15:58:36 -0700
Message-ID: <51b7ab9c.c9qKX/ijeIYo+zuf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3FKW6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, prarit@redhat.com, john.stultz@linaro.org, hiroyuki.yokoyama.vx@renesas.com, shinya.kuribayashi.px@renesas.com

Subject: + hrtimer-one-more-expiry-time-overflow-check-in-hrtimer_interrupt.patch added to -mm tree
To: shinya.kuribayashi.px@renesas.com,hiroyuki.yokoyama.vx@renesas.com,john.stultz@linaro.org,prarit@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:58:36 -0700


The patch titled
     Subject: hrtimer: one more expiry time overflow check in hrtimer_interrupt
has been added to the -mm tree.  Its filename is
     hrtimer-one-more-expiry-time-overflow-check-in-hrtimer_interrupt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Subject: hrtimer: one more expiry time overflow check in hrtimer_interrupt

When executing a date command to set the system date and time to a few
seconds before the 2038 problem expiration time, we got a WARN_ON_ONCE()
like this:

  root@renesas:~# date -s "2038-1-19 3:14:00"
  Tue Jan 19 03:14:00 GMT 2038
  (then wait for 7-8 seconds)
  root@renesas:~# [   27.662658] ------------[ cut here ]------------
  [   27.667297] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x3c/0x138()
  [   27.675720] Modules linked in:
  [   27.678802] [<c00130ec>] (unwind_backtrace+0x0/0xe0) from [<c001f4d8>] (warn_slowpath_common+0x4c/0x64)
  [   27.688201] [<c001f4d8>] (warn_slowpath_common+0x4c/0x64) from [<c001f508>] (warn_slowpath_null+0x18/0x1c)
  [   27.697845] [<c001f508>] (warn_slowpath_null+0x18/0x1c) from [<c00549bc>] (clockevents_program_event+0x3c/0x138)
  [   27.708007] [<c00549bc>] (clockevents_program_event+0x3c/0x138) from [<c005510c>] (tick_program_event+0x2c/0x34)
  [   27.718170] [<c005510c>] (tick_program_event+0x2c/0x34) from [<c003fa98>] (hrtimer_interrupt+0x268/0x2a8)
  [   27.727752] [<c003fa98>] (hrtimer_interrupt+0x268/0x2a8) from [<c00180c8>] (cmt_timer_interrupt+0x2c/0x34)
  [   27.737396] [<c00180c8>] (cmt_timer_interrupt+0x2c/0x34) from [<c0066748>] (handle_irq_event_percpu+0xb0/0x2a8)
  [   27.747467] [<c0066748>] (handle_irq_event_percpu+0xb0/0x2a8) from [<c0066998>] (handle_irq_event+0x58/0x74)
  [   27.757293] [<c0066998>] (handle_irq_event+0x58/0x74) from [<c0068f24>] (handle_fasteoi_irq+0xc0/0x148)
  [   27.766662] [<c0068f24>] (handle_fasteoi_irq+0xc0/0x148) from [<c0066014>] (generic_handle_irq+0x20/0x30)
  [   27.776245] [<c0066014>] (generic_handle_irq+0x20/0x30) from [<c000ef54>] (handle_IRQ+0x60/0x84)
  [   27.785003] [<c000ef54>] (handle_IRQ+0x60/0x84) from [<c0009334>] (gic_handle_irq+0x34/0x4c)
  [   27.793426] [<c0009334>] (gic_handle_irq+0x34/0x4c) from [<c000e2c0>] (__irq_svc+0x40/0x70)
  [   27.801788] Exception stack(0xc04aff68 to 0xc04affb0)
  [   27.806823] ff60:                   00000000 f0100000 00000001 00000000 c04ae000 c04ec388
  [   27.815002] ff80: c04b604c c0840d80 40004059 412fc093 00000000 00000000 c04ce140 c04affb0
  [   27.823150] ffa0: c000f064 c000f068 60000013 ffffffff
  [   27.828216] [<c000e2c0>] (__irq_svc+0x40/0x70) from [<c000f068>] (default_idle+0x24/0x2c)
  [   27.836395] [<c000f068>] (default_idle+0x24/0x2c) from [<c000f338>] (cpu_idle+0x74/0xc8)
  [   27.844451] [<c000f338>] (cpu_idle+0x74/0xc8) from [<c048c6d4>] (start_kernel+0x248/0x288)
  [   27.852722] ---[ end trace 9d8ad385bde80fd3 ]---
  [   27.857330] hrtimer: interrupt took 0 ns

This is triggered with our v3.4-based custom ARM kernel, but we confirmed
that v3.10-rc can still have the same problem.

I found a similar issue fixed in v3.9 by Prarit Bhargava in commit
8f294b5a13 ("hrtimer: Add expiry time overflow check in
hrtimer_interrupt", 2013-04-08).  It tried to resolve a overflow issue
detected around 1970 + 100 seconds.

On the other hand, we have another call site of tick_program_event() at
the bottom of hrtimer_interrupt().  The warning this time is triggered
there, so we need to apply the same fix to it.

Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Reported-by: Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/hrtimer.c~hrtimer-one-more-expiry-time-overflow-check-in-hrtimer_interrupt kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-one-more-expiry-time-overflow-check-in-hrtimer_interrupt
+++ a/kernel/hrtimer.c
@@ -1392,6 +1392,8 @@ retry:
 		expires_next = ktime_add_ns(now, 100 * NSEC_PER_MSEC);
 	else
 		expires_next = ktime_add(now, delta);
+	if (expires_next.tv64 < 0)
+		expires_next.tv64 = KTIME_MAX;
 	tick_program_event(expires_next, 1);
 	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
 		    ktime_to_ns(delta));
_

Patches currently in -mm which might be from shinya.kuribayashi.px@renesas.com are

hrtimer-one-more-expiry-time-overflow-check-in-hrtimer_interrupt.patch

