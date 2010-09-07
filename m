From: akpm@linux-foundation.org
Subject: + hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit.patch added to -mm tree
Date: Tue, 07 Sep 2010 13:00:41 -0700
Message-ID: <201009072000.o87K0fVR002725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181Ab0IGUJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 16:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clemens@ladisch.de, bpicco@redhat.com, jaswinderlinux@gmail.com, johnstul@us.ibm.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     hpet: fix unwanted interrupt due to stale irq status bit
has been added to the -mm tree.  Its filename is
     hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit.patch

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
Subject: hpet: fix unwanted interrupt due to stale irq status bit
From: Clemens Ladisch <clemens@ladisch.de>

Jaswinder Singh Rajput wrote:
> By executing Documentation/timers/hpet_example.c
>
> for polling, I requested for 3 iterations but it seems iteration work
> for only 2 as first expired time is always very small.
>
> # ./hpet_example poll /dev/hpet 10 3
> -hpet: executing poll
> hpet_poll: info.hi_flags 0x0
> hpet_poll: expired time = 0x13
> hpet_poll: revents = 0x1
> hpet_poll: data 0x1
> hpet_poll: expired time = 0x1868c
> hpet_poll: revents = 0x1
> hpet_poll: data 0x1
> hpet_poll: expired time = 0x18645
> hpet_poll: revents = 0x1
> hpet_poll: data 0x1

Clearing the HPET interrupt enable bit disables interrupt generation
but does not disable the timer, so the interrupt status bit will still
be set when the timer elapses.  If another interrupt arrives before
the timer has been correctly programmed (due to some other device on
the same interrupt line, or CONFIG_DEBUG_SHIRQ), this results in an
extra unwanted interrupt event because the status bit is likely to be
set from comparator matches that happened before the device was opened.

Therefore, we have to ensure that the interrupt status bit is and
stays cleared until we actually program the timer.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Bob Picco <bpicco@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN drivers/char/hpet.c~hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit
+++ a/drivers/char/hpet.c
@@ -479,6 +479,21 @@ static int hpet_ioctl_ieon(struct hpet_d
 	if (irq) {
 		unsigned long irq_flags;
 
+		if (devp->hd_flags & HPET_SHARED_IRQ) {
+			/*
+			 * To prevent the interrupt handler from seeing an
+			 * unwanted interrupt status bit, program the timer
+			 * so that it will not fire in the near future ...
+			 */
+			writel(readl(&timer->hpet_config) & ~Tn_TYPE_CNF_MASK,
+			       &timer->hpet_config);
+			write_counter(read_counter(&hpet->hpet_mc),
+				      &timer->hpet_compare);
+			/* ... and clear any left-over status. */
+			isr = 1 << (devp - devp->hd_hpets->hp_dev);
+			writel(isr, &hpet->hpet_isr);
+		}
+
 		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
 		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
 						? IRQF_SHARED : IRQF_DISABLED;
_

Patches currently in -mm which might be from clemens@ladisch.de are

linux-next.patch
hpet-unmap-unused-i-o-space.patch
hpet-fix-unwanted-interrupt-due-to-stale-irq-status-bit.patch
hpet-factor-timer-allocate-from-open.patch

