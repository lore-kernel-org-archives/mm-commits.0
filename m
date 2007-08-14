From: akpm@linux-foundation.org
Subject: - fix-hpet-init-race.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:26 -0700
Message-ID: <200708140502.l7E52QFG031976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762817AbXHNFDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, adurbin@google.com, ak@suse.de, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix HPET init race
has been removed from the -mm tree.  Its filename was
     fix-hpet-init-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix HPET init race
From: Robin Holt <holt@sgi.com>

I have had four seperate system lockups attributable to this exact problem
in two days of testing.  Instead of trying to handle all the weird end
cases and wrap, how about changing it to look for exactly what we appear
to want.

The following patch removes a couple races in setup_APIC_timer.  One occurs
when the HPET advances the COUNTER past the T0_CMP value between the time
the T0_CMP was originally read and when COUNTER is read.  This results in
a delay waiting for the counter to wrap.  The other results from the counter
wrapping.

This change takes a snapshot of T0_CMP at the beginning of the loop and
simply loops until T0_CMP has changed (a tick has happened).

<later>

I have one small concern about the patch.  I am not sure it meets the intent
as well as it should.  I think we are trying to match APIC timer interrupts up
with the hpet counter increment.  The event which appears to be disturbing
this loop in our test environment is the NMI watchdog.  What we believe has
been happening with the existing code is the setup_APIC_timer loop has read
the CMP value, and the NMI watchdog code fires for the first time.  This
results in a series of icache miss slowdowns and by the time we get back to
things it has wrapped.

I think this code is trying to get the CMP as close to the counter value as
possible.  If that is the intent, maybe we should really be testing against a
"window" around the CMP.  Something like COUNTER = CMP+/2.  It appears COUNTER
should get advanced every 89nSec (IIRC).  The above seems like an unreasonably
small window, but may be necessary.  Without documentation, I am not sure of
the original intent with this code.

In summary, this code fixes my boot hangs, but since I am not certain of the
intent of the existing code, I am not certain this has not introduced new bugs
or unexpected behaviors.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Andi Kleen <ak@suse.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Cc: "Aaron Durbin" <adurbin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~fix-hpet-init-race arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~fix-hpet-init-race
+++ a/arch/x86_64/kernel/apic.c
@@ -791,10 +791,8 @@ static void setup_APIC_timer(unsigned in
 
 	/* wait for irq slice */
 	if (hpet_address && hpet_use_timer) {
-		int trigger = hpet_readl(HPET_T0_CMP);
-		while (hpet_readl(HPET_COUNTER) >= trigger)
-			/* do nothing */ ;
-		while (hpet_readl(HPET_COUNTER) <  trigger)
+		u32 trigger = hpet_readl(HPET_T0_CMP);
+		while (hpet_readl(HPET_T0_CMP) == trigger)
 			/* do nothing */ ;
 	} else {
 		int c1, c2;
_

Patches currently in -mm which might be from holt@sgi.com are
