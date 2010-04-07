From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:51:10 -0400
Message-ID: <201004071852.o37IqaDE001379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab0DGSws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akataria@vmware.com, dhecht@vmware.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/hpet.c: fix bug in RTC emulation
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/hpet.c: fix bug in RTC emulation
From: Alok Kataria <akataria@vmware.com>

We think there exists a bug in the HPET code that emulates the RTC.

In the normal case, when the RTC frequency is set, the rtc driver tells
the hpet code about it here:

int hpet_set_periodic_freq(unsigned long freq)
{
        uint64_t clc;

        if (!is_hpet_enabled())
                return 0;

        if (freq <= DEFAULT_RTC_INT_FREQ)
                hpet_pie_limit = DEFAULT_RTC_INT_FREQ / freq;
        else {
                clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
                do_div(clc, freq);
                clc >>= hpet_clockevent.shift;
                hpet_pie_delta = (unsigned long) clc;
        }
        return 1;
}

If freq is set to 64Hz (DEFAULT_RTC_INT_FREQ) or lower, then
hpet_pie_limit (a static) is set to non-zero.  Then, on every one-shot
HPET interrupt, hpet_rtc_timer_reinit is called to compute the next
timeout.  Well, that function has this logic:

        if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
                delta = hpet_default_delta;
        else
                delta = hpet_pie_delta;

Since hpet_pie_limit is not 0, hpet_default_delta is used.  That
corresponds to 64Hz.

Now, if you set a different rtc frequency, you'll take the else path
through hpet_set_periodic_freq, but unfortunately no one resets
hpet_pie_limit back to 0.

Boom....now you are stuck with 64Hz RTC interrupts forever.

The patch below just resets the hpet_pie_limit value when requested freq
is greater than DEFAULT_RTC_INT_FREQ, which we think fixes this problem.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Daniel Hecht <dhecht@vmware.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/hpet.c~arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation
+++ a/arch/x86/kernel/hpet.c
@@ -1144,6 +1144,7 @@ int hpet_set_periodic_freq(unsigned long
 		do_div(clc, freq);
 		clc >>= hpet_clockevent.shift;
 		hpet_pie_delta = clc;
+		hpet_pie_limit = 0;
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from akataria@vmware.com are

origin.patch

