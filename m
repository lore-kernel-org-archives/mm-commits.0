From: akpm@linux-foundation.org
Subject: +
 kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch
 added to -mm tree
Date: Fri, 09 Aug 2013 16:21:36 -0700
Message-ID: <52057980.SWwC+gL10pY42OQa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031447Ab3HIXVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Aug 2013 19:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, voice.shen@atmel.com

Subject: + kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch added to -mm tree
To: voice.shen@atmel.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Fri, 09 Aug 2013 16:21:36 -0700


The patch titled
     Subject: kernel/time/sched_clock.c: correct the comparison parameter of MHz
has been added to the -mm tree.  Its filename is
     kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bo Shen <voice.shen@atmel.com>
Subject: kernel/time/sched_clock.c: correct the comparison parameter of MHz

Correct the comparison parameter of MHz from 4,000,000 to 1,000,000

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/sched_clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/sched_clock.c~kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz kernel/time/sched_clock.c
--- a/kernel/time/sched_clock.c~kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz
+++ a/kernel/time/sched_clock.c
@@ -128,7 +128,7 @@ void __init setup_sched_clock(u32 (*read
 	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 0);
 
 	r = rate;
-	if (r >= 4000000) {
+	if (r >= 1000000) {
 		r /= 1000000;
 		r_unit = 'M';
 	} else if (r >= 1000) {
_

Patches currently in -mm which might be from voice.shen@atmel.com are

kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch
linux-next.patch

