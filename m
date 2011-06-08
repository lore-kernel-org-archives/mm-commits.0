From: akpm@linux-foundation.org
Subject: + drivers-char-hpetc-fix-periodic-emulation-for-delayed-interrupts.patch added to -mm tree
Date: Wed, 08 Jun 2011 14:38:09 -0700
Message-ID: <201106082138.p58Lc90N030545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab1FHVix (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2011 17:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nils.carlson@ericsson.com, clemens@ladisch.de, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     drivers/char/hpet.c: fix periodic-emulation for delayed interrupts
has been added to the -mm tree.  Its filename is
     drivers-char-hpetc-fix-periodic-emulation-for-delayed-interrupts.patch

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
Subject: drivers/char/hpet.c: fix periodic-emulation for delayed interrupts
From: Nils Carlson <nils.carlson@ericsson.com>

When interrupts are delayed due to interrupt masking or due to other
interrupts being serviced the HPET periodic-emuation would fail.  This
happened because given an interval t and a time for the current interrupt
m we would compute the next time as t + m.  This works until we are
delayed for > t, in which case we would be writing a new value which is in
fact in the past.

This can be solved by computing the next time instead as (k * t) + m where
k is large enough to be in the future.  The exact computation of k is
described in a comment to the code.

Signed-off-by: Nils Carlson <nils.carlson@ericsson.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff -puN drivers/char/hpet.c~drivers-char-hpetc-fix-periodic-emulation-for-delayed-interrupts drivers/char/hpet.c
--- a/drivers/char/hpet.c~drivers-char-hpetc-fix-periodic-emulation-for-delayed-interrupts
+++ a/drivers/char/hpet.c
@@ -163,11 +163,32 @@ static irqreturn_t hpet_interrupt(int ir
 	 * This has the effect of treating non-periodic like periodic.
 	 */
 	if ((devp->hd_flags & (HPET_IE | HPET_PERIODIC)) == HPET_IE) {
-		unsigned long m, t;
+		unsigned long m, t, mc, base, k;
+		struct hpet __iomem *hpet = devp->hd_hpet;
+		struct hpets *hpetp = devp->hd_hpets;
 
 		t = devp->hd_ireqfreq;
 		m = read_counter(&devp->hd_timer->hpet_compare);
-		write_counter(t + m, &devp->hd_timer->hpet_compare);
+		mc = read_counter(&hpet->hpet_mc);
+		/* The time for the next interrupt would logically be t + m,
+		 * however, if we are very unlucky and the interrupt is delayed
+		 * for longer than t then we will completely miss the next
+		 * interrupt if we set t + m and an application will hang.
+		 * Therefore we need to make a more complex computation assuming
+		 * that there exists a k for which the following is true:
+		 * k * t + base < mc + delta
+		 * (k + 1) * t + base > mc + delta
+		 * where t is the interval in hpet ticks for the given freq,
+		 * base is the theoretical start value 0 < base < t,
+		 * mc is the main counter value at the time of the interrupt,
+		 * delta is the time it takes to write the a value to the
+		 * comparator.
+		 * k may then be computed as (mc - base + delta) / t .
+		 */
+		base = mc % t;
+		k = (mc - base + hpetp->hp_delta) / t;
+		write_counter(t * (k + 1) + base,
+			      &devp->hd_timer->hpet_compare);
 	}
 
 	if (devp->hd_flags & HPET_SHARED_IRQ)
_

Patches currently in -mm which might be from nils.carlson@ericsson.com are

drivers-char-hpetc-fix-periodic-emulation-for-delayed-interrupts.patch

