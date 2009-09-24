From: akpm@linux-foundation.org
Subject: [merged] hpet-hpet-driver-periodic-timer-setup-bug-fixes.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:18 -0700
Message-ID: <200909241936.n8OJaIgH002209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbZIXTgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nils.carlson@ericsson.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     hpet: hpet driver periodic timer setup bug fixes
has been removed from the -mm tree.  Its filename was
     hpet-hpet-driver-periodic-timer-setup-bug-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: hpet driver periodic timer setup bug fixes
From: Nils Carlson <nils.carlson@ericsson.com>

The periodic interrupt from drivers/char/hpet.c does not work correctly,
both when using the periodic capability of the hardware and while
emulating the periodic interrupt (when hardware does not support periodic
mode).

With timers capable of periodic interrupts, the comparator field is first
set with the period value followed by set of hidden accumulator, which has
the side effect of overwriting the comparator value.  This results in
wrong periodicity for the interrupts.  For, periodic interrupts to work,
following steps are necessary, in that order.

* Set config with Tn_VAL_SET_CNF bit

* Write to hidden accumulator, the value written is the time when the
  first interrupt should be generated

* Write compartor with period interval for subsequent interrupts
  (http://www.intel.com/hardwaredesign/hpetspec_1.pdf )

When emulating periodic timer with timers not capable of periodic
interrupt, driver is adding the period to counter value instead of
comparator value, which causes slow drift when using this emulation.

Also, driver seems to add hpetp->hp_delta both while setting up periodic
interrupt and while emulating periodic interrupts with timers not capable
of doing periodic interrupts.  This hp_delta will result in slower than
expected interrupt rate and should not be used while setting the interval.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Nils Carlson <nils.carlson@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/char/hpet.c~hpet-hpet-driver-periodic-timer-setup-bug-fixes drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-hpet-driver-periodic-timer-setup-bug-fixes
+++ a/drivers/char/hpet.c
@@ -166,9 +166,8 @@ static irqreturn_t hpet_interrupt(int ir
 		unsigned long m, t;
 
 		t = devp->hd_ireqfreq;
-		m = read_counter(&devp->hd_hpet->hpet_mc);
-		write_counter(t + m + devp->hd_hpets->hp_delta,
-			      &devp->hd_timer->hpet_compare);
+		m = read_counter(&devp->hd_timer->hpet_compare);
+		write_counter(t + m, &devp->hd_timer->hpet_compare);
 	}
 
 	if (devp->hd_flags & HPET_SHARED_IRQ)
@@ -504,21 +503,25 @@ static int hpet_ioctl_ieon(struct hpet_d
 	g = v | Tn_32MODE_CNF_MASK | Tn_INT_ENB_CNF_MASK;
 
 	if (devp->hd_flags & HPET_PERIODIC) {
-		write_counter(t, &timer->hpet_compare);
 		g |= Tn_TYPE_CNF_MASK;
-		v |= Tn_TYPE_CNF_MASK;
-		writeq(v, &timer->hpet_config);
-		v |= Tn_VAL_SET_CNF_MASK;
+		v |= Tn_TYPE_CNF_MASK | Tn_VAL_SET_CNF_MASK;
 		writeq(v, &timer->hpet_config);
 		local_irq_save(flags);
 
-		/* NOTE:  what we modify here is a hidden accumulator
+		/*
+		 * NOTE: First we modify the hidden accumulator
 		 * register supported by periodic-capable comparators.
 		 * We never want to modify the (single) counter; that
-		 * would affect all the comparators.
+		 * would affect all the comparators. The value written
+		 * is the counter value when the first interrupt is due.
 		 */
 		m = read_counter(&hpet->hpet_mc);
 		write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
+		/*
+		 * Then we modify the comparator, indicating the period
+		 * for subsequent interrupt.
+		 */
+		write_counter(t, &timer->hpet_compare);
 	} else {
 		local_irq_save(flags);
 		m = read_counter(&hpet->hpet_mc);
_

Patches currently in -mm which might be from nils.carlson@ericsson.com are

origin.patch

