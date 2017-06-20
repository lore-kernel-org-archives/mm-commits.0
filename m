From: akpm@linux-foundation.org
Subject: +
 powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix.patch added to
 -mm tree
Date: Tue, 20 Jun 2017 13:49:08 -0700
Message-ID: <59498a44.9FVuI4WkbXaycJnH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60374 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdFTUtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2017 16:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s: watchdog honor watchdog disable at boot/hotplug
has been added to the -mm tree.  Its filename is
     powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64s: watchdog honor watchdog disable at boot/hotplug

The boot/hotplug paths were not taking into account if the
watchdog was disabled or suspended. Currently only the watchdog
reconfiguration path is.

Link: http://lkml.kernel.org/r/20170621001346.5bb337c9@roar.ozlabs.ibm.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/watchdog.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/kernel/watchdog.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix arch/powerpc/kernel/watchdog.c
--- a/arch/powerpc/kernel/watchdog.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix
+++ a/arch/powerpc/kernel/watchdog.c
@@ -288,6 +288,12 @@ static int start_wd_on_cpu(unsigned int
 		return 0;
 	}
 
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		return 0;
+
+	if (watchdog_suspended)
+		return 0;
+
 	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
 		return 0;
 
@@ -337,12 +343,6 @@ void watchdog_nmi_reconfigure(void)
 	for_each_cpu(cpu, &wd_cpus_enabled)
 		stop_wd_on_cpu(cpu);
 
-	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
-		return;
-
-	if (watchdog_suspended)
-		return;
