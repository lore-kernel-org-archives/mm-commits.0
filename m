From: akpm@linux-foundation.org
Subject: + speedstep-ich-use-correct-cpu-in-speedstep_get.patch added to -mm tree
Date: Tue, 13 Oct 2009 14:33:50 -0700
Message-ID: <200910132133.n9DLXo1p024402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761198AbZJMVfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 17:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave.mueller@gmx.ch, davej@redhat.com, e.a.b.piel@tudelft.nl, linux@brodo.de, rjw@sisk.pl, rusty@rustcorp.com.au


The patch titled
     speedstep-ich: use correct CPU in speedstep_get()
has been added to the -mm tree.  Its filename is
     speedstep-ich-use-correct-cpu-in-speedstep_get.patch

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
Subject: speedstep-ich: use correct CPU in speedstep_get()
From: Dave Mueller <dave.mueller@gmx.ch>

It looks like commit 394122ab144dae4b276d74644a2f11c44a60ac5c ("cpumask:
avoid playing with cpus_allowed in speedstep-ich.c") broke the
speedstep-ich driver.

The problem seems to be that speedstep-lib.c:speedstep_get_frequency() is
called with a wrong value as "processor" parameter by the code below,
resulting in a return value of 0.  The "processor" parameter should be the
value returned by "speedstep_detect_processor()"

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14340

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dominik Brodowski <linux@brodo.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Eric Pielbug <e.a.b.piel@tudelft.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~speedstep-ich-use-correct-cpu-in-speedstep_get arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~speedstep-ich-use-correct-cpu-in-speedstep_get
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -246,7 +246,7 @@ static void get_freq_data(void *_data)
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	struct get_freq_data data = { .processor = cpu };
+	struct get_freq_data data = { .processor = speedstep_processor };
 
 	/* You're supposed to ensure CPU is online. */
 	if (smp_call_function_single(cpu, get_freq_data, &data, 1) != 0)
_

Patches currently in -mm which might be from dave.mueller@gmx.ch are

speedstep-ich-use-correct-cpu-in-speedstep_get.patch

