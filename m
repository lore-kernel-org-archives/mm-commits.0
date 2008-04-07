From: akpm@linux-foundation.org
Subject: + ia64-fix-unlock-ordering-in-smp_callin.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:13:59 -0700
Message-ID: <200804072313.m37NDx7L029901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbYDGXOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Alan.Brunelle@hp.com, alan.brunelle@hp.com


The patch titled
     ia64: fix unlock ordering in smp_callin
has been added to the -mm tree.  Its filename is
     ia64-fix-unlock-ordering-in-smp_callin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix unlock ordering in smp_callin
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>

One should normally unlock in the reverse order of the lock calls, and in this
case there certainly is no reason not to.

To better see the results (with locks included), here's the complete
section of corrected code:

        lock_ipi_calllock();
        spin_lock(&vector_lock);
        /* Setup the per cpu irq handling data structures */
        __setup_vector_irq(cpuid);
        cpu_set(cpuid, cpu_online_map);
        per_cpu(cpu_state, cpuid) = CPU_ONLINE;
        spin_unlock(&vector_lock);
        unlock_ipi_calllock();

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/smpboot.c~ia64-fix-unlock-ordering-in-smp_callin arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~ia64-fix-unlock-ordering-in-smp_callin
+++ a/arch/ia64/kernel/smpboot.c
@@ -400,9 +400,9 @@ smp_callin (void)
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	cpu_set(cpuid, cpu_online_map);
-	unlock_ipi_calllock();
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
+	unlock_ipi_calllock();
 
 	smp_setup_percpu_timer();
 
_

Patches currently in -mm which might be from Alan.Brunelle@hp.com are

ia64-fix-unlock-ordering-in-smp_callin.patch

