From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix.patch removed
 from -mm tree
Date: Wed, 12 Jul 2017 14:19:53 -0700
Message-ID: <59669279.y0q1Zt+ZJvKmCzBv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdGLVTy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s: watchdog honor watchdog disable at boot/hotplug
has been removed from the -mm tree.  Its filename was
     powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix.patch

This patch was dropped because it was folded into powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch

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
