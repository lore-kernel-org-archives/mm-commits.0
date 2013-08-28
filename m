From: akpm@linux-foundation.org
Subject: [withdrawn]
 kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch
 removed from -mm tree
Date: Tue, 27 Aug 2013 18:26:29 -0700
Message-ID: <521d51c5.l/94Lxt3XS4ABWox%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3H1B1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 21:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, voice.shen@atmel.com

Subject: [withdrawn] kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch removed from -mm tree
To: voice.shen@atmel.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 18:26:26 -0700


The patch titled
     Subject: kernel/time/sched_clock.c: correct the comparison parameter of MHz
has been removed from the -mm tree.  Its filename was
     kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch

This patch was dropped because it was withdrawn

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

linux-next.patch

