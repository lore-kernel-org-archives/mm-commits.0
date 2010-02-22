From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch added to -mm tree
Date: Mon, 22 Feb 2010 15:18:56 -0800
Message-ID: <201002222318.o1MNIuTv029746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab0BVXUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 18:20:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akataria@vmware.com, dhecht@vmware.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     arch/x86/kernel/hpet.c: fix bug in RTC emulation
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch

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
@@ -1143,6 +1143,7 @@ int hpet_set_periodic_freq(unsigned long
 		do_div(clc, freq);
 		clc >>= hpet_clockevent.shift;
 		hpet_pie_delta = clc;
+		hpet_pie_limit = 0;
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from akataria@vmware.com are

linux-next.patch
arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch

