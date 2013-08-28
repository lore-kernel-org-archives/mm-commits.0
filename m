From: akpm@linux-foundation.org
Subject: + sched_clock-document-4mhz-vs-1mhz-decision.patch added to -mm
 tree
Date: Wed, 28 Aug 2013 14:14:10 -0700
Message-ID: <521e6822.4kB8pcXEK3AkioZ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3H1VOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Aug 2013 17:14:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, voice.shen@atmel.com, tglx@linutronix.de, rmk@arm.linux.org.uk, sboyd@codeaurora.org

Subject: + sched_clock-document-4mhz-vs-1mhz-decision.patch added to -mm tree
To: sboyd@codeaurora.org,rmk@arm.linux.org.uk,tglx@linutronix.de,voice.shen@atmel.com
From: akpm@linux-foundation.org
Date: Wed, 28 Aug 2013 14:14:10 -0700


The patch titled
     Subject: sched_clock: document 4Mhz vs 1Mhz decision
has been added to the -mm tree.  Its filename is
     sched_clock-document-4mhz-vs-1mhz-decision.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched_clock-document-4mhz-vs-1mhz-decision.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched_clock-document-4mhz-vs-1mhz-decision.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: sched_clock: document 4Mhz vs 1Mhz decision

Bo Shen sent a patch to change this to 1Mhz instead of 4Mhz but according
to Russell King the use of 4Mhz was intentional.  Add a comment to this
effect so that others don't try to change the code as well.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bo Shen <voice.shen@atmel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/sched_clock.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/time/sched_clock.c~sched_clock-document-4mhz-vs-1mhz-decision kernel/time/sched_clock.c
--- a/kernel/time/sched_clock.c~sched_clock-document-4mhz-vs-1mhz-decision
+++ a/kernel/time/sched_clock.c
@@ -128,6 +128,10 @@ void __init setup_sched_clock(u32 (*read
 	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 0);
 
 	r = rate;
+	/*
+	 * Use 4MHz instead of 1MHz so that things like 1.832Mhz show as
+	 * 1832Khz
+	 */
 	if (r >= 4000000) {
 		r /= 1000000;
 		r_unit = 'M';
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

drivers-iommu-remove-unnecessary-platform_set_drvdata.patch
sched_clock-document-4mhz-vs-1mhz-decision.patch
panic-call-panic-handlers-before-kmsg_dump.patch
linux-next.patch

