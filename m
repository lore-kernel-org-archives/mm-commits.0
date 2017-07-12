From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix-2.patch removed from -mm tree
Date: Wed, 12 Jul 2017 14:19:56 -0700
Message-ID: <5966927c.KNX8SznWTPCcAz6h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753576AbdGLVT5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, dzickus@redhat.com, mpe@ellerman.id.au, santosiv@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s: watchdog false positive warning at CPU unplug
has been removed from the -mm tree.  Its filename was
     powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix-2.patch

This patch was dropped because it was folded into powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64s: watchdog false positive warning at CPU unplug

CPU unplug will call stop_wd_on_cpu regardless if the watchdog has been
configured to be enabled on that CPU.  Don't warn in the case it's not in
our enabled mask, this is a valid case.

Fixes: powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch
Link: http://lkml.kernel.org/r/20170630080740.20766-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reported-by: Santosh Sivaraj <santosiv@in.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/watchdog.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kernel/watchdog.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix-2 arch/powerpc/kernel/watchdog.c
--- a/arch/powerpc/kernel/watchdog.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix-2
+++ a/arch/powerpc/kernel/watchdog.c
@@ -310,10 +310,8 @@ static int start_wd_on_cpu(unsigned int
 
 static int stop_wd_on_cpu(unsigned int cpu)
 {
-	if (!cpumask_test_cpu(cpu, &wd_cpus_enabled)) {
-		WARN_ON(1);
-		return 0;
-	}
+	if (!cpumask_test_cpu(cpu, &wd_cpus_enabled))
+		return 0; /* Can happen in CPU unplug case */
 
 	stop_watchdog_timer_on(cpu);
 
_

Patches currently in -mm which might be from npiggin@gmail.com are

watchdog-remove-unused-declaration.patch
watchdog-introduce-arch_touch_nmi_watchdog.patch
watchdog-split-up-config-options.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch

