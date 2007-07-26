From: akpm@linux-foundation.org
Subject: + fix-hpet-init-race.patch added to -mm tree
Date: Thu, 26 Jul 2007 14:09:03 -0700
Message-ID: <200707262109.l6QL93it020911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934298AbXGZVJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 17:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com


The patch titled
     Fix HPET init race
has been added to the -mm tree.  Its filename is
     fix-hpet-init-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix HPET init race
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

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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

fix-hpet-init-race.patch
