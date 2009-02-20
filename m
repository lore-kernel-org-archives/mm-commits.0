From: akpm@linux-foundation.org
Subject: + oprofile-dont-set-counter-width-from-cpuid-on-core2.patch added to -mm tree
Date: Fri, 20 Feb 2009 13:45:37 -0800
Message-ID: <200902202145.n1KLjbtZ001757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbZBTVqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 16:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim@klingt.org, andi@firstfloor.org, mingo@elte.hu, robert.richter@amd.com, tglx@linutronix.de


The patch titled
     oprofile: don't set counter width from cpuid on core2
has been added to the -mm tree.  Its filename is
     oprofile-dont-set-counter-width-from-cpuid-on-core2.patch

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
Subject: oprofile: don't set counter width from cpuid on core2
From: Tim Blechmann <tim@klingt.org>

Resetting the counter width of the performance counters on intel's core2,
breaks the delivery of NMIs, when running in x86_64 mode.

This should fix bug #12395:
http://bugzilla.kernel.org/show_bug.cgi?id=12395

Signed-off-by: Tim Blechmann <tim@klingt.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/oprofile/op_model_ppro.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/oprofile/op_model_ppro.c~oprofile-dont-set-counter-width-from-cpuid-on-core2 arch/x86/oprofile/op_model_ppro.c
--- a/arch/x86/oprofile/op_model_ppro.c~oprofile-dont-set-counter-width-from-cpuid-on-core2
+++ a/arch/x86/oprofile/op_model_ppro.c
@@ -78,10 +78,18 @@ static void ppro_setup_ctrs(struct op_ms
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
+
+		/* For core2 (family 6, model 15), don't reset the counter width */
+		if (eax.split.version_id == 0 && current_cpu_data.x86 == 6 &&
+		      current_cpu_data.x86_model == 15)
+			goto clear_all_counters;
+
 		if (counter_width < eax.split.bit_width)
 			counter_width = eax.split.bit_width;
 	}
 
+clear_all_counters:
+
 	/* clear all counters */
 	for (i = 0 ; i < num_counters; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
_

Patches currently in -mm which might be from tim@klingt.org are

linux-next.patch
oprofile-dont-set-counter-width-from-cpuid-on-core2.patch

